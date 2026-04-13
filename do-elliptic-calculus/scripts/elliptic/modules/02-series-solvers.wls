(* ====================================================================== *)
(* q-Series Equation Solvers
(* SolveqSeries, SolveqSeriesExistence, SolveqbSeries, SolveqbiSeries, SolveqbiSeriesNumerics *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* Functions that solve q-series equations q-series = 0 *)
Clear[SolveqSeries]

(* solve unflavored equation q-series=0, whose coefficients are just numbers *)
SolveqSeries[expression_,vars_][solOrder_]:=Block[{coeffs},
coeffs=LaurentCoefficientList[expression//Normal,q,solOrder];
Solve[coeffs==0,vars]
];

(* Check existence of unflavored q-series=0, whose coefficients are just numbers *)
SolveqSeriesExistence[expression_][solOrder_]:=Block[{coeffs,vars,constantVector,coefficientMatrix},
coeffs=LaurentCoefficientList[expression//Normal,q,solOrder];
vars=Variables[coeffs];
{constantVector,coefficientMatrix}=CoefficientArrays[coeffs,vars]//Normal;
(MapThread[Append,{coefficientMatrix,constantVector}]//MatrixRank)-(coefficientMatrix//MatrixRank)==0
];

(* solve flavored equation q-series=0, whose coefficients are rational functions of b *)
Clear[SolveqbSeries]
SolveqbSeries[expression_,vars_][solOrder_]:=Block[{qcoeffs,qbcoeffs},
qcoeffs=LaurentCoefficientList[expression//Normal,q,2solOrder]//DeleteCases[#,0]&;
qbcoeffs=qcoeffs//Together//Numerator//CoefficientList[#,b]&//Flatten//DeleteCases[#,0]&;

Solve[qbcoeffs==0,vars]
];

(* solve flavored equation q-series=0, whose coefficients are rational functions of b[1], b[2], ... *)
Clear[SolveqbiSeries]
SolveqbiSeries[expression_,vars_][solOrder_]:=Block[{qcoeffs,qbcoeffs},
(* First extract the coefficient of q;
LaurentCoefficientList will replace q\[Rule]q^2, hence 2order *)
qcoeffs=LaurentCoefficientList[expression,q,2solOrder]//DeleteCases[#,0]&;

Print["coeffcients of q extracted"];
(* each coefficients of q is a complicated sum of rational function of b[i] *)
(* Together will be too slow *)
(* first isolate each summand, Factor to simplify *)
(* extract the denominators, find the LeastCommonMultiplier of the denominators *)
(* multiply each term with the LCM, then sum *)

(* \:63d0\:53d6\:6bcf\:4e00\:9879 q \:7684\:7cfb\:6570\:7684\:5206\:5b50 *)
Print["extracting numerators "];
qbcoeffs=Table[RationalFunctionNumerator[qcoeffs[[i]]],{i,Length[qcoeffs]}];

(* \:628a\:6bcf\:4e00\:9879 q \:7684\:7cfb\:6570\:6309\:7167 Log[b[i]], \[Tau] \:7684\:591a\:9879\:5f0f\:63d0\:53d6 refined coefficients *)
qbcoeffs=qbcoeffs//CoefficientList[#,
Array[b,6]
~Join~Table[\[ScriptB][$i],{$i,6}]
~Join~Table[Log[b[$i]],{$i,6}]
~Join~{\[ScriptB],b,\[Tau],Log[q]}]&//Flatten//DeleteCases[#,0]&;

Print["coeffcients of q and \!\(\*SubscriptBox[\(b\), \(i\)]\) extracted; begin solving"];
Print["qbcoeffs = ",qbcoeffs//Length];

(qbcoeffs==0)//Solve[#,vars]&
];

Clear[SolveqbiSeriesNumerics]
(* Numerically solve flavored equation q-series=0,
whose coefficients are rational functions of b[1], b[2], ... *)
SolveqbiSeriesNumerics[expression_,vars_][solOrder_]:=Block[{qcoeffs,qbcoeffs},
(* First extract the coefficient of q;
LaurentCoefficientList will replace q\[Rule]q^2, hence 2order *)
qcoeffs=LaurentCoefficientList[expression,q,2solOrder]//DeleteCases[#,0]&;
Print["coeffcients of q extracted"];
(* each coefficients of q is a complicated sum of rational function of b[i] *)
(* Together will be too slow *)
(* first isolate each summand, Factor to simplify *)
(* extract the denominators, find the LeastCommonMultiplier of the denominators *)
(* multiply each term with the LCM, then sum *)


If[Head[qbcoeffs]==Plus,
qbcoeffs=Table[PolynomialLCM@@Denominator/@(List@@qcoeffs[[i]]//Factor)List@@qcoeffs[[i]]//Factor//Total,{i,Length[qcoeffs]}]//CoefficientList[#,Table[b[i],{i,4}]]&//Flatten//DeleteCases[#,0]&,
qbcoeffs=qcoeffs//Together//Numerator//CoefficientList[#,Table[b[i],{i,4}]]&//Flatten//DeleteCases[#,0]&;
];
(* coefficients of vars are just \[Pi]'s, replace with numerics *)
Print["coeffcients of q and \!\(\*SubscriptBox[\(b\), \(i\)]\) extracted; begin solving"];
(qbcoeffs/.\[Pi]->(\[Pi]//N))==0//Solve[#,vars]&
];

