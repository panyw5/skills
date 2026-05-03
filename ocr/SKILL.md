---
name: ocr
description: "perform ocr on pdf files in the specified folder, or on the files specified by the user, generate and store corresponding markdown files"
---


# 通过 OCR 服务获取论文的步骤

## 1. 确定待 OCR 的文件

### 确定文件与文件夹

根据实际应用场景，存在多种确定待 OCR 文件的方法
- 用户 (或上级 agent) 指定 `{{文件夹}}` 中**所有 pdf** 文件均需 OCR
- 用户 (或上级 agent) 指定文件夹 `{{文件夹}}` 内**部分 pdf** 文件需 OCR
- 用户 (或上级 agent) 指定**单独的**或者若干个文件 `{{PDF 文件名}}.pdf`、单个或多个 `{{url}}` 需 OCR
  * 若用户指定了 `{{PDF 文件名}}.pdf`，则 `{{文件夹}}` 为 `{{PDF 文件名}}` 所在文件夹
  * 若用户指定了 `{{url}}`，则必须通过 `cunzhi` 工具向用户询问 ocr 结果应当放置的文件夹 `{{文件夹}}`

### 准备 `to-convert.md` 文件

- 检查 `{{文件夹}}` 中是否存在 `to-convert.md`
  - 若**不存在**: **自动创建**该文件，并将 `{{文件夹}}` 中所有 `.pdf` 文件名写入该文件，每行一个文件名
  - 若**存在且非空**: 读取该文件，该文件里面每一行是还未完成 OCR 的论文 PDF 文件名
  - 若**存在且为空**: 根据 `确定文件与文件夹` 步骤中明确需要 OCR 的文件，将这些文件名写入该文件，每行一个文件名
- 对这些文件名对应的 PDF 文件，从上到下逐一应用**第三步：OCR 流程**



## 2. OCR 流程

### (CRITICAL) 检查PDF文件是否已完成 OCR

- **先搜索** `{{文件夹}}` 中是否有同名的 `{{PDF 文件名}}.md` 文件 (可能有多个，全部检查) 以及 `MinerU-output/{{PDF 文件名}}` 文件夹
  * 若存在, 直接读取这个 `{{PDF 文件名}}.md` 文件，检查 `.md` 文件的标题是否与 `{{PDF 文件名}}` 相同
    * 若**相同**：则该 `{{PDF 文件名}}.md` 文件正确，**立即从 `to-convert.md` 中删除对应条目**，移动到下一个条目开始 OCR 流程
    * 若**不相同**：则可能是之前错误 OCR 产生的文件，删除该 `{{PDF 文件名}}.md`，以及 `MinerU-output/{{PDF 文件名}}` 文件夹，**并进入下一步 OCR 流程**

### 获取论文或文章、讲义基本信息

