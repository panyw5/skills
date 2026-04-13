# Frequently used conventions in analytical computation

本文档收集解析计算中常用的特殊函数定义和重要性质。

## 基本记号

- 复结构参数：$\tau \in \mathbb{C}$，$\text{Im}(\tau) > 0$
- Nome（模参数）：$q = e^{2\pi i \tau}$
- 变量：$z \in \mathbb{C}$，对应 $\mathfrak{z} = \frac{z}{2\pi i}$（有时简写为 $z$）
- 求和简写：
  - $\sum'_{m,n}$ 表示 $\sum_{\substack{(m,n)\in\mathbb{Z}^2\\(m,n)\neq(0,0)}}$
  - $\sum'_m$ 表示 $\sum_{\substack{m\in\mathbb{Z}\\m\neq 0}}$

---

## Jacobi theta 函数

### 标准定义

四个标准 Jacobi theta 函数定义为：

$$
\vartheta_1(\mathfrak{z}|\tau) = -i \sum_{r \in \mathbb{Z} + \frac{1}{2}} (-1)^{r-\frac{1}{2}} e^{2\pi i r \mathfrak{z}} q^{\frac{r^2}{2}}
$$

$$
\vartheta_2(\mathfrak{z}|\tau) = \sum_{r \in \mathbb{Z} + \frac{1}{2}} e^{2\pi i r \mathfrak{z}} q^{\frac{r^2}{2}}
$$

$$
\vartheta_3(\mathfrak{z}|\tau) = \sum_{n \in \mathbb{Z}} e^{2\pi i n \mathfrak{z}} q^{\frac{n^2}{2}}
$$

$$
\vartheta_4(\mathfrak{z}|\tau) = \sum_{n \in \mathbb{Z}} (-1)^n e^{2\pi i n \mathfrak{z}} q^{\frac{n^2}{2}}
$$

### 乘积形式

$q$-Pochhammer 符号：$(z;q) = \prod_{k=0}^{+\infty}(1 - zq^k)$

$$
\vartheta_1(\mathfrak{z}|\tau) = & \ i q^{\frac{1}{8}} z^{-\frac{1}{2}}(q;q)(z;q)(z^{-1}q;q) \ , \\
  \vartheta_2(\mathfrak{z}|\tau) = & \ q^{\frac{1}{8}}z^{-\frac{1}{2}}(q;q)(-z;q)(- z^{-1}q;q) \ , \\
  \vartheta_3(\mathfrak{z}|\tau)= & \ (q;q)(-zq^{1/2};q)(- z^{-1}q^{1/2};q) \ , \\
  \vartheta_4(\mathfrak{z}|\tau)= & \ (q;q)(zq^{1/2};q)(z^{-1}q^{1/2};q) \ .
$$

### 周期性质

**全周期平移：**

- $\vartheta_{1,2}(\mathfrak{z} + 1) = -\vartheta_{1,2}(\mathfrak{z})$
- $\vartheta_{3,4}(\mathfrak{z} + 1) = +\vartheta_{3,4}(\mathfrak{z})$
- $\vartheta_{1,4}(\mathfrak{z} + \tau) = -\lambda \vartheta_{1,4}(\mathfrak{z})$，其中 $\lambda = e^{-2\pi i \mathfrak{z}}e^{-\pi i \tau}$
- $\vartheta_{2,3}(\mathfrak{z} + \tau) = +\lambda \vartheta_{2,3}(\mathfrak{z})$

**一般平移公式：**

$$
\vartheta_1(\mathfrak{z} + m\tau + n) = (-1)^{m+n} e^{-2\pi i m \mathfrak{z}} q^{-\frac{1}{2}m^2}\vartheta_1(\mathfrak{z})
$$

### 导数关系

$$
4\pi i \partial_\tau \vartheta_i(z|\tau) = \vartheta''_i(z|\tau)
$$

$$
\frac{d}{d\mathfrak{z}}\left[\frac{\vartheta_1(\mathfrak{z})}{\vartheta_4(\mathfrak{z})}\right] = \vartheta_4(0)^2 \frac{\vartheta_2(\mathfrak{z})\vartheta_3(\mathfrak{z})}{\vartheta_4(\mathfrak{z})^2}
$$

### 复制公式（Duplication formulas）

$$
\vartheta_1(2\mathfrak{z})\vartheta_1'(0) = 2\pi\prod_{i=1}^{4}\vartheta_i(\mathfrak{z})
$$

$$
\vartheta_4(2\mathfrak{z})\vartheta_4(0)^3 = \vartheta_4(\mathfrak{z})^4 - \vartheta_1(\mathfrak{z})^4 = \vartheta_3(\mathfrak{z})^4 - \vartheta_2(\mathfrak{z})^4
$$

**特殊值：**

$$
\vartheta'_1(0) = \pi \vartheta_2(0)\vartheta_3(0)\vartheta_4(0)
$$

### 留数公式

