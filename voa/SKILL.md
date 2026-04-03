---
name: voa
description: 进行形顶点算符代数 (vertex operator algebra) 的解析、符号化的计算。当需要计算顶点算符代数的 OPE、normal ordered product, Zhu's C2 代数，Zhu's 代数，associate variety 等对象时使用，当需要为其它顶点算符代数程序包书写测试 (test) 时使用，辅助计算程序为 `pyope-voa` 和 `OPEdefs.wls`
---


# vertex operator algebra

顶点算符代数的基本概念、定义、恒等式: [VOA-preliminaries](manual/VOA-preliminaries.md)

primary, quasi-primary, superconformal primary 等概念: [VOA-primaries](manual/VOA-primaries.md)

Zhu's $C_2$ 代数、Zhu's 代数与 associate variety 等对象: [VOA-zhu](manual/VOA-zhu.md)


# Math convention

- 算符极点 $a(z) b(w)$ 可以展开为
  $$
  a(z) b(w) = \sum_{n} \frac{\{ab\}_n(w)}{(z - w)^n} 
  $$
  注: 我们用**花括号 $\{...\}_n$**，但 Theilemanns 的符号用**中括号 `[ab]_n`**
- 正规乘积 (圆括号) $(ab)$ 也记为 $\operatorname{NO}(a,b)$
- quasi-primary 的 OPE 极点 $\{ab\}_n$ 一般不是 quasi-primary，但其中存在一个 quasi-primary 的分量 $(ab)_n$ (注意与正规乘积 $(ab)$ 区分开来)
  $$
   (\mathcal{O}_1\mathcal{O}_2)_n(z) = \sum_{p \geq 0} \mathcal{K}_{h_1,h_2,n,p}\, \partial_z^p \{\mathcal{O}_1\mathcal{O}_2\}_{n+p}(z)
   $$

   其中：

   $$
   \mathcal{K}_{h_1,h_2,n,p} = \frac{(-)^p\,(2h_1 - n - p)_p}{p!\,(2h_1 + 2h_2 - 2n - p - 1)_p}
   $$


# `OPEdefs` 索引文件
优点: 高性能，适用于复杂的 OPE、NO 计算
[OPEdefs-index](manual/OPEdefs-index.md)
源文件 [OPEdefs.wls](manual/scripts/OPEdefs.wls)

# `pyope-voa` 索引文件
优点: 功能丰富，附带 Zhu's $C_2$ 代数，Zhu's 代数，associate variety、descendant 空间、null states 等功能模块
[pyope-index](manual/pyope-index.md)
安装: `pip install pyope-voa`


# `wls` Coding convention
1. **CRITICAL**: 多行表达式**必须用括号 `()`** 括起来作为一个整体
   ```Wolfram
   var = (term1
          + term2
          + term3
          + ...)
   ```
   否则 Wolfram Script 可能会**误解**表达式的结构，将第二行以及之后的行当成新的表达式，导致语法错误或计算错误
2. 函数要用**中括号** `[arg1, arg2, ...]` 包裹 arguments
3. **注意**: 变量名、argument 名字**不能**加下划线，除非是 pattern
4. 下划线代表 `pattern`，小心使用
