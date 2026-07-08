from __future__ import annotations

import argparse
import re
import subprocess
import sys
import textwrap
import time
from pathlib import Path
from urllib.parse import urljoin, urlparse
from urllib.request import Request, urlopen

from bs4 import BeautifulSoup, NavigableString, Tag

ARXIV_HTML_RE = re.compile(r"^https://arxiv\.org/html/(?P<id>\d{4}\.\d{4,5}v\d+)$")


def normalize_url(url: str) -> str:
    url = url.strip()
    while url.endswith(("\\n", "\\r", "\\t")):
        url = url[:-2].strip()
    return url


def fetch(url: str) -> bytes:
    url = url.strip()
    for attempt in range(1, 4):
        req = Request(url, headers={"User-Agent": "Mozilla/5.0 markdown-converter"})
        try:
            with urlopen(req, timeout=60) as response:
                data = response.read()
                if not data:
                    raise RuntimeError(f"empty response for {url}")
                return data
        except Exception as exc:
            print(
                f"warning: Python download attempt {attempt} failed for {url}: {exc}",
                file=sys.stderr,
            )
            time.sleep(attempt)

    result = subprocess.run(
        [
            "curl",
            "-L",
            "--fail",
            "--silent",
            "--show-error",
            "--user-agent",
            "Mozilla/5.0 markdown-converter",
            url,
        ],
        check=False,
        capture_output=True,
    )
    if result.returncode != 0:
        message = result.stderr.decode("utf-8", errors="replace").strip()
        print(f"warning: curl download failed for {url}: {message}", file=sys.stderr)
    else:
        if not result.stdout:
            raise RuntimeError(f"curl returned an empty response for {url}")
        return result.stdout

    result = subprocess.run(
        [
            "wget",
            "-q",
            "-O",
            "-",
            "--user-agent=Mozilla/5.0 markdown-converter",
            url,
        ],
        check=False,
        capture_output=True,
    )
    if result.returncode != 0:
        message = result.stderr.decode("utf-8", errors="replace").strip()
        raise RuntimeError(f"wget download failed for {url}: {message}")
    if not result.stdout:
        raise RuntimeError(f"wget returned an empty response for {url}")
    return result.stdout


def clean_text(text: str) -> str:
    return re.sub(r"\s+", " ", text).strip()


def filename_for_url(url: str, index: int) -> str:
    path = urlparse(url).path
    name = Path(path).name or f"image-{index}"
    name = re.sub(r"[^A-Za-z0-9._-]", "_", name)
    if "." not in name:
        name += ".bin"
    return f"{index:03d}-{name}"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Download an arXiv HTML paper, including images, and convert it to Markdown."
    )
    parser.add_argument(
        "url",
        help="arXiv HTML URL, for example: https://arxiv.org/html/2604.19885v2",
    )
    parser.add_argument(
        "--out-root",
        default="tmp",
        help="Root output directory. Default: tmp",
    )
    return parser.parse_args()


def arxiv_id_from_url(url: str) -> str:
    url = normalize_url(url)
    match = ARXIV_HTML_RE.match(url)
    if not match:
        raise ValueError(
            "URL must look like https://arxiv.org/html/XXXX.XXXXXvX; quote it and do not append literal \\n"
        )
    return match.group("id")


def inline_md(node: Tag | NavigableString, base_url: str) -> str:
    if isinstance(node, NavigableString):
        return str(node)
    if not isinstance(node, Tag):
        return ""

    name = node.name.lower()
    if name in {"script", "style", "noscript"}:
        return ""
    content = "".join(inline_md(child, base_url) for child in node.children)

    if name in {"strong", "b"}:
        return f"**{clean_text(content)}**"
    if name in {"em", "i"}:
        return f"*{clean_text(content)}*"
    if name == "code":
        return f"`{clean_text(content)}`"
    if name == "a":
        href = node.get("href")
        label = clean_text(content) or href or ""
        if href:
            return f"[{label}]({urljoin(base_url, href)})"
        return label
    if name == "br":
        return "\n"
    if name == "math":
        annotation = node.find("annotation", encoding="application/x-tex")
        if annotation and annotation.string:
            tex = annotation.string.strip()
            display = node.get("display") == "block" or node.find_parent(
                class_=re.compile("ltx_equation")
            )
            return f"\n\n$$\n{tex}\n$$\n\n" if display else f"${tex}$"
        return clean_text(node.get_text(" "))
    if name == "img":
        alt = clean_text(node.get("alt") or "")
        src = node.get("src") or ""
        return f"![{alt}]({src})"
    return content


