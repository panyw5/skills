# Elliptic Functions - Mathematica Module Directory

## Overview

Mathematica/Wolfram Language library for symbolic computations involving elliptic functions, modular forms, theta functions, and related special functions.

## Module Dependency Graph

```
00-globals (root)
    |
    v
01-series-utils
    |
    +---> 02-series-solvers
    |
    +---> 03-plethystic
    |
    +---> 04-eisenstein
    |       |
    |       v
    |   05-eisenstein-theta <---> 06-theta-eisenstein-rules
    |       |                           |
    |       v                           v
    |   07-theta-functions <------------+
    |       |
    |       v
    |   08-special-functions
    |       |
    |       v
    +---> 09-abstract-series
            |
            v
        10-modular-operators
            |
            +---> 11-physical-voa
            |       |
            |       v
            +---> 12-fmlde
            |
            v
        13-simplify
            |
            v
        14-qshift
            |
            v
        15-dtau-to-dz
            |
            v
        16-modular-transforms
            |
            v
        17-mde-transforms
```



## File Summary

| File | Lines | Purpose |
|------|-------|---------|
| 00-globals.wls | 48 | Global configuration |
| 01-series-utils.wls | 75 | Series utilities |
| 02-series-solvers.wls | 88 | Equation solvers |
| 03-plethystic.wls | 47 | Plethystic operations |
| 04-eisenstein.wls | 157 | Eisenstein series |
| 05-eisenstein-theta.wls | 122 | E→θ conversion |
| 06-theta-eisenstein-rules.wls | 169 | θ→E conversion |
| 07-theta-functions.wls | 136 | Theta functions |
| 08-special-functions.wls | 113 | ℘, η functions |
| 09-abstract-series.wls | 146 | Symbol→series |
| 10-modular-operators.wls | 132 | Modular operators |
| 11-physical-voa.wls | 54 | VOA quantities |
| 12-fmlde.wls | 94 | FMLDE generation |
| 13-simplify.wls | 27 | Simplification |
| 14-qshift.wls | 575 | Shift operations |
| 15-dtau-to-dz.wls | 39 | Derivative conversion |
| 16-modular-transforms.wls | 347 | S,T transforms |
| 17-mde-transforms.wls | 290 | MDE transforms |
| main.wls | 65 | Module loader |


## Module Descriptions

### 00-globals.wls
**Purpose**: Global configuration and utility functions

**Key Variables**:
- `order` - Truncation order for q-series (default: 0, set dynamically)
- `maxDerivativeOrder` - Maximum derivative order (default: 20)
- `$Assumptions` - Global assumptions for symbolic simplification
- `$debug$` - Debug print flag

**Key Functions**:
- `PrintDebug[f]` - Conditional debug printing
- `TypeOfPole` - Classify poles of elliptic functions (real vs imaginary)
- `PM` - Plus/minus sign based on pole type

---

### 01-series-utils.wls
**Purpose**: Series expansion, truncation, and coefficient extraction utilities

**Key Functions**:

| Function | Description |
|----------|-------------|
| `DynamicSum[summand][range]` | Programmatic Sum |
| `DynamicTable[expr][range]` | Programmatic Table |
| `qTruncate[exp]` | Truncate q-series above `order` |
| `qSeries[exp]` | Series expansion in q |
| `qtSeries[exp]` | Series expansion in qt |
| `pSeries[exp]` | Series expansion in p |
| `pqSeries[exp]` | Double series in p,q |
| `LogRemove[exp]` | Remove/clean logarithms in expressions |
| `HighTempLimit[f[τ]]` | Compute high temperature limit β→0 |
| `LaurentCoefficientList[exp, x, Order]` | Extract Laurent series coefficients |
| `RationalFunctionNumerator[exp]` | Extract numerator from rational function sum |

**Aliases**: `CL`, `Clean`, `RemoveLog`

---

### 02-series-solvers.wls
**Purpose**: Solve equation `q-series = 0`, where the coefficients of `q-series` can be numbers, functions of `b`, functions of `b[i]`, ...

**Key Functions**:

