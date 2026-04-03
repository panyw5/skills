# pyope Module Index

This folder is a documentation pack for building a future pyope skill. It is organized as a retrieval-friendly map of the repository rather than a narrative tutorial.

## How To Use This Folder

Read the files in this order if you want to build a skill prompt or retrieval pack:

1. `README.md`: package map, API tiers, and where each module fits.
2. `01-core-runtime.md`: operator model, constants, registry, and `OPEData`.
3. `02-ope-algebra-workflow.md`: public OPE workflow, simplification, Jacobi checks, quasiprimary helpers.
4. `03-operator-spaces-and-realizations.md`: fixed-weight operator spaces, sparse coordinates, realizations, descendants.
5. `04-c2-and-null-search.md`: experimental quotient and null-search APIs.
6. `05-examples-tests-and-reference-map.md`: which demos, tests, and references to retrieve for each user intent.

## Public API Tiers

### Tier 1: Core public API for most users

These are the safest exports to emphasize in a skill:

- `BasisOperator`, `Operator`, `DerivativeOperator`, `NormalOrderedOperator`
- `Bosonic`, `Fermionic`, `clear_registry`
- `OPE`, `MakeOPE`, `NO`, `NO_product`, `normal_product`, `bracket`
- `d`, `dn`
- `One`, `Zero`, `Delta`
- `simplify`
- `check_jacobi_identity`, `verify_jacobi_identity`

### Tier 2: Advanced but teachable research helpers

- `LocalOperatorBasis`, `LocalOperatorCanonicalizer`, `SparseLinearContext`
- `RealizedGenerator`, `make_realized`, `realize`, `realize_and_simplify`
- `DescendantSpace`
- `compact_family_poles`
- `qp`, `quasiprimary_product`

### Tier 3: Experimental and evolving APIs

These should be labeled as evolving if the future skill retrieves them:

- `GenericC2Reducer`, `AbstractC2Reducer`, `C2ReductionWitness`
- `FreeFieldC2Reducer`, `DerivativeKillingFreeFieldC2Reducer`
- `SingularVectorAnalyzer`
- `NullSearchResult`, `QuotientC2NullSearcher`
- `RealizationBackend`, `IdentityRealizationBackend`, `DerivativeKillingRealizationBackend`
- legacy compatibility exports `C2Space` and `C2NullSearcher`

## Source Package Map

### Package gateway

| File | Role | Main items |
| --- | --- | --- |
| `src/pyope/__init__.py` | Public export surface | Re-exports the package API and defines the public boundary for users and skills. |

### Core operator model

| File | Role | Main items |
| --- | --- | --- |
| `src/pyope/operators.py` | Symbolic operator classes | `Operator`, `BasisOperator`, `DerivativeOperator`, `NormalOrderedOperator`, `d`, `dn` |
| `src/pyope/constants.py` | Distinguished constants | `One`, `Zero`, `Delta`, `ConstantOperator` |
| `src/pyope/local_operator.py` | Local-operator typing and decomposition helpers | `LocalOperator`, `is_local_operator`, `extract_scalar_operator`, `collect_operator_terms`, parity helpers |
| `src/pyope/exceptions.py` | Domain-specific error types | Illegal operator multiplication and related validation errors |

### OPE engine and algebra utilities

| File | Role | Main items |
| --- | --- | --- |
| `src/pyope/registry.py` | Global OPE registry and parity declarations | `OPERegistry`, `ope_registry`, `Bosonic`, `Fermionic`, `clear_registry` |
| `src/pyope/ope_data.py` | Pole container for OPE data | `OPEData`, `from_list`, `.pole(n)`, `.max_pole` |
| `src/pyope/api.py` | Main user workflow for OPE computation | `OPE`, `MakeOPE`, `NO`, `normal_product`, `bracket` |
| `src/pyope/simplify.py` | Canonicalization and normal-order simplification | `simplify`, derivative expansion, nested `NO` rewriting |
| `src/pyope/cache.py` | Numeric helper cache layer | internal optimization support |
| `src/pyope/utils.py` | Small support functions | internal expression and coefficient helpers |

