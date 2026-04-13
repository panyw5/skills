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
(* explicit q-series for Jacobi theta functions *)
(* TODO: optimize *)
Clear[\[Theta]S]

\[Theta]S[i_][\[ScriptZ]_,q_^$$n_Rational,order_]:=(\[Theta]S[i][\[ScriptZ],$q,Ceiling[order/$$n]]//Normal)/.$q->q^$$n
(* \[CurlyTheta][1][\[ScriptZ],q]=Sum[(-1)^(r-1/2)2Sin[2\[Pi] r \[ScriptZ]]q^(r^2/2),{r,1/2,Sqrt[2order]}], \:5b9a\:4e49: r^2/2=(n+1/2)^2/2=(2n+1)^2/8=l/8, Sqrt[l]=2n+1 = 2r *)
\[Theta]S[1][\[ScriptZ]_,q_:q,order_]:=\[Theta]S[1][\[ScriptZ],q,order]=SeriesData[q,0,SparseArray[#^2->(-1)^((#-1)/2) 2 Sin[# \[Pi] \[ScriptZ]]&/@Range[1,Floor[Sqrt[8 order]],2],8 order]//Normal,1,8order,8];
\[Theta]S[1][\[ScriptZ]_,q_^$$n_Integer,order_]:=\[Theta]S[1][\[ScriptZ],q^$$n,order]=SeriesData[q,0,SparseArray[$$n #^2->(-1)^((#-1)/2) 2 Sin[# \[Pi] \[ScriptZ]]&/@Range[1,Floor[Sqrt[8 order]],2],8 order*$$n]//Normal,1,8order,8];


(* =Sum[(-1)^n 2Cos[2\[Pi] n \[ScriptZ]]q^(n^2/2),{n,1,Sqrt[2order]}] *)
\[Theta]S[4][\[ScriptZ]_,q_:q,order_]:=\[Theta]S[4][\[ScriptZ],q,order]=1+SeriesData[q,0,SparseArray[#^2->(-1)^# 2 Cos[2 \[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[2 order]]],2 order]//Normal
,1,2order,2];

\[Theta]S[4][\[ScriptZ]_,q_^$$n_Integer,order_]:=\[Theta]S[4][\[ScriptZ],q^$$n,order]=1+SeriesData[q,0,SparseArray[$$n #^2->(-1)^# 2 Cos[2 \[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[2 order]]],2 order*$$n]//Normal
,1,2order,2];


(*Subscript[\[CurlyTheta], 3][\[ScriptZ],q] = 1+Sum[2Cos[2\[Pi] n \[ScriptZ]]q^(n^2/2),{n,1,Sqrt[2order]}], \:5b9a\:4e49 n^2/2=l/2, l=0,1, ..., 2order \:4e14\:8981\:6c42 Sqrt[l]=n \:662f\:6574\:6570  *)

\[Theta]S[3][\[ScriptZ]_,q_:q,order_]:=\[Theta]S[3][\[ScriptZ],q,order]=1+SeriesData[q,0,SparseArray[#^2->2 Cos[2 \[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[2 order]]],2 order]//Normal,1,2order,2];

\[Theta]S[3][\[ScriptZ]_,q_^$$n_Integer,order_]:=\[Theta]S[3][\[ScriptZ],q^$$n,order]=1+SeriesData[q,0,SparseArray[$$n #^2->2 Cos[2 \[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[2 order]]],2 order*$$n]//Normal,1,2order,2];

(*Subscript[\[CurlyTheta], 2][\[ScriptZ],q] = Sum[2Cos[2\[Pi] r \[ScriptZ]]q^(r^2/2),{r,1/2,Sqrt[2order]}]; \:5b9a\:4e49: r^2/2=(n+1/2)^2/2=(2n+1)^2/8=l/8, Sqrt[l]=2n+1 = 2r *)

\[Theta]S[2][\[ScriptZ]_,q_:q,order_]:=\[Theta]S[2][\[ScriptZ],q,order]=SeriesData[q,0,SparseArray[#^2->2 Cos[\[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[8 order]],2],8 order]//Normal,1,8order,8];
\[Theta]S[2][\[ScriptZ]_,q_^$$n_Integer,order_]:=\[Theta]S[2][\[ScriptZ],q^$$n,order]=SeriesData[q,0,SparseArray[$$n #^2->2 Cos[\[Pi] # \[ScriptZ]]&/@Range[1,Floor[Sqrt[8 order]],2],8 order*$$n]//Normal,1,8order,8];

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
Clear[TakeResidue,TakeGeneralResidue]

(* deal with simple pole *)
TakeResidue[f_][\[ScriptA]_,\[ScriptA]pole_]:=Module[{\[Epsilon],fShifted},
fShifted=f/.{\[ScriptA]->\[Epsilon]+\[ScriptA]pole}//qShift//RemoveLog;
(* All \[CurlyTheta] that vanish at \[ScriptA]pole will all turn into \[CurlyTheta][1][n \[Epsilon],q], which can be handled by EllipticTheta[1] series expansion *)
2\[Pi] I(fShifted//MakeTheta//SeriesCoefficient[#,{\[Epsilon],0,-1}]&//makeAbstract)/.{E^(k_ \[Tau]):>q^(k/(2\[Pi] I))}/.{\[CurlyTheta]p[1][0,q_]:>(2\[Pi])\[Eta]\[Eta][q]^3}//PowerExpand
];

TakeResidue[f_,{\[ScriptA]_,\[ScriptA]pole_}]:=TakeResidue[f][\[ScriptA],\[ScriptA]pole];

(* deal with higher order pole *)
TakeGeneralResidue[f_,{\[ScriptZ]_,\[ScriptZ]pole_,m_}]:=Module[{$\[Epsilon]},
2\[Pi] I((\[ScriptZ]-\[ScriptZ]pole)^(m-1) *(-1)^(m-1)/(m-1)! f/.{\[ScriptZ]->\[ScriptZ]pole+$\[Epsilon]}//qShift//Simplify//MakeTheta//SeriesCoefficient[#,{$\[Epsilon],0,-1}]&//MakeAbstract//simplify)/.{\[CurlyTheta]p[1][0,q_]:>(2 \[Pi]) \[Eta]\[Eta][q]^3}
];


(* ::Input::Initialization:: *)
(* functions that generate \[CapitalGamma]^0(2) and Subscript[\[CapitalGamma], 0](2) modular forms *)
Clear[\[CapitalTheta],\[CapitalTheta]S,\[CapitalTheta]t,\[CapitalTheta]tS]
(* Subscript[\[CapitalTheta], r,s], Subscript[Overscript[\[CapitalTheta], ~], r,s] *)
\[CapitalTheta][r_,s_][q_:q]:=\[Theta][2][0,q]^(4r) \[Theta][3][0,q]^(4s)+\[Theta][2][0,q]^(4s) \[Theta][3][0,q]^(4r)
\[CapitalTheta]t[r_,s_][q_:q]:=(-1)^(r+s) (\[Theta][4][0,q]^(4r) \[Theta][3][0,q]^(4s)+\[Theta][4][0,q]^(4s) \[Theta][3][0,q]^(4r))
\[CapitalTheta]S[r_,s_][q_:q]:=\[CapitalTheta][r,s][q]//MakeAbstract//makeqSeries
\[CapitalTheta]tS[r_,s_][q_:q]:=\[CapitalTheta]t[r,s][q]//MakeAbstract//makeqSeries

