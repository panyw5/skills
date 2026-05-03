# Goal
这是用于 skill `ocr` 的 API 调用说明文档。参考完整文档 [doc](https://mineru.net/apiManage/docs)

关键输出是 `{{文件夹}}/MinerU-output/{{文件名}}/` 文件夹中的 `{{文件名}}.md` 文件

# 本地 pdf 文件 ocr

参考如下示例代码，通过将文件上传到 MinerU 服务器完成 ocr
```python

import requests

token = "官网申请的api token"
url = "https://mineru.net/api/v4/file-urls/batch"
header = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {token}"
}
data = {
    "files": [
        {"name":"demo.pdf", "data_id": "abcd"}
    ],
    "model_version":"vlm"
}
file_path = ["demo.pdf"]
try:
    response = requests.post(url,headers=header,json=data)
    if response.status_code == 200:
        result = response.json()
        print('response success. result:{}'.format(result))
        if result["code"] == 0:
            batch_id = result["data"]["batch_id"]
            urls = result["data"]["file_urls"]
            print('batch_id:{},urls:{}'.format(batch_id, urls))
            for i in range(0, len(urls)):
                with open(file_path[i], 'rb') as f:
                    res_upload = requests.put(urls[i], data=f)
                    if res_upload.status_code == 200:
                        print(f"{urls[i]} upload success")
                    else:
                        print(f"{urls[i]} upload failed")
        else:
            print('apply upload url failed,reason:{}'.format(result["msg"]))
    else:
        print('response not success. status:{} ,result:{}'.format(response.status_code, response))
except Exception as err:
    print(err)
```

curl 命令示例
```bash
curl --location --request POST 'https://mineru.net/api/v4/extract/task' \
--header 'Authorization: Bearer ***' \
--header 'Content-Type: application/json' \
--header 'Accept: */*' \
--data-raw '{
    "url": "https://cdn-mineru.openxlab.org.cn/demo/example.pdf",
    "model_version": "vlm"
}'
···

# 对 url 指向的 pdf 文件进行 ocr

参考如下示例代码，通过将 url 提交到 MinerU 服务器完成 ocr
```python
import requests

token = "官网申请的api token"
url = "https://mineru.net/api/v4/extract/task"
header = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {token}"
}
data = {
    "url": "https://cdn-mineru.openxlab.org.cn/demo/example.pdf",
    "model_version": "vlm"
}

res = requests.post(url,headers=header,json=data)
print(res.status_code)
print(res.json())
print(res.json()["data"])
```


# ocr 进度和结果查询

无论你是“本地文件上传 OCR”还是“URL OCR”，成功创建任务后都会拿到 `task_id`（有些返回也会带 `batch_id`）。  
后续流程建议统一为：**轮询状态 -> 成功后下载结果 -> 解压整理到目标目录**。

## 1) 查询任务状态

> 建议使用轮询，每 2~5 秒查一次，直到任务完成或失败。  
> 常见终态：`done / success / finished`（成功），`failed / error`（失败）。  
> 具体状态字符串以官网返回为准
```python
import time
import requests

token = "官网申请的api token"
task_id = "你的task_id"

# 注意：此处路径按 v4 常见写法给出，若官网实际路径不同请替换
status_url = f"https://mineru.net/api/v4/extract/task/{task_id}"

headers = {
    "Authorization": f"Bearer {token}",
    "Accept": "application/json"
}

terminal_success = {"done", "success", "finished"}
terminal_failed = {"failed", "error"}

while True:
    res = requests.get(status_url, headers=headers, timeout=30)
    print("http_status =", res.status_code)
    data = res.json()
    print("resp =", data)

    if data.get("code") != 0:
        raise RuntimeError(f"query status failed: {data}")

    task_data = data.get("data", {})
    status = str(task_data.get("state", "")).lower() or str(task_data.get("status", "")).lower()
    print("task status =", status)

    if status in terminal_success:
        print("task finished")
        # 一般在这里取结果下载地址（字段名以实际返回为准）
        # 可能是 result_url / zip_url / output_url
        result_url = (
            task_data.get("result_url")
            or task_data.get("zip_url")
            or task_data.get("output_url")
        )
        print("result_url =", result_url)
        break

    if status in terminal_failed:
        raise RuntimeError(f"task failed: {task_data}")

    time.sleep(3)

```

2) 下载结果并解压

如果状态接口返回了压缩包地址（例如 `result_url`），可直接下载并解压：
```python 
import os
import shutil
import zipfile
import requests

token = "官网申请的api token"
result_url = "状态查询返回的结果下载地址"
file_name = "demo"  # 不带后缀，用于最终 md 命名

# 目标目录：{{文件夹}}/MinerU-output/{{文件名}}/
base_dir = os.path.abspath(".")
target_dir = os.path.join(base_dir, "MinerU-output", file_name)
os.makedirs(target_dir, exist_ok=True)

zip_path = os.path.join(target_dir, f"{file_name}.zip")
extract_dir = os.path.join(target_dir, "extract_tmp")

headers = {
    "Authorization": f"Bearer {token}"
}

# 下载 zip
with requests.get(result_url, headers=headers, stream=True, timeout=120) as r:
    r.raise_for_status()
    with open(zip_path, "wb") as f:
        for chunk in r.iter_content(chunk_size=8192):
            if chunk:
                f.write(chunk)

# 解压
if os.path.exists(extract_dir):
    shutil.rmtree(extract_dir)
os.makedirs(extract_dir, exist_ok=True)

with zipfile.ZipFile(zip_path, "r") as zf:
    zf.extractall(extract_dir)

# 将 full.md 重命名为 {{文件名}}.md 并移动到目标目录根
src_full_md = None
for root, _, files in os.walk(extract_dir):
    for fn in files:
        if fn == "full.md":
            src_full_md = os.path.join(root, fn)
            break
    if src_full_md:
        break

if not src_full_md:
    raise FileNotFoundError("full.md not found in extracted result")

dst_md = os.path.join(target_dir, f"{file_name}.md")
shutil.copy2(src_full_md, dst_md)

# 删除所有 json 文件
for root, _, files in os.walk(extract_dir):
    for fn in files:
        if fn.endswith(".json"):
            os.remove(os.path.join(root, fn))

# 可选：清理临时文件
os.remove(zip_path)
shutil.rmtree(extract_dir)

print("done, output md:", dst_md)

```

3) curl 示例（状态轮询 + 下载）

```python
# 1) 查询状态（示例）
curl --location --request GET 'https://mineru.net/api/v4/extract/task/{task_id}' \
--header 'Authorization: Bearer ***' \
--header 'Accept: application/json'

# 返回中拿到 result_url 后下载（示例）
curl --location --request GET '{result_url}' \
--header 'Authorization: Bearer ***' \
--output result.zip
```

# API 调用结果处理

- 将 ocr 结果 (解压后) 放入 `{{文件夹}}/MinerU-output/{{文件名}}/` 文件夹
- 将其中的 `full.md` 重命名为 `{{文件名}}.md`
- 移除结果中的 `.json` 文件
