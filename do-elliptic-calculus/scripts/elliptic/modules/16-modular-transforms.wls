(* ====================================================================== *)
(* S and T Modular Transformations
(* STransForm, TTransForm, SDualFrame, TDualFrame *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* perform symbolic S, T transformation on \[CurlyTheta] and Eisenstein series *)
Clear[STransForm]

STransForm[f_,\[Tau]]:=Module[{},
f/.\[CurlyTheta]pToDerivative\[CurlyTheta][maxDerivativeOrder]/.{q->E^(2\[Pi] I \[Tau])}/.{\[Tau]->-1/\[Tau]}
]

STransForm[f_]:=Block[{rule1,rule2,\[CurlyTheta]ps,\[Tau]\[Tau]},

\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];
(* \:7528\:4e8e q\[Rule]\[ExponentialE]^(2\[Pi] \[ImaginaryI] (-/\[Tau])) *)
rule1=(Table[\[CurlyTheta]ps[pnum][i][z_,q^$n_.]:>Evaluate[\[CurlyTheta]ps[pnum][i][z,E^(2\[Pi] I $n \[Tau]\[Tau])]],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);
(* \:7528\:4e8e z\[Rule]z/\[Tau] *)
rule2=(Table[\[CurlyTheta]ps[pnum][i][z_,qq_]:>Evaluate[\[CurlyTheta]ps[pnum][i][z/\[Tau],qq]],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);
(f/.{\[Tau]->-1/\[Tau]}/.rule1/.rule2
/.{EEi[$k_][q^$n_.]:>EEi[$k][E^(2\[Pi] I $n(-1/\[Tau]))],
\[Eta]\[Eta][q^$n_]:>\[Eta]\[Eta][E^(2\[Pi] I $n (-1/\[Tau]))]}/.\[Tau]\[Tau]->-1/\[Tau])
];

(* STransform[f,{\[ScriptB][1],...}] *)
STransForm[f_,\[ScriptB]List_/;Head[\[ScriptB]List]==List]:=Block[{SparamRules},
SparamRules=({Table[$\[ScriptB]->$\[ScriptB]/\[Tau],{$\[ScriptB],\[ScriptB]List}],\[Tau]->-1/\[Tau]}//Flatten);
f/.{q->E^(2\[Pi] I \[Tau])}/.SparamRules/.{EEE[$k_][{
 {pm_},
 {$b_}
}][$q_]:>EEE[$k][{
 {pm},
 {$b//PowerExpand}
}][$q//PowerExpand]}/.EEE[$k_][{
 {pm_},
 {E^\[ScriptB]_}
}][$q_]:>EEE[$k][{
 {pm},
 {E^(\[ScriptB]//Together)}
}][$q]
];

(* STransform[f,{\[ScriptB], \[ScriptC], ...},{\[ScriptX],\[ScriptY]...}] *)
(* take \[ScriptB]\[Rule]\[ScriptB]/\[Tau], \[ScriptC]\[Rule]\[ScriptC]/\[Tau], \[ScriptX]\[Rule]\[ScriptX]-\[ScriptB]^2/\[Tau], \[ScriptY]\[Rule]\[ScriptY]-\[ScriptC]^2/\[Tau], \[Tau]\[Rule]-(1/\[Tau]) *)
STransForm[f_,\[ScriptB]List_/;Head[\[ScriptB]List]==List,\[ScriptY]List_/;Head[\[ScriptY]List]==List]:=STransForm[f,\[ScriptB]List]/.Table[\[ScriptY]List[[i]]->\[ScriptY]List[[i]]-\[ScriptB]List[[i]]^2/\[Tau],{i,Length[\[ScriptY]List]}];


(* STransform[f, \[ScriptB], \[ScriptY]] *)
(* take \[ScriptB][i]\[Rule]\[ScriptB][i]/\[Tau], \[ScriptY][i]\[Rule]\[ScriptY][i]-\[ScriptB][i]^2/\[Tau], \[Tau]\[Rule]-(1/\[Tau]) *)
STransForm[f_,\[ScriptB]_/;Head[\[ScriptB]]==Symbol,\[ScriptY]_/;Head[\[ScriptY]]==Symbol]:=Block[{rule1,\[CurlyTheta]ps,\[Tau]\[Tau]},
Print["A"];
\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];

(* turn all (derivatives of) \[CurlyTheta][i][z,q] into \[CurlyTheta][i][z,\[ExponentialE]^(2\[Pi]\[ImaginaryI](-1/\[Tau]))] *)
rule1=(Table[\[CurlyTheta]ps[pnum][i][z_,q^n_.]:>Evaluate[\[CurlyTheta]ps[pnum][i][z,E^(2\[Pi] I n(-1/\[Tau]))]],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);
(f/.{\[Tau]->-(1/\[Tau])}/.rule1
/.{\[ScriptB][i_]:>\[ScriptB][i]/\[Tau],\[ScriptY][i_]:>\[ScriptY][i]-\[ScriptB][i]^2/\[Tau]}
/.{EEi[n_][q^$n_]:>EEi[n][E^(2\[Pi] I $n(-1/\[Tau]))],\[WeierstrassP]\[WeierstrassP][\[ScriptB]\[ScriptB]_,q^$n_]:>\[WeierstrassP]\[WeierstrassP][\[ScriptB]\[ScriptB]//Simplify,E^(2\[Pi] I $n(-1/\[Tau]))],\[Eta]\[Eta][q^$n_]:>\[Eta]\[Eta][E^(2\[Pi] I $n(-1/\[Tau]))],
EEE[$k_][{
 {pm_},
 {$b_}
}][$q_]:>EEE[$k][{
 {pm},
 {$b//PowerExpand//Together}
}][$q//PowerExpand//Together]}
)//PowerExpand
];
STransform=STransForm;


(* ::Input::Initialization:: *)
Clear[TTransForm,TTransform]
TTransForm[f_]:=Block[{rule,\[CurlyTheta]ps,\[Tau]\[Tau]\[Tau],TruleOnEEE,$\[Tau]},

TruleOnEEE[{
 {1},
 {-b_}
}]:=({
 {1},
 {-b}
});
TruleOnEEE[{
 {-1},
 {-b_}
}]:=({
 {-1},
 {b}
});
TruleOnEEE[{
 {1},
 {b_}
}]:=({
 {1},
 {b}
});
TruleOnEEE[{
 {-1},
 {b_}
}]:=({
 {-1},
 {-b}
});
\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];
rule=(Table[\[CurlyTheta]ps[pnum][i][z_,q_]:>Evaluate[E^((\[Pi] I)/4) \[CurlyTheta]ps[pnum][i][z,q]],{pnum,0,maxDerivativeOrder},{i,1,2}]~Join~Table[\[CurlyTheta]ps[pnum][i][z_,q_]:>Evaluate[\[CurlyTheta]ps[pnum][i+1][z,q]],{pnum,0,maxDerivativeOrder},{i,3,3}]~Join~
Table[\[CurlyTheta]ps[pnum][i][z_,q_]:>Evaluate[\[CurlyTheta]ps[pnum][i-1][z,q]],{pnum,0,maxDerivativeOrder},{i,4,4}])//Flatten;

(* use \[Eta][\[Tau]+1/2]=\[ExponentialE]^(\[Pi]\[ImaginaryI]/24)*\[Eta][2\[Tau]]^3/(\[Eta][\[Tau]]\[Eta][4\[Tau]]),
from
https://math.stackexchange.com/questions/2822781/one-half-shift-in-argument-of-dedekind-eta-function *)
f/.rule/.{\[Eta]\[Eta][x_]:>\[Eta]\[Eta][x/.q->E^(2\[Pi] I \[Tau])//PowerExpand]}/.{

\[Eta]\[Eta][E^(\[Lambda]_. \[Tau])]:>E^((\[Pi] I)/12 (\[Lambda]/(2\[Pi] I))) \[Eta]\[Eta][E^(\[Lambda] $\[Tau])]/;IntegerQ[\[Lambda]/(2\[Pi] I)//Simplify],
\[Eta]\[Eta][E^(\[Lambda]_. \[Tau])]:>E^((\[Pi] I)/24)*\[Eta]\[Eta][E^(2\[Pi] I $\[Tau](2*\[Lambda]/(2\[Pi] I)))]^3/(\[Eta]\[Eta][E^(2\[Pi] I $\[Tau](\[Lambda]/(2\[Pi] I)))]\[Eta]\[Eta][E^((4\[Lambda])/(2\[Pi] I) 2\[Pi] I $\[Tau])]) E^((\[Pi] I)/12 ((2(\[Lambda]/(2\[Pi] I))-1)/2))/;OddQ[(2\[Lambda])/(2\[Pi] I)//Simplify],
(* the output has [q] as the last argument, since I don't want to deal with EEE[n][a
b

][\[ExponentialE]^(2\[Pi]\[ImaginaryI](\[Tau]+k))] *)
EEE[nn_][{
 {pm_},
 {b_}
}][E^(2\[Pi] I \[Tau])]:>EEE[nn][TruleOnEEE[{
 {pm},
 {b}
}]][E^(2\[Pi] I $\[Tau])],
EEE[nn_][{
 {pm_},
 {b_}
}][E^(2\[Pi] I \[Tau])]:>EEE[nn][TruleOnEEE[{
 {pm},
 {b}
}]][E^(2\[Pi] I $\[Tau])]
}/.{\[Tau]->\[Tau]+1(* deal with \[Tau]-dependence in other places *)}/.{$\[Tau]->\[Tau]}/.{E^x_:>(E^x//Simplify)}
];
TTransform=TTransForm;


(* ::Input::Initialization:: *)
(* Directly transform \[Theta]z\[Tau][i][z,\[Tau]] into its equaling S-dual expression *)

Clear[SDualFrame]
SDualFrame[f_]:=Module[{SruleOnEEE,$\[Tau]t,\[Tau]p,\[Alpha],$result,\[ScriptB]},
\[Alpha][z_,\[Tau]_]:=Sqrt[-I \[Tau]] E^(\[Pi]/\[Tau] I z^2);
SruleOnEEE[{
 {1},
 {E^(\[ScriptB]_/\[Tau])}
}]:=({
 {1},
 {E^\[ScriptB]}
});
SruleOnEEE[{
 {-1},
 {E^(\[ScriptB]_/\[Tau])}
}]:=({
 {1},
 {-E^\[ScriptB]}
});
SruleOnEEE[{
 {1},
 {-E^((\[ScriptB]_/\[Tau]))}
}]:=({
 {-1},
 {E^\[ScriptB]}
});
SruleOnEEE[{
 {-1},
 {-E^((\[ScriptB]_/\[Tau]))}
}]:=({
 {-1},
 {-E^\[ScriptB]}
});
SruleOnEEE[{
 {1},
 {1}
}]:=({
 {1},
 {1}
});
SruleOnEEE[{
 {-1},
 {1}
}]:=({
 {1},
 {-1}
});
SruleOnEEE[{
 {1},
 {-1}
}]:=({
 {-1},
 {1}
});
SruleOnEEE[{
 {-1},
 {-1}
}]:=({
 {-1},
 {-1}
});

SruleOnEEE[{
 {1},
 {E^(-(\[ScriptB]_/\[Tau]))}
}]:=({
 {1},
 {E^-\[ScriptB]}
});
SruleOnEEE[{
 {-1},
 {E^(-(\[ScriptB]_/\[Tau]))}
}]:=({
 {1},
 {-E^-\[ScriptB]}
});
SruleOnEEE[{
 {1},
 {-E^(-(\[ScriptB]_/\[Tau]))}
}]:=({
 {-1},
 {E^-\[ScriptB]}
});
SruleOnEEE[{
 {-1},
 {-E^(-(\[ScriptB]_/\[Tau]))}
}]:=({
 {-1},
 {-E^-\[ScriptB]}
});

(* \:628a \[CurlyTheta]ppppp[i] --> Derivative[n][\[CurlyTheta][i]] *)
$result=f/.\[CurlyTheta]pToDerivative\[CurlyTheta][maxDerivativeOrder];

$result=$result/.{\[CurlyTheta][i_][\[ScriptZ]_,q_]:>\[CurlyTheta][i][\[ScriptZ]//Together,q],
Derivative[$n_,$m_][\[CurlyTheta][i_]][\[ScriptZ]_,q_]:>Derivative[$n,$m][\[CurlyTheta][i]][\[ScriptZ]//Together,q],
EEE[k_][{
 {pm_},
 {E^y_}
}][E^(-((2 I \[Pi])/\[Tau]))]:>EEE[k][{
 {pm},
 {E^(y//Together)}
}][E^(-((2 I \[Pi])/\[Tau]))]
};
(* \:5904\:7406 \[CurlyTheta][i][\[ScriptZ]/\[Tau],\[ExponentialE]^(-((2\[Pi]\[ImaginaryI]n)/\[Tau]))] *)
$result=$result/.{\[CurlyTheta][i_][\[ScriptZ]_/\[Tau],E^(minustwo\[Pi]In_/\[Tau])]:>With[{$n=minustwo\[Pi]In/(-2\[Pi] I)},
Rescaled[$n,\[ScriptZ]][\[CurlyTheta][i][(\[ScriptZ]/$n)/\[Tau],E^(-((2\[Pi] I)/\[Tau]))]]]}/.{
\[CurlyTheta][1][\[ScriptZ]_,E^two\[Pi]I\[Tau]_]:>\[CurlyTheta][1][\[ScriptZ]/(two\[Pi]I\[Tau]/(2\[Pi] I)),E^(-2\[Pi] I (two\[Pi]I\[Tau]/(2\[Pi] I))^-1)]/(-I \[Alpha][\[ScriptZ],two\[Pi]I\[Tau]/(2\[Pi] I)]),
Derivative[$n_,0][\[CurlyTheta][1]][\[ScriptZ]_,E^two\[Pi]I\[Tau]_]:>(D[\[CurlyTheta][1][$\[ScriptW]/(two\[Pi]I\[Tau]/(2\[Pi] I)),E^(-2\[Pi] I (two\[Pi]I\[Tau]/(2\[Pi] I))^-1)]/(-I \[Alpha][$\[ScriptW],two\[Pi]I\[Tau]/(2\[Pi] I)]),{$\[ScriptW],$n}]/.{$\[ScriptW]->\[ScriptZ]}),
\[CurlyTheta][i_/;2<=i<=4][\[ScriptZ]_,E^two\[Pi]I\[Tau]_]:>\[CurlyTheta][6-i][\[ScriptZ]/(two\[Pi]I\[Tau]/(2\[Pi] I)),E^(-2\[Pi] I (two\[Pi]I\[Tau]/(2\[Pi] I))^-1)]/\[Alpha][\[ScriptZ],two\[Pi]I\[Tau]/(2\[Pi] I)],
Derivative[$n_,0][\[CurlyTheta][i_/;2<=i<=4]][\[ScriptZ]_,E^two\[Pi]I\[Tau]_]:>(D[\[CurlyTheta][6-i][$\[ScriptW]/(two\[Pi]I\[Tau]/(2\[Pi] I)),E^(-2\[Pi] I (two\[Pi]I\[Tau]/(2\[Pi] I))^-1)]/\[Alpha][$\[ScriptW],two\[Pi]I\[Tau]/(2\[Pi] I)],{$\[ScriptW],$n}]/.{$\[ScriptW]->\[ScriptZ]})

};
$result=$result/.{Rescaled[$n_,\[ScriptZ]_][fn_]:>(fn/.{\[Tau]->\[Tau]/$n})};
(* \:5f15\:5165 $\[Tau]t \:662f\:4e3a\:4e86\:4ece \[ExponentialE]^((2\[Pi]\[ImaginaryI])/n)=\[ExponentialE]^((2\[Pi]\[ImaginaryI] \[Tau]/n)/\[Tau])\:5206\:79bb\:51fa\:7b49\:6548 \[ScriptB]=\[Tau]/n\:ff0c\:5426\:5219 Mathematica \:4f1a\:628a \[ExponentialE]^((2\[Pi]\[ImaginaryI] \[Tau]/n)/\[Tau]) \:81ea\:52a8\:5316\:7b80\:4e3a \[ExponentialE]^((2\[Pi]\[ImaginaryI])/n)  *)
$result=$result/.{
EEE[k_][{
 {pm_},
 {x_?NumericQ/;x^2!=1}
}][E^(-((2 I \[Pi])/\[Tau]))]:>EEE[k][{
 {pm},
 {E^((Log[x]$\[Tau]t)/\[Tau])}
}][E^(-((2 I \[Pi])/\[Tau]))],
EEE[k_][{
 {pm_},
 {x_ E^y_/;x^2==1}
}][E^(-((2 I \[Pi])/\[Tau]))]:>EEE[k][{
 {pm},
 {x E^(y//Together)}
}][E^(-((2 I \[Pi])/\[Tau]))],
EEE[k_][{
 {pm_},
 {x_ E^y_/;x^2!=1}
}][E^(-((2 I \[Pi])/\[Tau]))]:>EEE[k][{
 {pm},
 {E^(Log[x]+y//Together)}
}][E^(-((2 I \[Pi])/\[Tau]))]
};
$result=$result/.{\[Eta]\[Eta][qq_]:>(Sqrt[-I $\[Tau]t]\[Eta]\[Eta][E^(2\[Pi] I $\[Tau]t)]/.{$\[Tau]t->-(1/(2\[Pi] I) Log[qq])^-1}),
\[WeierstrassP]\[WeierstrassP][$\[ScriptB]t_,$qq_]:>($\[Tau]t^2 \[WeierstrassP]\[WeierstrassP][$\[Tau]t $\[ScriptB]t,E^(2\[Pi] I $\[Tau]t)]/.$\[Tau]t->-(1/(2\[Pi] I) Log[$qq])^-1)};

$result=$result/.{

EEi[2][qq_]:>($\[Tau]t^2 EEi[2][E^(2\[Pi] I $\[Tau]t)]-1/(2\[Pi] I) $\[Tau]t/.{$\[Tau]t->-(1/(2\[Pi] I) Log[qq])^-1}),
EEE[2][{
 {1},
 {1}
}][qq_]:>($\[Tau]t^2 EEE[2][{
 {1},
 {1}
}][E^(2\[Pi] I $\[Tau]t)]-1/(2\[Pi] I) $\[Tau]t/.{$\[Tau]t->-(1/(2\[Pi] I) Log[qq])^-1}),

EEi[n_/;n>2][qq_]:>($\[Tau]t^n EEi[n][E^(2\[Pi] I $\[Tau]t)]/.{$\[Tau]t->-(1/(2\[Pi] I) Log[qq])^-1}),

EEE[nn_][{
 {pm_},
 {ppm_. E^(\[ScriptB]_/\[Tau])}
}][E^(2\[Pi] I(-1/\[Tau]))]:>(
(1/(2\[Pi] I))^nn SeriesCoefficient[(Sum[1/Factorial[n] (-\[ScriptB])^n y^n,{n,0,10}]Sum[(2\[Pi] I \[Tau])^m EEE[m][SruleOnEEE[{
 {pm},
 {ppm E^(\[ScriptB]/\[Tau])}
}]][E^(2\[Pi] I \[Tau])]y^m,{m,0,10}]),{y,0,nn}]/.{EEE[0][{
 {\[Theta]_},
 {\[Phi]_}
}][q_]:>-1}
),
EEE[nn_][{
 {pm_},
 {ppm_. E^(-(\[ScriptB]_/\[Tau]))}
}][E^(2\[Pi] I(-1/\[Tau]))]:>(
(1/(2\[Pi] I))^nn SeriesCoefficient[(Sum[1/Factorial[n] (\[ScriptB])^n y^n,{n,0,10}]Sum[(2\[Pi] I \[Tau])^m EEE[m][SruleOnEEE[{
 {pm},
 {ppm E^(-(\[ScriptB]/\[Tau]))}
}]][E^(2\[Pi] I \[Tau])]y^m,{m,0,10}]),{y,0,nn}]/.{EEE[0][{
 {\[Theta]_},
 {\[Phi]_}
}][q_]:>-1}
),
EEE[nn_][{
 {pm_/;pm^2==1},
 {ppm_/;ppm^2==1}
}][E^(2\[Pi] I(-1/\[Tau]))]:>(
(1/(2\[Pi] I))^nn SeriesCoefficient[(Sum[1/Factorial[n] (-\[ScriptB])^n y^n,{n,0,10}]Sum[(2\[Pi] I \[Tau])^m EEE[m][SruleOnEEE[{
 {pm},
 {ppm E^(\[ScriptB]/\[Tau])}
}]][E^(2\[Pi] I \[Tau])]y^m,{m,0,10}]),{y,0,nn}]/.{EEE[0][{
 {\[Theta]_},
 {\[Phi]_}
}][q_]:>-1,\[ScriptB]->0}
)

}/.$\[Tau]t->\[Tau]//RemoveLog//makeAbstract
];


(* ::Input::Initialization:: *)
Clear[TDualFrame]
TDualFrame[f_]:=f/.{
\[Theta][1][z_,E^(2\[Pi] I (\[Tau]+1))]:>E^((\[Pi] I)/4) \[Theta][1][z,E^(2\[Pi] I \[Tau])],
\[Theta][2][z_,E^(2\[Pi] I (\[Tau]+1))]:>E^((\[Pi] I)/4) \[Theta][2][z,E^(2\[Pi] I \[Tau])],
\[Theta][3][z_,E^(2\[Pi] I (\[Tau]+1))]:>\[Theta][4][z,E^(2\[Pi] I \[Tau])],
\[Theta][4][z_,E^(2\[Pi] I (\[Tau]+1))]:>\[Theta][3][z,E^(2\[Pi] I \[Tau])],

EllipticThetaPrime[i_/;i==1||i==2,z_,q_]:>E^((\[Pi] I)/4) EllipticThetaPrime[i,z,q],
EllipticThetaPrime[3,z_,q_]:>E^((\[Pi] I)/4) EllipticThetaPrime[4,z,q],
EllipticThetaPrime[4,z_,q_]:>E^((\[Pi] I)/4) EllipticThetaPrime[3,z,q]
};