- **搜索网络**: 根据用户提供的 `{{PDF 文件名}}.pdf` 文件名，通过 `exa` mcp 搜索获取相应论文 arXiv 号 `{{arxiv-id}}`、arXiv 上的 **PDF 网址** `{{arxiv-url}}` 或者其他**非 arXiv 源**的 PDF 网址 `{{url}}`。如果用户或者上级 agent 已经提供了 `{{url}}`，则可**跳过此步骤**
  * **关键**: 搜索时应处理特殊字符（如 `=`），并尝试多种搜索策略（如仅标题、作者+标题）。
  * **关键**: 使用正确的 URL 编码。
  * **关键**: 有的论文存放在 **Project Euclid** 上，在搜索时会作为条目出现，但可能未能显示完整的论文名称，请特别小心处理，可以通过打开网站，`fetch` 页面信息检查**论文标题与作者**，并查看 pdf 连接

  示例代码: 通过 arXiv API 搜索论文 ID
  ```python
  import requests
  import re
  import xml.etree.ElementTree as ET

  def search_arxiv(authors, title):
    """搜索 arXiv 获取论文 ID"""
    print(f"  搜索 arXiv...")
    
    # 构建搜索查询
    queries = []
    
    # 策略1: 使用作者 + 标题关键词
    if authors:
        author_list = [a.strip() for a in re.split(r'[,;&]|et\.?\s*al\.?', authors)]
        if author_list:
            first_author = author_list[0].split()[-1]  # 取姓氏
            title_keywords = '+'.join(title.split()[:4])  # 取前4个词
            queries.append(f"au:{first_author}+AND+ti:{title_keywords}")
    
    # 策略2: 仅使用标题
    title_keywords = '+'.join(title.split()[:6])  # 取前6个词
    queries.append(f"ti:{title_keywords}")
    
    # 策略3: 使用完整标题搜索
    full_title = '+'.join(title.split())
    queries.append(f"ti:{full_title}")
    
    for query_idx, query in enumerate(queries):
        try:
            url = f"http://export.arxiv.org/api/query?search_query={query}&max_results=20"
            response = requests.get(url, timeout=30)
            if response.status_code == 200:
                # 解析 XML
                root = ET.fromstring(response.content)
                ns = {'atom': 'http://www.w3.org/2005/Atom'}
                
                for entry in root.findall('atom:entry', ns):
                    entry_title = entry.find('atom:title', ns)
                    entry_id = entry.find('atom:id', ns)
                    
                    if entry_title is not None and entry_id is not None:
                        if entry_title.text and entry_id.text:
                            entry_title_text = entry_title.text.strip()
                            
                            # 验证标题是否匹配
                            if titles_match(title, entry_title_text):
                                arxiv_id = entry_id.text.split('/abs/')[-1]
                                print(f"  ✓ 找到匹配的 arXiv ID: {arxiv_id}")
                                print(f"    原标题: {title}")
                                print(f"    arXiv标题: {entry_title_text}")
                                return arxiv_id
                            
        except Exception as e:
            print(f"  搜索异常 (查询{query_idx+1}): {e}")
            continue
    
    print(f"  ✗ 未找到匹配的 arXiv ID")
    print(f"    原标题: {title}")
    return None

  ```


### 调用 MinerU 完成论文 OCR

MinerU 是一个在线免费的 pdf ocr 服务供应商。文档在 `https://mineru.net/apiManage/docs`。

- 根据上一步骤获得的 `{{arxiv-url}}` 或者 `{{url}}`，按照如下的**步骤 1-4**调用 minerU 进行 OCR
- **步骤 1-4**完成后，在 `{{文件夹}}` 下的 `to-convert.md` 中删除已经完成 OCR 的文件信息

以下是调用 MinerU 进行 OCR 的详细**步骤 1-4**。本技能目录现在指定统一脚本为：

- `/.claude/skills/ocr/ocr_single_paper.py`
- `/.claude/skills/ocr/ocr_batch.py`

使用要求：

- 优先使用这个脚本，不再优先调用工作区里各个子目录下那些历史遗留的 `batch_ocr.py`、`ocr_processor.py`、`ocr_single.py`
- 该脚本会自动查找可用的 `.env`（包括当前工作区、`Papers/.env`、项目根目录）并读取 `MINERU_TOKEN`，若找不到则回退到环境变量 `MINERU_TOKEN`
- 该脚本只会把 OCR 结果保存到 `{{文件夹}}/MinerU-output/{{PDF 文件名}}/{{PDF 文件名}}.md`，**不会**再复制一份到 PDF 所在目录
- 若流程需要批量处理，也应以这个脚本为核心进行循环调用，而不是再复用那些各目录下逻辑分叉的旧脚本

推荐用法：

- **单篇 OCR**：使用 `/.claude/skills/ocr/ocr_single_paper.py`
- **整个目录 OCR**：使用 `/.claude/skills/ocr/ocr_batch.py "{{文件夹}}"`
- **若干指定 PDF OCR**：使用 `/.claude/skills/ocr/ocr_batch.py "{{文件夹}}" "a.pdf" "b.pdf"`

已验证：

