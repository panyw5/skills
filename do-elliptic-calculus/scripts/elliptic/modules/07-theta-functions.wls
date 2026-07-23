(* ====================================================================== *)
(* Jacobi Theta Functions and Series
(* ThetaS, ThetaGS, ThetaAlphaBeta, Theta aliases, TakeResidue, CapitalTheta *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* \[CurlyTheta]ps[pnum] generates abstract symbols for Jacobi \[CurlyTheta] functions and its derivatives *)
(* p denotes the number of derivatives *)
\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])]
(* examples *)
Table[\[CurlyTheta]ps[p],{p,0,5}]

(* \[CurlyTheta][i][\[ScriptZ],q], \[CurlyTheta]p[i][\[ScriptZ],q], ... are mapped to explicit q-series using the makeqSeries function *)
(* \[Theta][i][\[ScriptZ],q] is an alias for the built-in EllipticTheta *)
(* \[Theta]S[i][\[ScriptZ],q] are explicit q-series *)


(* ::Input::Initialization:: *)
(* ::Input::Initialization::*)(* ============================================================*)(* Helper:construct SeriesData from {power,coefficient} pairs*)
(* Supports rational powers such as 1/2,3/2,7/2,...*)
(* ============================================================*)\[Theta]SSeriesData[qvar_,pairs_,order_]:=Module[{powers,den,scaledPairs,minPow,maxPow,len,sa},powers=pairs[[All,1]];
den=LCM@@(Denominator/@powers);
scaledPairs=({den #[[1]],#[[2]]}&/@pairs);
minPow=Min[scaledPairs[[All,1]]];
maxPow=Max[Max[scaledPairs[[All,1]]],den order];
len=maxPow-minPow+1;
sa=SparseArray[(#1-minPow+1)->#2&@@@scaledPairs,len];
SeriesData[qvar,0,Normal[sa],minPow,Max[maxPow+1,den order+1],den]];



(* ::Input::Initialization:: *)
(* explicit q-series for Jacobi theta functions *)
(* TODO: optimize *)
Clear[\[Theta]S]

\[Theta]S[i_][\[ScriptZ]_,q_^$$n_Rational,order_]:=(\[Theta]S[i][\[ScriptZ],$q,Ceiling[order/$$n]]//Normal)/.$q->q^$$n
(* \[CurlyTheta][1][\[ScriptZ],q]=Sum[(-1)^(r-1/2)2Sin[2\[Pi] r \[ScriptZ]]q^(r^2/2),{r,1/2,Sqrt[2order]}], \:5b9a\:4e49: r^2/2=(n+1/2)^2/2=(2n+1)^2/8=l/8, Sqrt[l]=2n+1 = 2r *)

(* ----------------------------------------------------------- *)
(* \:5c0f\:5fc3 \:5982\:679c \[CurlyTheta][1][\[ScriptZ]+\[Lambda]\[Tau],q^n] \:7684 |\[Lambda]|>=n/2\:ff0c\:5fc5\:987b\:5148\:505a qShift\:ff0c\:5426\:5219\:7ed3\:679c\:662f\:9519\:7684 *)
(* ----------------------------------------------------------- *)
\[Theta]S[1][\[Lambda]_ Log[q_],q_^$$n_.,order_]:=Module[{c,rmax,pairs},

c=Pi I \[Lambda];
rmax=Floor[(2 c+Sqrt[4 c^2+8 $$n order])/$$n];
If[EvenQ[rmax],rmax--];
pairs=Flatten[Table[{{$$n r^2/8+c*r,(-1)^((r-1)/2)/I},{$$n r^2/8-c*r,-(-1)^((r-1)/2)/I}},{r,1,rmax,2}],1];
\[Theta]SSeriesData[q,pairs,order]]/;IntegerQ[$$n]&&Abs[2\[Pi] \[Lambda]]<$$n/2;

\[Theta]S[1][\[ScriptZ]_+\[Lambda]_ Log[q_],q_^$$n_.,order_]:=Module[{c,rmax,pairs},
c=Pi I \[Lambda];
rmax=Floor[(2 c+Sqrt[4 c^2+8 $$n order])/$$n];
If[EvenQ[rmax],rmax--];
pairs=Flatten[Table[{{$$n r^2/8+c*r,(-1)^((r-1)/2) E^(Pi I r \[ScriptZ])/I},{$$n r^2/8-c*r,-(-1)^((r-1)/2) E^(-Pi I r \[ScriptZ])/I}},{r,1,rmax,2}],1];
\[Theta]SSeriesData[q,pairs,order]]/;IntegerQ[$$n]&&Abs[2\[Pi] \[Lambda]]<$$n/2;


\[Theta]S[1][\[ScriptZ]_,q_^$$n_Integer,order_]:=\[Theta]S[1][\[ScriptZ],q^$$n,order]=SeriesData[q,0,SparseArray[$$n #^2->(-1)^((#-1)/2) 2 Sin[# \[Pi] \[ScriptZ]]&/@Range[1,Floor[Sqrt[8 order]],2],8 order*$$n]//Normal,1,8order,8];

\[Theta]S[1][\[ScriptZ]_,q_:q,order_]:=\[Theta]S[1][\[ScriptZ],q,order]=SeriesData[q,0,SparseArray[#^2->(-1)^((#-1)/2) 2 Sin[# \[Pi] \[ScriptZ]]&/@Range[1,Floor[Sqrt[8 order]],2],8 order]//Normal,1,8order,8];


(* =Sum[(-1)^n 2Cos[2\[Pi] n \[ScriptZ]]q^(n^2/2),{n,1,Sqrt[2order]}] *)


\[Theta]S[4][\[ScriptZ]_,q_^$$n_Integer,order_]:=\[Theta]S[4][\[ScriptZ],q^$$n,order]=1+SeriesData[q,0,SparseArray[$$n #^2->(-1)^# 2 Cos[2 \[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[2 order]]],2 order*$$n]//Normal
,1,2order,2];

(* \:5f53 z = \[Lambda] Log[q] \:65f6\:ff0c\:76f4\:63a5\:6784\:9020 SeriesData *)
(* \[Theta]S[4] \:4e0e \[Theta]S[3] \:7ed3\:6784\:76f8\:540c\:4f46\:6bcf\:9879\:4e58 (-1)^k *)
\[Theta]S[4][\[Lambda]_ Log[q_],q_^$$n_.,order_]:=Module[{c,kmax,pairs,powers,den,scaledPairs,minPow,maxPow,len,sa},c=2 Pi I \[Lambda];
kmax=Floor[(c+Sqrt[c^2+2 $$n order])/$$n];
pairs=Join[{{0,1}},Flatten[Table[{{$$n k^2/2+c*k,(-1)^k},{$$n k^2/2-c*k,(-1)^k}},{k,kmax}],1]];
powers=pairs[[All,1]];
den=LCM@@(Denominator/@powers);
scaledPairs=({den #[[1]],#[[2]]}&/@pairs);
minPow=Min[scaledPairs[[All,1]]];
maxPow=Max[Max[scaledPairs[[All,1]]],den order];
len=maxPow-minPow+1;
sa=SparseArray[(#1-minPow+1)->#2&@@@scaledPairs,len];
SeriesData[q,0,Normal[sa],minPow,Max[maxPow+1,den order+1],den]]/;IntegerQ[$$n]&&Abs[2\[Pi] \[Lambda]]<$$n/2;


(* \:5f53 z = \[ScriptZ] + \[Lambda] Log[q] \:65f6\:ff0c\[Theta]S[4] \:76f4\:6784\:9020 SeriesData *)

\[Theta]S[4][\[ScriptZ]_+\[Lambda]_ Log[q_],q_^$$n_.,order_]:=Module[{kmax,c,pairs,powers,den,scaledPairs,minPow,maxPow,len,sa},
c=2 Pi I \[Lambda];
kmax=Floor[(c+Sqrt[c^2+2 $$n order])/$$n];
pairs=Join[{{0,1}},Flatten[Table[{{$$n k^2/2+c*k,(-1)^k E^(2 Pi I k \[ScriptZ])},{$$n k^2/2-c*k,(-1)^k E^(-2 Pi I k \[ScriptZ])}},{k,kmax}],1]];
powers=pairs[[All,1]];
den=LCM@@(Denominator/@powers);
scaledPairs=({den #[[1]],#[[2]]}&/@pairs);
minPow=Min[scaledPairs[[All,1]]];
maxPow=Max[Max[scaledPairs[[All,1]]],den order];
len=maxPow-minPow+1;
sa=SparseArray[(#1-minPow+1)->#2&@@@scaledPairs,len];
SeriesData[q,0,Normal[sa],minPow,Max[maxPow+1,den order+1],den]
]/;IntegerQ[$$n]&&Abs[2\[Pi] \[Lambda]]<$$n/2;

\[Theta]S[4][\[ScriptZ]_,q_:q,order_]:=\[Theta]S[4][\[ScriptZ],q,order]=1+SeriesData[q,0,SparseArray[#^2->(-1)^# 2 Cos[2 \[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[2 order]]],2 order]//Normal
,1,2order,2];

(* Subscript[\[CurlyTheta], 3][\[ScriptZ],q] = 1+Sum[2Cos[2\[Pi] n \[ScriptZ]]q^(n^2/2),{n,1,Sqrt[2order]}], \:5b9a\:4e49 n^2/2=l/2, l=0,1, ..., 2order \:4e14\:8981\:6c42 Sqrt[l]=n \:662f\:6574\:6570 *)

\[Theta]S[3][\[Lambda]_ Log[q_],q_^$$n_Integer,order_]:=Module[{c,kmax,pairs},c=2 Pi I \[Lambda];
kmax=Floor[(c+Sqrt[c^2+2 $$n order])/$$n];
pairs=Join[{{0,1}},Flatten[Table[{{$$n k^2/2+c*k,1},{$$n k^2/2-c*k,1}},{k,kmax}],1]];
\[Theta]SSeriesData[q,pairs,order]];


\[Theta]S[3][\[ScriptZ]_+\[Lambda]_ Log[q_],q_^$$n_Integer,order_]:=Module[{c,kmax,pairs},c=2 Pi I \[Lambda];
kmax=Floor[(c+Sqrt[c^2+2 $$n order])/$$n];
pairs=Join[{{0,1}},Flatten[Table[{{$$n k^2/2+c*k,E^(2 Pi I k \[ScriptZ])},{$$n k^2/2-c*k,E^(-2 Pi I k \[ScriptZ])}},{k,kmax}],1]];
\[Theta]SSeriesData[q,pairs,order]];

\[Theta]S[3][\[ScriptZ]_,q_^$$n_Integer,order_]:=\[Theta]S[3][\[ScriptZ],q^$$n,order]=1+SeriesData[q,0,SparseArray[$$n #^2->2 Cos[2 \[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[2 order]]],2 order*$$n]//Normal,1,2order,2];

\[Theta]S[3][\[ScriptZ]_,q_:q,order_]:=\[Theta]S[3][\[ScriptZ],q,order]=Module[{$q},

(1+SeriesData[$q,0,SparseArray[#^2->2 Cos[2 \[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[2 order]]],2 order]//Normal,1,2order,2]//Normal)/.$q->q

];
(*Subscript[\[CurlyTheta], 2][\[ScriptZ],q] = Sum[2Cos[2\[Pi] r \[ScriptZ]]q^(r^2/2),{r,1/2,Sqrt[2order]}]; \:5b9a\:4e49: r^2/2=(n+1/2)^2/2=(2n+1)^2/8=l/8, Sqrt[l]=2n+1 = 2r *)


\[Theta]S[2][\[ScriptZ]_,q_^$$n_Integer,order_]:=\[Theta]S[2][\[ScriptZ],q^$$n,order]=SeriesData[q,0,SparseArray[$$n #^2->2 Cos[\[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[8 order]],2],8 order*$$n]//Normal,1,8order,8];

(*\[Theta]S[2],z=\[Lambda] Log[q],directly return SeriesData*)\[Theta]S[2][\[Lambda]_ Log[q_],q_^$$n_Integer,order_]:=Module[{c,rmax,pairs},c=Pi I \[Lambda];
rmax=Floor[(2 c+Sqrt[4 c^2+8 $$n order])/$$n];
If[EvenQ[rmax],rmax--];
pairs=Flatten[Table[{{$$n r^2/8+c*r,1},{$$n r^2/8-c*r,1}},{r,1,rmax,2}],1];
\[Theta]SSeriesData[q,pairs,order]];


(*\[Theta]S[2],z=scriptZ+\[Lambda] Log[q]*)
\[Theta]S[2][\[ScriptZ]_+\[Lambda]_ Log[q_],q_^$$n_Integer,order_]:=Module[{c,rmax,pairs},c=Pi I \[Lambda];
rmax=Floor[(2 c+Sqrt[4 c^2+8 $$n order])/$$n];
If[EvenQ[rmax],rmax--];
pairs=Flatten[Table[{{$$n r^2/8+c*r,E^(Pi I r \[ScriptZ])},{$$n r^2/8-c*r,E^(-Pi I r \[ScriptZ])}},{r,1,rmax,2}],1];
\[Theta]SSeriesData[q,pairs,order]];
\[Theta]S[2][\[ScriptZ]_,q_:q,order_]:=\[Theta]S[2][\[ScriptZ],q,order]=Module[{$q},
(SeriesData[$q,0,SparseArray[#^2->2 Cos[\[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[8 order]],2],8 order]//Normal,1,8order,8]//Normal)/.{$q->q}

];


(*\[Theta]S[i_][z_,q_:q]:=(Series[\[Theta][i][z,qq],{qq,0,order}]//Normal)/.{qq\[Rule]q}//PowerExpand;*)


(* ::Input::Initialization:: *)
\[Theta]z\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]S[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]pz\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]pS[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]ppz\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]ppS[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]pppz\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]pppS[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]ppppz\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]ppppS[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]pppppz\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]pppppS[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]ppppppz\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]ppppppS[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]pppppppz\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]pppppppS[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]ppppppppz\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]ppppppppS[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]pppppppppz\[Tau]S[i_][z_,\[Tau]_]:=\[Theta]pppppppppS[i][z,E^(2\[Pi] I \[Tau])];


(* ::Input::Initialization:: *)
D\[Tau][f_]:=2\[Pi] I q D[f,q];


(* ::Input::Initialization:: *)
\[Theta]\[Alpha]\[Beta][1,1][z_,q_:q]:=-\[Theta][1][z,q]
\[Theta]\[Alpha]\[Beta][1,0][z_,q_:q]:=\[Theta][2][z,q]
\[Theta]\[Alpha]\[Beta][0,1][z_,q_:q]:=\[Theta][4][z,q]
\[Theta]\[Alpha]\[Beta][0,0][z_,q_:q]:=\[Theta][3][z,q]

\[Theta]\[Alpha]\[Beta]S[\[Alpha]_,\[Beta]_][\[ScriptZ]_,q_:q]:=Sum[q^(1/2 (n+\[Alpha]/2)^2) E^(2\[Pi] I(n+\[Alpha]/2)(\[ScriptZ]+\[Beta]/2)),{n,Floor[-Sqrt[2order]-\[Alpha]/2],Ceiling[Sqrt[2order]-\[Alpha]/2]}];

\[Theta]z\[Tau]\[Alpha]\[Beta]S[\[Alpha]_,\[Beta]_][\[ScriptZ]_,\[Tau]_:\[Tau]]:=Sum[q^(1/2 (n+\[Alpha]/2)^2) E^(2\[Pi] I(n+\[Alpha]/2)(\[ScriptZ]+\[Beta]/2)),{n,Floor[-Sqrt[2order]-\[Alpha]/2],Ceiling[Sqrt[2order]-\[Alpha]/2]}]/.{q->E^(2\[Pi] I \[Tau])};


(* ::Input::Initialization:: *)
(* \[Theta][i][\[ScriptZ],q], \[Theta]p[i][\[ScriptZ],q] are aliases for the built-in EllipticTheta and its derivatives *)
\[Theta][i_][z_,q_:q]:=EllipticTheta[i,\[Pi] z,q^(1/2)];
\[Theta]p[i_][z_,q_:q]:=D[\[Theta][i][w,q],w]/.{w->z};
\[Theta]pp[i_][z_,q_:q]:=D[\[Theta][i][w,q],{w,2}]/.{w->z};
\[Theta]ppp[i_][z_,q_:q]:=D[\[Theta][i][w,q],{w,3}]/.{w->z};
\[Theta]pppp[i_][z_,q_:q]:=D[\[Theta][i][w,q],{w,4}]/.{w->z};
\[Theta]ppppp[i_][z_,q_:q]:=D[\[Theta][i][w,q],{w,5}]/.{w->z};
\[Theta]pppppp[i_][z_,q_:q]:=D[\[Theta][i][w,q],{w,6}]/.{w->z};
\[Theta]ppppppp[i_][z_,q_:q]:=D[\[Theta][i][w,q],{w,7}]/.{w->z};


(* ::Input::Initialization:: *)
\[Theta]z\[Tau][i_][z_,\[Tau]_]:=\[Theta][i][z,E^(2\[Pi] I \[Tau])];
\[Theta]pz\[Tau][i_][z_,\[Tau]_]:=\[Theta]p[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]ppz\[Tau][i_][z_,\[Tau]_]:=\[Theta]pp[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]pppz\[Tau][i_][z_,\[Tau]_]:=\[Theta]ppp[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]ppppz\[Tau][i_][z_,\[Tau]_]:=\[Theta]pppp[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]pppppz\[Tau][i_][z_,\[Tau]_]:=\[Theta]ppppp[i][z,E^(2\[Pi] I \[Tau])];
\[Theta]ppppppz\[Tau][i_][z_,\[Tau]_]:=\[Theta]pppppp[i][z,E^(2\[Pi] I \[Tau])];\[Theta]pppppppz\[Tau][i_][z_,\[Tau]_]:=\[Theta]ppppppp[i][z,E^(2\[Pi] I \[Tau])];


(* ::Input::Initialization:: *)
\[Theta]GS[1][z_,q_:q]:=-I Sum[(-1)^(r-1/2) E^(2\[Pi] I r z) q^(r^2/2),{r,-1/2-order,1/2+order}]
\[Theta]GS[2][z_,q_:q]:=Sum[E^(2\[Pi] I r z) q^(r^2/2),{r,-1/2-order,1/2+order}]
\[Theta]GS[3][z_,q_:q]:=Sum[E^(2\[Pi] I n z) q^(n^2/2),{n,-order,order}]
\[Theta]GS[4][z_,q_:q]:=Sum[(-1)^n E^(2\[Pi] I n z) q^(n^2/2),{n,-order,order}]


(* ::Input::Initialization:: *)
(* perform symbolic residue computation of ratios of \[CurlyTheta][i][\[ScriptZ],q] *)
Clear[TakeResidueOld,TakeGeneralResidue]

(* deal with simple pole *)
TakeResidueOld[f_][\[ScriptA]_,\[ScriptA]pole_]:=Module[{\[Epsilon],fShifted},
fShifted=f/.{\[ScriptA]->\[Epsilon]+\[ScriptA]pole}//qShift//RemoveLog;
(* All \[CurlyTheta] that vanish at \[ScriptA]pole will all turn into \[CurlyTheta][1][n \[Epsilon],q], which can be handled by EllipticTheta[1] series expansion *)
2\[Pi] I(fShifted//MakeTheta//SeriesCoefficient[#,{\[Epsilon],0,-1}]&//makeAbstract)/.{E^(k_ \[Tau]):>q^(k/(2\[Pi] I))}/.{\[CurlyTheta]p[1][0,q_]:>(2\[Pi])\[Eta]\[Eta][q]^3}//PowerExpand
];

TakeResidueOld[f_,{\[ScriptA]_,\[ScriptA]pole_}]:=TakeResidueOld[f][\[ScriptA],\[ScriptA]pole];

(* deal with higher order pole *)
TakeGeneralResidue[f_,{\[ScriptZ]_,\[ScriptZ]pole_,m_}]:=Module[{$\[Epsilon]},
2\[Pi] I((\[ScriptZ]-\[ScriptZ]pole)^(m-1) *(-1)^(m-1)/(m-1)! f/.{\[ScriptZ]->\[ScriptZ]pole+$\[Epsilon]}//qShift//Simplify//MakeTheta//SeriesCoefficient[#,{$\[Epsilon],0,-1}]&//MakeAbstract//simplify)/.{\[CurlyTheta]p[1][0,q_]:>(2 \[Pi]) \[Eta]\[Eta][q]^3}
];


(* ::Input::Initialization:: *)
Clear[FastThetaResidue,ThetaLocalJet,ThetaJetRules,ThetaDerivativeSymbol,ThetaDerivativeOrder,ThetaDerivativeJetRules,ThetaResidueSimplify];

(*ThetaDerivativeSymbol:construct symbol for n-th derivative of theta*)
ThetaDerivativeSymbol[n_Integer]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",n])];
(*ThetaJetTerm:construct local jet term for theta with derivatives up to extraOrder*)
ThetaJetTerm[baseOrder_Integer,i_,arg_,qq_,eps_,extraOrder_Integer]:=Module[{arg0,delta},arg0=arg/. eps->0;
delta=arg-arg0;
ThetaDerivativeSymbol[baseOrder][i][arg0,qq]+Sum[ThetaDerivativeSymbol[baseOrder+k][i][arg0,qq]*delta^k/k!,{k,1,extraOrder}]];
(*ThetaDerivativeOrder:extract derivative order from theta derivative symbol (count'p' characters)*)
ThetaDerivativeOrder[sym_Symbol]:=Module[{name,chars},name=SymbolName[Unevaluated[sym]];
If[StringTake[name,UpTo[1]]=!="\[CurlyTheta]",Return[Missing["NotThetaDerivative"]]];
chars=Characters[name];
Count[Rest[chars],"p"]];
(*ThetaDerivativeJetRules:generate replacement rules for theta derivatives->jet expansion*)
ThetaDerivativeJetRules[eps_,extraOrder_Integer]:=Module[{rules},rules=Table[With[{head=ThetaDerivativeSymbol[derOrder],offset=derOrder},{HoldPattern[Power[head[i_][arg_,qq_],n_Integer?Negative]]:>Power[ThetaJetTerm[offset,i,arg,qq,eps,extraOrder],n],HoldPattern[head[i_][arg_,qq_]]:>ThetaJetTerm[offset,i,arg,qq,eps,extraOrder]}],{derOrder,1,maxDerivativeOrder}];
Flatten[rules]];
(*ThetaResidueSimplify:post-processing simplification (abstract theta,apply boundary values,power expand)*)
ThetaResidueSimplify[expr_]:=Module[{tmp},tmp=expr//MakeAbstract//simplify;
tmp=tmp/. {\[CurlyTheta]p[1][0,qq_]:>2 \[Pi] \[Eta]\[Eta][qq]^3};
tmp=tmp/. {E^(coef_. \[Tau]):>q^(coef/(2 \[Pi] I))};
tmp//PowerExpand];
(*ThetaJetRules:full replacement rules for theta and derivatives->local jet expansion*)
ThetaJetRules[eps_,jetOrder_Integer]:=Module[{extraOrder,thetaRules},extraOrder=jetOrder+6;
thetaRules={HoldPattern[Power[\[Theta][i_][arg_,qq_],n_Integer?Negative]]:>Power[ThetaJetTerm[0,i,arg,qq,eps,extraOrder],n],HoldPattern[\[Theta][i_][arg_,qq_]]:>ThetaJetTerm[0,i,arg,qq,eps,extraOrder],HoldPattern[Power[\[CurlyTheta][i_][arg_,qq_],n_Integer?Negative]]:>Power[ThetaJetTerm[0,i,arg,qq,eps,extraOrder],n],HoldPattern[\[CurlyTheta][i_][arg_,qq_]]:>ThetaJetTerm[0,i,arg,qq,eps,extraOrder]};
Join[thetaRules,ThetaDerivativeJetRules[eps,extraOrder]]];
(*ThetaLocalJet:compute local jet series expansion of expr around eps=0 up to jetOrder*)
ThetaLocalJet[expr_,eps_,jetOrder_Integer]:=Module[{jet},jet=expr/. ThetaJetRules[eps,jetOrder];
jet=jet//MakeAbstract//simplify;
Series[jet,{eps,0,jetOrder}]//Normal//PowerExpand];
FastThetaResidue[f_,{zvar_,zpole_}]:=Module[{eps,shifted,localSeries,residue,\[Epsilon]fast},eps=\[Epsilon]fast;
shifted=(f/. {zvar->zpole+eps})//qShift//RemoveLog//\[CurlyTheta]Expand;
localSeries=ThetaLocalJet[shifted,eps,0];
residue=2 \[Pi] I SeriesCoefficient[localSeries,{eps,0,-1}];
ThetaResidueSimplify[residue]];
FastThetaResidue[f_,{zvar_,zpole_,poleOrder_Integer?Positive}]:=Module[{eps,shifted,jetOrder,localSeries,residue,\[Epsilon]fast},eps=\[Epsilon]fast;
jetOrder=poleOrder-1;
shifted=(f/. {zvar->zpole+eps})//qShift//RemoveLog//\[CurlyTheta]Expand;
localSeries=ThetaLocalJet[shifted,eps,jetOrder];
residue=2 \[Pi] I SeriesCoefficient[localSeries,{eps,0,-1}];
ThetaResidueSimplify[residue]];
FastThetaGeneralResidueLegacy[f_,{zvar_,zpole_,poleOrder_Integer?Positive}]:=Module[{eps,shifted,localSeries,residue,\[Epsilon]fast},eps=\[Epsilon]fast;
shifted=((zvar-zpole)^(poleOrder-1)*(-1)^(poleOrder-1)/(poleOrder-1)!*f/. {zvar->zpole+eps})//qShift//RemoveLog//\[CurlyTheta]Expand;
localSeries=ThetaLocalJet[shifted,eps,0];
residue=2 \[Pi] I SeriesCoefficient[localSeries,{eps,0,-1}];
ThetaResidueSimplify[residue]];
(*ThetaLocalJetV1:alias for ThetaLocalJet (v1 method)*)
ThetaLocalJetV1=ThetaLocalJet;
FastThetaGeneralResidueLegacyV1=FastThetaGeneralResidueLegacy;
FastThetaResidueV1=FastThetaResidue;
FastThetaGeneralResidueLegacyV1=FastThetaGeneralResidueLegacy;
FastThetaResidueV1=FastThetaResidue;
Clear[ThetaFactorLaurent,ThetaDependsQ,ThetaSeriesAssociation,ThetaFactorMinPowerLowerBound,ThetaProductWindow,ThetaConvolveAssociations,ThetaProductCoefficient,FastThetaGeneralResidueLegacyV3,FastThetaResidueV3];
(*ThetaDependsQ:check if expr depends on variable eps*)
ThetaDependsQ[expr_,eps_]:=!FreeQ[expr,eps];
(*ThetaSeriesAssociation:convert Laurent series to Association (power->coefficient)*)
ThetaSeriesAssociation[expr_,eps_,minPow_Integer,maxPow_Integer]:=Module[{expanded,pairs},expanded=expr//PowerExpand//Expand;
pairs=Table[k->Coefficient[expanded,eps,k],{k,minPow,maxPow}];
Association[DeleteCases[pairs,_->0]]];
(*ThetaFactorMinPowerLowerBound:compute lower bound of minimal power in Laurent expansion*)
ThetaFactorMinPowerLowerBound[expr_,eps_]/;!ThetaDependsQ[expr,eps]:=0;
ThetaFactorMinPowerLowerBound[eps_,eps_]:=1;
ThetaFactorMinPowerLowerBound[Power[base_,n_Integer],eps_]:=n*ThetaFactorMinPowerLowerBound[base,eps];
ThetaFactorMinPowerLowerBound[Times[terms__],eps_]:=Total[ThetaFactorMinPowerLowerBound[#,eps]&/@{terms}];
ThetaFactorMinPowerLowerBound[Plus[terms__],eps_]:=Min[ThetaFactorMinPowerLowerBound[#,eps]&/@{terms}];
ThetaFactorMinPowerLowerBound[(\[Theta]|\[CurlyTheta])[i_][arg_,qq_],eps_]:=If[((arg/. eps->0)===0)&&i===1,1,0];
ThetaFactorMinPowerLowerBound[head_Symbol[i_][arg_,qq_],eps_]/;IntegerQ[ThetaDerivativeOrder[head]]:=Module[{arg0,derivOrder},arg0=arg/. eps->0;
derivOrder=ThetaDerivativeOrder[head];
If[arg0=!=0,0,If[i===1,If[EvenQ[derivOrder],1,0],If[OddQ[derivOrder],1,0]]]];
ThetaFactorMinPowerLowerBound[expr_,eps_]:=0;
(*ThetaProductWindow:compute truncation window for product Laurent expansion*)
ThetaProductWindow[expr_,eps_,target_Integer]:=Module[{factors,factorMinPows,totalMin},factors=If[Head[expr]===Times,List@@expr,{expr}];
factorMinPows=ThetaFactorMinPowerLowerBound[#,eps]&/@factors;
totalMin=Total[factorMinPows];
<|"minPow"->Min[-8,totalMin],"maxPow"->Max[4,target-totalMin+Max[factorMinPows]]|>];
(*ThetaFactorLaurent:compute Laurent series of a single factor as Association (power->coefficient)*)
ThetaFactorLaurent[factor_,eps_,minPow_Integer,maxPow_Integer]:=Module[{jet,ser},If[!ThetaDependsQ[factor,eps],Return[<|0->factor|>]];
jet=factor/. ThetaJetRules[eps,maxPow-minPow+2];
jet=jet//simplify;
ser=Quiet[Normal[Series[jet,{eps,0,maxPow}]]];
ThetaSeriesAssociation[ser,eps,minPow,maxPow]];
(*ThetaConvolveAssociations:convolve two Laurent series Associations to compute product coefficients*)
ThetaConvolveAssociations[a_Association,b_Association,minPow_Integer,maxPow_Integer]:=Module[{res,ka,kb,pow,val},res=<||>;
Do[Do[pow=ka+kb;
If[minPow<=pow<=maxPow,val=Lookup[res,pow,0]+a[ka] b[kb];
If[val===0,KeyDropFrom[res,pow],res[pow]=val]],{kb,Keys[b]}],{ka,Keys[a]}];
res];
(*ThetaProductCoefficient:compute specific coefficient of product Laurent expansion via factor convolution*)
ThetaProductCoefficient[expr_,eps_,target_Integer,minPow_Integer,maxPow_Integer]:=Module[{factors,acc,factorAssoc,idx},factors=If[Head[expr]===Times,List@@expr,{expr}];
acc=<|0->1|>;
Do[factorAssoc=ThetaFactorLaurent[factors[[idx]],eps,minPow,maxPow];
acc=ThetaConvolveAssociations[acc,factorAssoc,minPow,maxPow];,{idx,Length[factors]}];
Lookup[acc,target,0]];
FastThetaResidueV3[f_,{zvar_,zpole_}]:=Module[{eps,shifted,coeff,window,\[Epsilon]fast},eps=\[Epsilon]fast;
shifted=(f/. {zvar->zpole+eps})//qShift//RemoveLog//\[CurlyTheta]Expand;
window=ThetaProductWindow[shifted,eps,-1];
coeff=ThetaProductCoefficient[shifted,eps,-1,window["minPow"],window["maxPow"]];
ThetaResidueSimplify[2 \[Pi] I coeff]];
FastThetaGeneralResidueLegacyV3[f_,{zvar_,zpole_,poleOrder_Integer?Positive}]:=Module[{eps,shifted,coeff,window,\[Epsilon]fast},eps=\[Epsilon]fast;
shifted=((zvar-zpole)^(poleOrder-1)*(-1)^(poleOrder-1)/(poleOrder-1)!*f/. {zvar->zpole+eps})//qShift//RemoveLog//\[CurlyTheta]Expand;
window=ThetaProductWindow[shifted,eps,-1];
coeff=ThetaProductCoefficient[shifted,eps,-1,window["minPow"],window["maxPow"]];
ThetaResidueSimplify[2 \[Pi] I coeff]];
(*ThetaResidueShifted:shift f to pole+eps,apply qShift,RemoveLog,ThetaExpand*)
ThetaResidueShifted[f_,{zvar_,zpole_},eps_]:=((f/. {zvar->zpole+eps})//qShift//RemoveLog//\[CurlyTheta]Expand);
ThetaResidueShifted[f_,{zvar_,zpole_,poleOrder_Integer?Positive},eps_]:=(((zvar-zpole)^(poleOrder-1)*(-1)^(poleOrder-1)/(poleOrder-1)!*f/. {zvar->zpole+eps})//qShift//RemoveLog//\[CurlyTheta]Expand);
Clear[ThetaResiduePlan,ThetaResidueApplyPlan];

(*ThetaResiduePlan:analyze shifted expression,compute jetLeaves,choose method (v1 or v3),build plan*)
ThetaResiduePlan[f_,poleSpec_]:=Module[{eps,shifted,factors,depCount,jetLeaves,method,window,\[Epsilon]plan},eps=\[Epsilon]plan;
shifted=ThetaResidueShifted[f,poleSpec,eps];
factors=If[Head[shifted]===Times,List@@shifted,{shifted}];
depCount=Count[factors,factor_/;ThetaDependsQ[factor,eps]];
jetLeaves=LeafCount[shifted/. ThetaJetRules[eps,0]];
(*Empirical rule from large benchmark:v1 wins only in the special high-jetLeaves branch.*)method=If[jetLeaves>=2200,"v1","v3"];
window=ThetaProductWindow[shifted,eps,-1];
<|"eps"->eps,"poleSpec"->poleSpec,"shifted"->shifted,"depCount"->depCount,"jetLeaves"->jetLeaves,"method"->method,"window"->window|>];

(*ThetaResidueApplyPlan:execute plan (dispatch to v1 Jet or v3 Laurent method),extract residue coefficient*)
ThetaResidueApplyPlan[plan_Association]:=Module[{eps,localSeries,coeff,window},eps=plan["eps"];
If[plan["method"]==="v1",localSeries=ThetaLocalJetV1[plan["shifted"],eps,0];
coeff=SeriesCoefficient[localSeries,{eps,0,-1}];
ThetaResidueSimplify[2 \[Pi] I coeff],window=Lookup[plan,"window",ThetaProductWindow[plan["shifted"],eps,-1]];
coeff=ThetaProductCoefficient[plan["shifted"],eps,-1,window["minPow"],window["maxPow"]];
ThetaResidueSimplify[2 \[Pi] I coeff]]];

Clear[TakeResidue]
(*TakeResidue rewrites theta[2] and theta[3] into theta[1] before delegating to ThetaResiduePlan+ThetaResidueApplyPlan.This ensures all vanishing thetas at the pole become theta[1] which has a clean EllipticTheta[1] series expansion.*)
TakeResidue[f_,{\[ScriptA]_,pole_}]:=ThetaResidueApplyPlan[ThetaResiduePlan[f/.{\[CurlyTheta][2][\[ScriptZ]_,q^n_.]:>-\[CurlyTheta][1][\[ScriptZ]-1/2,q^n],\[CurlyTheta][3][\[ScriptZ]_,q]:>-E^(-I \[Pi] \[ScriptZ]+(I \[Pi] \[Tau])/4)\[CurlyTheta][1][\[ScriptZ]-(\[Tau]/2+1/2),q]},{\[ScriptA],pole}]]


(* ::Input::Initialization:: *)
(* functions that generate \[CapitalGamma]^0(2) and Subscript[\[CapitalGamma], 0](2) modular forms *)
Clear[\[CapitalTheta],\[CapitalTheta]S,\[CapitalTheta]t,\[CapitalTheta]tS]
(* Subscript[\[CapitalTheta], r,s], Subscript[Overscript[\[CapitalTheta], ~], r,s] *)
\[CapitalTheta][r_,s_][q_:q]:=\[Theta][2][0,q]^(4r) \[Theta][3][0,q]^(4s)+\[Theta][2][0,q]^(4s) \[Theta][3][0,q]^(4r)
\[CapitalTheta]t[r_,s_][q_:q]:=(-1)^(r+s) (\[Theta][4][0,q]^(4r) \[Theta][3][0,q]^(4s)+\[Theta][4][0,q]^(4s) \[Theta][3][0,q]^(4r))
\[CapitalTheta]S[r_,s_][q_:q]:=\[CapitalTheta][r,s][q]//MakeAbstract//makeqSeries
\[CapitalTheta]tS[r_,s_][q_:q]:=\[CapitalTheta]t[r,s][q]//MakeAbstract//makeqSeries

