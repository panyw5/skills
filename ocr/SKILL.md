---
name: ocr
description: "perform ocr (optical character recognition) on pdf files in the specified folder, or on the files specified by the user, generate and store corresponding markdown files"
---

# WORKFLOW OVERVIEW

1. 处理用户输入，确定需要 ocr 的文件和文件夹、ocr 结果存放地点
2. 准备工作: [prepare](prepare.md)
3. 调用 api 进行 ocr: [api](api.md)
4. 检查 ocr 结果: [check](check.md)
5. 修正错误或者反馈


# 处理用户输入，确定需要 ocr 的文件和文件夹、ocr 结果存放地点

根据用户输入，有如下几种常见 ocr 场景
- 用户 (或上级 agent) 指定 `{{文件夹}}` 中 **all pdf** 文件均需 ocr
- 用户 (或上级 agent) 指定文件夹 `{{文件夹}}` 内**部分 pdf** 文件需 ocr
- 用户 (或上级 agent) 指定 **单独的** 或者若干个文件 `{{文件名}}.pdf`
- 用户 (或上级 agent) 指定单个或多个 `{{url}}` 需 ocr

确定 ocr 结果存放位置
- 若用户指定了 `{{文件夹}}`，请你记住该路径
- 若用户指定了 `{{文件名}}.pdf`，则 `{{文件夹}}` = `{{文件名}}.pdf` 所在文件夹
- 若用户指定了 `{{url}}`，则必须通过询问工具 (`question` 或者 `AskUSerQuestion`) 向用户询问 ocr 结果应当放置的文件夹 `{{文件夹}}`
- 最终 ocr 结果的存放位置是 `{{文件夹}}/MinerU-output/` 文件夹：若 `MinerU-output/` 不存在，请你现在创建它

# 准备工作

参考 [prepare](prepare.md) 文档，完成准备工作

# 调用 API 进行 ocr

参考 [api](api.md) 文档，完成调用 API 进行 ocr 的工作

# 检查 ocr 结果

参考 [check](check.md) 文档，完成检查 ocr 结果的工作

# 修正错误或者反馈

**必须行为**: 完成上述任务后，请在主对话窗口中输出完成情况 (便于日后检查复盘)，并 **调用 `cunzhi`** MCP 服务器，向用户总结你的回答，并询问是否需要进一步解释。

**禁止行为**: 直接结束对话，不通过 `cunzhi` MCP 服务器反馈结果