$$
\mathop{\operatorname{Res}}\limits_{a \to b^{\frac{1}{n}}q^{\frac{k}{n}}e^{2\pi i \frac{\ell}{n}}} \frac{1}{a} \frac{1}{\vartheta_1(n\mathfrak{a} - \mathfrak{b})} = \frac{1}{n} \frac{i}{\eta(\tau)^3} (-1)^{k+\ell} q^{\frac{1}{2}k^2}
$$

$$
\mathop{\operatorname{Res}}\limits_{a \to b^{\frac{1}{n}}q^{\frac{k}{n} + \frac{1}{2n}}e^{2\pi i \frac{\ell}{n}}} \frac{1}{a} \frac{1}{\vartheta_4(n\mathfrak{a} - \mathfrak{b})} = \frac{1}{n} \frac{1}{(q;q)^3} (-1)^k q^{\frac{1}{2}k(k+1)}
$$

---

## Weierstrass 函数族

椭圆函数具有双周期性：$f(z) = f(z+\tau) = f(z+1)$

### Weierstrass ζ 函数

$$
\zeta(z) = \frac{1}{z} + \sum'_{m,n} \left[\frac{1}{z - m - n\tau} + \frac{1}{m + n\tau} + \frac{z}{(m + n\tau)^2}\right]
$$

**准周期性：**
- $\zeta(z + 1|\tau) - \zeta(z|\tau) = 2\eta_1(\tau)$
- $\zeta(z + \tau|\tau) - \zeta(z|\tau) = 2\eta_2(\tau) = 2\tau\eta_1(\tau) - 2\pi i$

其中 $\eta_1(\tau) = -2\pi^2 E_2$，$\eta_2(\tau) = \tau\eta_1(\tau) - \pi i$

**与 theta 函数的关系：**

