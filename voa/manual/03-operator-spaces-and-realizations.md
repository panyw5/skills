# Fixed-Weight Operator Spaces, Realizations, and Descendants

This file covers the modules that move beyond direct OPE computation into fixed-weight basis management and realization-aware workflows.

## Modules Covered

| Module | Why it matters | Key exports |
| --- | --- | --- |
| `operator_spaces.py` | Fixed-weight basis enumeration, coordinates, sparse linear algebra, realization helpers | `LocalOperatorBasis`, `LocalOperatorCanonicalizer`, `SparseLinearContext`, `RealizedGenerator`, `make_realized`, `realize`, `realize_and_simplify`, `realized_coordinates` |
| `descendants.py` | Descendant generation from sources to target weight | `DescendantSpace` |
| `realizations.py` | Optional backends for realization-aware quotient computations | `RealizationBackend`, `IdentityRealizationBackend`, `DerivativeKillingRealizationBackend` |

## Why This Cluster Matters

This cluster is the bridge from symbolic OPE manipulation to linear-algebraic reasoning about spaces of operators.

The typical use cases are:

- enumerate a basis of local operators at fixed conformal weight
- compute coordinates of an expression in that basis
- detect linear dependence without enumerating the full ambient basis when possible
- define composite realized generators and expand them back to free-field expressions
- generate descendant spaces from chosen source operators

## Example: fixed-weight basis and coordinates

```python
from pyope import BasisOperator, Bosonic, LocalOperatorBasis, NO, d

T = BasisOperator("T", conformal_weight=2)
J = BasisOperator("J", conformal_weight=1)
Bosonic(T, J)

basis = LocalOperatorBasis([T, J], max_weight=3)

expr = 5 * NO(T, J) + d(T)
weight_three_basis = basis.list(3)
coords = basis.coordinates(expr, weight=3)

print(weight_three_basis)
print(coords)
```

The tests show that `LocalOperatorBasis` is not just a pretty wrapper. It provides a canonicalization and coordinate-extraction interface that later modules reuse heavily.

## Example: realized generators

```python
import sympy as sp

from pyope import BasisOperator, Bosonic, NO, RealizedGenerator, d, realize

J = BasisOperator("J", conformal_weight=1)
Bosonic(J)

W = RealizedGenerator("W", realization=NO(J, J))

expr = NO(W, d(W))
print(realize(expr))
```

The realization layer is especially important for a future skill because users may ask questions in two different languages:

- generator language: `W`, `T`, `J`
- explicit free-field language: composites such as `NO(J, J)`

## Example: `make_realized(...)`

`make_realized(...)` promotes already-bound expressions into same-named `RealizedGenerator` objects by inspecting the caller namespace.

```python
from pyope import BasisOperator, Bosonic, NO, make_realized, d

b = BasisOperator("b", fermionic=True, conformal_weight=2)
c = BasisOperator("c", fermionic=True, conformal_weight=-1)
Bosonic(b, c)

J0 = NO(b, c)
Jminus = -NO(d(b), c)

J0, Jminus = make_realized([J0, Jminus])
print(J0.name, Jminus.name)
```

This behavior is convenient, but it also means a skill should explain that names come from the Python variable bindings.

## Example: descendant spaces

```python
from pyope import BasisOperator, Bosonic, DescendantSpace, LocalOperatorBasis

T = BasisOperator("T", conformal_weight=2)
Bosonic(T)

basis = LocalOperatorBasis([T], max_weight=4)
descendants = DescendantSpace(basis)

print(descendants.generate(T, 4))
print(descendants.basis(T, 4))
```

`DescendantSpace` is the cleanest entry point for users who want fixed-weight descendant generation without immediately reading the more experimental null-search stack.

## Sparse Linear Algebra Guidance

`SparseLinearContext` is important for performance-sensitive checks such as:

- finding an independent subset of expressions
- finding zero relations among expressions
- avoiding full basis enumeration for local dependence checks

That makes `tests/test_operator_spaces.py` and `tests/test_sparse_c2_api.py` especially good sources for skill retrieval.

## Best Evidence Files

- `tests/test_operator_spaces.py`
- `tests/test_descendant_space.py`
- `tests/test_descendants.py`
- `demo/operator_spaces_demo.ipynb`
- `demo/null_states_case.py`

## Skill Routing Notes

Retrieve this cluster first when users ask:

- "What operators exist at weight 4?"
- "How do I get coordinates of an expression in a basis?"
- "How do realized generators work?"
- "How do I generate descendants from a primary?"