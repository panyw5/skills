#!/usr/bin/env python3
"""
单个论文OCR处理脚本
使用arXiv API搜索论文，然后调用MinerU进行OCR
"""

import io
import os
import re
import sys
import tempfile
import time
import xml.etree.ElementTree as ET
import zipfile

import requests

BASE_URL = "https://mineru.net/api/v4/extract"


def load_env_file(start_path):
    """Search upward for a .env file and parse key=value pairs."""
    current_path = os.path.abspath(start_path)
    while True:
        env_path = os.path.join(current_path, ".env")
        if os.path.exists(env_path):
            env_vars = {}
            try:
                with open(env_path, "r", encoding="utf-8") as f:
                    for line in f:
                        line = line.strip()
                        if not line or line.startswith("#") or "=" not in line:
                            continue
                        key, value = line.split("=", 1)
                        env_vars[key.strip()] = value.strip()
                return env_vars
            except Exception as e:
                print(f"Warning: Failed to read .env file at {env_path}: {e}")
                return None

        parent_path = os.path.dirname(current_path)
        if parent_path == current_path:
            return None
        current_path = parent_path


def load_mineru_token():
    search_roots = [
        os.path.dirname(os.path.abspath(__file__)),
        os.getcwd(),
        "/Users/lelouch/Nutstore Files/Math and Physics/Papers",
        "/Users/lelouch/Nutstore Files/Math and Physics",
    ]

    seen = set()
    for root in search_roots:
        if not root:
            continue
        root = os.path.abspath(root)
        if root in seen:
            continue
        seen.add(root)
        env_vars = load_env_file(root)
        if env_vars and env_vars.get("MINERU_TOKEN"):
            return env_vars["MINERU_TOKEN"]

    return os.environ.get("MINERU_TOKEN")


API_KEY = load_mineru_token()
if not API_KEY:
    print("Warning: MINERU_TOKEN not found in .env file or environment variables.")

HEADERS = {"Authorization": f"Bearer {API_KEY}", "Content-Type": "application/json"}


def titles_match(title1, title2):
    """检查两个标题是否匹配（忽略大小写和特殊字符）"""
    stop_words = {
        "a",
        "an",
        "the",
        "to",
        "of",
        "in",
        "on",
        "for",
        "and",
        "with",
        "from",
        "by",
        "into",
    }

    def normalize(s):
        # 移除特殊字符，转小写
        s = re.sub(r"[^\w\s]", "", s.lower())
        # 移除多余空格
        s = " ".join(s.split())
        return s

    norm1 = normalize(title1)
    norm2 = normalize(title2)

    # 检查是否有足够的重叠
    words1 = set(norm1.split())
    words2 = set(norm2.split())

    if len(words1) == 0 or len(words2) == 0:
        return False

    overlap = len(words1 & words2)
    min_len = min(len(words1), len(words2))

    # 额外约束：重要词（长度>=5且非停用词）至少匹配60%
    sig1 = {w for w in words1 if len(w) >= 5 and w not in stop_words}
    sig2 = {w for w in words2 if len(w) >= 5 and w not in stop_words}
    if sig1:
        sig_overlap_ratio = len(sig1 & sig2) / len(sig1)
        if sig_overlap_ratio < 0.6:
            return False

    # 如果至少70%的词重叠，认为匹配
    return overlap / min_len >= 0.7


def parse_pdf_filename(filename):
    """从PDF文件名解析作者和标题"""
    # 移除.pdf扩展名
    name = filename.replace(".pdf", "")

    # 尝试匹配 [作者] 标题 格式
    match = re.match(r"\[(.*?)\]\s*(.*)", name)
    if match:
        authors = match.group(1)
        title = match.group(2)
        return authors, title

    # 如果没有方括号，整个作为标题
    return "", name


def search_arxiv(authors, title):
    """搜索arXiv获取论文ID"""
    print(f"  搜索 arXiv...")
    print(f"    作者: {authors}")
    print(f"    标题: {title}")

    # 构建搜索查询
    queries = []

    # 策略1: 使用作者 + 标题关键词
    if authors:
        author_list = [a.strip() for a in re.split(r"[,;&]|et\.?\s*al\.?", authors)]
        if author_list:
            first_author = author_list[0].split()[-1]  # 取姓氏
            title_keywords = "+".join(title.split()[:4])  # 取前4个词
            queries.append(f"au:{first_author}+AND+ti:{title_keywords}")

    # 策略2: 仅使用标题关键词
    title_keywords = "+".join(title.split()[:6])  # 取前6个词
    queries.append(f"ti:{title_keywords}")

    # 策略3: 使用完整标题搜索
    full_title = "+".join(title.split())
    queries.append(f"ti:{full_title}")

    for query_idx, query in enumerate(queries):
        try:
            url = (
                f"http://export.arxiv.org/api/query?search_query={query}&max_results=20"
            )
            print(f"  尝试查询 {query_idx + 1}: {query[:50]}...")
            response = requests.get(url, timeout=30)
            if response.status_code == 200:
                # 解析XML
                root = ET.fromstring(response.content)
                ns = {"atom": "http://www.w3.org/2005/Atom"}

                for entry in root.findall("atom:entry", ns):
                    entry_title = entry.find("atom:title", ns)
                    entry_id = entry.find("atom:id", ns)

                    if entry_title is not None and entry_id is not None:
                        if entry_title.text and entry_id.text:
                            entry_title_text = entry_title.text.strip()

                            # 验证标题是否匹配
                            if titles_match(title, entry_title_text):
                                arxiv_id = entry_id.text.split("/abs/")[-1]
                                print(f"  ✓ 找到匹配的 arXiv ID: {arxiv_id}")
                                print(f"    原标题: {title}")
                                print(f"    arXiv标题: {entry_title_text}")
                                return arxiv_id, f"https://arxiv.org/pdf/{arxiv_id}.pdf"

        except Exception as e:
            print(f"  搜索异常 (查询{query_idx + 1}): {e}")
            continue

    print(f"  ✗ 未找到匹配的 arXiv ID")
    print(f"    原标题: {title}")
    return None, None


