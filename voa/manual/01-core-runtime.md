# Core Runtime: Operators, Registry, and OPEData

This file covers the modules that define the pyope object model and the minimal workflow for registering and computing OPEs.

## Modules Covered

| Module | Why it matters | Key exports |
| --- | --- | --- |
| `operators.py` | Defines the symbolic operator classes used everywhere else | `Operator`, `BasisOperator`, `DerivativeOperator`, `NormalOrderedOperator`, `d`, `dn` |
| `constants.py` | Provides the vacuum-like constants and special formal symbols | `One`, `Zero`, `Delta` |
| `local_operator.py` | Tells you what counts as a valid local operator and how to split scalar vs operator parts | `is_local_operator`, `extract_scalar_operator`, `collect_operator_terms` |
| `registry.py` | Stores parity and OPE definitions for generators | `OPERegistry`, `ope_registry`, `Bosonic`, `Fermionic`, `clear_registry` |
| `ope_data.py` | Encodes pole data for OPEs | `OPEData`, `OPEData.from_list`, `.pole(n)`, `.max_pole` |

## Core Mental Model

The package is built around symbolic operator expressions backed by SymPy.

- `BasisOperator("T", conformal_weight=2)` creates a named generator.
- `Bosonic(T)` or `Fermionic(G)` records parity in the global registry.
- `OPE[T, T] = MakeOPE([...])` stores the singular part of an OPE.
- `OPE(T, T)` computes and returns an `OPEData` object.
- `d(T)` and `dn(2, T)` construct derivative operators rather than performing numeric differentiation.

## Minimal Example

```python
import sympy as sp

from pyope import BasisOperator, Bosonic, MakeOPE, OPE
from pyope import One, Zero, d

T = BasisOperator("T", conformal_weight=2)
Bosonic(T)

c = sp.Symbol("c")

OPE[T, T] = MakeOPE([
    sp.Rational(1, 2) * c * One,
    Zero,
    2 * T,
    d(T),
])

tt = OPE(T, T)
print(tt.max_pole)
print(tt.pole(4))
print(tt.pole(2))
```

## Why `OPEData.from_list(...)` Matters

`MakeOPE([...])` and `OPEData.from_list([...])` follow the Mathematica package convention:

- the list is ordered from highest pole to lowest pole
- `[pole_4, pole_3, pole_2, pole_1]` means exactly the coefficients of `(z-w)^(-4)` down to `(z-w)^(-1)`

This convention is central enough that any future skill should restate it explicitly whenever the user is defining a new OPE.

## Important Guardrails

### Direct operator multiplication is intentionally rejected

pyope does not want users to write `A * B` for VOA products. If an expression contains multiple operator-like factors inside a plain SymPy multiplication, the library treats that as illegal and points users toward `NO(A, B)`.

### The global registry is stateful

Many tests clear the registry before re-defining generators and OPEs. A skill should mention this when users run several unrelated computations in the same session.

Typical reset pattern:

```python
from pyope import clear_registry

clear_registry()
```

## Best Evidence Files

Use these files when you need canonical examples for the core runtime:

- `README.md`
- `tests/test_virasoro_voa.py`
- `tests/test_registry.py`
- `tests/test_illegal_operator_mul.py`
- `demo/pyope_basic_demo.ipynb`

## Skill Routing Notes

If a user asks one of these questions, retrieve the core runtime modules first:

- "How do I define a generator?"
- "How do I declare bosonic or fermionic statistics?"
- "How do I encode the Virasoro OPE?"
- "Why does `A * B` fail?"
- "How do I inspect a pole coefficient?"