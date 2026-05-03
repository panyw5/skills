#!/usr/bin/env python3
"""
Batch OCR entrypoint for a directory or an explicit list of PDFs.

This script uses ocr_single_paper.py as the single source of truth.
"""

import os
import sys

from ocr_single_paper import process_single_paper


def ensure_to_convert(paper_dir, explicit_files=None):
    """Ensure to-convert.md exists and return the file entries to process."""
    paper_dir = os.path.abspath(paper_dir)
    to_convert_path = os.path.join(paper_dir, "to-convert.md")

    if not os.path.exists(to_convert_path):
        pdfs = sorted(
            name for name in os.listdir(paper_dir) if name.lower().endswith(".pdf")
        )
        with open(to_convert_path, "w", encoding="utf-8") as f:
            for name in pdfs:
                f.write(name + "\n")
    elif os.path.getsize(to_convert_path) == 0 and explicit_files:
        with open(to_convert_path, "w", encoding="utf-8") as f:
            for name in explicit_files:
                f.write(name + "\n")

    with open(to_convert_path, "r", encoding="utf-8") as f:
        lines = [
            line.strip() for line in f if line.strip() and not line.startswith("#")
        ]

    if explicit_files:
        wanted = set(explicit_files)
        lines = [line for line in lines if line in wanted]

    return to_convert_path, lines


def normalize_pdf_name(name):
    return name if name.lower().endswith(".pdf") else f"{name}.pdf"


def main():
    if len(sys.argv) < 2:
        print("用法: python ocr_batch.py <paper_dir> [pdf1 pdf2 ...]")
        print('示例1: python ocr_batch.py "/path/to/folder"')
        print('示例2: python ocr_batch.py "/path/to/folder" "a.pdf" "b.pdf"')
        sys.exit(1)

    paper_dir = os.path.abspath(sys.argv[1])
    explicit_files = (
        [normalize_pdf_name(name) for name in sys.argv[2:]]
        if len(sys.argv) > 2
        else None
    )

    if not os.path.isdir(paper_dir):
        print(f"错误: 目录不存在: {paper_dir}")
        sys.exit(1)

    to_convert_path, files = ensure_to_convert(paper_dir, explicit_files)

    if not files:
        print("✓ 没有待处理文件")
        sys.exit(0)

    print(f"工作目录: {paper_dir}")
    print(f"列表文件: {to_convert_path}")
    print(f"共有 {len(files)} 个文件待处理")

    success_count = 0
    failed = []

    for index, filename in enumerate(files, 1):
        print(f"\n\n进度: [{index}/{len(files)}]")
        pdf_filename = os.path.splitext(filename)[0]
        success, md_path = process_single_paper(pdf_filename, paper_dir)
        if success:
            success_count += 1
            print("  ✓ 成功")
        else:
            failed.append(filename)
            print("  ✗ 失败")
            if md_path and os.path.exists(md_path):
                print(f"  ⚠ 生成了待检查文件: {md_path}")

    print(f"\n{'=' * 80}")
    print("处理完成!")
    print(f"成功: {success_count}/{len(files)}")
    print(f"失败: {len(failed)}/{len(files)}")
    print(f"{'=' * 80}")

    if failed:
        failed_path = os.path.join(paper_dir, "failed-convert.md")
        with open(failed_path, "w", encoding="utf-8") as f:
            f.write("# 转换失败的文件\n\n")
            for item in failed:
                f.write(item + "\n")
        print(f"失败列表已保存到: {failed_path}")
        sys.exit(1)

    sys.exit(0)


if __name__ == "__main__":
    main()
