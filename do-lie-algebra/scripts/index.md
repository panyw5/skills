# Scripts 索引

Lie Algebras v0.3 by Yiwen Pan — 基于 LieART 的李代数计算工具包。

## 加载方式

```wolfram
Get["load_all.wls"]
```

等价于原始 `Lie Algebras.m` 的全部功能。

## 模块一览

| 文件 | 功能 | 主要符号 |
|------|------|----------|
| [init.wls](./init.wls) | 包加载与版本信息 | `<<LieART`` |
| [algebra.wls](./algebra.wls) | 有限维李代数初始化 | `GetAlgebra` |
| [utilities.wls](./utilities.wls) | 小工具函数 | `CoRootBasis`, `LongRoots`, `LengthSquare`, `Dynkin` |
| [predicates.wls](./predicates.wls) | 类型判断谓词 | `IsRoot`, `IsPositiveRoot`, `IsSimpleRoot`, `IsAffineRoot`, `IsAffineWeight`, `IsZeroWeight` |
| [affine.wls](./affine.wls) | 仿射李代数初始化 | `GetAffineAlgebra`, `SimpleAffineRoot`, `FundamentalAffineWeight` |
| [killing_form.wls](./killing_form.wls) | Killing 形式与度量 | `GetKillingForm`, `KillingForm`, `KillingFormD`, `KillingFormChevalley` |
| [translators.wls](./translators.wls) | 基底转换 | `DynkinLabel`, `Heights`, `ToLieArt`, `ToSTD` |
| [structure_constants.wls](./structure_constants.wls) | 结构常数计算 | `GetStructureConstants`, `fabc`, `fabcChevalley` |
| [simplify.wls](./simplify.wls) | 李代数表达式化简 | `simplifyLieAlgebra`, `ffContraction`, `fffContraction`, `KfContraction` |
| [matrices_A.wls](./matrices_A.wls) | $A_r$ 型矩阵表示 | `GetMatrices[Algebra[A][r]]` |
| [matrices_BD.wls](./matrices_BD.wls) | $B_r$, $D_r$, $D_4$ 型矩阵表示 | `GetMatrices[Algebra[B][r]]`, `GetMatrices[D4]`, `GetMatrices[Algebra[D][r]]` |
| [matrices_EFG.wls](./matrices_EFG.wls) | $G_2$, $F_4$, $E_6$, $E_7$ 型矩阵表示 | `GetMatrices[G2]`, `GetMatrices[F4]`, `GetMatrices[E6]`, `GetMatrices[E7]` |
| [weyl.wls](./weyl.wls) | Weyl 群操作 | `Weyl`, `WeylDot`, `WeylAffine`, `Translation`, `WeylGroupAr` |
| [representation.wls](./representation.wls) | 表示论 | `Irrep`, `Dimq` |
| [lattice.wls](./lattice.wls) | 格点生成 | `RootLattice`, `CoRootLattice` |

## 依赖关系

```
init
 └─ algebra
     ├─ utilities
     ├─ predicates
     │   └─ affine
     ├─ killing_form
     │   └─ translators
     │       └─ structure_constants
     ├─ simplify
     ├─ matrices_A / matrices_BD / matrices_EFG
     │   (内部调用 GetKillingForm + GetStructureConstants)
     ├─ weyl
     ├─ representation
     └─ lattice
```

## 原始文件

- [Lie Algebras.m](./Lie%20Algebras.m) — 由 Mathematica Notebook 自动生成的单文件版本（已拆分为上述模块）
