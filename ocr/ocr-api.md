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


# API 调用结果处理

- 将 ocr 结果 (解压后) 放入 `{{文件夹}}/MinerU-output/{{文件名}}/` 文件夹
- 将其中的 `full.md` 重命名为 `{{文件名}}.md`
- 移除结果中的 `.json` 文件
