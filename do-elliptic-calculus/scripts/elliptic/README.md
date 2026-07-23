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
| 00-globals.wls | 52 | Global configuration |
| 01-series-utils.wls | 72 | Series utilities |
| 02-series-solvers.wls | 99 | Equation solvers |
| 03-plethystic.wls | 65 | Plethystic operations |
| 04-eisenstein.wls | 180 | Eisenstein series |
| 05-eisenstein-theta.wls | 121 | E→θ conversion |
| 06-theta-eisenstein-rules.wls | 190 | θ→E conversion |
| 07-theta-functions.wls | 366 | Theta functions |
| 08-special-functions.wls | 120 | ℘, η functions |
| 09-abstract-series.wls | 146 | Symbol→series |
| 10-modular-operators.wls | 131 | Modular operators |
| 11-physical-voa.wls | 53 | VOA quantities |
| 12-fmlde.wls | 93 | FMLDE generation |
| 13-simplify.wls | 40 | Simplification |
| 14-qshift.wls | 642 | Shift operations |
| 15-dtau-to-dz.wls | 38 | Derivative conversion |
| 16-modular-transforms.wls | 377 | S,T transforms |
| 17-mde-transforms.wls | 289 | MDE transforms |
| main.wls | 64 | Module loader |


## Module Descriptions

### 00-globals.wls
**Purpose**: Global configuration, utility functions, and pole classification helpers

**Key Variables**:
- `order` - Truncation order for q-series (default: 0, set dynamically)
- `maxDerivativeOrder` - Maximum derivative order (default: 20)
- `$Assumptions` - Global assumptions for symbolic simplification
- `$debug$` - Debug print flag
- `$depth$` - Optional indentation depth for nested debug output

**Key Functions**:
- `PrintDebug[f]` - Conditional debug printing; when `$depth$>0` prepends `$depth$` bullet markers for nested-call visualization
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
| `ToStraight[exp]`, `ToScript[exp]` | Convert between script variables and exponential fugacities |
| `ProductToScriptSum[f]` | Convert product fugacity expressions to script-variable sums |

**Dependencies**: [01-series-utils.wls](modules/01-series-utils.wls) (uses `LaurentCoefficientList`)

---

### 03-plethystic.wls
**Purpose**: Plethystic exponential and logarithm operations, and q-Pochhammer → theta conversion

**Key Functions**:

| Function | Description |
|----------|-------------|
| `PE[X][q]` | Plethystic exponential of X |
| `PE0[x]` | Leading term (order 0) of PE |
| `PLog[f][aList][q]` | Plethystic logarithm using Möbius inversion |
| `QPochhammerToTheta[f]` | Convert q-Pochhammer symbols involving `a[1]` into $\vartheta_1$ and $\eta$ functions |
| `QPochhammerToTheta[f, a, \[ScriptA]]` | Same conversion with an explicit fugacity `a` / script variable `\[ScriptA]` |


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
| `EiTwistedOld[k][λ, Θ]`, `EEOld[k]` | Legacy twisted Eisenstein implementation retained for compatibility with `EiTwisted[1][0,z]` |
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
| `CurlyThetapToEEE` | Cached rules: $\vartheta^{(n)}_i(\mathfrak{z},q) \to E_k$ for **all four** $i=1,2,3,4$ (derivatives up to 11th order) |
| `Theta0ToEisensteinRule[n]` | Dynamically generate conversion rules |
| `Theta0ToEisenstein[f]` | Apply theta-to-Eisenstein conversion |

**Note**: `CurlyThetapToEEE` now covers $\vartheta_2$ and $\vartheta_3$ derivative rules in addition to $\vartheta_1,\vartheta_4$; the $\vartheta_2$ family uses characteristics $\left[\begin{smallmatrix}1\\-b\end{smallmatrix}\right]$ and $\vartheta_3$ uses $\left[\begin{smallmatrix}-1\\-b\end{smallmatrix}\right]$ (with $b=e^{2\pi i\mathfrak{z}}$).

**Dependencies**: [04-eisenstein.wls](modules/04-eisenstein.wls), [05-eisenstein-theta.wls](modules/05-eisenstein-theta.wls), [07-theta-functions.wls](modules/07-theta-functions.wls)

