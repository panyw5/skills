(* ====================================================================== *)
(* Eisenstein-Theta Function Conversions
(* EisensteinToTheta, EEiToTheta, EisensteinToThetaFull, EisensteinToThetaRule, EisensteinPolynomialGen *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
Clear[EisensteinToTheta,EisensteinToThetaFull]
Clear[EEiToTheta,EisensteinToThetaFull]

Clear[Ebold]
Ebold[0]=1;
Ebold[twok_]:=E^Sum[EEi[2kk][q]/(2kk) y^(2kk),{kk,1,40}]//SeriesCoefficient[#,{y,0,twok}]&//Expand;

EisensteinToTheta[ff_]:=Module[{\[ScriptZ]},

ff/.{EEE[2][{
 {1},
 {1}
}][$q_]:>-(1/2) EEi[2][$q]+\[CurlyTheta]ppp[1][0,$q]/(8 \[Pi]^2 \[CurlyTheta]p[1][0,$q])}/.{
EEE[KK_][{
 {1},
 {-z_}
}][$q_]:>((-1)^(KK+1) Sum[(1/(2\[Pi] I))^(KK-2l)*1/Factorial[KK-2l] (Ebold[2l]/.q->$q)*\[CurlyTheta]ps[KK-2l][2][\[ScriptZ],$q]/\[CurlyTheta][2][\[ScriptZ],$q],{l,0,Floor[KK/2]}]/.{\[ScriptZ]->1/(2\[Pi] I) Log[z]}),

EEE[KK_][{
 {-1},
 {-z_}
}][$q_]:>((-1)^(KK+1) Sum[(1/(2\[Pi] I))^(KK-2l)*1/Factorial[KK-2l] (Ebold[2l]/.q->$q)*\[CurlyTheta]ps[KK-2l][3][\[ScriptZ],$q]/\[CurlyTheta][3][\[ScriptZ],$q],{l,0,Floor[KK/2]}]/.{\[ScriptZ]->1/(2\[Pi] I) Log[z]}),
EEE[KK_][{
 {1},
 {z_}
}][$q_]:>((-1)^(KK+1) Sum[(1/(2\[Pi] I))^(KK-2l)*1/Factorial[KK-2l] (Ebold[2l]/.q->$q)*\[CurlyTheta]ps[KK-2l][1][\[ScriptZ],$q]/\[CurlyTheta][1][\[ScriptZ],$q],{l,0,Floor[KK/2]}]/.{\[ScriptZ]->1/(2\[Pi] I) Log[z]}),
EEE[KK_][{
 {-1},
 {z_}
}][$q_]:>((-1)^(KK+1) Sum[(1/(2\[Pi] I))^(KK-2l)*1/Factorial[KK-2l] (Ebold[2l]/.q->$q)*\[CurlyTheta]ps[KK-2l][4][\[ScriptZ],$q]/\[CurlyTheta][4][\[ScriptZ],$q],{l,0,Floor[KK/2]}]/.{\[ScriptZ]->1/(2\[Pi] I) Log[z]})

}//RemoveLog//Expand\[CurlyTheta]]

(*EisensteinToTheta[ff_]:=ff/.{EEE[2][1
1

][q]\[Rule]-(1/2) EEi[2][q]+\[CurlyTheta]ppp[1][0,q]/(8 \[Pi]^2 \[CurlyTheta]p[1][0,q])}/.{
EEE[KK_][1
-z_

][q]\[RuleDelayed]((-1)^(KK+1) Sum[(1/(2\[Pi] \[ImaginaryI]))^(KK-2l)*1/Factorial[KK-2l]Ebold[2l]*\[CurlyTheta]ps[KK-2l][2][\[ScriptZ],q]/\[CurlyTheta][2][\[ScriptZ],q],{l,0,Floor[KK/2]}]/.{\[ScriptZ]\[Rule]1/(2\[Pi] \[ImaginaryI])Log[z]}),

EEE[KK_][-1
-z_

][q]\[RuleDelayed]((-1)^(KK+1) Sum[(1/(2\[Pi] \[ImaginaryI]))^(KK-2l)*1/Factorial[KK-2l]Ebold[2l]*\[CurlyTheta]ps[KK-2l][3][\[ScriptZ],q]/\[CurlyTheta][3][\[ScriptZ],q],{l,0,Floor[KK/2]}]/.{\[ScriptZ]\[Rule]1/(2\[Pi] \[ImaginaryI])Log[z]}),
EEE[KK_][1
z_

][q]\[RuleDelayed]((-1)^(KK+1) Sum[(1/(2\[Pi] \[ImaginaryI]))^(KK-2l)*1/Factorial[KK-2l]Ebold[2l]*\[CurlyTheta]ps[KK-2l][1][\[ScriptZ],q]/\[CurlyTheta][1][\[ScriptZ],q],{l,0,Floor[KK/2]}]/.{\[ScriptZ]\[Rule]1/(2\[Pi] \[ImaginaryI])Log[z]}),
EEE[KK_][-1
z_

][q]\[RuleDelayed]((-1)^(KK+1) Sum[(1/(2\[Pi] \[ImaginaryI]))^(KK-2l)*1/Factorial[KK-2l]Ebold[2l]*\[CurlyTheta]ps[KK-2l][4][\[ScriptZ],q]/\[CurlyTheta][4][\[ScriptZ],q],{l,0,Floor[KK/2]}]/.{\[ScriptZ]\[Rule]1/(2\[Pi] \[ImaginaryI])Log[z]})

}//RemoveLog//Expand\[CurlyTheta];*)


EEiToTheta[n_]:=EEiToTheta[n]=Module[{En,z},
En=EEE[n][{
 {1},
 {E^(2\[Pi] I z)}
}][q]//EisensteinToTheta//MakeTheta//SeriesCoefficient[#,{z,0,0}]&//makeAbstract//simplify//Simplify;
EEi[n][q]/.Solve[EEi[n][q]==En,EEi[n][q]][[1]]/.{EEi[k_/;k<n][q]:>EEiToTheta[k]}
];

EisensteinToThetaFull[f_]:=Module[{},
(f//EisensteinToTheta)/.EEi[n_][q]:>EEiToTheta[n]
]



(* ::Input::Initialization:: *)
Clear[EisensteinToThetaRule,EisensteinToThetaOld]
EisensteinToThetaRule[maxDerivativeOrder_]:=EisensteinToThetaRule[maxDerivativeOrder]=
Table[EEE[k][{
 {1},
 {-z_}
}][q]:>Evaluate[((-1)^(k-1) E^(y/(2\[Pi] I) Dz+Sum[EEi[2nn][q]/(2nn) y^(2nn),{nn,1,40}])//SeriesCoefficient[#,{y,0,k}]&//Expand)/.{Dz->\[CurlyTheta]p[2][\[ScriptZ],q]/\[CurlyTheta][2][\[ScriptZ],q],Dz^n_:>\[CurlyTheta]ps[n][2][\[ScriptZ],q]/\[CurlyTheta][2][\[ScriptZ],q]}/.{\[ScriptZ]->1/(2\[Pi] I) Log[z]}],{k,1,maxDerivativeOrder}]~Join~
Table[EEE[k][{
 {-1},
 {-z_}
}][q]:>Evaluate[((-1)^(k-1) E^(y/(2\[Pi] I) Dz+Sum[EEi[2nn][q]/(2nn) y^(2nn),{nn,1,40}])//SeriesCoefficient[#,{y,0,k}]&//Expand)/.{Dz->\[CurlyTheta]p[3][\[ScriptZ],q]/\[CurlyTheta][3][\[ScriptZ],q],Dz^n_:>\[CurlyTheta]ps[n][3][\[ScriptZ],q]/\[CurlyTheta][3][\[ScriptZ],q]}/.{\[ScriptZ]->1/(2\[Pi] I) Log[z]}],{k,1,maxDerivativeOrder}]~Join~

Table[EEE[k][{
 {-1},
 {z_}
}][q]:>Evaluate[((-1)^(k-1) E^(y/(2\[Pi] I) Dz+Sum[EEi[2nn][q]/(2nn) y^(2nn),{nn,1,40}])//SeriesCoefficient[#,{y,0,k}]&//Expand)/.{Dz->\[CurlyTheta]p[4][\[ScriptZ],q]/\[CurlyTheta][4][\[ScriptZ],q],Dz^n_:>\[CurlyTheta]ps[n][4][\[ScriptZ],q]/\[CurlyTheta][4][\[ScriptZ],q]}/.{\[ScriptZ]->1/(2\[Pi] I) Log[z]}],{k,1,maxDerivativeOrder}]~Join~Table[EEE[k][{
 {1},
 {z_}
}][q]:>Evaluate[((-1)^(k-1) E^(y/(2\[Pi] I) Dz+Sum[EEi[2nn][q]/(2nn) y^(2nn),{nn,1,40}])//SeriesCoefficient[#,{y,0,k}]&//Expand)/.{Dz->\[CurlyTheta]p[1][\[ScriptZ],q]/\[CurlyTheta][1][\[ScriptZ],q],Dz^n_:>\[CurlyTheta]ps[n][1][\[ScriptZ],q]/\[CurlyTheta][1][\[ScriptZ],q]}/.{\[ScriptZ]->1/(2\[Pi] I) Log[z]}],{k,1,maxDerivativeOrder}];
EisensteinToThetaOld[f_]:=Block[{},

f/.EisensteinToThetaRule[maxDerivativeOrder]//RemoveLog//\[Theta]Expand

];


(* ::Input::Initialization:: *)
(* Generate polynomials of Eisenstein series at any given modular weight k *)
EisensteinPolynomialGen[k_][seeds_]:=Module[{nn,combinations,raw,z},
raw=(k(E^Sum[z^nn/nn Total[seeds/.{EEE[n_]->EEE[nn],EEi[n_]:>EEi[nn]}],{nn,1,40}])//SeriesCoefficient[#,{z,0,k}]&)//Expand;

combinations=((List@@raw)
/.x_ y_:>y/;x\[Element]Reals/.{EEE[kk_/;OddQ[kk]][{
 {1},
 {1}
}][q]:>0,EEE[kk_/;OddQ[kk]][{
 {-1},
 {1}
}][q]:>0,EEi[kk_/;OddQ[kk]][q]:>0}
)//DeleteCases[#,0]&;
(Table[a[n]combinations[[n]],{n,Length[combinations]}]//Total)
]

