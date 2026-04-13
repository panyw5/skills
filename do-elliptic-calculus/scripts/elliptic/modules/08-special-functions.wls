(* ====================================================================== *)
(* Weierstrass, Eta and Related Special Functions
(* WeierstrassP, WeierstrassPZhu, WeierstrassPS, Zeta, Eta, EtaS, Pfn, Qfn, Rfn, P[m], PkZhu *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* Follows from Mathur, Mukhi, \[WeierstrassP] = Subscript[\[WeierstrassP], 0] *)
D\[Tau][f_]:=2\[Pi] I q D[f,q];
\[ScriptP][z_,q_:q]:=(-D[D[\[Theta][1][w,q],w]/\[Theta][1][w,q],w]+4\[Pi] I D\[Tau][Log[\[Eta][q]]])/.{w->z};
\[ScriptP]z\[Tau][z_,\[Tau]_:q]:=(-D[D[\[Theta]z\[Tau][1][w,\[Tau]],w]/\[Theta]z\[Tau][1][w,\[Tau]],w]/.{w->z})+4\[Pi] I D[Log[\[Eta]\[Tau][\[Tau]]],\[Tau]]
\[WeierstrassP]=\[ScriptP];
\[WeierstrassP]z\[Tau]=\[ScriptP]z\[Tau];


(* ::Input::Initialization:: *)
(* Zhu's Weierstrass series *)
\[WeierstrassP]Zhu[k_][z_,q_:q]:=1/z^k+(-1)^k Sum[Factorial[2n+1]/(Factorial[k-1]Factorial[2n+1-(k-1)]) Gi[2n+2][q]z^(2n+2-k),{n,1,order}]


(* ::Input::Initialization:: *)
Clear[\[WeierstrassP]S,\[WeierstrassP]pS]
\[WeierstrassP]S[\[ScriptB]_,q_]:=Module[{result},
order=order+1;
result=(\[WeierstrassP][\[ScriptB],q]//D\[Tau]ToDz//MakeAbstract)/.{\[CurlyTheta][i_][\[ScriptZ]_,qq_]:>\[Theta]S[i][\[ScriptZ],q,order],
\[CurlyTheta]p[i_][\[ScriptZ]_,qq_]:>(D[\[Theta]S[i][$\[ScriptZ]\[ScriptZ],qq,order],$\[ScriptZ]\[ScriptZ]]/.{$\[ScriptZ]\[ScriptZ]->\[ScriptZ]}),
\[CurlyTheta]pp[i_][\[ScriptZ]_,qq_]:>(D[\[Theta]S[i][$\[ScriptZ]\[ScriptZ],qq,order],{$\[ScriptZ]\[ScriptZ],2}]/.{$\[ScriptZ]\[ScriptZ]->\[ScriptZ]}),
\[CurlyTheta]ppp[i_][\[ScriptZ]_,qq_]:>(D[\[Theta]S[i][$\[ScriptZ]\[ScriptZ],qq,order],{$\[ScriptZ]\[ScriptZ],3}]/.{$\[ScriptZ]\[ScriptZ]->\[ScriptZ]})
};
order=order-1;
result//qSeries//RemoveLog//Simplify
];
\[WeierstrassP]pS[\[ScriptB]_,q_]:=D[\[WeierstrassP]S[$\[ScriptB]p,q],$\[ScriptB]p]/.$\[ScriptB]p->\[ScriptB]


(* ::Input::Initialization:: *)
\[Zeta][z_,q_]:=\[Theta]p[1][z,q]/\[Theta][1][z,q]+2z*(-(\[CurlyTheta]ppp[1][0,q]/(6 \[CurlyTheta]p[1][0,q]))//MakeTheta)
\[Zeta]z\[Tau][z_,\[Tau]_]:=\[Theta]pz\[Tau][1][z,\[Tau]]/\[Theta]z\[Tau][1][z,\[Tau]]+2z*\[Eta]1\[Tau][\[Tau]]


(* ::Input::Initialization:: *)
Clear[\[Eta]]
\[Eta][q_]:=(\[Theta]p[1][0,q]/(2\[Pi]))^(1/3);


(* ::Input::Initialization:: *)
Clear[\[Eta]S]
\[Eta]SOld[q_]:=Sum[(Boole[Mod[n,12]==1||Mod[n,12]==11]
-Boole[Mod[n,12]==5||Mod[n,12]==12-5])q^(1/24 n^2),{n,1,Sqrt[24order]}]//qSeries

\[Eta]S[q_^$p$_Integer]:=SeriesData[q,0,SparseArray[$p$ #^2->Boole[Mod[#,12]==1||Mod[#,12]==11]
-Boole[Mod[#,12]==5||Mod[#,12]==12-5]&/@Range[Floor[Sqrt[24order]]]]//Normal,1,24order,24]
\[Eta]S[q_^$p$_Rational]:=Module[{$q},
(\[Eta]S[$q]//Normal)/.{$q->q^$p$}//qSeries
];
\[Eta]S[q_]:=SeriesData[q,0,SparseArray[#^2->Boole[Mod[#,12]==1||Mod[#,12]==11]
-Boole[Mod[#,12]==5||Mod[#,12]==12-5]&/@Range[Floor[Sqrt[24order]]]]//Normal,1,24order,24]


(* ::Input::Initialization:: *)
Clear[\[Eta]1,\[Eta]1\[Tau]]
\[Eta]1[$q_]:=(-2\[Pi] I)/3*D\[Tau][\[Theta]p[1][0,q]]/\[Theta]p[1][0,q]/.q->$q;
\[Eta]1\[Tau][\[Tau]_]:=(-2\[Pi] I)/3*D[\[Theta]pz\[Tau][1][0,\[Tau]],\[Tau]]/\[Theta]pz\[Tau][1][0,\[Tau]];


(* ::Input::Initialization:: *)
Clear[S,e]
S[i_][z_,\[Tau]_]:=\[Theta]pz\[Tau][1][0,\[Tau]]/\[Theta]z\[Tau][i][0,\[Tau]]*\[Theta]z\[Tau][i][z,\[Tau]]/\[Theta]z\[Tau][1][z,\[Tau]]
e[i_][\[Tau]_]:=Module[{\[Tau]\[Tau]},
-4\[Pi] I D[Log[\[Theta]z\[Tau][i][0,\[Tau]\[Tau]]/\[Eta]\[Tau][\[Tau]\[Tau]]],\[Tau]\[Tau]]/.{\[Tau]\[Tau]->\[Tau]}];


(* ::Input::Initialization:: *)
Clear[Pfn,Qfn,Rfn,\[CapitalDelta]fn,\[CapitalDelta]fn,jfn]
Pfn[q_:q,order_:order]:=-12EEi[2][q]
Qfn[q_:q,order_:order]:=720EEi[4][q]
Rfn[q_:q,order_:order]:=-30240EEi[6][q]
\[CapitalDelta]fn[q_:q]:=(Qfn[q]^3-Rfn[q]^2)/12^3;
jfn[q_:q]:=Qfn[q]^3/\[CapitalDelta]fn[q]

Kfn[q_:q]:=(\[CurlyTheta][3][0,q]/\[Eta][q])^12-24
\[Lambda]fn[q_:q]:=\[CurlyTheta][2][0,q]^4/\[CurlyTheta][3][0,q]^4;


(* ::Input::Initialization:: *)
P[m_][z_,q_]:=-1/Factorial[m-1] D[Log[\[Theta][1][z,q]],{z,m}]-\[Pi] I If[m==1,1,0];
Pz\[Tau][m_][z_,\[Tau]_]:=-1/Factorial[m-1] D[Log[\[Theta]z\[Tau][1][z,\[Tau]]],{z,m}]-\[Pi] I If[m==1,1,0];


(* ::Input::Initialization:: *)
Clear[PkZhu]
PkZhu[k_/;k==1][E^z_,q_]:=(-D[\[Theta][1][zzz,q],zzz] /\[Theta][1][zzz,q]-I \[Pi])/.{zzz->z/(2\[Pi] I)}
PkZhu[k_/;k==2][E^z_,q_]:=\[WeierstrassP]k[2][z/(2\[Pi] I),q]+Gi[2][q]
PkZhu[k_/;k>2][E^z_,q_]:=(-1)^k \[WeierstrassP]k[k][z/(2\[Pi] I),q]

PkZhuz\[Tau][k_/;k==1][E^z_,\[Tau]_]:=(-D[\[Theta]z\[Tau][1][zzz,\[Tau]],zzz] /\[Theta]z\[Tau][1][zzz,\[Tau]]-I \[Pi])/.{zzz->z/(2\[Pi] I)}
PkZhuz\[Tau][k_/;k>1][E^z_,\[Tau]_]:=1/(k-1) D[PkZhuz\[Tau][k-1][E^(2\[Pi] I u),\[Tau]],u]/.{u->z/(2\[Pi] I)}


(* ::Input::Initialization:: *)
Clear[P]
P[1][{
 {1},
 {b_}
}][\[ScriptZ]_,q_]:=Module[{$\[ScriptB]},(QPochhammer[q,q]^3 I q^(-1/8) \[CurlyTheta][1][-$\[ScriptB]+\[ScriptZ],q])/(I q^(-1/8) \[CurlyTheta][1][-$\[ScriptB],q]I q^(-1/8) \[CurlyTheta][1][\[ScriptZ],q])/.{$\[ScriptB]->1/(2\[Pi] I) Log[b]}];
P[k_Integer/;k>1][{
 {1},
 {b_}
}][\[ScriptZ]_,q_]:=(-1)^k/(k-1)!*1/(2\[Pi] I)^(k-1) D[P[1][{
 {1},
 {b}
}][$\[ScriptZ],q],{$\[ScriptZ],k-1}]/.{$\[ScriptZ]->\[ScriptZ]};

