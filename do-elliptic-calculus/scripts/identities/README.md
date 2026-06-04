# Identities

Wolfram Script 格式的椭圆函数恒等式集合，按内容主题拆分。所有表达式均为注释掉的验证代码，供查阅和参考。

## 文件说明

| 文件 | 主题 |
|------|------|
| [jacobi-theta-identities.wls](jacobi-theta-identities.wls) | Jacobi theta 函数恒等式：q→q² 变换，$\Theta_i(0,q)^4$ 恒等式，$\Theta^{(n)}/\Theta$ 互化，$\Theta_{rs}$ ↔ Eisenstein，Frobenius 行列式公式 |
| [eisenstein-fourier-series.wls](eisenstein-fourier-series.wls) | $E_k[\{\pm1\},\{z\}]$ 的 Fourier 展开（$E_1$ 到 $E_{10}$），含递推系数 $c[2n][2m]$，高阶 Fourier 级数 |
| [eisenstein-scaling.wls](eisenstein-scaling.wls) | $q\rightarrow q^p$、$b\rightarrow b^p$ 下 Eisenstein 级数的标度变换规则 |
| [eisenstein-shifts.wls](eisenstein-shifts.wls) | Twisted Eisenstein 的对称性与平移：$\theta\leftrightarrow\theta^{-1}$ 对称，半周期 / 全周期平移 |
| [eisenstein-standard-relations.wls](eisenstein-standard-relations.wls) | 标准 $E_{2n}$ 之间的乘积关系，unflavored twisted Eisenstein 的线性与多项式关系 |
| [eisenstein-flavored-relations.wls](eisenstein-flavored-relations.wls) | Weight 2/4/6/8/10 的 flavored twisted Eisenstein 多项式关系（最大文件） |
| [eisenstein-derivatives.wls](eisenstein-derivatives.wls) | $\partial_b E_k[\pm1,\{b\}]$ 的递推关系 |
| [eisenstein-theta-relations.wls](eisenstein-theta-relations.wls) | $E_k$ ↔ $\Theta_i(0,q)$ 转换，`EisensteinToTheta` 函数定义，$\Theta^{(n)}/\Theta$ ↔ Eisenstein 互化规则 |
| [global-init.wls](global-init.wls) | 全局初始化（加载 `Elliptic Functions.m`） |

## 相关定义

Elliptic 函数的基础定义和约定见 [conventions](../elliptic/conventions.md)
