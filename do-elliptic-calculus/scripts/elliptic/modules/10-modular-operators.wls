(* ====================================================================== *)
(* Modular Differential Operators
(* SerreD, MDO, MDOCache, Db, Dbi, MakeEquationqSeries, SimplifyqSeries *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* Define the Serre derivative SerreD[k] = \!\(
\*SubscriptBox[\(\[PartialD]\), \((k)\)]\ \(\(=\)\(\ \)\(q
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+
\*SubscriptBox[\(kE\), \(2\)]\)\((\[Tau])\)\)\)\)*)
Clear[SerreD,SerreD\[Tau]]
(* when f is a series *)
SerreD[k_,f_SeriesData]:=q D[f,q]+k Ei[2][q]f//Simplify;
(* when f is a product of something times a series *)
SerreD[k_,f_]:=(Expand[q \!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\((f)\)\)+k Ei[2][q] f])/;MatchQ[f,HoldPattern[_ SeriesData[___]]]
(* when f is a sum *)
SerreD[k_,f_Plus]:=Total[SerreD[k,#]&/@(RandomSample[List@@f])];
(* other cases *)
SerreD[k_,f_]:=(q D[f,q]+k EEi[2][q]f//Expand);

SerreD\[Tau][k_,f_]:=1/(2\[Pi] I) D[f,\[Tau]]+k EEi\[Tau][2][\[Tau]]f//Expand


(* Define modular differential operator Subsuperscript[D, q, (k)]*)
Clear[MDO,MDO\[Tau]]
(*MDO[k_/;k>0,f_]:=SerreD[2k-2,MDO[k-1,f]];*)
MDO[k_/;k==0,f_]:=f;
(* !!! Simple memoization does not work directly with parallelzation !!! *)
(*MDO[k_/;k>0,$TEST[q]]:=MDO[k,$TEST[q]]=SerreD[2k-2,MDO[k-1,$TEST[q]]];*)
(* Use the MDOCach to store data, which is  *)

(* for series f *)
MDO[k_/;k>0,f_SeriesData]:=MDO[k,$TEST[q]]/.{$TEST[q]->f,Derivative[n_][$TEST][q]:>D[f,{q,n}],EEi->Ei};
MDO[k_/;k>0,f_/;MatchQ[f,HoldPattern[_ SeriesData[___]]]]:=MDO[k,$TEST[q]]/.{$TEST[q]->f,Derivative[n_][$TEST][q]:>D[f,{q,n}],EEi->Ei};

(* for abstract expression f[q] *)
MDO[k_/;k>0,f_]:=MDO[k,$TEST[q]]/.{$TEST[q]->f,Derivative[n_][$TEST][q]:>D[f,{q,n}]};

Clear[MDOCache]
MDO[k_/;k>0,$TEST[q]]:=If[
MDOCache[k,$TEST[q]]===Null,

(MDOCache[k,$TEST[q]]=SerreD[2k-2,MDO[k-1,$TEST[q]]];
MDOCache[k,$TEST[q]]),

If[Head[MDOCache[k,$TEST[q]]]===MDOCache,

(MDOCache[k,$TEST[q]]=SerreD[2k-2,MDO[k-1,$TEST[q]]];
MDOCache[k,$TEST[q]]),

(MDOCache[k,$TEST[q]])

]
];
SetSharedFunction[MDOCache];

MDO\[Tau][k_/;k==0,f_]:=f;
MDO\[Tau][k_/;k>0,$TEST[\[Tau]]]:=MDO\[Tau][k,$TEST[\[Tau]]]=SerreD\[Tau][2k-2,MDO\[Tau][k-1,$TEST[\[Tau]]]]
MDO\[Tau][k_/;k>0,f_]:=MDO\[Tau][k,$TEST[\[Tau]]]/.{$TEST[\[Tau]]->f,Derivative[n_][$TEST][\[Tau]]:>D[f,{\[Tau],n}]}

(*Import["MDO.mx"]*)

Clear[Db,Dbi]
Db[f_]:=b D[f,b]
Db[n_,f_]:=Nest[Db,f,n]

Dbi[i_][f_]:=b[i]D[f,b[i]];
Dbi[i_][n_,f_]:=Sum[StirlingS2[n,k]b[i]^k D[f,{b[i],k}],{k,1,n}]
DbiOld[i_][n_,f_]:=Nest[Dbi[i],f,n]


(* ::Input::Initialization:: *)
(* Map modular differential operators acting on combinations of Eisenstein, Jacobi theta and \[Eta] functions into q-series *)
Clear[MakeEquationqSeries,MakeEquationqSeriesParallel,MakeEquationqSeriesParallel2]
(* deal with sum *)
MakeEquationqSeriesParallel[expression_Plus]:=Module[{Randomized},

ParallelTable[term/.{MMDO[k_,cch]:>MDO[k,$TEST[q]]}/.{$TEST[q]->ch,Derivative[n_][$TEST][q]:>D[ch,{q,n}],EEi->Ei}//Simplify,{term,RandomSample@(List@@expression)}]//Total
];

MakeEquationqSeriesParallel[expression_Plus,maxMDO_Integer]:=Module[{randomized,start,end},
randomized=RandomSample@(List@@(expression/.{
x_ MMDO[k_/;k>maxMDO-1,cch]:>Total[(Times[x,#]&/@(List@@MDO[k,$TEST[q]]))],
MMDO[k_,cch]:>MDO[k,$TEST[q]]
}));

Print["number of terms = ",Length[randomized],", begins parallel computation"];
start=AbsoluteTime[];
result=ParallelTable[term/.{$TEST[q]->ch,Derivative[n_][$TEST][q]:>D[ch,{q,n}],EEi->Ei}//Simplify,{term,randomized}]//Total;
Print["Total time = ",AbsoluteTime[]-start];
result
];

MakeEquationqSeriesParallel2[expression_Plus]:=Module[{randomized},

randomized=RandomSample[List@@expression];
Print["number of terms = ",Length[randomized],", begins parallel computation"];
ParallelTable[term/.{MMDO[k_,cch]:>MDO[k,$TEST[q]]}/.{$TEST[q]->ch,Derivative[n_][$TEST][q]:>D[ch,{q,n}],EEi->Ei}//Simplify,{term,randomized}]//Total

];

MakeEquationqSeries[f_Plus]:=Module[{},
Print["treat each summand individually"];
Total[MakeEquationqSeries/@(RandomSample[List@@f])]//Simplify
];

MakeEquationqSeries[f_Plus/; Length[f]>8]:=Module[{},
Print["treat each summand individually"];
Total[Parallelize[MakeEquationqSeries/@(RandomSample[List@@f])]]//Simplify
];

(* deal with monomial *)
(* to increase performance *)
(* - cch\[Rule]ch should be a q-series *)
(* - EE, Ei, \[CapitalTheta]S, \[CapitalTheta]tS, \[WeierstrassP]S should all be q-series *)
(* to avoid the abstract symbol *)
MakeEquationqSeries[f_]:=f//.{MMDO[$n_,DDbi[i_][$m_,cch_]]:>DDbi[i][$m,MMDO[$n,cch]]}/.{
cch->ch,
MMDO[nn_,cch_]:>(MDO[nn,ch//Normal]/.EEi->Ei//Normal//Collect[#,q]&//qSeries)/;MatchQ[ch,HoldPattern[_ SeriesData[___]]],
MMDO[nn_,cch]:>MDO[nn,ch]/;MatchQ[ch,HoldPattern[SeriesData[___]]],
DDb->Db,DDbi->Dbi,EEE->EE,EEi->Ei,\[CapitalTheta]\[CapitalTheta]->\[CapitalTheta]S,\[CapitalTheta]\[CapitalTheta]t->\[CapitalTheta]tS,\[WeierstrassP]\[WeierstrassP]->\[WeierstrassP]S,\[CurlyTheta][i_][\[ScriptZ]_,q_]:>\[Theta]S[i][\[ScriptZ],q,order]}//qSeries//Simplify


(* ::Input::Initialization:: *)
SimplifyqSeries[exp_SeriesData]:=exp/.{
HoldPattern[SeriesData[q,0,coeffs_,nmin_,nmax_,den_]]:>(SeriesData[q,0,
Table[coeffs[[i]]//Simplify,{i,Length[coeffs]}],
nmin,nmax,den])
};

