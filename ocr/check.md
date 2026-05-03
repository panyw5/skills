# GOAL

这是用于 skill `ocr` 的自我检查文档

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
