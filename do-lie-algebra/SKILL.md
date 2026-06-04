---
name: do-lie-algebra
description: "perform lie algebra calculations. Use this skill when the task involves (co-)weights/(co-)roots, inner product of weights, weight systems of irreducible representations, explicit matrix representations of Lie algebras."
---

# Index
[index](./scripts/index.md) 是 Lie Algebras v0.3 的脚本索引，包含了所有模块的功能介绍和依赖关系图。建议先阅读该文档以了解整体结构和使用方法。

# Notation

一般生成元 $J^a$。对易关系 $[J^a, J^b] = if^{ab}{_c}J^c$

Cartan-Weyl basis: $H^I$, $E^\alpha$，根集合为 $\Delta$。满足对易关系
$$
[H^I, H^J] = 0, \quad [H^I, E^\alpha] = \alpha^I E^\alpha, \quad [E^\alpha, E^{-\alpha}] = K_{IJ} \alpha^I H^J, \quad [E^\alpha, E^\beta] = N_{\alpha,\beta} E^{\alpha+\beta} \text{ if } \alpha + \beta \text{ is a root}
$$

Killing form $K(X, Y) = \frac{1}{2h^\vee} \operatorname{tr} \mathfrak{ad}_X \mathfrak{ad}_Y$。

$K^{ab}\coloneqq K(J^a, J^b)$。$K^{IJ} = K(H^I, H^J)$，$K_{IJ} K^{JK} = \delta_I{^K}$。$K^{IJ} = \frac{1}{2h^\vee}\sum_{\alpha \in \Delta}\alpha^I \alpha^J$

weight 是 $H^I$ 的本征值，$H^I|\mu\rangle = \mu^I |\mu\rangle$。weight 中间的内积 $(\mu, \lambda) \coloneqq K_{IJ}\mu^I \lambda^J$

结构常数
$$
f^{abc} \coloneqq K^{cd}f^{ab}{_d}
$$

在 