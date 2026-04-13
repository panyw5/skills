---
name: use-wolframscript
description: Perform computations using wolframscript. Use this skill when the the user requests symbolic computation, or the discussions require symbolic computations
compatibility: wolframscript
---


# `wolframscript` coding convention

- **CRITICAL**: 多行表达式必须用括号 `()` 括起来作为一个整体
   否则 `wolframscript` 可能会误解表达式的结构，将第二行以及之后的行当成新的表达式，导致语法错误或计算错误
- 函数要用**中括号** `[arg1, arg2, ...]` 包裹 arguments
- **WARNING**: 变量名、argument 名字**不能**加下划线 (下划线代表 `pattern`)
- 优先使用模式匹配 (pattern matching) 和替换规则 (replacement) 进行数学变换


# `wolframscript` basics


列表用**花括号**包裹，列表元素用双中括号 ``[[i, j, k, ...]]`` 引用
```
list = {a, b, {c, d, {e,f,g}}}
```

```Mathematica
V = {a, b, c, d}; V[[1]] (* => a *)

V = Table[a[i, j] b^i c^j, {i, 4}, {j, 4}](* 用 Table 生成多维列表 *)
```


函数 arguments 用**中括号**包裹
```Mathematica
Sin[{{a}, b}] (* 函数名 Sin, argument 是 {{a}, b} *)
```

函数、变量可以不加声明直接调用
```Mathematica
a (* 不加声明，就是符号变量 a *)
a = 3; a (* => 3 *)
f[0] (* 不加声明，就是符号函数值 f[0] *)
```

simple replacement
```Mathematica
x^2 + y^2 /. {x -> 3} (* => 9 + y^2 *)
x^2 + y^2 /. {x^2 -> x2} (* => x2 + y^2 *)
x^2 z^2 + y^2 /. {x^2 -> x2} (* => y^2 + x2 z^2 *)
x^2 z^2 + y^3 /. {x^2 z^2 -> x2 z2} (* => y^3 + x2 z2 *)
x^2 + y^2 + z^2 /. {x^2 + y^2 -> 1} (* => 1 + z^2 *)
1/(4 \[Pi]^2 x^2) + y^2 + z^2 /. {1/(4 \[Pi]^2 x^2) -> 4} (* => x^4 + y^4 + z^4 *)
```

表达式中的 `x^4` 无法匹配到任何 `x^2`，因此没有变化
```Mathematica
x^4 + y^4 + z^4 /. {x^2 -> x2} (* => x^4 + y^4 + z^4 *)
```

pattern matching 和替换规则

```Mathematica

Clear[x, \[Gamma], y]
x + \[Gamma][k] + \[Gamma][l] + \[Gamma][p] + 
  y /. {\[Gamma] :> \[CapitalGamma]}(* 函数名可以被替换 *)
x + \[Gamma][k] + \[Gamma][l] + \[Gamma][p] + 
  y /. {\[Gamma][k_] :> \[CapitalGamma][
    k]} (* 识别结构 \[Gamma][k_]，并作替换，并且保持追踪自变量 k *)
x + \[Gamma][k] + \[Gamma][l] + \[Gamma][p, l] + 
  y /. {\[Gamma][k_] :> \[CapitalGamma][
    k]} (* \[Gamma][k_] 只识别含单一变量的 \[Gamma] *)

x + \[Gamma][1] + \[Gamma][2] + \[Gamma][3] + 
  y /. {\[Gamma][k_ /; k > 2] :> \[CapitalGamma][
    k]} (* 识别结构时还可以加甄别条件 *)
x + \[Gamma][1] + \[Gamma][2] + \[Gamma][3] + 
  y /. {\[Gamma][k_ /; k > 2] :> a^k} (* 识别结构时还可以加甄别条件 *)

x^a y^b + x^(2 a) y^b /. {x^m_ y^n_ :> m^x n^y}
x y^b + x^(2 a) y^b /. {x^m_ y^n_ :> 
   m^x n^y}(* x y^b 中 x 没有幂次，对不上 x^m_y^n_ 结构 *)
x y^b + x^(2 a) y^b /. {x^m_ y^n_ :> m^x n^y, x y^n_ :> one^x n^y}


(* 输出 *)

(* x + y + \[CapitalGamma][k] + \[CapitalGamma][l] + \[CapitalGamma][p] *)
(* x + y + \[CapitalGamma][k] + \[CapitalGamma][l] + \[CapitalGamma][p] *)
(* x + y + \[Gamma][p, l] + \[CapitalGamma][k] + \[CapitalGamma][l] *)
(* x + y + \[Gamma][1] + \[Gamma][2] + \[CapitalGamma][3] *)
(* a^3 + x + y + \[Gamma][1] + \[Gamma][2] *)
(* a^x b^y + 2^x a^x b^y *)
(* 2^x a^x b^y + x y^b *)
(* 2^x a^x b^y + b^y one^x *)
```


