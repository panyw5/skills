---
name: tex-to-marp
description: 将 LaTeX Beamer ppt 转换为 Marp 格式的 Markdown 文件的技能
---

# MANDATORY rules
- [CRITICAL] **DO NOT** change the content of the original `.tex` file, **CONVERT ONLY** the syntax and format into marp syntax
- [CRITICAL] **DO NOT** use python or bash script: highly unreliable and will break the format. Use your own **large language model capability** to perform the conversion manually.


## Task and Workflow:

### Objective
Convert a specified `.tex` file into a single, well-formatted `.md` file for Marp presentations, using a sectional approach.

### WORKFLOW OVERVIEW

Make a **TODO list** for the following workflow. Assign tasks to subagents to perform small tasks

0. Preparation
1. Segment `%source`
2. Script to Split `%source`
3. 检查 `to-convert-i.tex` 文件
4. 把 `to-convert-i.tex` 文件转换为 `converted-i.md` 文件
5. Verify and Refine Segment Conversion
6. Iterate for All Segments
7. Script to Merge `converted-n.md` Files


#### WORKFLOW DETAIL


### Step 0: Preparation
- 检查项目目录下是否有 `images/` 文件夹，如果没有，请创建一个用于存放图片文件。
- 检查项目目录是否有用户指定的 `.tex` 文件 (`%source`)，如果没有，请用户提供一个 `.tex` 文件作为转换的输入。
- 样本文件：[slides-example](slides-example.md)
  - 学习 marp 语法
  - 了解常用样式
- 新建一个 `tikzpicture.md` 文件，专门用于标记等待转换为 standalone tikzpicture 的 tex 代码片段


### Step 1: Segment `%source`**

- **Action:** Analyze `%source` and divide it into logical sections (approx. 10-20 Marp slides each).
- **Output:** A manifest listing the start and end line numbers for each section in `%source`.
### Step 2: Script to Split `%source`**

- **Action:** Create a script (e.g., Bash, Batch, Python).
- **Inputs:** `%source`, section manifest (line numbers).
- **Functionality:** Extract content for each section into separate files.
- **Output:** `to-convert-1.tex`, `to-convert-2.tex`, ..., `to-convert-n.tex`.
- **Constraint:** **MANDATORY** generation of `to-convert-n.tex` files. Do not skip.
- **completeness** when splitting, ensure that each `to-convert-i.tex` file contains a complete set of frames (one `\begin{frame}` must be paired with one `\end{frame}`)

### Step 3: 检查 `to-convert-i.tex` 文件
详情参考 [tikzpicture->svg](tikzpicture->svg.md)
- 定位所有 tikzpicture 环境片段 in `to-convert-i.tex` file: 确定起始和终结行号
- 将定位到的 tikzpicture 环境片段保存到 `tikzpicture.md` 文件中，标记起始和终结行号，每条目记录为 `markdown` todo 格式
  ```markdown
  - [ ] `to-convert-i.tex`, lines X-Y
  - [ ] `to-convert-j.tex`, lines Z-W
  ```
- 对上面每个条目，逐一保存 tikzpicture 环境内容到独立的 `.tex` file under the folder `images/`
- 独立 `.tex` 文件的格式
- 编译独立 `.tex` 文件，生成 pdf 文件
- 将 pdf 文件转换为 svg 文件
- 在 `to-convert-i.tex` 文件中，将原 tikzpicture 环境替换为对生成的 svg 文件的引用
  ```markdown
  ![width:YYpx](path-to-svg-file)
  ```
  后续完成 tex-to-marp 转换时，直接复制上述 markdown 语法到 `converted-i.md` 文件中即可