**Key Relations**:
$$
\theta'''_1(0,q) = 12\pi^2 \theta'_1(0,q) E_2(q)
$$

---

### 07-theta-functions.wls
**Purpose**: Jacobi theta function definitions, series expansions (including the $z=\lambda\tau$ and $z+\lambda\tau$ branches), and symbolic residue computation via the jet/Laurent framework

**Key Functions**:

| Function | Description |
|----------|-------------|
| `\[Theta]SSeriesData[qvar, pairs, order]` | Helper: build `SeriesData` from `{power, coefficient}` pairs (supports rational powers) |
| `ThetaS[i][z, q, order]` | Explicit q-series for $\theta_i(z,q)$ |
| `ThetaS[i][\[Lambda] Log[q], q^n, order]` | Direct series construction when $z=\lambda\tau$ (i.e. $z=\lambda\log q$), valid for $|2\pi\lambda|<n/2$ |
| `ThetaS[i][\[ScriptZ]+\[Lambda] Log[q], q^n, order]` | Same, with an additional $\mathcal{Z}$ offset in the argument |
| `ThetaAlphaBeta[α,β][z,q]` | General theta with characteristics |
| `Theta[i][z,q]` | Alias for `EllipticTheta[i, πz, q^(1/2)]` |
| `ThetazTau[i][z,τ]` | Theta with nome $e^{2\pi i \tau}$ |
| `Dτ[f]` | τ-derivative: $\frac{1}{2\pi i} \frac{\partial}{\partial \tau}$ |
| `ThetaDerivativeSymbol[n]` | Construct the abstract symbol $\vartheta^{(n)}$ for the n-th z-derivative of theta |
| `ThetaDerivativeOrder[sym]` | Recover derivative order n from a $\vartheta^{(n)}$ symbol (counts `p` characters) |
| `ThetaJetTerm[baseOrder, i, arg, q, eps, extraOrder]` | Build a local jet (Taylor) term of $\vartheta_i$ around `eps=0` up to `extraOrder` |
| `ThetaDerivativeJetRules[eps, extraOrder]` | Replacement rules mapping $\vartheta^{(n)}_i(\text{arg},q) \to$ jet expansion |
| `ThetaJetRules[eps, jetOrder]` | Full rules for $\vartheta_i$ and all derivatives $\to$ local jet expansion |
| `ThetaLocalJet[expr, eps, jetOrder]` | Compute the local jet series of `expr` in `eps` up to `jetOrder` |
| `ThetaResidueSimplify[expr]` | Post-processing: `MakeAbstract` + `simplify` + $\vartheta_1'(0,q)\to 2\pi\eta^3$ + $e^{c\tau}\to q^{c/(2\pi i)}$ + `PowerExpand` |
| `ThetaDependsQ[expr, eps]` | Check whether `expr` depends on `eps` |
| `ThetaSeriesAssociation[expr, eps, minPow, maxPow]` | Convert a Laurent expansion into an `Association` `power -> coefficient` |
| `ThetaFactorMinPowerLowerBound[expr, eps]` | Lower bound on the minimal power of `eps` in a single factor's Laurent expansion |
| `ThetaProductWindow[expr, eps, target]` | Compute the truncation window `{minPow, maxPow}` for the product Laurent expansion |
| `ThetaFactorLaurent[factor, eps, minPow, maxPow]` | Laurent series of one factor as an `Association` |
| `ThetaConvolveAssociations[a, b, minPow, maxPow]` | Convolve two Laurent-series Associations to get the product's coefficients |
| `ThetaProductCoefficient[expr, eps, target, minPow, maxPow]` | Specific Laurent coefficient of a product via factor-by-factor convolution |
| `ThetaResidueShifted[f, {z, pole}, eps]` | Shift `f` to `pole+eps`, apply `qShift`, `RemoveLog`, `\[CurlyTheta]Expand` |
| `ThetaResidueShifted[f, {z, pole, m}, eps]` | Same, with the higher-order-pole prefactor $(z-\text{pole})^{m-1}(-1)^{m-1}/(m-1)!$ |
| `ThetaResiduePlan[f, poleSpec]` | Analyze shifted expression, compute `jetLeaves`, choose method (`v1` or `v3`), build plan |
| `ThetaResidueApplyPlan[plan]` | Execute plan: dispatch to `v1` (Jet) or `v3` (Laurent convolution), extract residue |
| `TakeResidue[f, {z, pole}]` | **New**: residue at simple pole via `ThetaResiduePlan`+`ApplyPlan`; rewrites $\vartheta_2,\vartheta_3\to\vartheta_1$ first |
| `TakeResidueOld[f, {z, pole}]` | **Legacy**: residue at simple pole via `MakeTheta`+`SeriesCoefficient` (retained for comparison) |
| `TakeGeneralResidue[f, {z, pole, m}]` | Residue at m-th order pole (legacy `MakeTheta` route) |
| `FastThetaResidue[f, {z, pole}]` | Fast residue at simple pole via `ThetaLocalJet` |
| `FastThetaResidue[f, {z, pole, m}]` | Fast residue at m-th order pole via `ThetaLocalJet` with `jetOrder=m-1` |
| `FastThetaGeneralResidueLegacy[f, {z, pole, m}]` | Legacy fast residue with the higher-order prefactor applied |
| `FastThetaResidueV1`, `FastThetaGeneralResidueLegacyV1` | Aliases pinning the `v1` (Jet) method |
| `FastThetaResidueV3`, `FastThetaGeneralResidueLegacyV3` | Aliases pinning the `v3` (Laurent convolution) method |
| `CapitalTheta[r,s][q]` | $\Gamma^0(2)$ modular forms |
| `CapitalThetaS[r,s][q]` | Series version of CapitalTheta |

**Theta Function Definitions**:
$$
\theta_1(z,q) = 2\sum_{r=0}^{\infty} (-1)^r \sin((2r+1)\pi z) q^{(2r+1)^2/8}
$$

**Residue Method Selection** (empirical, from benchmark):
- `ThetaResiduePlan` picks `v1` (Jet) when `jetLeaves >= 2200`, otherwise `v3` (Laurent convolution).

**Runtime Dependencies**: The residue helpers (`TakeResidue`, `FastThetaResidue*`, `ThetaResidueShifted`) call `qShift` and `\[CurlyTheta]Expand` from [14-qshift.wls](modules/14-qshift.wls) at evaluation time. Load order (07 before 14) is safe because these symbols are only resolved when the residue functions are actually invoked, by which point module 14 has been loaded.

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
| `EtaS[q]` | q-series for η function (via `SeriesData`, post-processed with `PowerExpand`/`qSeries`) |
| `EtaS[q^n]` | Integer/rational nome-power overloads $\eta(n\tau)$ built directly as `SeriesData` |
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
- $E_k\left[\begin{smallmatrix}\pm1\\\pm1\end{smallmatrix}\right](\tau) \to 0$ for odd $k$ (odd-twisted Eisenstein series vanish)
- $\vartheta_1'(0,q) \to 2\pi\,\eta^3$

---

### 14-qshift.wls
**Purpose**: Quasi-periodic shift operations for theta functions

**Key Functions**:

| Function | Description |
|----------|-------------|
| `qShift[f]` | Main shift function (handles all cases) |
| `qShiftInteger[f]` | Integer shifts only |
| `qShift0[f]` | Simplified version (better performance) |
| `qShiftToTheta1[f]` | Apply `qShift` then rewrite $\vartheta_2(\mathcal{Z},q^n)\to -\vartheta_1(\mathcal{Z}-1/2,q^n)$ and $\vartheta_3(\mathcal{Z},q^n)\to -e^{-i\pi\mathcal{Z}+i\pi n\tau/4}\,\vartheta_1(\mathcal{Z}-(n\tau/2+1/2),q^n)$ |
| `ThetaNormalize[expr, z]` | **New**: normalize all Jacobi theta factors to $\vartheta_1$ with canonical shift — extracts integer-period shifts ($k_A,k_B$) as phases and reflects the fractional remainder into the fundamental domain |
| `ThetaNormalizeFactor[expr, z]` | Internal single-theta decomposition helper for `ThetaNormalize` |
| `ThetaExpand[f]` | Expand theta arguments |
| `CurlyThetaExpand[f]` | Alias for ThetaExpand |
| `CurlyThetaDerivativeToCurlyThetaP[f]` | Convert Derivative to θp notation |
| `FlipSign[var][f]` / `FlipSign[f, var]` | Flip sign for negative arguments |
| `FlipSignAll[f, letter]` | Apply `FlipSign` across indexed variables and the bare variable |
| `FlipSignAll\[ScriptA]`, `FlipSignAll\[ScriptB]`, `FlipSignAlla`, `FlipSignAllb` | Convenience sign-flip variants, including reversed-order variants |

**Shift Formulas**:
$$
\theta_1(z+\tau, q) = -e^{-\pi i(2z+\tau)}\theta_1(z,q)
$$

**Bug Fix**: `FlipSignAll\[ScriptA]` and `FlipSignAll\[ScriptA]Reversed` now correctly apply `FlipSign` with the bare `\[ScriptA]` at the end (previously incorrectly used `\[ScriptB]`).

**Bug Fix**: the half-period shift rules $\vartheta_{2,3}(z+m\tau)\ (1/2\le m\lt1)$ dropped the spurious leading factor `I` (kept only for $\vartheta_{1,4}$), and `CurlyThetaDerivativeToCurlyThetaP` now matches the nome with a proper `q_` pattern.

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
| `Sawtooth[x]`, `DedekindSum[h,k]` | Helpers for Dedekind-sum eta modular dual transformations |

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

### 6. q-Pochhammer to Theta Conversion

```wolfram
 (* Convert a q-Pochhammer factor involving the fugacity a[1] into theta functions *)
 expr = QPochhammer[a[1]^-1, q];
 thetaExpr = QPochhammerToTheta[expr];

 (* With an explicit (named) fugacity a and script variable \[ScriptA] *)
 thetaExpr2 = QPochhammerToTheta[QPochhammer[a^-2, q], a, \[ScriptA]];
 ```

### 7. Symbolic Residue Computation (jet/Laurent framework)

```wolfram
 (* Residue at a simple pole *)
 expr = \[CurlyTheta]p[1][\[ScriptZ], q]/\[CurlyTheta][1][\[ScriptZ], q];
 res = TakeResidue[expr, {\[ScriptZ], 0}];

 (* Residue at an m-th order pole (use the explicit-order signature) *)
 expr2 = 1/\[CurlyTheta][1][\[ScriptZ], q]^2;
 res2 = FastThetaResidue[expr2, {\[ScriptZ], 0, 2}];

 (* Inspect which method the planner chose for a given expression *)
 plan = ThetaResiduePlan[expr, {\[ScriptZ], 0}];
 Print["method = ", plan["method"], ", jetLeaves = ", plan["jetLeaves"]];

 (* Force a specific method variant *)
 resV1 = FastThetaResidueV1[expr, {\[ScriptZ], 0}];
 resV3 = FastThetaResidueV3[expr, {\[ScriptZ], 0}];
 ```

### 8. Theta Series at z = λ τ

```wolfram
(* Direct SeriesData construction when the argument is z = λ Log[q] *)
(* Valid for |2 π λ| < n/2 when the nome is q^n *)
order = 6;
s = \[Theta]S[3][0 Log[q], q, order];
(* Same with an extra \[ScriptZ] offset *)
s2 = \[Theta]S[3][\[ScriptZ] + (1/4) Log[q], q, order];
```

### 9. Theta Normalization to $\vartheta_1$

```wolfram
(* Normalize all theta factors to \[CurlyTheta][1] with canonical shift *)
(* Extracts integer periods as phases and reflects the remainder into the fundamental domain *)
expr = \[CurlyTheta][3][\[ScriptZ] + 1/3, q]^2 * \[CurlyTheta][2][\[ScriptZ], q];
result = ThetaNormalize[expr, \[ScriptZ]];
```

`ThetaNormalize` is an opt-in utility and does not alter `qShift`/`qShift0`/`qShiftInteger` behavior.

## Global Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `order` | 0 | Truncation order for q-series |
| `maxDerivativeOrder` | 20 | Maximum theta derivative order |
| `$debug$` | False | Enable debug printing |
| `$depth$` | unset | Optional indentation depth for nested `PrintDebug` output |
| `$Assumptions` | Complex assumptions | Symbolic simplification assumptions |

## Notation Conventions

### Theta Functions
- `Theta[i][z, q]` - Jacobi theta with built-in `EllipticTheta`
- `ThetaS[i][z, q, order]` - Explicit q-series
- `ThetaS[i][\[Lambda] Log[q], q^n, order]` - Direct `SeriesData` when $z=\lambda\tau$ (requires $|2\pi\lambda|<n/2$)
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
- `ThetaDerivativeSymbol[n]` - Abstract symbol $\vartheta^{(n)}$ for the n-th z-derivative

### Modular Operators
- `MDO[k, f]` - Modular differential operator $\mathcal{D}_q^{(k)}$
- `MMDO[k, ch]` - Abstract version (for symbolic manipulation)
- `SerreD[k, f]` - Serre derivative

### q-Pochhammer and Residue
- `QPochhammerToTheta[f]` / `QPochhammerToTheta[f, a, \[ScriptA]]` - Convert $(a;q)_\infty$-type factors into $\vartheta_1$ / $\eta$ expressions
- `TakeResidue[f, {z, pole}]` - Residue at a simple pole (jet/Laurent framework; rewrites $\vartheta_2,\vartheta_3\to\vartheta_1$ first)
- `TakeResidueOld[f, {z, pole}]` - Legacy residue via `MakeTheta`+`SeriesCoefficient`
- `FastThetaResidue[f, {z, pole}]` / `FastThetaResidue[f, {z, pole, m}]` - Fast residue via `ThetaLocalJet`
- `ThetaResiduePlan` / `ThetaResidueApplyPlan` - Plan-and-apply residue pipeline with automatic `v1`/`v3` method dispatch