- 已使用 `Papers/Quantum Gravity/` 对 `ocr_batch.py` 做过真实测试
- 测试文件为 `[Penington, Witten] Algebras and States in JT Gravity.pdf`
- 测试结果成功，输出仅保存在 `MinerU-output/[Penington, Witten] Algebras and States in JT Gravity/[Penington, Witten] Algebras and States in JT Gravity.md`
- `to-convert.md` 中对应条目会在成功后自动删除，且不会在 PDF 所在目录额外复制顶层 `.md`

若在流程中发现问题，请优先修改这个统一脚本，而不是继续扩散修补多个旧脚本。

#### 步骤 1: 搜索 arXiv 并提交 OCR 任务
避免调用脚本时阻碍对话进程，请你将任务提交到后台运行，提交后通过 `cunzhi` 向我汇报提交是否顺利。

> 补充（非 arXiv URL / URL 抓取失败场景）
>
> - 若用户已提供非 arXiv `{{url}}`，可直接提交 URL 任务。
> - 若任务失败且 `err_msg` 包含 `failed to read file`，应切换到 **文件上传模式**：
>   1. 先下载该 PDF 到本地临时文件；
>   2. 调用 `POST https://mineru.net/api/v4/extract/task`（multipart/form-data，字段 `file` + `model_version=vlm`）；
>   3. 再按常规步骤查询任务状态并下载结果。
> - 若上传返回 `code=-10006`（`file upload not allowed`），说明当前 Token 无上传权限；需提示用户更换具备上传权限的 Token 或改用可被 MinerU 直接抓取的公开 URL。
> - 文件上传模式与 URL 模式共用相同的任务查询接口 `GET /api/v4/extract/task/{task_id}`（看 `state` 字段）。

文件上传模式示例代码：

```python
def submit_ocr_task_with_file(pdf_path):
    upload_headers = {
        "Authorization": f"Bearer {API_KEY}"
    }
    with open(pdf_path, "rb") as f:
        files = {
            "file": (os.path.basename(pdf_path), f, "application/pdf")
        }
        data = {
            "model_version": "vlm"
        }
        res = requests.post(
            "https://mineru.net/api/v4/extract/task",
            headers=upload_headers,
            files=files,
            data=data,
            timeout=120,
        )
    res.raise_for_status()
    result = res.json()
    if result.get("code") == 0 and result.get("msg") == "ok":
        return result["data"]["task_id"]
    return None
```

```python
def submit_ocr_task(pdf_url):
    """提交 OCR 任务"""
    data = {
        "url": pdf_url,
        "model_version": "vlm"
    }
    try:
        print(f"  提交任务到 MinerU...")
        res = requests.post(f"{BASE_URL}/task", headers=HEADERS, json=data, timeout=30)
        res.raise_for_status()
        result = res.json()
        if result.get("code") == 0 and result.get("msg") == "ok":
            task_id = result["data"]["task_id"]
            print(f"  ✓ 任务 ID: {task_id}")
            return task_id
        else:
            print(f"  ✗ 提交任务失败: {result}")
            return None
    except Exception as e:
        print(f"  ✗ 提交任务异常: {e}")
        return None
```

#### 步骤 2: 查询任务状态

- 定时查询任务状态。通过主对话窗口 (不是 `cunzhi`) 实时更新 OCR 任务状态。
- 当 OCR 任务完成，通过 `cunzhi` 向我汇报。

**关键**: 返回的 JSON 中使用 `state` 字段（不是 `status`）来表示任务状态。

示例代码

```python
import time

query_url = f"https://mineru.net/api/v4/extract/task/{task_id}"
max_attempts = 30
attempt = 0

while attempt < max_attempts:
    res = requests.get(query_url, headers=header)
    if res.status_code == 200:
        result = res.json()
        state = result["data"].get("state")  # 注意：是 state 不是 status
        
        if state == "done":  # 任务完成
            zip_url = result["data"]["full_zip_url"]
            print(f"任务完成！ZIP 文件: {zip_url}")
            break
        elif state == "failed":  # 任务失败
            print(f"任务失败: {result['data'].get('err_msg')}")
            break
        else:  # running 或其他状态，继续等待
            print(f"任务进行中 (state={state})，等待 10 秒...")
            time.sleep(10)
    
    attempt += 1
```

