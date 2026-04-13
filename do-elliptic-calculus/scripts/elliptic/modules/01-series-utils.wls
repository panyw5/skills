(* ====================================================================== *)
(* Series Expansion, Truncation and Coefficient Extraction
(* DynamicSum/Table, qTruncate, qSeries, LogRemove, HighTempLimit, LaurentCoefficientList, RationalFunctionNumerator *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* programatically perform Sum, Table, SeriesCoefficients *)
Clear[DynamicSum,DynamicTable,DynamicSeriesCoefficient]
DynamicSum[summand_][range__]:=Sum[summand,range];
DynamicTable[summand_][range__]:=Table[summand,range];
DynamicSeriesCoefficient[summand_][range__]:=SeriesCoefficient[summand,range];


(* ::Input::Initialization:: *)
(* Functions that perform different series expansions *)
Clear[qTruncate,qTruncateHalf]
qTruncate[exp_]:=exp/.{q^(n_/;n>order):>0};
qTruncateHalf[f_]:=(f//Normal)/.{q^n_:>0/;n>order/2}//qSeries

qSeries[exp_]:=exp//Series[#,{q,0,order}]&;
qtSeries[exp_]:=exp//Series[#,{qt,0,order}]&;
pSeries[exp_]:=exp//Series[#,{p,0,order}]&;
pqSeries[exp_]:=exp//Series[#,{p,0,order},{q,0,order}]&;
qpSeries[exp_]:=exp//Series[#,{q,0,order},{p,0,order}]&;
qLogqSeries[exp_]:=((exp//Normal)/.Log[q]->Logq//qSeries//Normal)/.{Logq->Log[q]};
qCollect[exp_]:=Collect[exp,{q,lnq},Simplify];

Clear[SeriesCoefficientParallel]
SeriesCoefficientParallel[series_,{a_,a0_,$order_}]:=ParallelTable[SeriesCoefficient[(series//Normal)[[i]],{a,a0,$order}],{i,Length[series//Normal]}]//Total


(* ::Input::Initialization:: *)
LogRemove[exp_]:=(((exp//TrigToExp)
/.{E^x_:>E^(x//Expand)}
/.{Log[x_]:>Log[x//PowerExpand]}
/.{Sqrt[E^x_]:>E^(x/2),1/Sqrt[E^x_]:>E^(-(x/2)),Log[E^x_]:>x,Log[-E^x_]:>Log[E^(x+\[Pi] I)]})
/.{EllipticTheta[i_,z_,q_]:>EllipticTheta[i,z//Expand,q],EllipticThetaPrime[i_,z_,q_]:>EllipticThetaPrime[i,z//Expand,q]})
RemoveLog=LogRemove;
Clean=LogRemove;
CL=Clean;


(* ::Input::Initialization:: *)
HighTempLimit[functionOf\[Tau]_]:=Limit[(functionOf\[Tau]//STransForm//RemoveLog//makeAbstract//makeqSymmetricSeries//PowerExpand//Simplify)/.{\[Tau]->I \[Beta]}/.{\[Beta]->\[Beta]^2},{\[Beta]->0}]
SmallbetaLimit=HighTempLimit;


(* ::Input::Initialization:: *)
(* Functions that efficiently extract series coefficients (without invoking the slower SeriesCoefficient) *)
Clear[LaurentCoefficientList]
LaurentCoefficientList[0,x_,Order_]:=0

(* get Laurent series coefficients from a single-variable Laurent series *)
(*LaurentCoefficientList[exp_SeriesData,x_,Order_]:=exp/.HoldPattern[SeriesData[x,0,l_,y___]]\[RuleDelayed]l//DeleteCases[#,0]&;*)

LaurentCoefficientList[lpol_,$x_,Order_]:=With[{min=Exponent[lpol//Normal,$x,Min]},
CoefficientList[((lpol/$x^min//Normal)/.$x->$x^2//PowerExpand//Expand)/.{$x^(n_/;n>2Order-2min):>0},
$x]//DeleteDuplicates];
LaurentCoefficientList[lpol_,$x_,Order_,den_]:=With[{min=Exponent[lpol//Normal,$x,Min]},
CoefficientList[((lpol/$x^min//Normal)/.$x->$x^den//PowerExpand//Expand)/.{$x^(n_/;n>den Order-den min):>0},
$x]//DeleteDuplicates];


Clear[RationalFunctionNumerator];
(* if exp is a sum of rational functions *)
RationalFunctionNumerator[exp_Plus]:=Module[{commonDenominator,numerators},
commonDenominator=PolynomialLCM@@Denominator/@(List@@exp//Factor);
numerators=commonDenominator(List@@exp)//Factor;
numerators//Total
];
RationalFunctionNumerator[exp_Times]:=Numerator[exp//Together];
RationalFunctionNumerator[exp_]:=exp
