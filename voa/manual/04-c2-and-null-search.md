# Experimental `C_2` Reduction and Null-State Search

This file covers the most research-oriented part of the current package. These APIs are real and tested, but they are still marked as evolving in the project README.

## Modules Covered

| Module | Why it matters | Key exports |
| --- | --- | --- |
| `c2.py` | Defines the generic sparse quotient interface | `AbstractC2Reducer`, `GenericC2Reducer`, `C2ReductionWitness` |
| `free_field_c2.py` | Implements realization-specific quotient rules | `FreeFieldC2Reducer`, `DerivativeKillingFreeFieldC2Reducer` |
| `singularity.py` | Computes positive-mode constraints and singular-vector conditions | `SingularVectorAnalyzer` |
| `null_search.py` | Orchestrates quotient prechecks and descendant lifts | `NullSearchResult`, `QuotientC2NullSearcher` |
| `operator_spaces.py` | Still contains legacy compatibility entry points | `C2Space`, `C2NullSearcher` |

## Core Mental Model

The null-search stack tries to solve a problem of the form:

- target operator lies in a descendant space at fixed weight
- target operator becomes trivial modulo `C_2`

The current implementation emphasizes local operators, normal products, derivatives, sparse coordinates, and quotient witnesses rather than a mode-algebra-first design.

## Example: generic `C_2` reduction

```python
from pyope import BasisOperator, Bosonic, GenericC2Reducer, LocalOperatorBasis, NO, d

T = BasisOperator("T", conformal_weight=2)
Bosonic(T)

basis = LocalOperatorBasis([T], max_weight=5)
reducer = GenericC2Reducer(basis)

print(reducer.is_zero_mod_c2(NO(d(T), T)))
print(reducer.quotient_normal_form(NO(T, T)))
```

The most important user-facing idea here is that the reducer returns a normal form or a witness, not just a Boolean.

## Example: quotient precheck and null search

```python
from pyope import (
    BasisOperator,
    Bosonic,
    DescendantSpace,
    GenericC2Reducer,
    LocalOperatorCanonicalizer,
    NO,
    QuotientC2NullSearcher,
)

T = BasisOperator("T", conformal_weight=2)
Bosonic(T)

canonicalizer = LocalOperatorCanonicalizer([T], stress_tensor=T, max_weight=5)
reducer = GenericC2Reducer(canonicalizer)
searcher = QuotientC2NullSearcher(
    canonicalizer=canonicalizer,
    c2_reducer=reducer,
    descendants=DescendantSpace(canonicalizer._basis),
)

result = searcher.search_from_sources(4, [T], NO(T, T))
print(result.status)
print(result.null_operator)
```

The structured result type is central here. `NullSearchResult` stores status, quotient remainder, obstruction, witness data, descendant basis, and optional singularity metadata.

## Example: singular-vector analysis

```python
from pyope import (
    BasisOperator,
    Bosonic,
    LocalOperatorBasis,
    MakeOPE,
    OPE,
    SingularVectorAnalyzer,
    d,
)

T = BasisOperator("T", conformal_weight=2)
J = BasisOperator("J", conformal_weight=1)
Bosonic(T, J)

OPE[T, J] = MakeOPE([J, d(J)])

basis = LocalOperatorBasis([T, J], max_weight=3)
analyzer = SingularVectorAnalyzer(basis, generators=[T], stress_tensor=T)

print(analyzer.positive_mode_constraints(J))
print(analyzer.is_singular(J))
```

This layer is a natural fit for a skill because users may ask about primary or singular conditions in terms of OPE pole constraints rather than mode language.

## Status Guidance For A Future Skill

When retrieving these APIs, the future skill should explicitly note:

- the null-search and realization-aware quotient interfaces are still evolving
- the structured APIs are preferred over legacy compatibility helpers
- examples from tests are more reliable than inferring behavior from scratch

## Best Evidence Files

- `tests/test_sparse_c2_api.py`
- `tests/test_c2_null_searcher.py`
- `tests/test_c2_space.py`
- `tests/test_free_field_c2.py`
- `tests/test_singular_vector_analyzer.py`
- `tests/test_singularity.py`
- `demo/w_algebra_null_states_demo.ipynb`
- `demo/virasoro_c2_algebra_demo.ipynb`

## Skill Routing Notes

Retrieve this cluster first when users ask:

- "How do I work modulo `C_2`?"
- "How do I search for a null relation?"
- "How do I impose singular-vector constraints from OPE poles?"
- "What is the difference between quotient precheck and descendant lift?"