#!/usr/bin/env python3
"""
使用指定的 arXiv ID 进行 OCR 处理
"""

import requests
import time
import zipfile
import io
import os
import sys
import re

# MinerU API配置
BASE_URL = "https://mineru.net/api/v4/extract"
API_KEY = "eyJ0eXBlIjoiSldUIiwiYWxnIjoiSFM1MTIifQ.eyJqdGkiOiIzODIwNDA0NiIsInJvbCI6IlJPTEVfUkVHSVNURVIiLCJpc3MiOiJPcGVuWExhYiIsImlhdCI6MTc2NzM0NjU0NywiY2xpZW50SWQiOiJsa3pkeDU3bnZ5MjJqa3BxOXgydyIsInBob25lIjoiIiwib3BlbklkIjpudWxsLCJ1dWlkIjoiM2VlYzcwMjAtNjVmZi00NjU2LTlmMDEtYjNmOGM3MzRjOWZhIiwiZW1haWwiOiIiLCJleHAiOjE3Njg1NTYxNDd9.aVLYxcmS8g5iqCY60QmxFX34YKaD_gOnzDPnibKIgn0jdI6fEegSUHS2QbCkWRIxuCdSE_R0e6ptkVLq1ObgMw"
HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

def submit_ocr_task(pdf_url):
    """提交OCR任务到MinerU"""
    data = {
        "url": pdf_url,
        "model_version": "vlm"
    }
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
                    return zip_url
                elif state == "failed":
                    err_msg = result["data"].get("err_msg", "未知错误")
                    print(f"  ✗ 任务失败: {err_msg}")
                    return None
                else:
                    print(f"  任务进行中 (state={state})，等待 10 秒... ({attempt+1}/{max_attempts})")
                    time.sleep(10)
        except Exception as e:
            print(f"  查询异常: {e}")
            time.sleep(10)

        attempt += 1

    print(f"  ✗ 任务超时")
    return None

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

def main():
    if len(sys.argv) < 3:
        print("用法: python ocr_with_arxiv_id.py <PDF文件名(不含扩展名)> <arXiv_ID> [paper_dir]")
        print("示例: python ocr_with_arxiv_id.py '[Kim, Kim] 3D TFTs...' 2511.23194")
        sys.exit(1)

    pdf_filename = sys.argv[1]
    arxiv_id = sys.argv[2]

    # 确定论文目录
    if len(sys.argv) >= 4:
        paper_dir = sys.argv[3]
    else:
        paper_dir = "Supersymmetric Gauge Theory/d=4"

    paper_dir = os.path.abspath(paper_dir)

    print(f"\n{'='*60}")
    print(f"开始处理: {pdf_filename}")
    print(f"arXiv ID: {arxiv_id}")
    print(f"论文目录: {paper_dir}")
    print(f"{'='*60}\n")

    # 构建 arXiv PDF URL
    pdf_url = f"https://arxiv.org/pdf/{arxiv_id}.pdf"

    # 提交OCR任务
    task_id = submit_ocr_task(pdf_url)
    if not task_id:
        print("\n✗ 提交OCR任务失败")
        sys.exit(1)

    # 等待任务完成
    zip_url = wait_for_task(task_id)
    if not zip_url:
        print("\n✗ OCR任务未完成")
        sys.exit(1)

    # 下载并解压
    md_path = download_and_extract(zip_url, pdf_filename, paper_dir)
    if not md_path:
        print("\n✗ 下载解压失败")
        sys.exit(1)

    print(f"\n{'='*60}")
    print(f"✓ OCR完成！")
    print(f"  结果文件: {md_path}")
    print(f"{'='*60}\n")
    sys.exit(0)

if __name__ == "__main__":
    main()
