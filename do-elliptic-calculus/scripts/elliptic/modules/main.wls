#!/usr/bin/env wolframscript
(* ====================================================================== *)
(* Elliptic Functions - Main Loader                                    *)
(* Load all modules in dependency order                                *)
(* ====================================================================== *)

(* Base directory for modules *)
$EllipticFunctionsDir = DirectoryName[$InputFileName];

(* Global Settings and Utilities *)
Get[FileNameJoin[{$EllipticFunctionsDir, "00-globals.wls"}]];

(* Series Expansion, Truncation and Coefficient Extraction *)
Get[FileNameJoin[{$EllipticFunctionsDir, "01-series-utils.wls"}]];

(* q-Series Equation Solvers *)
Get[FileNameJoin[{$EllipticFunctionsDir, "02-series-solvers.wls"}]];

(* Plethystic Exponential and Logarithm *)
Get[FileNameJoin[{$EllipticFunctionsDir, "03-plethystic.wls"}]];

(* Eisenstein Series Definitions *)
Get[FileNameJoin[{$EllipticFunctionsDir, "04-eisenstein.wls"}]];

(* Eisenstein-Theta Function Conversions *)
Get[FileNameJoin[{$EllipticFunctionsDir, "05-eisenstein-theta.wls"}]];

(* Theta-to-Eisenstein Conversion Rules *)
Get[FileNameJoin[{$EllipticFunctionsDir, "06-theta-eisenstein-rules.wls"}]];

(* Jacobi Theta Functions and Series *)
Get[FileNameJoin[{$EllipticFunctionsDir, "07-theta-functions.wls"}]];

(* Weierstrass, Eta and Related Special Functions *)
Get[FileNameJoin[{$EllipticFunctionsDir, "08-special-functions.wls"}]];

(* Abstract Symbol to Series Conversion Machinery *)
Get[FileNameJoin[{$EllipticFunctionsDir, "09-abstract-series.wls"}]];

(* Modular Differential Operators *)
Get[FileNameJoin[{$EllipticFunctionsDir, "10-modular-operators.wls"}]];

(* Physical / VOA Quantities *)
Get[FileNameJoin[{$EllipticFunctionsDir, "11-physical-voa.wls"}]];

(* Flavored Modular Linear Differential Equation Generation *)
Get[FileNameJoin[{$EllipticFunctionsDir, "12-fmlde.wls"}]];

(* Simplification Utilities *)
Get[FileNameJoin[{$EllipticFunctionsDir, "13-simplify.wls"}]];

(* Quasi-Periodic Shift Operations *)
Get[FileNameJoin[{$EllipticFunctionsDir, "14-qshift.wls"}]];

(* Tau-derivative to z-derivative Conversion *)
Get[FileNameJoin[{$EllipticFunctionsDir, "15-dtau-to-dz.wls"}]];

(* S and T Modular Transformations *)
Get[FileNameJoin[{$EllipticFunctionsDir, "16-modular-transforms.wls"}]];

(* MDE Transformation Utilities *)
Get[FileNameJoin[{$EllipticFunctionsDir, "17-mde-transforms.wls"}]];

Print["Elliptic Functions v0.7 - All modules loaded successfully"];