$$
\zeta(\mathfrak{z}) = \frac{\vartheta'_1(\mathfrak{z})}{\vartheta_1(\mathfrak{z})} - 4\pi^2 \mathfrak{z} E_2
$$

### Weierstrass ℘ 函数

$$
\wp(z) = \frac{1}{z^2} + \sum_{(m,n)\neq(0,0)} \left[\frac{1}{(z - m - n\tau)^2} - \frac{1}{(m + n\tau)^2}\right]
$$

**周期性：**

$$
\wp(z) = \wp(z + 1) = \wp(z + \tau)
$$

**与 ζ 函数的关系：**

$$
\wp(z) = -\partial_z \zeta(z)
$$

---

## Eisenstein 级数

### 标准 Eisenstein 级数定义

对于偶数 $k \geq 2$：
$$
E_k(\tau) = - \frac{B_k}{k!} + \frac{2}{(k-1)!} \sum_{n=1}^{\infty} \frac{n^{k-1} q^n}{1 - q^n}
$$

### 扭曲 Eisenstein 级数定义

对于 $k \geq 1$，$\phi = e^{2\pi i \lambda}$（$0 \leq \lambda < 1$）：

$$
E_k\left[\begin{matrix}\phi \\ \theta\end{matrix}\right] = -\frac{B_k(\lambda)}{k!} + \frac{1}{(k-1)!}\sum_{r\geq 0}' \frac{(r+\lambda)^{k-1}\theta^{-1}q^{r+\lambda}}{1-\theta^{-1}q^{r+\lambda}} + \frac{(-1)^k}{(k-1)!}\sum_{r\geq 1} \frac{(r-\lambda)^{k-1}\theta q^{r-\lambda}}{1-\theta q^{r-\lambda}}
$$

其中 $B_k(x)$ 是第 $k$ 个 Bernoulli 多项式。

**约定：** $E_0\left[\begin{matrix}\phi \\ \theta\end{matrix}\right] = -1$

### 特殊值

$$
E_1\left[\begin{matrix}+1 \\ z\end{matrix}\right] = \frac{1}{2\pi i} \frac{\vartheta'_1(\mathfrak{z})}{\vartheta_1(\mathfrak{z})}
$$

$$
E_{2n}\left[\begin{matrix}+1 \\ +1\end{matrix}\right] = E_{2n} \quad \text{（标准 Eisenstein 级数）}
$$

$$
E_{2n+1\geq 3}\left[\begin{matrix}+1 \\ +1\end{matrix}\right] = 0
$$

### 对称性

$$
E_k\left[\begin{matrix}\pm 1 \\ z^{-1}\end{matrix}\right] = (-1)^k E_k\left[\begin{matrix}\pm 1 \\ z\end{matrix}\right]
$$

### 导数关系

$$
q\partial_q E_k\left[\begin{matrix}\phi \\ b\end{matrix}\right] = (-k) b\partial_b E_{k+1}\left[\begin{matrix}\phi \\ b\end{matrix}\right]
$$

### 平移公式

对于非零 $n \in \mathbb{Z}$：

$$
E_k\left[\begin{matrix}\pm 1 \\ zq^{\frac{n}{2}}\end{matrix}\right] = \sum_{\ell=0}^{k} \left(\frac{n}{2}\right)^\ell \frac{1}{\ell!} E_{k-\ell}\left[\begin{matrix}(-1)^n(\pm 1) \\ z\end{matrix}\right]
$$

**差分公式：**

$$
\Delta_k\left[\begin{matrix}\pm 1 \\ z\end{matrix}\right] \equiv E_k\left[\begin{matrix}\pm 1 \\ zq^{\frac{1}{2}}\end{matrix}\right] - E_k\left[\begin{matrix}\pm 1 \\ zq^{-\frac{1}{2}}\end{matrix}\right] = \sum_{m=0}^{\lfloor\frac{k-1}{2}\rfloor} \frac{1}{2^{2m}(2m+1)!} E_{k-1-2m}\left[\begin{matrix}\mp 1 \\ z\end{matrix}\right]
$$

### 与 theta 函数的转换

$$
E_k\left[\begin{matrix}+1 \\ z\end{matrix}\right] = \sum_{\ell=0}^{\lfloor k/2\rfloor} \frac{(-1)^{k+1}}{(k-2\ell)!}\left(\frac{1}{2\pi i}\right)^{k-2\ell} \mathbb{E}_{2\ell} \frac{\vartheta_1^{(k-2\ell)}(\mathfrak{z})}{\vartheta_1(\mathfrak{z})}
$$

其中 $\mathbb{E}_{2\ell}$ 定义为：

$$
\mathbb{E}_{2\ell} = \sum_{\substack{\{n_p\}\\\sum_{p\geq 1}(2p)n_p = 2\ell}} \prod_{p\geq 1} \frac{1}{n_p!}\left(\frac{1}{2p}E_{2p}\right)^{n_p}
$$

例如：
- $\mathbb{E}_2 = E_2$
- $\mathbb{E}_4 = E_4 + \frac{1}{2}(E_2)^2$
- $\mathbb{E}_6 = E_6 + \frac{3}{4}E_4E_2 + \frac{1}{8}(E_2)^3$

### 前几个 Eisenstein 级数的显式表达

$$
E_2\left[\begin{matrix}+1 \\ z\end{matrix}\right] = \frac{1}{8\pi^2}\frac{\vartheta_1''(\mathfrak{z})}{\vartheta_1(\mathfrak{z})} - \frac{1}{2}E_2
$$

$$
E_3\left[\begin{matrix}+1 \\ z\end{matrix}\right] = \frac{i}{48\pi^3}\frac{\vartheta'''_1(\mathfrak{z})}{\vartheta_1(\mathfrak{z})} - \frac{i}{4\pi}\frac{\vartheta'_1(\mathfrak{z})}{\vartheta_1(\mathfrak{z})}E_2
$$

### 留数

$$
\mathop{\operatorname{Res}}_{z\to 1}\frac{1}{z}E_k\left[\begin{matrix}+1 \\ z\end{matrix}\right] = \delta_{k1}
$$

$$
\mathop{\operatorname{Res}}_{z\to q^{\frac{1}{2}+n}}\frac{1}{z}E_k\left[\begin{matrix}-1 \\ z\end{matrix}\right] = \frac{1}{2^{k-1}(k-1)!}
$$

### 常数项

$$
\text{const. term of } E_{2n}\left[\begin{matrix}+1 \\ z\end{matrix}\right] = -\frac{B_{2n}}{(2n)!}
$$

$$
\text{const. term of } E_{2n}\left[\begin{matrix}-1 \\ z\end{matrix}\right] = -\mathcal{S}_{2n} = -\left[\frac{y}{2}\frac{1}{\sinh\frac{y}{2}}\right]_{2n}
$$

其中 $[f(y)]_k$ 表示 $f(y)$ 在 $y=0$ 处 Taylor 展开的第 $k$ 项系数。

---

## 常用恒等式

### Eisenstein 级数恒等式

$$
E_1\left[\begin{matrix}+1 \\ z\end{matrix}\right] - E_1\left[\begin{matrix}-1 \\ z\end{matrix}\right] = \frac{\eta(\tau)^3}{2i} \frac{\vartheta_1(2\mathfrak{z})\vartheta_4(0)^2}{\vartheta_1(\mathfrak{z})^2\vartheta_4(\mathfrak{z})^2}
$$

### 复制公式（Eisenstein）

$$
\sum_{\pm}E_k\left[\begin{matrix}\phi \\ \pm z\end{matrix}\right](\tau) = 2E_k\left[\begin{matrix}\phi \\ z^2\end{matrix}\right](2\tau)
$$

$$
\sum_{\pm\pm}E_k\left[\begin{matrix}\pm 1 \\ \pm z\end{matrix}\right](\tau) = \frac{4}{2^k}E_k\left[\begin{matrix}+1 \\ z^2\end{matrix}\right](\tau)
$$

---

## Plythestic exponential

For function $X(q)$ of $q$: $\text{PE}[X] = \exp\left(\sum_{n=1}^{\infty} \frac{X(q^n)}{n}\right)$

Can be generalized to multiple variables $x_1, x_2, \ldots, x_m$: $\text{PE}[X] = \exp\left(\sum_{n=1}^{\infty} \frac{X(x_1^n, x_2^n, \ldots, x_m^n)}{n}\right)$