- 完成后，在 ``tikzpicture.md` 文件中标记完成状态
  ```markdown
  - [x] `to-convert-i.tex`, lines X-Y
  - [ ] `to-convert-j.tex`, lines Z-W
  ```


### Step 4: 把 `to-convert-i.tex` 文件转换为 `converted-i.md` 文件

- **For each `to-convert-i.tex`:**
    - **A. Create:** New `converted-i.md` file.
    - **B. Convert:** Entire content of `to-convert-i.tex` to Marp format in `converted-i.md`.
    - **STRICTLY Follow** rules in the "Detailed replacemenet rules" section
    - **Adhere to Marp syntax** for slides, directives, and features.
    - **Preserve all content:** No omissions of frames, sentences, or math expressions.
    - **Content Integrity:** No substantive content changes; only format conversion.
    - **Math:** Use Marp-compatible LaTeX for math (inline math using `$...$`, and `$$...$$` for other math environments).

### Step 5: Verify and Refine Segment Conversion

- **For each `converted-i.md`:**
    - **A. Compare:** `converted-i.md` with its source `to-convert-i.tex`.
    - **B. Check for:** Omissions, errors (especially math), structural loss.
    - **C. Correct:** Revise `converted-i.md` to fix issues (add missing frames, fix math errors, etc.), maintaining original structure.


### Step 6: Iterate for All Segments

- **Action:** Repeat Step 3 (Convert) and Step 4 (Verify) for all `to-convert-n.tex` files.
- **Outcome:** A set of verified `converted-1.md`, ..., `converted-n.md` files.


### Step 7: Script to Merge `converted-n.md` Files

- **Action:** Create a script.
- **Inputs:** All `converted-n.md` files.
- **Functionality:**
- Remove the global marp directives and latex `\newcommand` from all **but the first** `converted-1.md` file

```markdown
---
marp: true
theme: rose-pine-dawn
paginate: true
_paginate: skip
size: 16:9

math: mathjax
---
```
and 

```markdown
$$
\newcommand\blue[1]{{\color[rgb]{0.20, 0.43, 0.75}{#1}}}
\newcommand\red[1]{{\color[rgb]{0.839844, 0.507813, 0.488281}{#1}}}
\newcommand\green[1]{{\color[rgb]{.359375, .59765625, .41015625}{#1}}}
\newcommand\gray[1]{{\color[rgb]{0.5, 0.5, 0.5}{#1}}}
\newcommand\purple[1]{{\color[rgb]{0.63515625, 0.49609375, 0.80859375}{#1}}}
\newcommand\white[1]{{\color{white}{#1}}}
\newcommand\orange[1]{{\color[rgb]{0.63515625, 0.51015625, 0.37734375}{#1}}}
$$
```

-  Concatenate `converted-1.md` through `converted-n.md` sequentially.
-  **Directive Management:** Ensure only one set of necessary global Marp directives (from `converted-1.md`) exists at the start of the final file. Remove redundant global directives from subsequent files. Maintain slide separators.
- **Output:** A single `converted.md` file.


# .tex 到 .md 的详细替换规则

## convert itemize environment
- Simply use the markdown `-` to replace the `\item` environment
- Use `*` to replace the `\item<+->` environment

## convert colored box
(the double star should be included in the replacement, with NO SPACE between the stars and the content)
- `\greenbox{green text}` -> `**<green>green text**`
- `\redbox{green text}` -> `**<red>green text**`
- `\bluebox{green text}` -> `**<orange>green text**`

## convert comment block
- `\commentblock{COMMENT_TITLE}{COMMENT_CONTENT}` should be replaced by (notice an EMPTY line should be added AFTER the `<div class='proof comment'>`)

  ```tex
  <div class='proof comment'>
  
  **COMMENT_TITLE**
  
  COMMENT_CONTENT
  </div>
  ```

- In `\commentblock{COMMENT_TITLE}{COMMENT_CONTENT}`, there are also colored boxes, `\greenbox{text}`, `\bluebox{text}`, `\redbox{text}`, also replaceable by `**<green>green text**`, `**<red>red text**`, `**<orange>orange text**`

## convert exposition block
- `\expositionblock{TITLE}{CONTENT}` should be replaced by (notice an EMPTY line should be added AFTER the <div class="proof">)

  ```tex
  <div class="proof">

  **TITLE**

  CONTENT
  </div>
  ```

## convert highlight in math environment
- In math environment, replace `\highlight{red}{MATH}` by `\red{MATH}` 
- In math environment, replace `\highlight{titlegreen}{MATH}` by `\green{MATH}` 
- In math environment, replace `\highlight{titleblue}{MATH}` by `\orange{MATH}`
- DO NOT CHANGE THE CONTENT OF THE MATH EQUATION, KEEP THE `\begin{align}...\end{align}` and the alignment points `&=`, `=&`, etc.

## convert png/jpeg images
- replace `\includegraphics[width=XX\textwidth]{path-to-image-file}` with

  ```markdown
  ![width:YYpx](path-to-image-file)
  ```
  adjust YY based on XX and the width of the slide



## an example .sh file for splitting
[split.sh](split.sh)
