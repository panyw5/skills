# Core Runtime: Operators, Registry, and `OPEData`

## Main Objects

| Module | Use | Main items |
| --- | --- | --- |
| `operators.py` | symbolic generators and composites | `Operator`, `BasicOperator`, `DerivativeOperator`, `NormalOrderedOperator`, `d`, `dn` |
| `constants.py` | distinguished constants | `One`, `Zero`, `Delta` |
| `local_operator.py` | split scalar parts from operator parts | `is_local_operator`, `extract_scalar_operator`, `collect_operators_coefficients` |
| `registry.py` | parity and OPE registry | `Bosonic`, `Fermionic`, `clear_registry`, `ope_registry` |
| `ope_data.py` | singular OPE data | `OPEData`, `OPEData.from_list`, `.pole(n)`, `.max_pole` |

## Define Generators and OPEs

```python
import sympy as sp

from pyope import BasicOperator, Bosonic, MakeOPE, OPE, One, Zero, d

T = BasicOperator("T", conformal_weight=2)
Bosonic(T)

c = sp.Symbol("c")
OPE[T, T] = MakeOPE([
    c / 2 * One,
    Zero,
    2 * T,
    d(T),
])

tt = OPE(T, T)
print(tt.max_pole)
print(tt.pole(4))
print(tt.pole(2))
```

Use `MakeOPE([...])` in descending pole order. For example,
`[pole_4, pole_3, pole_2, pole_1]` means the coefficients of `(z-w)^(-4)` down to `(z-w)^(-1)`.

## Collect Coefficients of an Expression
Extract the coefficients of operator monomials from an expression.
```python
from pyope import NO, collect_operators_coefficients

expr = 3 * NO(T, T) + 2 * d(T)
print(collect_operators_coefficients(expr))
```

The returned dictionary uses operator monomials as keys, and coefficients as values.

## Caution

- Product of operators is **forbidden**
- The OPE registry is stateful. Clear it before an unrelated computation:

    ```python
    from pyope import clear_registry

    clear_registry()
    ```

- `extract_scalar_operator(expr)` splits a scalar coefficient from one operator factor.
- `is_local_operator(expr)` checks whether an expression is a valid local-operator expression.

## Backend Reminder

**禁止**使用 `set_compute_backend("wolfram")`，Wolfram 后端仅通过 `simplify_with_wolfram(...)` 显式调用。
