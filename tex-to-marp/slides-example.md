---
marp: true
theme: rose-pine-dawn
paginate: true
_paginate: skip
size: 16:9

math: mathjax

---
# Slide title
$$
\newcommand\blue[1]{{\color[rgb]{0.20, 0.43, 0.75}{#1}}}
\newcommand\red[1]{{\color[rgb]{0.839844, 0.507813, 0.488281}{#1}}}
\newcommand\green[1]{{\color[rgb]{.359375, .59765625, .41015625}{#1}}}
\newcommand\gray[1]{{\color[rgb]{0.5, 0.5, 0.5}{#1}}}
\newcommand\purple[1]{{\color[rgb]{0.63515625, 0.49609375, 0.80859375}{#1}}}
\newcommand\white[1]{{\color{white}{#1}}}
\newcommand\orange[1]{{\color[rgb]{0.63515625, 0.51015625, 0.37734375}{#1}}}
$$

---
<!-- footer: 球函数 -->

# chapter title

- section 1
- section 2
- section 3
- section 4
- section 5

---
<!-- header: section 1 -->
# section 1



---

### Frame title 1

* item 1
  $$
  u(\mathbf{r}) = R(r) Y(\theta, \varphi) = R(r) H(\theta) \Phi(\varphi)
  $$
* item 2
  $$
  \Phi(\varphi + 2\pi) = \Phi(\varphi)
  $$
  于是 $\Phi(\varphi)$ 必然是**指数函数** $e^{im \varphi}$, $m \in \mathbb{Z}$
* item 3
  $$
  r^2 R'' + 2r R' - \lambda R = 0
  $$

---
### Frame title 2

<!-- **<green>green text** replaces \greenbox{green text} -->
<!-- **<red>green text** replaces \redbox{green text} -->
<!-- **<orange>green text** replaces \bluebox{green text} -->
<!-- comment block replaces \commentblock{title}{content}, for example

\commentblock{comment title}{comment content}

should be replaced by (becareful of the indentation; add a blank line after the opening tag)

<div class='proof comment'>
  
**comment title**

comment content
</div>

-->
* item 1, **<green>green text**, and some other **<red>red text**, and some **<orange>orange text**
  $$
  \begin{align}
    & \ \frac{d}{dx}\bigg[(1 - x^2)\frac{dP}{dx}\bigg] + \bigg(\lambda - \frac{m^2}{1 - x^2}\bigg)P = 0\\
    & \ P(\pm 1) = \left\{ \begin{array}{cc}
      0 & m \ne 0\\
      \text{有限} & m = 0
    \end{array}\right.
  \end{align}
  $$
  
  <div class='proof comment'>
  
  **m 值来自 $\Phi(\varphi)$ 的指数**

  $x = \pm 1$ 对应 $\theta = 0, \pi$，即南北极位置
  </div>

---
### Frame title 3
<!-- In \commentblock{title}{content}, there are also \greenbox, \bluebox, \redbox, also replaceable by **<green>green text**, **<red>red text**, **<orange>orange text**
 -->
- item 1
  $$
  \left\{\begin{array}{cc}
    P(\pm 1) = 0 & m \ne 0\\
    P(\pm 1) < \infty & m = 0
  \end{array}\right.
  $$
  
  <div class='proof comment'>
  
  这是使得 $Y(\theta, \varphi) = H(\theta)e^{\pm im \varphi}$ 形成球面上函数的 **<green>自然边界</green>** 条件：$\theta = 0, \pi$, $\forall \varphi$ 对应南北极两个固定的点
  - 当 $m \ne 0$，$H(\theta = 0, \pi) = 0$ 才能 well-defined
  - 当 $m = 0$，$H(\theta = 0, \pi)$ 只要**有限**即可
  </div>



---
### Frame title
<!-- The following <div class="proof"> replaces \expositionblock{title}{content}, for example,

\expositionblock{title}{content}

should be replaced by (notice an empty line should be added after the <div class="proof">)

<div class="proof">

**title**

content
</div>
-->

<div class='proof'>

**径向方程的求解**。
* 此方程属于 **<green>欧拉 (Euler) 方程**，标准解法令 $r = e^t$，
  $$
  \frac{dt}{dr} = \frac{1}{r}, \qquad
  r \frac{dR}{dr} = r \frac{dR}{dt} \frac{dt}{dr} = \frac{dR}{dt}
  $$
  $$
  r^2 \frac{d^2 R}{dr^2} = - \frac{dR}{dt} + \frac{d^2 R}{dt^2}
  $$
* 径向方程变成 $R$ 与 $t$ 的 **常系数**线性齐次常微分方程，
  $$
  \frac{d^2 R}{dt^2} + \frac{dR}{dt} - \lambda R = 0
  $$
</div>


---
### Frame title

<!-- replace  \highlight{red}{math} by \red{math} 
replace  \highlight{titlegreen}{math} by \green{math} 
replace  \highlight{titleblue}{math} by \orange{math} -->

<div class='proof'>

* texts, texts, $\purple{a^2 + b^2 = c^2}$, 
* texts
  $$
  \red{\frac{d^\ell}{dx^\ell}(x^2 - 1)}
  = \blue{\sum_{k = 0}^{\ell} (-1)^k C_\ell^k \frac{d^\ell}{dx^\ell}x^{2\ell - 2k}}
  = \sum_{k = 0}^{\red{\boldsymbol{\lfloor \ell/2 \rfloor}}}
  (-1)^k C_\ell^k \frac{(2\ell - 2k)!}{(\purple{2\ell - 2k - \ell})!}
  x^{\purple{2\ell - 2k - \ell}}
  $$
</div>

---
### Frame title

<!-- replace \includegraphics[width=XX\textwidth]{url} with

![width:YYpx](url)

adjust YY based on XX
-->
- texts
<center>

![width:420px](/image/flat-space-sphere.png)
</center>