def block_md(node: Tag, base_url: str) -> list[str]:
    name = node.name.lower()
    classes = " ".join(node.get("class", []))

    if name in {"script", "style", "noscript"}:
        return []
    if name in {"h1", "h2", "h3", "h4", "h5", "h6"}:
        level = int(name[1])
        return [f"{'#' * level} {clean_text(inline_md(node, base_url))}"]
    if name == "p" or "ltx_para" in classes:
        text = clean_text(inline_md(node, base_url))
        return [text] if text else []
    if name == "figure" or "ltx_figure" in classes:
        parts: list[str] = []
        for img in node.find_all("img"):
            alt = clean_text(img.get("alt") or "")
            src = img.get("src") or ""
            parts.append(f"![{alt}]({src})")
        caption = node.find(class_=re.compile("ltx_caption")) or node.find("figcaption")
        if caption:
            cap = clean_text(inline_md(caption, base_url))
            if cap:
                parts.append(f"*{cap}*")
        return parts
    if name in {"ul", "ol"}:
        out: list[str] = []
        ordered = name == "ol"
        for idx, li in enumerate(node.find_all("li", recursive=False), 1):
            marker = f"{idx}." if ordered else "-"
            out.append(f"{marker} {clean_text(inline_md(li, base_url))}")
        return out
    if name == "table" or "ltx_tabular" in classes:
        text = clean_text(node.get_text(" | "))
        return [text] if text else []
    if name == "blockquote":
        text = clean_text(inline_md(node, base_url))
        return (
            ["\n".join(f"> {line}" for line in textwrap.wrap(text, 100))]
            if text
            else []
        )
    if name == "math":
        return [inline_md(node, base_url).strip()]
    if name == "img":
        alt = clean_text(node.get("alt") or "")
        src = node.get("src") or ""
        return [f"![{alt}]({src})"] if src else []

    blocks: list[str] = []
    for child in node.children:
        if isinstance(child, Tag):
            blocks.extend(block_md(child, base_url))
    return blocks


def main() -> int:
    args = parse_args()
    args.url = normalize_url(args.url)
    try:
        arxiv_id = arxiv_id_from_url(args.url)
    except ValueError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    out_dir = Path(args.out_root) / f"arxiv_{arxiv_id.replace('.', '_')}"
    img_dir = out_dir / "images"
    html_path = out_dir / f"{arxiv_id}.html"
    md_path = out_dir / f"{arxiv_id}.md"

    out_dir.mkdir(parents=True, exist_ok=True)
    img_dir.mkdir(parents=True, exist_ok=True)

    html = fetch(args.url)
    html_path.write_bytes(html)
    soup = BeautifulSoup(html, "html.parser")

    base_tag = soup.find("base", href=True)
    asset_base_url = urljoin(args.url, base_tag["href"]) if base_tag else args.url

    for unwanted in soup.find_all(["script", "style", "noscript"]):
        unwanted.decompose()

    image_map: dict[str, str] = {}
    for idx, img in enumerate(soup.find_all("img"), 1):
        src = img.get("src")
        if not src:
            continue
        src = src.strip()
        if not src:
            continue
        abs_url = urljoin(asset_base_url, src)
        if abs_url not in image_map:
            name = filename_for_url(abs_url, idx)
            target = img_dir / name
            target.write_bytes(fetch(abs_url))
            image_map[abs_url] = f"images/{name}"
        img["src"] = image_map[abs_url]

    main = soup.find("article") or soup.find("main") or soup.body or soup
    blocks = block_md(main, asset_base_url)
    title = soup.find("title")
    title_text = clean_text(title.get_text(" ")) if title else f"arXiv {arxiv_id}"
    header = [f"# {title_text}", "", f"Source: {args.url}"]
    md = "\n\n".join(header + blocks).strip() + "\n"
    md_path.write_text(md, encoding="utf-8")

    print(f"html={html_path}")
    print(f"markdown={md_path}")
    print(f"images={len(image_map)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
