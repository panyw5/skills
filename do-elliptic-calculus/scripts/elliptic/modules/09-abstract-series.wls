(* ====================================================================== *)
(* Abstract Symbol to Series Conversion Machinery
(* makeAbstract, MakeTheta, makeqSeries, makeqSymmetricSeries, AbstractToSeries *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* Replace Mathematica notations by nicer abstract symbols *)
Clear[makeAbstract]

makeAbstract[f_]:=f/.{
(* qhalf denotes q^(1/2) *)
EllipticTheta[i_,z_,qhalf_]:>\[CurlyTheta][i][\[Pi]^-1 z,qhalf^2],
EllipticThetaPrime[i_,z_,qhalf_]:>\[Pi]^-1 \[CurlyTheta]p[i][\[Pi]^-1 z,qhalf^2],
\!\(\*SuperscriptBox[\(EllipticTheta\),
TagBox[
RowBox[{"(",
RowBox[{"0", ",", "m_", ",", "n_"}], ")"}],
Derivative],
MultilineFunction->None]\)[i_,z_,qhalf_]:>(D[\[CurlyTheta][i][\[Pi]^-1 zz,qqhalf^2],{qqhalf,n},{zz,m}]/.{qqhalf->qhalf,zz->z}),
\!\(\*SuperscriptBox[\(EllipticThetaPrime\),
TagBox[
RowBox[{"(",
RowBox[{"0", ",", "m_", ",", "n_"}], ")"}],
Derivative],
MultilineFunction->None]\)[i_,z_,qhalf_]:>(D[\[CurlyTheta][i][\[Pi]^-1 zz,qqhalf^2],{qqhalf,n},{zz,m+1}]/.{qqhalf->qhalf,zz->z})
}/.{\[CurlyTheta]p[n_][i_][z_,q_]:>(D[\[CurlyTheta][i][zz,q],{zz,n}]/.zz->z)}/.{\!\(\*SuperscriptBox[\(\[CurlyTheta][i_]\),
TagBox[
RowBox[{"(",
RowBox[{"m_", ",", "n_"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_,q_]:>Symbol[StringJoin@@(ConstantArray["Dq",n]~Join~{"\[CurlyTheta]"}~Join~ConstantArray["p",m])][i][z,q]};


MakeAbstract=makeAbstract;

Clear[MakeTheta]
MakeTheta[f_]:=Block[{i,ll,w,z},
f/.{
\[Theta]\[Theta]->\[Theta],\[CurlyTheta]->\[Theta]
}~Join~(Table[
Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",ll])][i][z_,q_]:>(Evaluate[(D[\[Theta][i][w,q],{w,ll}]/.{w->z})//Normal//PowerExpand]),{ll,0,maxDerivativeOrder},{i,1,4}
]//Flatten)
];


(* ::Input::Initialization:: *)
(* after making abstract expressions, further make it into series in q *)
Clear[makeqSeries,makeqSymmetricSeries,\[CurlyTheta]pToDerivative\[CurlyTheta]]

\[CurlyTheta]pToDerivative\[CurlyTheta][maxDerivativeOrder_Integer]:=\[CurlyTheta]pToDerivative\[CurlyTheta][maxDerivativeOrder]=Module[{$$$$$q,$z,$$$i},

Table[
Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",$$$$ll])][$$$i][$z_,$$$$$q_]:>Evaluate[Derivative[$$$$ll,0][\[CurlyTheta][$$$i]][$z,$$$$$q]],{$$$$ll,0,maxDerivativeOrder},{$$$i,1,4}
]//Flatten];


(* turn \[Tau], \[ScriptB] in \[CurlyTheta] function and Eisenstein to Log[q], Log[b] *)
(* this keeps the mutiplicative factors of \[Tau] outside of the theta functions intact *)
(* which will improve performance when doing series expansion: Log[q] impacts series expansion significantly *)
\[Tau]\[ScriptB]Toqb[exp_]:=Module[{$rules},
$rules={\[Tau]->1/(2\[Pi] I) Log[q],
\[ScriptA][$i_]:>1/(2\[Pi] I) Log[a[$i]],\[ScriptA]->1/(2\[Pi] I) Log[a],
\[ScriptB][$i_]:>1/(2\[Pi] I) Log[b[$i]],\[ScriptB]->1/(2\[Pi] I) Log[b],
\[ScriptC][$i_]:>1/(2\[Pi] I) Log[c[$i]],\[ScriptC]->1/(2\[Pi] I) Log[c],
\[ScriptD][$i_]:>1/(2\[Pi] I) Log[d[$i]],\[ScriptD]->1/(2\[Pi] I) Log[d],
\[ScriptM][$i_]:>1/(2\[Pi] I) Log[m[$i]],\[ScriptM]->1/(2\[Pi] I) Log[m],
\[ScriptZ][$i_]:>1/(2\[Pi] I) Log[z[$i]],\[ScriptZ]->1/(2\[Pi] I) Log[z]
};

exp/.\[CurlyTheta]pToDerivative\[CurlyTheta][maxDerivativeOrder]/.{
Derivative[m_,n_][\[CurlyTheta][i_]][$\[ScriptZ]_,$q_]:>(Derivative[m,n][\[CurlyTheta][i]][$\[ScriptZ],$q]/.$rules),
\[CurlyTheta][i_][$\[ScriptZ]_,$q_]:>(\[CurlyTheta][i][$\[ScriptZ],$q]/.$rules),
EEE[$k_][$\[Alpha]_][$q_]:>(EEE[$k][$\[Alpha]][$q]/.$rules)
}
];

Clear[AbstractToSeries]
AbstractToSeries[f_]:=Module[{$$w},
f/.{
\[Eta]\[Eta]->\[Eta]S,QPochhammer[$x_,q_]:>(QPochhammer[$x,q]//qSeries),
\[CurlyTheta][i_][$$\[ScriptZ]\[ScriptZ]$$_,q_]:>\[Theta]S[i][$$\[ScriptZ]\[ScriptZ]$$,q,order],
\[CurlyTheta]\[Alpha]\[Beta][\[Alpha]_,\[Beta]_]:>\[Theta]\[Alpha]\[Beta]S[\[Alpha],\[Beta]],
\[CurlyTheta]z\[Tau]\[Alpha]\[Beta][\[Alpha]_,\[Beta]_][$$\[ScriptZ]\[ScriptZ]$$_,\[Tau]_]:>\[Theta]\[Alpha]\[Beta]S[\[Alpha],\[Beta]][$$\[ScriptZ]\[ScriptZ]$$,E^(2\[Pi] I \[Tau])],
Derivative[$l_,0][\[CurlyTheta][i_]][$$\[ScriptZ]\[ScriptZ]$$_,q_]:>(D[\[Theta]S[i][$$w,q,order],{$$w,$l}]/.$$w->$$\[ScriptZ]\[ScriptZ]$$),
EEE->EE,EEi->Ei,
\[WeierstrassP]\[WeierstrassP]->\[WeierstrassP]S,\[WeierstrassP]\[WeierstrassP]p->\[WeierstrassP]pS}
];


Clear[LogProductToSumLog];
LogProductToSumLog[f_]:=f//.{$Log$[$x_Times]:>Total[$Log$[#]&/@List@@$x],$Log$[1/x_]:>-$Log$[x],
$Log$[x_^n_]:>n $Log$[x]};


makeqSeries[f_Times]:=Module[{result,$b,numerator,denominator,resultLogNumerator,resultLogDenominator,$\[Lambda]$},
PrintDebug["separating numerator and denominator"];

numerator=Numerator[f];
denominator=Denominator[f];

result=(numerator//makeqSeries)/(denominator//makeqSeries)
]/; Length[List@@f]>4&&!TrueQ[Denominator[f]==1];


(*makeqSeries[f_Times]:=Module[{result,$b,numerator,denominator,resultLogNumerator,resultLogDenominator,$\[Lambda]$},
PrintDebug["f has no denominator, change product into \[ExponentialE]^Log[sum]"];
(* Log[-1+a[1]q+...+O[q^n]] \:7531\:4e8e\:9886\:5934\:9879\:662f\:4e2a\:8d1f\:6570\:ff0c\:4f1a\:51fa\:73b0\:6761\:4ef6 Piecewise \:7ed3\:679c\:ff0c\:5fc5\:987b\:907f\:514d *)
(* \:89e3\:51b3\:65b9\:6cd5\:662f\:5f15\:5165 $Log$ \:8f85\:52a9\:51fd\:6570\:8fdb\:884c\:62e6\:622a\:ff0c\:7ed9\:6240\:6709 $Log$[SeriesData] \:4e58\:4ee5\:4e00\:4e2a\:5c40\:90e8\:53d8\:91cf $\[Lambda]$ *)

resultLogNumerator=Together/@($Log$[f]//LogProductToSumLog//makeqSeries);

result=(resultLogNumerator/.$Log$[x_SeriesData]\[RuleDelayed]$Log$[$\[Lambda]$ x]/.$Log$\[Rule]Log//RemoveLog//Exp)/.$\[Lambda]$\[Rule]1
]/; Length[List@@f]>4&&TrueQ[Denominator[f]==1];
*)

makeqSeries[f_Plus/; Length[f]<=4]:=Module[{$w,z,qq,ll},
PrintDebug["Turning sum into series"];

Table[f[[i]]//makeqSeries,{i,Length[f]}]//Total
];

makeqSeries[f_Plus/; Length[f]>4]:=Module[{fList,$i$},
PrintDebug["Parallelizing makeqseries"];
fList=RandomSample@(List@@f);
ParallelTable[fList[[$i$]]//makeqSeries,{$i$,Length[fList]}]//Total
];

makeqSeries[f_]:=Module[{},

PrintDebug["Turning one term into series"];
PrintDebug["f = ",f];
f//\[Tau]\[ScriptB]Toqb//AbstractToSeries//RemoveLog
];

(* after making abstract expressions, further make it into series in q *)
makeqSymmetricSeries[f_]:=f/.(
(* process \[CurlyTheta]pppppppp...pp[i][z,q] up to maxDerivativeOrder "p" *)
(Table[
Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",ll])][i][z_,q_]:>(Evaluate[(D[\[Theta]GS[i][w,q],{w,ll}]/.{w->z})//Normal//PowerExpand]),{ll,0,maxDerivativeOrder},{i,1,4}
]//Flatten)~Join~
{
Dq\[CurlyTheta][i_][z_,q_]:>(D[\[Theta]GS[i][z,qq],qq]/.{qq->q}),
Dq\[CurlyTheta]p[i_][z_,q_]:>(D[(D[\[Theta]GS[i][w,qq],w]/.{w->z}),qq]/.{qq->q})
});