### Algebra checks and higher products

| File | Role | Main items |
| --- | --- | --- |
| `src/pyope/jacobi.py` | Jacobi identity checks | `check_jacobi_identity`, `verify_jacobi_identity` |
| `src/pyope/compact_ope.py` | Compact OPE-family helpers | `compact_family_poles` |
| `src/pyope/quasiprimary.py` | Quasiprimary completion helpers | `quasiprimary_product`, `qp` |

### Fixed-weight spaces and realization-aware tools

| File | Role | Main items |
| --- | --- | --- |
| `src/pyope/operator_spaces.py` | Fixed-weight basis, coordinates, sparse linear algebra, realization helpers | `LocalOperatorBasis`, `LocalOperatorCanonicalizer`, `SparseLinearContext`, `RealizedGenerator`, `make_realized`, `realize`, `realized_coordinates` |
| `src/pyope/descendants.py` | Descendant-space generation | `DescendantSpace` |
| `src/pyope/realizations.py` | Optional realization backends | `RealizationBackend`, `IdentityRealizationBackend`, `DerivativeKillingRealizationBackend` |

### Experimental quotient and null-state stack

| File | Role | Main items |
| --- | --- | --- |
| `src/pyope/c2.py` | Sparse `C_2` quotient reduction | `AbstractC2Reducer`, `GenericC2Reducer`, `C2ReductionWitness` |
| `src/pyope/free_field_c2.py` | Specialized free-field quotient rules | `FreeFieldC2Reducer`, `DerivativeKillingFreeFieldC2Reducer` |
| `src/pyope/singularity.py` | Singular-vector constraints from OPE poles | `SingularVectorAnalyzer` |
| `src/pyope/null_search.py` | Structured null-search orchestration | `NullSearchResult`, `QuotientC2NullSearcher` |

## Retrieval Guidance For A Future Skill

If a future user asks about these topics, retrieve the following modules first:

| User intent | Retrieve first | Retrieve second |
| --- | --- | --- |
| Define generators and an OPE | `src/pyope/__init__.py`, `src/pyope/api.py` | `src/pyope/operators.py`, `src/pyope/registry.py`, `README.md` |
| Understand `NO(...)`, derivatives, simplification | `src/pyope/api.py`, `src/pyope/simplify.py` | `tests/test_normal_product.py`, `demo/normal_product_demo.ipynb` |
| Check Jacobi identities | `src/pyope/jacobi.py` | `tests/test_jacobi.py`, `demo/jacobi_identity_demo.ipynb` |
| Build fixed-weight bases | `src/pyope/operator_spaces.py` | `tests/test_operator_spaces.py`, `demo/operator_spaces_demo.ipynb` |
| Search descendants or singular vectors | `src/pyope/descendants.py`, `src/pyope/singularity.py` | `tests/test_descendants.py`, `tests/test_singular_vector_analyzer.py` |
| Work modulo `C_2` or search null states | `src/pyope/c2.py`, `src/pyope/null_search.py` | `tests/test_sparse_c2_api.py`, `tests/test_c2_null_searcher.py`, `tests/test_free_field_c2.py` |
| Compare with Mathematica or original package behavior | `OPEdefs/OPEdefs.m`, `tests/*mathematica*.wls` | `demo/mathematica_comparison.ipynb`, README notes |

## What To Ignore Or De-prioritize

These files are useful for repository history and research, but they should not be core skill material unless the user explicitly asks about them:

- top-level `tmp_*.py` and `tmp_*.wls` scratch files
- exploratory notebooks that are narrower than the core package surface
- generated metadata under `pyope.egg-info/`

The skill should anchor itself on `src/pyope`, `README.md`, `demo/`, `tests/`, and `OPEdefs/`.