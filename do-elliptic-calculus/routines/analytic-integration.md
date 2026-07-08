# 任务
完成解析函数 (`elliptic`) 与 Eisenstein 多项式 `P`、积分变量 `a` 多项式乘积的解析积分，对结果进行化简

# 约定与常用函数
- 设 `a[i]` 为积分变量，`a[i] = E^(2 \[Pi] I \[ScriptA][i])`

  其它变量 `b[i], c[i], ...` 以及 `b[i] = E^(2 \[Pi] I \[ScriptB][i]), c[i] = E^(2 \[Pi] I \[ScriptC][i]), ...`

  `q = E^(2 \[Pi] I [\Tau])`

  通过 `//ToScript//RemoveLog` 和 `//ToStraight//RemoveLog` 相互转化
- `\[CurlyTheta][i][\[ScriptZ], q]`: Abstract Jacobi theta
- `EEE[k][ {{\[PlusMinus]1},{z}} ][q]`: Abstract Eisenstein series
- `\[Eta]\[Eta][q]`: Abstract Dedekind eta function
- `makeqSeries`: 将 Abstract 函数转化为 `q`-级数

# workflow
- 验证 `elliptic` 的椭圆性
  ```Mathematica

  ```