def submit_ocr_task(pdf_url):
    """提交OCR任务到MinerU"""
    data = {"url": pdf_url, "model_version": "vlm"}
    try:
        print(f"  提交任务到 MinerU...")
        print(f"    PDF URL: {pdf_url}")
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


def submit_ocr_task_with_file(pdf_path):
    """通过本地文件上传提交OCR任务"""
    try:
        print(f"  提交本地文件到 MinerU...")
        upload_headers = {"Authorization": f"Bearer {API_KEY}"}
        with open(pdf_path, "rb") as f:
            files = {"file": (os.path.basename(pdf_path), f, "application/pdf")}
            data = {"model_version": "vlm"}
            res = requests.post(
                f"{BASE_URL}/task",
                headers=upload_headers,
                files=files,
                data=data,
                timeout=120,
            )
        res.raise_for_status()
        result = res.json()
        if result.get("code") == 0 and result.get("msg") == "ok":
            task_id = result["data"]["task_id"]
            print(f"  ✓ 上传任务 ID: {task_id}")
            return task_id
        if result.get("code") == -10006:
            print("  ✗ 当前 MinerU Token 无文件上传权限（code=-10006）")
            return None
        print(f"  ✗ 上传任务提交失败: {result}")
        return None
    except Exception as e:
        print(f"  ✗ 上传任务提交异常: {e}")
        return None


def download_source_pdf(pdf_url, pdf_filename):
    """下载源PDF到临时文件，供上传模式使用"""
    try:
        print("  下载源 PDF 到本地用于上传模式...")
        res = requests.get(pdf_url, timeout=120)
        res.raise_for_status()
        if not res.content.startswith(b"%PDF"):
            print("  ✗ 下载内容不是有效 PDF")
            return None
        tmp_file = tempfile.NamedTemporaryFile(
            prefix=f"ocr_{pdf_filename[:24]}_", suffix=".pdf", delete=False
        )
        tmp_file.write(res.content)
        tmp_file.close()
        print(f"  ✓ 临时 PDF: {tmp_file.name}")
        return tmp_file.name
    except Exception as e:
        print(f"  ✗ 下载源 PDF 失败: {e}")
        return None


def wait_for_task(task_id, max_attempts=60):
    """等待OCR任务完成"""
    query_url = f"{BASE_URL}/task/{task_id}"
    attempt = 0

    print(f"  等待任务完成...")
    while attempt < max_attempts:
        try:
            res = requests.get(query_url, headers=HEADERS, timeout=30)
            if res.status_code == 200:
                result = res.json()
                state = result["data"].get("state")

                if state == "done":
                    zip_url = result["data"]["full_zip_url"]
                    print(f"  ✓ 任务完成！")
                    return zip_url, state, None
                elif state == "failed":
                    err_msg = result["data"].get("err_msg", "未知错误")
                    print(f"  ✗ 任务失败: {err_msg}")
                    return None, state, err_msg
                else:
                    print(
                        f"  任务进行中 (state={state})，等待 10 秒... ({attempt + 1}/{max_attempts})"
                    )
                    time.sleep(10)
        except Exception as e:
            print(f"  查询异常: {e}")
            time.sleep(10)

        attempt += 1

    print(f"  ✗ 任务超时")
    return None, "timeout", "任务超时"


