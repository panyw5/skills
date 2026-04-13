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

Useful definitions and scripts are available in folder `./scripts/elliptic/`
- [README](./scripts/elliptic/README.md): overview of the `modules`
- [conventions](./scripts/elliptic/conventions.md): formal definitions, conventions, and common identities


# `wls` coding convention
1. **CRITICAL**: 多行表达式必须用括号 `()` 括起来作为一个整体
   否则 `wolframscript` 可能会误解表达式的结构，将第二行以及之后的行当成新的表达式，导致语法错误或计算错误
2. 函数要用**中括号** `[arg1, arg2, ...]` 包裹 arguments
3. **WARNING**: 变量名、argument 名字**不能**加下划线 (下划线代表 `pattern`)
