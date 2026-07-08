---
name: do-elliptic-calculus
description: Perform symbolic calculus involving elliptic functions and related special functions. Use this skill when the discussions involve elliptic functions, Eisenstein series, Jacobi theta functions, Weierstrass function series, q-Pochhammer symbols, modular forms, superconformal index, Schur index
compatibility: wolframscript, python
meta:
  author: Yiwen Pan
---

# Workflow

深入理解用户及主 agent 碰到的数学计算需求，识别涉及椭圆函数、Eisenstein series, Jacobi theta/Weierstrass/q-Pochhammer symbols/modular forms, superconformal/Schur index/elliptic genus


# Resources

## Eisenstein Series, and Jacobi Theta Functions, Weierstrass function series, q-Pochhammer symbols, Plethystic exponential

Useful definitions and scripts are available in folder `scripts/elliptic/`
- [conventions](./scripts/elliptic/conventions.md): formal definitions, latex conventions, coding conventions, and common identities
- [README](scripts/elliptic/README.md): overview of the `modules/` in `scripts/elliptic/`

目录 `scripts/identities/` 下有大量 Eisenstein 和 Jacobi theta 函数的恒等式 (identities), 当你需要化简 Jacobi theta、Eisenstein 级数形成的表达式时使用

目录 `routines/` 下有一些日常业务的详细指引
- 解析围道积分: [integration](routines/analytic-integration.md)


# `wls` coding RULEs
1. **CRITICAL**: 多行表达式必须用括号 `()` 括起来作为一个整体
   否则 `wolframscript` 可能会误解表达式的结构，将第二行以及之后的行当成新的表达式，导致语法错误或计算错误
2. 函数要用**中括号** `[arg1, arg2, ...]` 包裹 arguments
3. **WARNING**: 变量名、argument 名字**不能**加下划线 (下划线代表 `pattern`)
4. **CRICITAL**: 必须使用如下符号 (详情见 [README.md](./scripts/elliptic/README.md))
  ```Mathematica

  EEE[k][{{a}, {b}}][q]

  
  ```


# LaTex reply format

输出回答时，必须用如下 `LaTex` 符号标记 Eisenstein 级数以及 Jacobi theta
- Jacobi theta 函数 $\vartheta_i(\mathfrak{z})$ 或者 $\vartheta_i(\mathfrak{z}|\tau)$
- 标准 Eisenstein 级数记号 $E_k(\tau)$
- 行间 twisted Eisenstein 级数记号
  $$
  E_k\left[\begin{matrix}\phi \\ \theta\end{matrix}\right](\tau), \qquad
  E_k\left[\begin{matrix}\phi \\ \theta\end{matrix}\right]
  $$
- 行内 twisted Eisenstein 级数记号 $E_k [\substack{\phi \\ \theta}]$