def download_and_extract(zip_url, pdf_filename, paper_dir):
    """下载并解压OCR结果"""
    print(f"  下载并解压结果...")

    # 创建MinerU-output文件夹
    mineru_output_dir = os.path.join(paper_dir, "MinerU-output")
    extract_dir = os.path.join(mineru_output_dir, pdf_filename)
    os.makedirs(extract_dir, exist_ok=True)

    try:
        # 下载ZIP文件
        response = requests.get(zip_url, timeout=60)
        response.raise_for_status()

        # 解压
        with zipfile.ZipFile(io.BytesIO(response.content)) as zip_ref:
            zip_ref.extractall(extract_dir)

        print(f"  ✓ 解压完成: {extract_dir}")

        # 处理full.md文件
        full_md_path = os.path.join(extract_dir, "full.md")
        if os.path.exists(full_md_path):
            new_md_name = f"{pdf_filename}.md"
            new_md_path = os.path.join(extract_dir, new_md_name)
            os.rename(full_md_path, new_md_path)
            print(f"  ✓ 重命名 full.md -> {new_md_name}")
            return new_md_path
        else:
            print(f"  ✗ 未找到 full.md 文件")
            return None

    except Exception as e:
        print(f"  ✗ 下载解压异常: {e}")
        return None


def verify_ocr_result(md_path, expected_title, expected_authors):
    """验证OCR结果是否正确"""
    print(f"  验证OCR结果...")

    try:
        with open(md_path, "r", encoding="utf-8") as f:
            content = f.read(2000)  # 只读前2000字符

        # 检查标题是否在前面部分出现
        if titles_match(expected_title, content):
            print(f"  ✓ 标题匹配")
            return True
        else:
            print(f"  ✗ 标题不匹配")
            print(f"    期望: {expected_title}")
            print(f"    MD文件前200字符: {content[:200]}")
            return False

    except Exception as e:
        print(f"  ✗ 验证异常: {e}")
        return False


def update_to_convert(paper_dir, pdf_filename):
    """Remove the processed PDF entry from to-convert.md if present."""
    to_convert_path = os.path.join(paper_dir, "to-convert.md")
    if not os.path.exists(to_convert_path):
        return

    with open(to_convert_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    new_lines = [line for line in lines if pdf_filename not in line]

    with open(to_convert_path, "w", encoding="utf-8") as f:
        f.writelines(new_lines)

    print("✓ 已从 to-convert.md 中删除该条目")


def process_single_paper(pdf_filename, paper_dir, direct_pdf_url=None):
    """Run OCR flow for a single PDF filename (without extension)."""
    paper_dir = os.path.abspath(paper_dir)

    print(f"\n{'=' * 60}")
    print(f"开始处理: {pdf_filename}")
    print(f"论文目录: {paper_dir}")
    print(f"{'=' * 60}\n")

    authors, title = parse_pdf_filename(pdf_filename)

    if direct_pdf_url:
        pdf_url = direct_pdf_url
        print(f"  使用用户提供的 PDF URL: {pdf_url}")
    else:
        arxiv_id, pdf_url = search_arxiv(authors, title)
        if not arxiv_id:
            print("\n✗ 无法找到arXiv论文，请手动提供 PDF URL")
            return False, None

    task_id = submit_ocr_task(pdf_url)
    if not task_id:
        print("\n✗ 提交OCR任务失败")
        return False, None

    zip_url, state, err_msg = wait_for_task(task_id)

    if (
        not zip_url
        and state == "failed"
        and err_msg
        and "failed to read file" in err_msg.lower()
    ):
        print("\n  检测到 URL 读取失败，自动切换为文件上传模式重试...")
        local_pdf = download_source_pdf(pdf_url, pdf_filename)
        if local_pdf:
            try:
                task_id = submit_ocr_task_with_file(local_pdf)
                if task_id:
                    zip_url, state, err_msg = wait_for_task(task_id)
            finally:
                if os.path.exists(local_pdf):
                    os.remove(local_pdf)

    if not zip_url:
        print("\n✗ OCR任务未完成")
        return False, None

    md_path = download_and_extract(zip_url, pdf_filename, paper_dir)
    if not md_path:
        print("\n✗ 下载解压失败")
        return False, None

    if verify_ocr_result(md_path, title, authors):
        print(f"\n{'=' * 60}")
        print("✓ OCR完成！")
        print(f"  结果文件: {md_path}")
        print(f"{'=' * 60}\n")
        update_to_convert(paper_dir, pdf_filename)
        return True, md_path

    print("\n✗ OCR结果验证失败")
    return False, md_path


def main():
    if len(sys.argv) < 2:
        print(
            "用法: python ocr_single_paper.py <PDF文件名(不含扩展名)> [paper_dir] [pdf_url]"
        )
        print(
            "示例: python ocr_single_paper.py '[Kim, Kim] 3D TFTs and boundary VOAs from BPS spectra of (G, G′) Argyres-Douglas theories'"
        )
        sys.exit(1)

    pdf_filename = sys.argv[1]

    if len(sys.argv) >= 3:
        paper_dir = sys.argv[2]
    else:
        paper_dir = "Supersymmetric Gauge Theory/d=4"

    direct_pdf_url = sys.argv[3] if len(sys.argv) >= 4 else None

    success, _ = process_single_paper(pdf_filename, paper_dir, direct_pdf_url)
    sys.exit(0 if success else 1)


if __name__ == "__main__":
    main()
