# Goal
这是用于 skill `ocr` 的 API 调用说明文档。参考完整文档 [doc](https://mineru.net/apiManage/docs)

关键输出是 `{{文件夹}}/MinerU-output/{{文件名}}/` 文件夹中的 `{{文件名}}.md` 文件

# 本地 pdf 文件 ocr

根据 `文件名` 进行搜索，确认文件是否 arXiv 论文。根据结果进行如下处理。

## arXiv 论文 ocr
- 获取 arXiv 论文的 HTML 页面链接 `https://arxiv.org/html/XXXX.XXXXXvX`
- 参考脚本 [arxiv-to-md](arxiv-to-md.py) 进行下载和转换
- 下载和转换产物按照上述输出要求重命名和放置


## 非 arXiv 论文 ocr

如果未能找到 arXiv 号，通过将本地文件上传到 MinerU 服务器完成 ocr。参考脚本 [ocr_single_paper](ocr_single_paper.py), [ocr_batch](ocr_batch.py)

# 对 url 指向的 pdf 文件进行 ocr

参考 [ocr_single_paper](ocr_single_paper.py) 的 `submit_ocr_task(pdf_url)`


# MinerU ocr 进度和结果查询

无论你是“本地文件上传 OCR”还是“URL OCR”，成功创建任务后都会拿到 `task_id`（有些返回也会带 `batch_id`）。  
后续流程建议统一为：**轮询状态 -> 成功后下载结果 -> 解压整理到目标目录**。

## 1) 查询任务状态

建议使用轮询，每 2~5 秒查一次，直到任务完成或失败。  
常见终态：`done / success / finished`（成功），`failed / error`（失败）。  
具体状态字符串以官网返回为准

参考 `wait_for_task` in [ocr_single_paper](ocr_single_paper.py)

2) 下载结果并解压

如果状态接口返回了压缩包地址（例如 `result_url`），可直接下载并解压。参考 [ocr_single_paper](ocr_single_paper.py) 的 `download_and_extract`。清理 `.json` 等与 `.md` 无关的文件


# API 调用结果处理

- 将 ocr 结果 (解压后) 放入 `{{文件夹}}/MinerU-output/{{文件名}}/` 文件夹
- 将其中的 `full.md` 重命名为 `{{文件名}}.md`
- 移除结果中的 `.json` 文件