| Function | Description |
|----------|-------------|
| `SolveqSeries[expr, vars][solOrder]` | Solve unflavored q-series = 0 |
| `SolveqSeriesExistence[expr][solOrder]` | Check existence of solution |
| `SolveqbSeries[expr, vars][solOrder]` | Solve with b-flavor fugacity |
| `SolveqbiSeries[expr, vars][solOrder]` | Solve with multiple flavors b[i] |
| `SolveqbiSeriesNumerics[expr, vars][solOrder]` | Numerical solution with π→N[π] |

**Dependencies**: [01-series-utils.wls](modules/01-series-utils.wls) (uses `LaurentCoefficientList`)

---

### 03-plethystic.wls
**Purpose**: Plethystic exponential and logarithm operations

**Key Functions**:

| Function | Description |
|----------|-------------|
| `PE[X][q]` | Plethystic exponential of X |
| `PE0[x]` | Leading term (order 0) of PE |
| `PLog[f][aList][q]` | Plethystic logarithm using Möbius inversion |


---

### 04-eisenstein.wls
**Purpose**: Eisenstein series definitions and twisted Eisenstein series

**Key Functions**:

| Function | Description |
|----------|-------------|
| `EEi[k][q]` |  symbolic representation of $E_k(\tau)$ for symbolic manipulations| 
| `Ei[k][q]` | Eisenstein series $E_k(\tau)$ as q-series |
| `E2[q]`, `E4[q]` | Shorthand for Ei[2], Ei[4] |
| `EEE[k][{{α}, {β}}][q]`  | symbolic representation of twisted Eisenstein series|
| `EiTwisted[k][α, Θ][q]` | Twisted Eisenstein series $E_k\left[\begin{smallmatrix}\alpha\\\Theta\end{smallmatrix}\right](\tau)$ |
| `EE[k][{{α},{Θ}}][q]` | alias for  `EiTwisted` |
| `Gi[k][q]` | Alternative Eisenstein definition |
| `E2Wolfger[q, Λ]`, `E4Wolfger[q, Λ]` | Truncated Eisenstein series |

**Mathematical Background**:
$$
E_k(\tau) = 1 - \frac{2k}{B_k} \sum_{n=1}^{\infty} \sigma_{k-1}(n) q^n
$$

---

### 05-eisenstein-theta.wls
**Purpose**: Convert Eisenstein series to theta function representations

**Key Functions**:

| Function | Description |
|----------|-------------|
| `EisensteinToTheta[ff]` | Convert EEE notation to θ functions |
| `EisensteinToThetaFull[f]` | Full conversion including EEi substitution |
| `EEiToTheta[n]` | Compute EEi[n] in terms of theta at z=0 |
| `EisensteinToThetaRule[maxOrder]` | Generate conversion rules |
| `EisensteinPolynomialGen[k][seeds]` | Generate Eisenstein polynomials |

**Dependencies**: [04-eisenstein.wls](modules/04-eisenstein.wls), [07-theta-functions.wls](modules/07-theta-functions.wls)

---

### 06-theta-eisenstein-rules.wls
**Purpose**: Convert theta functions (especially derivatives at z=0) to Eisenstein series

**Key Functions**:

| Function | Description |
|----------|-------------|
| `CurlyThetapToEEE` | Cached rules: $\theta^{(n)}_i(0,q) \to E_k$ |
| `Theta0ToEisensteinRule[n]` | Dynamically generate conversion rules |
| `Theta0ToEisenstein[f]` | Apply theta-to-Eisenstein conversion |

**Dependencies**: [04-eisenstein.wls](modules/04-eisenstein.wls), [05-eisenstein-theta.wls](modules/05-eisenstein-theta.wls), [07-theta-functions.wls](modules/07-theta-functions.wls)