# 极为有用的技巧

## `Map`
函数的 `Map` 可以**提高性能**
```Mathematica
Map[f, {a, b, c, d, e}] (* => f[a], f[b], f[c], f[d], f[e] *)

f /@ {a, b, c, d, e} (* => f[a], f[b], f[c], f[d], f[e] *)
```

也可以用 pure function 做 `Map`
```Mathematica
(1 + g[#]) & /@ {a, b, c, d, e} 

(* 输出: {1 + g[a], 1 + g[b], 1 + g[c], 1 + g[d], 1 + g[e]} *)
```

## Collect

```Mathematica
(* Collect 合并同类项 *)

4 y x^2 + x y^2 + a x^9 + c y x + d/f x^2 + y^-2 x^2 + y^2 x^2 // 
 Collect[#, x] &
4 y x^2 + x y^2 + a x^9 + c y x + d/f x^2 + y^-2 x^2 + y^2 x^2 // 
 Collect[#, y] &

(* 识别所有 NO[_,_] 结构，合并同类项 *)
4/Cos[\[Phi]] NO[x, y] + 8 c NO[x, NO[y, z]] + 
  Sin[\[Theta]] NO[y, NO[x, z]] + Tan[\[Theta]] NO[x, y] // 
 Collect[#, NO[__]] &

(* 输出 *)
(* a x^9 + x^2 (d/f + 1/y^2 + 4 y + y^2) + x (c y + y^2) *)
(* (d x^2)/f + a x^9 + x^2/y^2 + (c x + 4 x^2) y + (x + x^2) y^2 *)
(* 8 c NO[x, NO[y, z]] + NO[y, NO[x, z]] Sin[\[Theta]] + 
 NO[x, y] (4 Sec[\[Phi]] + Tan[\[Theta]]) *)
```

`Collect` 的输出抱有加法结构 (是个"多项式")，而 `Simplify` 或者 `FullSymplify` 虽然会化简但会破坏结构
```Mathematica

(* 完全化简，破坏加法结构 *)
(3 BB[4][x, q]^2)/(8 y^2 AA[1][2 x, q]^2) + 
  AA[4][x, 
    q] (-((BB[1][2 x, q] BB[4][x, q])/(4 y^2 AA[1][2 x, 
           q]^3)) + (3 CC[4][x, q])/(16 y^2 AA[1][2 x, q]^2)) + 
  AA[4][x, 
    q]^2 (-(CC[4][0, 
         q]/(16 y^2 AA[1][2 x, q]^2 AA[4][0, q])) + (CC[1][x, 
          q]/(16 y^2 AA[1][x, q]) - ((2 y CC[2][0, q])/
            AA[2][0, q] - (2 y CC[2][x, q])/
            AA[2][x, q] + (2 y CC[3][0, q])/
            AA[3][0, q] - (2 y CC[3][x, q])/AA[3][x, q] + 
           DD[1][0, q]/\[Eta]\[Eta][q]^3)/(32 y^3))/
      AA[1][2 x, q]^2) // Simplify

(* => (1/(32 y^3 AA[1][2 x, q]^3))(12 y AA[1][2 x, q] BB[4][x, q]^2 + 
  AA[4][x, 
    q] (-8 y BB[1][2 x, q] BB[4][x, q] + 
     6 y AA[1][2 x, q] CC[4][x, q]) + 
  AA[1][2 x, q] AA[4][x, 
    q]^2 ((2 y CC[1][x, q])/AA[1][x, q] - (2 y CC[2][0, q])/
     AA[2][0, q] + (2 y CC[2][x, q])/AA[2][x, q] - (2 y CC[3][0, q])/
     AA[3][0, q] + (2 y CC[3][x, q])/AA[3][x, q] - (2 y CC[4][0, q])/
     AA[4][0, q] - DD[1][0, q]/\[Eta]\[Eta][q]^3)) *)
```


