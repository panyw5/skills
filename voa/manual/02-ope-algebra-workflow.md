# OPE Workflow, Simplification, and Algebra Checks

This file covers the modules that most directly support day-to-day symbolic OPE computations.

## Modules Covered

| Module | Why it matters | Key exports |
| --- | --- | --- |
| `api.py` | Main computation entry points | `OPE`, `MakeOPE`, `NO`, `NO_product`, `normal_product`, `bracket` |
| `simplify.py` | Canonical form for local-operator expressions | `simplify`, `collect_normal_ordered_terms`, `combine_normal_ordered_terms`, `expand_nested_no` |
| `jacobi.py` | Structural consistency checks | `check_jacobi_identity`, `verify_jacobi_identity` |
| `compact_ope.py` | Utilities for compact OPE families | `compact_family_poles` |
| `quasiprimary.py` | Quasiprimary completion formulas | `quasiprimary_product`, `qp` |

## Standard User Workflow

For most interactive usage, the path is:

1. Create generators with `BasisOperator`.
2. Declare parity with `Bosonic(...)` or `Fermionic(...)`.
3. Register basic OPEs with `OPE[A, B] = MakeOPE([...])`.
4. Compute derived OPEs with `OPE(expr1, expr2)`.
5. Extract poles using `bracket(A, B, n)`.
6. Build normal-ordered expressions with `NO(...)` or `normal_product(...)`.
7. Canonicalize results with `simplify(...)`.

## Example: OPE plus brackets plus normal ordering

```python
import sympy as sp

from pyope import BasisOperator, Bosonic, MakeOPE, OPE
from pyope import One, Zero, NO, bracket, d, simplify

T = BasisOperator("T", conformal_weight=2)
Bosonic(T)

c = sp.Symbol("c")
OPE[T, T] = MakeOPE([c / 2 * One, Zero, 2 * T, d(T)])

tt = OPE(T, T)
pole_4 = bracket(T, T, 4)
composite = NO(T, T)

print(tt.max_pole)
print(pole_4)
print(simplify(composite + composite))
```

## `NO(...)` vs `normal_product(...)`

- `NO(A, B)` is the most explicit binary normal-ordered constructor.
- `normal_product(A, B, C, ...)` is convenient for longer chains.
- simplification rewrites nested structures into canonical order when possible.

The normal-ordering rules are important enough that the future skill should prefer examples from tests rather than inventing new ones on the fly.

## Example: Jacobi identity verification

```python
from pyope import verify_jacobi_identity

ok = verify_jacobi_identity(T, T, T)
print(ok)
```

The normalization behavior is covered by `tests/test_jacobi.py`, which is a good retrieval source when users ask why a Jacobi result is represented by `Zero` rather than `0`.

## Example: quasiprimary completion

```python
from pyope import BasisOperator, Bosonic, MakeOPE, OPE, qp, d

J = BasisOperator("J", conformal_weight=1)
Bosonic(J)

OPE[T, J] = MakeOPE([J, d(J)])

candidate = qp(T, J, 0)
print(candidate)
```

This is more specialized than the basic OPE workflow, but it is still a coherent module cluster because it builds on the same bracket and conformal-weight infrastructure.

## Common Skill Pitfalls To Call Out

### Do not confuse symbolic derivatives with calculus on coefficients

`d(T)` is a VOA operator constructor. It is not the same as differentiating a numeric function with SymPy.

### `simplify(...)` is part of the pyope algebra semantics

Users coming from plain SymPy often expect `sp.simplify(...)` to be enough. In pyope, algebraic canonicalization of normal-ordered products lives in `pyope.simplify.simplify(...)`.

### Prefer package exports over deep imports for user answers

For a future skill, answer with `from pyope import ...` unless the user explicitly asks about internals.

## Best Evidence Files

- `README.md`
- `tests/test_normal_product.py`
- `tests/test_simplify.py`
- `tests/test_jacobi.py`
- `tests/test_quasiprimary.py`
- `demo/normal_product_demo.ipynb`
- `demo/jacobi_identity_demo.ipynb`
- `demo/pyope_ope_demo.ipynb`