#### 步骤 3: 下载并解压结果

**关键**: 将解压后的文件放入 `{{文件夹}}/MinerU-output/{{PDF 文件名}}/` 文件夹，并将其中的 `full.md` 重命名为 `{{PDF 文件名}}.md`。

示例代码

```python
import zipfile
import io
import os
import shutil

# 获取论文文件名（不带扩展名）
pdf_filename = "论文文件名"  # 例如: "[Nishinaka, Tachikawa] On 4d rank-one N =3 superconformal field theories"
paper_dir = os.path.dirname(pdf_path)  # PDF 文件所在目录

# 创建 MinerU-output 文件夹及子文件夹
mineru_output_dir = os.path.join(paper_dir, "MinerU-output")
extract_dir = os.path.join(mineru_output_dir, pdf_filename)
os.makedirs(extract_dir, exist_ok=True)

# 下载并解压 ZIP 文件
response = requests.get(zip_url)
with zipfile.ZipFile(io.BytesIO(response.content)) as zip_ref:
    zip_ref.extractall(extract_dir)  # 解压到 MinerU-output/论文名/ 文件夹

# 处理 full.md 文件
full_md_path = os.path.join(extract_dir, "full.md")
if os.path.exists(full_md_path):
    # 重命名为论文名.md
    new_md_name = f"{pdf_filename}.md"
    new_md_path_in_folder = os.path.join(extract_dir, new_md_name)
    os.rename(full_md_path, new_md_path_in_folder)
    
```

#### 步骤 4：检查 OCR 结果是否正确

检查 `{{PDF 文件名}}.md` 文件的内容是否与 `{{PDF 文件名}}` 的内容一致
- 对比两篇论文、文章的**标题**是否一致
- 对比两篇论文、文章的**作者**是否一致

- 如果**一致**，则 OCR 结果正确，则**步骤 1-4**完成
  - **关键**: 成功完成后，立即从 `to-convert.md` 中删除该文件条目，以免重复处理
- 如果**不一致**：删除 `{{PDF 文件名}}.md`，以及 `MinerU-output` 中在步骤 3 产生的 `{{PDF 文件夹}}` 文件夹，重新执行步骤 1-4

## 处理失败文件 (Manual Fallback)

对于批量处理中失败的文件（如无法找到 arXiv ID 或 OCR 失败），请按以下步骤操作：

1. **手动搜索 arXiv ID**:
   - 使用 `exa` mcp 搜索论文标题。
   - 找到对应的 arXiv ID (如 `2106.12579` 或 `hep-th/9603042`)。

2. **使用统一单文件处理脚本**:
   - 运行 `/.claude/skills/ocr/ocr_single_paper.py` 进行单独处理。
   - 命令格式: `python "/Users/lelouch/Nutstore Files/Math and Physics/.claude/skills/ocr/ocr_single_paper.py" "PDF文件名(不含扩展名)" "/目标文件夹绝对路径" "PDF_URL"`
   - 示例:
     ```bash
     python "/Users/lelouch/Nutstore Files/Math and Physics/.claude/skills/ocr/ocr_single_paper.py" "[Kang, Lawrie, Song] Infinitely many 4d N = 2 SCFTs" "/目标文件夹绝对路径" "https://arxiv.org/pdf/2106.12579.pdf"
     ```

3. **更新列表**:
   - 手动处理成功后，运行 `update_to_convert.py` 或手动从 `to-convert.md` 中删除该文件。

## 3. 反馈

**必须行为**: 完成上述任务后，请在主对话窗口中输出完成情况 (便于日后检查复盘)，并 **调用 `cunzhi`** MCP 服务器，向用户总结你的回答，并询问是否需要进一步解释。

**禁止行为**: 直接结束对话，不通过 `cunzhi` MCP 服务器反馈结果