**Key Relations**:
$$
\theta'''_1(0,q) = 12\pi^2 \theta'_1(0,q) E_2(q)
$$

---

### 07-theta-functions.wls
**Purpose**: Jacobi theta function definitions and series expansions

**Key Functions**:

| Function | Description |
|----------|-------------|
| `ThetaS[i][z, q, order]` | Explicit q-series for $\theta_i(z,q)$ |
| `ThetaAlphaBeta[α,β][z,q]` | General theta with characteristics |
| `Theta[i][z,q]` | Alias for `EllipticTheta[i, πz, q^(1/2)]` |
| `ThetazTau[i][z,τ]` | Theta with nome $e^{2\pi i \tau}$ |
| `Dτ[f]` | τ-derivative: $\frac{1}{2\pi i} \frac{\partial}{\partial \tau}$ |
| `TakeResidue[f][z, z0]` | Symbolic residue computation |
| `TakeGeneralResidue[f, {z, z0, m}]` | Residue for m-th order pole |
| `CapitalTheta[r,s][q]` | $\Gamma^0(2)$ modular forms |
| `CapitalThetaS[r,s][q]` | Series version of CapitalTheta |

**Theta Function Definitions**:
$$
\theta_1(z,q) = 2\sum_{r=0}^{\infty} (-1)^r \sin((2r+1)\pi z) q^{(2r+1)^2/8}
$$

---

### 08-special-functions.wls
**Purpose**: Weierstrass ℘, Dedekind η, and related special functions

**Key Functions**:

| Function | Description |
|----------|-------------|
| `WeierstrassP[z,q]` | Weierstrass ℘ function |
| `WeierstrassPZhu[k][z,q]` | Zhu's series expansion |
| `WeierstrassPZ[β,q]` | Series expansion in q |
| `Zeta[z,q]` | Weierstrass ζ function |
| `Eta[q]` | Dedekind η function: $\eta(\tau) = q^{1/24}\prod(1-q^n)$ |
| `EtaS[q]` | q-series for η function |
| `Pfn[q]`, `Qfn[q]`, `Rfn[q]` | Eisenstein-related invariants |
| `P[m][{α},{b}][z,q]` | Generalized P-function |

**Dependencies**: [04-eisenstein.wls](modules/04-eisenstein.wls), [07-theta-functions.wls](modules/07-theta-functions.wls)

---

### 09-abstract-series.wls
**Purpose**: Convert abstract symbolic notation to explicit q-series

**Key Functions**:

| Function | Description |
|----------|-------------|
| `makeAbstract[f]` | Replace EllipticTheta with θ notation |
| `MakeTheta[f]` | Replace abstract θ with explicit derivatives |
| `makeqSeries[f]` | Convert abstract expression to q-series |
| `makeqSymmetricSeries[f]` | Convert to symmetric series using θGS |
| `TauBToqb[exp]` | Replace τ, $\mathcal{B}$ with Log[q], Log[b] |
| `AbstractToSeries[f]` | Full conversion pipeline |
| `LogProductToSumLog[f]` | Simplify log of products |

**Dependencies**: [01-series-utils.wls](modules/01-series-utils.wls), [04-eisenstein.wls](modules/04-eisenstein.wls), [07-theta-functions.wls](modules/07-theta-functions.wls), [08-special-functions.wls](modules/08-special-functions.wls)

---

### 10-modular-operators.wls
**Purpose**: Modular differential operators for acting on modular forms

**Key Functions**:

| Function | Description |
|----------|-------------|
| `SerreD[k, f]` | Serre derivative: $q\frac{d}{dq} + k E_2$ |
| `SerreDTau[k, f]` | Serre derivative in τ variable |
| `MDO[k, f]` | Modular differential operator $\mathcal{D}_q^{(k)}$ |
| `MDOCache[k, f]` | Cached computation of MDO |
| `Db[f]`, `Db[n, f]` | Flavor derivative $b\frac{\partial}{\partial b}$ |
| `Dbi[i][f]`, `Dbi[i][n,f]` | Multi-flavor derivatives |
| `MakeEquationqSeries[expr]` | Convert MDO equation to q-series |
| `SimplifyqSeries[exp]` | Simplify series coefficients |

**Mathematical Background**:
$$
\mathcal{D}_q^{(k)} = \prod_{n=1}^{k}\left(q\frac{d}{dq} + (k-n)E_2\right)
$$

---

### 11-physical-voa.wls
**Purpose**: Physical/VOA (Vertex Operator Algebra) quantities

**Key Functions**:

| Function | Description |
|----------|-------------|
| `ScriptCapitalS[l]` | Coefficient from $\frac{y/2}{\sinh(y/2)}$ |
| `Lambda[k,l]` | Lambda coefficients for VOA correlators |
| `LambdaT[n,l][k]` | Transformed Lambda coefficients |
| `Ign[g,n]` | Unflavored correlator (genus g, n insertions) |
| `Itgn[g,n][k]` | Flavored correlator |
| `IgnUnflavored[g,n]` | Simplified unflavored version |
| `ItgnUnflavored[g,n][k]` | Simplified flavored version |

**Dependencies**: [04-eisenstein.wls](modules/04-eisenstein.wls), [07-theta-functions.wls](modules/07-theta-functions.wls)

---

### 12-fmlde.wls
**Purpose**: Generate flavored modular linear differential equations

**Key Functions**:

| Function | Description |
|----------|-------------|
| `DerivativeComposition[exp]` | Compose differential operators |
| `UnflavoredMLDESL2ZGenAbs[n]` | Generate SL(2,Z) MLDE |
| `UnflavoredMLDEGamma02GenAbs[n]` | Generate Γ₀(2) MLDE |
| `FMLDEGenAbstract[k][seeds]` | Generate FMLDE with Db |
| `FMLDEGenAbstract[k][seeds, bList]` | Generate FMLDE with Dbi[i] |
| `FMLDEGenSeries[k][seeds]` | Convert to q-series |

**Dependencies**: [10-modular-operators.wls](modules/10-modular-operators.wls)

---

### 13-simplify.wls
**Purpose**: Simplification utilities using theta function properties

**Key Functions**:

| Function | Description |
|----------|-------------|
| `simplifyArgs[g]` | Expand arguments of functions |
| `simplify[f]` | Apply simplification rules:

**Simplification Rules**:
- $\theta_1^{(2l)}(0) = 0$ (even derivatives vanish)
- $\theta_{2,3,4}^{(2l+1)}(0) = 0$ (odd derivatives vanish)
- $\theta_i(m\tau + n) \to 0$ for integer m,n where theta vanishes

---

### 14-qshift.wls
**Purpose**: Quasi-periodic shift operations for theta functions

**Key Functions**:

| Function | Description |
|----------|-------------|
| `qShift[f]` | Main shift function (handles all cases) |
| `qShiftInteger[f]` | Integer shifts only |
| `qShift0[f]` | Simplified version (better performance) |
| `ThetaExpand[f]` | Expand theta arguments |
| `CurlyThetaExpand[f]` | Alias for ThetaExpand |
| `CurlyThetaDerivativeToCurlyThetaP[f]` | Convert Derivative to θp notation |
| `FlipSign[var][f]` | Flip sign for negative arguments |
| `FlipSignAllB[f]` | Apply FlipSign to all B[i] |

**Shift Formulas**:
$$
\theta_1(z+\tau, q) = -e^{-\pi i(2z+\tau)}\theta_1(z,q)
$$

**Dependencies**: [04-eisenstein.wls](modules/04-eisenstein.wls), [07-theta-functions.wls](modules/07-theta-functions.wls)

---

### 15-dtau-to-dz.wls
**Purpose**: Convert τ-derivatives to z-derivatives using heat equation

**Key Functions**:

| Function | Description |
|----------|-------------|
| `DTauToDz[f]` | Replace $\frac{\partial}{\partial q}$ with $\frac{\partial^2}{\partial z^2}$ |

**Heat Equation**:
$$
\frac{\partial \theta_i(z,q)}{\partial q} = -\frac{1}{4q}\frac{\partial^2 \theta_i(z,q)}{\partial z^2}
$$

---

### 16-modular-transforms.wls
**Purpose**: S and T modular transformations

**Key Functions**:

| Function | Description |
|----------|-------------|
| `STransForm[f]` | S-transformation: $\tau \to -1/\tau$ |
| `STransForm[f, τ]` | S-transformation with explicit τ |
| `STransForm[f, BList]` | S-transformation with parameters B[i] |
| `STransForm[f, BList, YList]` | S-transformation with Y[i] shift |
| `TTransForm[f]` | T-transformation: $\tau \to \tau+1$ |
| `SDualFrame[f]` | Direct S-dual frame conversion |
| `TDualFrame[f]` | Direct T-dual frame conversion |

**S-Transformation**:
$$
\theta_i\left(\frac{z}{\tau}, e^{-2\pi i/\tau}\right) = \sqrt{-i\tau} e^{\pi i z^2/\tau} \tilde{\theta}_i(z,\tau)
$$

**Dependencies**: [04-eisenstein.wls](modules/04-eisenstein.wls), [07-theta-functions.wls](modules/07-theta-functions.wls), [14-qshift.wls](modules/14-qshift.wls)

---

### 17-mde-transforms.wls
**Purpose**: Modular differential equation transformation utilities

**Key Functions**:

| Function | Description |
|----------|-------------|
| `linearAbsOp` | List of abstract operators |
| `MDOInit[]` | Initialize operator algebra rules |
| `STransFormOnMDENew[eq][BList]` | S-transform MDE with parameters |
| `STransFormOnMDE` | Alias for STransFormOnMDENew |
| `bShiftMDE[eq][b[i]]` | Shift b[i] → b[i]q in MDE |
| `bShiftMDE[eq][nList]` | Multiple shifts b[i] → b[i]q^n[i] |

**Dependencies**: `10-modular-operators.wls`, `16-modular-transforms.wls`

---

### main.wls
**Purpose**: Main loader script

Loads all modules in the correct dependency order. Usage:
```wolfram
Get["path/to/main.wls"]
```

## Common Workflows

### 1. Basic Theta Function Series Expansion

```wolfram
(* Set the truncation order *)
order = 10;

(* Get a series expansion *)
result = qSeries[Theta[1][z, q]];

(* Convert to explicit q-series *)
resultSeries = makeqSeries[result];
```

### 2. Eisenstein to Theta Conversion

```wolfram
(* Define an expression with Eisenstein series *)
expr = EE[2][{{1}, {E^(2πI z)}}][q];

(* Convert to theta functions *)
thetaExpr = EisensteinToTheta[expr];

(* Make theta functions explicit *)
result = MakeTheta[thetaExpr];
```

### 3. Solve q-Series Equation

```wolfram
(* Define equation parameters *)
vars = {a1, a2, a3};
expr = a1*q + a2*q^2 + (a1 + a3)*q^3;

(* Solve for coefficients *)
solution = SolveqSeries[expr, vars][5];
```

### 4. Modular Differential Operators

```wolfram
(* Apply modular differential operator *)
f[ch_] := ch * Eta[q]^4;
result = MDO[4, f[Ei[4][q]]];

(* Convert to series *)
seriesResult = MakeEquationqSeries[result];
```

### 5. S and T Transformations

```wolfram
(* Define theta expression *)
expr = Theta[1][z, q] * Theta[2][z, q];

(* Apply S-transformation *)
sResult = STransForm[expr];

(* Apply T-transformation *)
tResult = TTransForm[expr];
```

## Global Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `order` | 0 | Truncation order for q-series |
| `maxDerivativeOrder` | 20 | Maximum theta derivative order |
| `$debug$` | False | Enable debug printing |
| `$Assumptions` | Complex assumptions | Symbolic simplification assumptions |

## Notation Conventions

### Theta Functions
- `Theta[i][z, q]` - Jacobi theta with built-in `EllipticTheta`
- `ThetaS[i][z, q, order]` - Explicit q-series
- `ThetaAlphaBeta[α,β][z,q]` - General theta with characteristics

### Eisenstein Series
- `Ei[k][q]` - Explicit q-series for $E_k$
- `EEi[k][q]` - Symbolic version (for algebraic manipulation)
- `EE[k][{α},{Θ}][q]` - Twisted Eisenstein (symbolic)
- `EEE[k][{α},{Θ}][q]` - Preprocessed twisted Eisenstein

### Derivatives
- `Theta[i][z,q]` - $\theta_i(z,q)$
- `Thetap[i][z,q]` - $\theta_i'(z,q)$
- `Thetapp[i][z,q]` - $\theta_i''(z,q)$
- `Thetappp[i][z,q]` - $\theta_i'''(z,q)$

### Modular Operators
- `MDO[k, f]` - Modular differential operator $\mathcal{D}_q^{(k)}$
- `MMDO[k, ch]` - Abstract version (for symbolic manipulation)
- `SerreD[k, f]` - Serre derivative