```Mathematica
(* 保留一点加法结构，同时合并同类项 *)
(3 BB[4][x, q]^2)/(8 y^2 AA[1][2 x, q]^2) + 
  AA[4][x, 
    q] (-((BB[1][2 x, q] BB[4][x, q])/(4 y^2 AA[1][2 x, 
           q]^3)) + (3 CC[4][x, q])/(16 y^2 AA[1][2 x, q]^2)) + 
  AA[4][x, 
    q]^2 (-(CC[4][0, 
         q]/(16 y^2 AA[1][2 x, q]^2 AA[4][0, q])) + (CC[1][x, 
          q]/(16 y^2 AA[1][x, q]) - ((2 y CC[2][0, q])/
            AA[2][0, q] - (2 y CC[2][x, q])/
            AA[2][x, q] + (2 y CC[3][0, q])/
            AA[3][0, q] - (2 y CC[3][x, q])/AA[3][x, q] + 
           DD[1][0, q]/\[Eta]\[Eta][q]^3)/(32 y^3))/AA[1][2 x, q]^2) //
  Collect[#, AA[4][_, q]] &

(* => (3 BB[4][x, q]^2)/(8 y^2 AA[1][2 x, q]^2) - (
 AA[4][x, q]^2 CC[4][0, q])/(16 y^2 AA[1][2 x, q]^2 AA[4][0, q]) + 
 AA[4][x, 
   q] (-((BB[1][2 x, q] BB[4][x, q])/(4 y^2 AA[1][2 x, q]^3)) + (
    3 CC[4][x, q])/(16 y^2 AA[1][2 x, q]^2)) + (
 AA[4][x, 
   q]^2 (CC[1][x, q]/(
    16 y^2 AA[1][x, q]) - ((2 y CC[2][0, q])/AA[2][0, q] - (
     2 y CC[2][x, q])/AA[2][x, q] + (2 y CC[3][0, q])/AA[3][0, q] - (
     2 y CC[3][x, q])/AA[3][x, q] + DD[1][0, q]/\[Eta]\[Eta][q]^3)/(
    32 y^3)))/AA[1][2 x, q]^2 *)

```


```Mathematica
(* 保持整体加法结构，合并同类项，对系数化简 *)
(3 BB[4][x, q]^2)/(8 y^2 AA[1][2 x, q]^2) + 
  AA[4][x, 
    q] (-((BB[1][2 x, q] BB[4][x, q])/(4 y^2 AA[1][2 x, 
           q]^3)) + (3 CC[4][x, q])/(16 y^2 AA[1][2 x, q]^2)) + 
  AA[4][x, 
    q]^2 (-(CC[4][0, 
         q]/(16 y^2 AA[1][2 x, q]^2 AA[4][0, q])) + (CC[1][x, 
          q]/(16 y^2 AA[1][x, q]) - ((2 y CC[2][0, q])/
            AA[2][0, q] - (2 y CC[2][x, q])/
            AA[2][x, q] + (2 y CC[3][0, q])/
            AA[3][0, q] - (2 y CC[3][x, q])/AA[3][x, q] + 
           DD[1][0, q]/\[Eta]\[Eta][q]^3)/(32 y^3))/AA[1][2 x, q]^2) //
  Collect[#, AA[4][_, q], Simplify] &

(* => (3 BB[4][x, q]^2)/(8 y^2 AA[1][2 x, q]^2) - (
 AA[4][x, q]^2 CC[4][0, q])/(16 y^2 AA[1][2 x, q]^2 AA[4][0, q]) + (
 AA[4][x, 
   q] (-4 BB[1][2 x, q] BB[4][x, q] + 3 AA[1][2 x, q] CC[4][x, q]))/(
 16 y^2 AA[1][2 x, q]^3) + (1/(32 y^3 AA[1][2 x, q]^2))
 AA[4][x, 
   q]^2 ((2 y CC[1][x, q])/AA[1][x, q] - (2 y CC[2][0, q])/
    AA[2][0, q] + (2 y CC[2][x, q])/AA[2][x, q] - (2 y CC[3][0, q])/
    AA[3][0, q] + (2 y CC[3][x, q])/AA[3][x, q] - 
    DD[1][0, q]/\[Eta]\[Eta][q]^3) *)

```


## 换头
用 `@@` 换函数头，改变数据结构，`G@F[x,y,z] => G[x,y,z]`

如 `List@@` 可以快速将加法结构转换为 `List`
```Mathematica
List@@(3 NO[a, b] + 4 NO[c,d] + x NO[e, f]) (* => {3 NO[a, b], 4 NO[c, d], x NO[e, f]} *)
```
结合 `Collect` 和 `List@@` 可以快速提取加法项及系数。
```Mathematica
terms = List @@ ((3 NO[a, b] + 4 NO[c, d] + x NO[ee, ff] + y NO[a, b] // 
  Collect[#, NO[___]] &))

(* => {(3 + y) NO[a, b], 4 NO[c, d], x NO[ee, ff]} *)

coeffs = terms /. NO[___] :> 1 (* => {3 + y, 4, x} *)

coeffs == 0//Solve (* 求解使得系数同时为零的 x, y；本例子无解 *)
```
