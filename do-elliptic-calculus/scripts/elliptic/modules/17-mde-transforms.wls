(* ====================================================================== *)
(* MDE Transformation Utilities
(* linearAbsOp, MDOInit, STransFormOnMDENew, bShiftMDE *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* perform symbolic S, T transformation on \[CurlyTheta] and Eisenstein series, and the modular differential operators Subsuperscript[D, q, (n)] and Subscript[D, Subscript[b, i]] *)

linearAbsOp={cch,MMDDO,SerreDD,MMDO}~Join~Table[DDbbi[i],{i,1,10}]~Join~Table[DDbi[i],{i,1,10}];
Clear[MDOInit]
(* Will need to use Evaluate command later, therefore write the code in `Block` instead of `Module` *)
MDOInit[]:=Block[{n,x,y,z},
Clear[SerreDD,DDbbi,MMDDO];
Table[linearAbsOp[[i]][x_+y_]:=(linearAbsOp[[i]][x]+linearAbsOp[[i]][y]//Evaluate(*!!!*)),{i,Length[linearAbsOp]}];
Table[linearAbsOp[[i]][x_(y_+z_)]:=(linearAbsOp[[i]][x y]+linearAbsOp[[i]][x z]//Evaluate(*!!!*)),{i,Length[linearAbsOp]}];
Table[linearAbsOp[[i]][n_,x_+y_]:=(linearAbsOp[[i]][n,x]+linearAbsOp[[i]][n,y]//Evaluate(*!!!*)),{i,Length[linearAbsOp]}];
Table[linearAbsOp[[i]][n_,x_(y_+z_)]:=(linearAbsOp[[i]][n,x y]+linearAbsOp[[i]][n,x z]//Evaluate(*!!!*)),{i,Length[linearAbsOp]}];

(* Implement Leibniz rule *)
DDbbi[i_][0,ff_]:=ff;

DDbbi[i_][n_/;n>0,\[Lambda]_ ff_/;MemberQ[linearAbsOp,Head[ff]]]:=DDbbi[i][n-1,Dbi[i][1,\[Lambda]/.{\[ScriptB][ii_]:>1/(2\[Pi] I) Log[b[ii]]}]ff]+DDbbi[i][n-1,\[Lambda] DDbbi[i][1,ff]];

DDbbi[i_][m_,DDbbi[i_][n_,ff_/;MemberQ[linearAbsOp,Head[ff]]]]:=DDbbi[i][m+n,ff];


MMDDO[0,ff_]:=ff;
MMDDO[1,\[Lambda]_ ff_/;MemberQ[linearAbsOp,Head[ff]]]:=q D[\[Lambda]/.{\[Tau]->1/(2\[Pi] I) Log[q]},q]ff+\[Lambda] MMDDO[1,ff];
MMDDO[k_/;k>1,\[Lambda]_ ff_/;MemberQ[linearAbsOp,Head[ff]]]:=SerreDD[2k-2,MMDDO[k-1,\[Lambda] ff]];

(* \!\(
\*SubscriptBox[\(\[PartialD]\), \((0)\)]\ \(\(=\)\(\ \)\(q
\*SubscriptBox[\(\[PartialD]\), \(q\)]\)\)\) *)
SerreDD[0,ff_]:=MMDDO[1,ff];
SerreDD[n_/;n>0,\[ScriptCapitalK][i_,j_] ff_]:=\[ScriptCapitalK][i,j] SerreDD[n,ff];
SerreDD[n_/;n>0,\[ScriptB][i_] ff_]:=\[ScriptB][i] SerreDD[n,ff];
SerreDD[n_/;n>0,\[ScriptB][i_]^l_ ff_]:=\[ScriptB][i]^l SerreDD[n,ff];
SerreDD[n_/;n>0,\[Tau] ff_]:=\[Tau] SerreDD[n,ff]+q D[\[Tau]/.{\[Tau]->1/(2\[Pi] I) Log[q]},q] ff;
(* \!\(
\*SubscriptBox[\(\[PartialD]\), \((n)\)]\((
\*SuperscriptBox[\(\[Tau]\), \(l\)]f)\)\)=(q\!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+
\*SubscriptBox[\(nE\), \(2\)]\)\))(\[Tau]^lf) = \[Tau]^l \!\(
\*SubscriptBox[\(\[PartialD]\), \((n)\)]f\) + q\!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\((
\*SuperscriptBox[\(\[Tau]\), \(l\)])\)\)f *)
SerreDD[n_/;n>0,\[Tau]^l_ ff_]:=\[Tau]^l SerreDD[n,ff]+q D[\[Tau]^l/.{\[Tau]->1/(2\[Pi] I) Log[q]},q] ff;
SerreDD[n_/;n>0,\[Lambda]_?NumericQ ff_]:=\[Lambda] SerreDD[n,ff];

SerreDD[n_/;n>0,\[Lambda]_ ff_/;MemberQ[linearAbsOp,Head[ff]]]:=q D[\[Lambda]/.{\[Tau]->1/(2\[Pi] I) Log[q]},q]ff+\[Lambda] SerreDD[n,ff];

(* \!\(
\*SubscriptBox[\(\[PartialD]\), \(2 k\)]
\*SubsuperscriptBox[\(D\), \(q\), \((n)\)]\) = (q\!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+2\)\)Subscript[kE, 2])Subsuperscript[D, q, (n)] = (q\!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+2\)\)Subscript[nE, 2] + (2k - 2n)Subscript[E, 2])Subsuperscript[D, q, (n)] = \!\(
\*SubsuperscriptBox[\(D\), \(q\), \((n + 1)\)]\  + \ \(\((2 k - 2 n)\)
\*SubscriptBox[\(E\), \(2\)]
\*SubsuperscriptBox[\(D\), \(q\), \((n)\)]\)\) *)
SerreDD[twok_,MMDDO[n_,ff_]]:=MMDDO[n+1,ff]+(twok-2n)EEi[2][q]MMDDO[n,ff];
SerreDD[n_,cch[x___]]:=MMDDO[1,cch[x]]+n EEi[2][q]cch[x];

MMDDO[m_,DDbbi[i_][n_,ff_/;MemberQ[linearAbsOp,Head[ff]]]]:=DDbbi[i][n,MMDDO[m,ff]];
SerreDD[n_,DDbbi[i_][m_,ff_]]:=DDbbi[i][m,SerreDD[n,ff]]

];


(* ::Input::Initialization:: *)
Clear[STransFormOnMDENew];


MMDO[m_,DDbi[i_][n_,ff_/;MemberQ[linearAbsOp,Head[ff]]]]:=DDbi[i][n,MMDO[m,ff]];

STransFormOnMDENew[eq_,\[ScriptB]List_]:=STransFormOnMDENew[eq][\[ScriptB]List];
STransFormOnMDENew[eq_][n_/;IntegerQ[n]]:=STransFormOnMDENew[eq][Table[\[ScriptB][i],{i,n}]];

STransFormOnMDENew[eq_][\[ScriptB]List_/;Head[\[ScriptB]List]==List]:=Module[{qdqRules,DDbiRules,MDOSTransformed,rules,result,SruleOnEEE,Getb,n},

SruleOnEEE[{
 {1},
 {-b_}
}]:=({
 {-1},
 {b}
});
SruleOnEEE[{
 {-1},
 {-b_}
}]:=({
 {-1},
 {-b}
});
SruleOnEEE[{
 {1},
 {b_}
}]:=({
 {1},
 {b}
});
SruleOnEEE[{
 {-1},
 {b_}
}]:=({
 {1},
 {-b}
});
Getb[-b_]:=b;
Getb[b_]:=b;
MDOInit[];

(* Transform \[CurlyTheta], Eisenstein coefficients *)
MDOSTransformed=(eq//STransForm[#,\[ScriptB]List]&//SDualFrame//Simplify)/.{
EEE[nn_][{
 {pm_},
 {bb_}
}][E^(2\[Pi] I(-1/\[Tau]))]:>(
(1/(2\[Pi] I))^nn SeriesCoefficient[(
Sum[1/Factorial[np] (-Log[Getb[bb]])^np y^np,{np,0,40}]
Sum[(2\[Pi] I \[Tau])^m EEE[m][SruleOnEEE[{
 {pm},
 {bb}
}]][q]y^m,{m,0,40}]),{y,0,nn}]/.{EEE[0][{
 {\[Theta]_},
 {\[Phi]_}
}][q_]:>-1}
),
EEi[k_/;k>2][q]:>\[Tau]^(2k) EEi[k][q],
EEi[2][q]:>\[Tau]^2 EEi[2][q]-\[Tau]/(2\[Pi] I)
}//PowerExpand//Simplify;

(* \!\(
\*SubsuperscriptBox[\(D\), \(q\), \((n)\)]f\) = \!\(
\*SubscriptBox[\(\[PartialD]\), \((2 n - 2)\)]
\*SubsuperscriptBox[\(D\), \(q\), \((n - 1)\)]\)f = (q\!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+\((2 n - 2)\)\)\)Subscript[E, 2])Subsuperscript[D, q, (n-1)]f *)
(* \[Rule] (\[Tau]^2q\!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+\[Tau]\)\)\!\(
\*SubscriptBox[\(\[Sum]\), \(i\)]\(
\*SubscriptBox[\(\[ScriptB]\), \(i\)]
\*SubscriptBox[\(D\), \(b[i]\)]\)\)+\!\(
\*SubscriptBox[\(\[Sum]\), \(ij\)]\(
\*SuperscriptBox[\(\[ScriptCapitalK]\), \(ij\)]
\*SubscriptBox[\(\[ScriptB]\), \(i\)]
\*SubscriptBox[\(\[ScriptB]\), \(j\)]\)\)+(2n-2)\[Tau]^2Subscript[E, 2]-(2n-2)*\[Tau]/(2\[Pi]\[ImaginaryI]))Subsuperscript[D, q, (n-1)]f *)
(* \[Rule] (\[Tau]^2q\!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+\[Tau]\)\)\!\(
\*SubscriptBox[\(\[Sum]\), \(i\)]\(
\*SubscriptBox[\(\[ScriptB]\), \(i\)]
\*SubscriptBox[\(D\), \(b[i]\)]\)\)+\!\(
\*SubscriptBox[\(\[Sum]\), \(ij\)]\(
\*SuperscriptBox[\(\[ScriptCapitalK]\), \(ij\)]
\*SubscriptBox[\(\[ScriptB]\), \(i\)]
\*SubscriptBox[\(\[ScriptB]\), \(j\)]\)\)+(2n-2)\[Tau]^2Subscript[E, 2]-(2n-2)*\[Tau]/(2\[Pi]\[ImaginaryI])) (\[Tau]^2q\!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+\[Tau]\)\)\!\(
\*SubscriptBox[\(\[Sum]\), \(i\)]\(
\*SubscriptBox[\(\[ScriptB]\), \(i\)]
\*SubscriptBox[\(D\), \(b[i]\)]\)\)+\!\(
\*SubscriptBox[\(\[Sum]\), \(ij\)]\(
\*SuperscriptBox[\(\[ScriptCapitalK]\), \(ij\)]
\*SubscriptBox[\(\[ScriptB]\), \(i\)]
\*SubscriptBox[\(\[ScriptB]\), \(j\)]\)\)+(2n-4)\[Tau]^2Subscript[E, 2]-(2n-4)*\[Tau]/(2\[Pi]\[ImaginaryI])) Subsuperscript[D, q, (n-2)]f *)
(* \[Rule] (\[Tau]^2q\!\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+\[Tau]\)\)\!\(
\*SubscriptBox[\(\[Sum]\), \(i\)]\(
\*SubscriptBox[\(\[ScriptB]\), \(i\)]
\*SubscriptBox[\(D\), \(b[i]\)]\)\)+\!\(
\*SubscriptBox[\(\[Sum]\), \(ij\)]\(
\*SuperscriptBox[\(\[ScriptCapitalK]\), \(ij\)]
\*SubscriptBox[\(\[ScriptB]\), \(i\)]
\*SubscriptBox[\(\[ScriptB]\), \(j\)]\)\)+(2n-2)\[Tau]^2Subscript[E, 2]-(2n-2)*\[Tau]/(2\[Pi]\[ImaginaryI])) ... (\!\(
\*SuperscriptBox[\(\[Tau]\), \(2\)]q
\*SubscriptBox[\(\[PartialD]\), \(q\)]\))f *)
(* \!\(where\
\*SuperscriptBox[\(\[Tau]\), \(2\)]q\(
\*SubscriptBox[\(\[PartialD]\), \(q\)]\(+\((2 n - 2 l)\)\)\)
\*SuperscriptBox[\(\[Tau]\), \(2\)]
\*SubscriptBox[\(E\), \(2\)]\ groups\ into\
\*SuperscriptBox[\(\[Tau]\), \(2\)]
\*SubscriptBox[\(\[PartialD]\), \((2 n - 2 l)\)]\), l=1,2,...,n *)

MDOSTransformed=MDOSTransformed//.{
MMDO[nn_/;nn>0,ff_]:>\[Tau]^2 SerreDD[2nn-2,MMDO[nn-1,ff]]
+\[Tau] Sum[\[ScriptB][i]DDbbi[i][1,MMDO[nn-1,ff]],{i,Length[\[ScriptB]List]}]
+(Sum[\[ScriptCapitalK][ii,jj]\[ScriptB][ii]\[ScriptB][jj],{ii,Length[\[ScriptB]List]},{jj,Length[\[ScriptB]List]}]-(2nn-2)*\[Tau]/(2\[Pi] I))MMDO[nn-1,ff],
MMDO[0,ff_]:>ff
}//.{DDbi[i_][nn_/;nn>=1,ff_]:>(\[Tau] DDbbi[i][1,DDbi[i][nn-1,ff]]+(D[Sum[\[ScriptCapitalK][ii,jj]\[ScriptB][ii]\[ScriptB][jj],{ii,Length[\[ScriptB]List]},{jj,Length[\[ScriptB]List]}],\[ScriptB][i]])DDbi[i][nn-1,ff]),
DDbi[i_][0,ff_]:>ff};

result=(MDOSTransformed
/.{DDbbi->DDbi,MMDDO->MMDO}/.{DDbi[i_][nn_,x_?NumericQ]:>0,MMDO[nn_,x_?NumericQ]:>0}
/.{\[Tau]->1/(2\[Pi] I) Log[q],\[ScriptB][i_]:>1/(2\[Pi] I) Log[b[i]]}/.{Log[b[i_]]:>2\[Pi] I \[ScriptB][i],Log[q]->2\[Pi] I \[Tau]});

Clear[DDbbi,MMDDO,SerreDD];
result
];
STransFormOnMDE=STransFormOnMDENew;


(* ::Input::Initialization:: *)
Clear[bShiftMDE];
bShiftMDE[eq_][b[i0_]]:=Module[{qdqRules,DDbiRules,shifted,rules,result,SruleOnEEE,Getb},
MDOInit[];
shifted=(eq/.{b[i0]->b[i0] q}/.{
EEE[k_][{
 {\[CurlyPhi]_},
 {z_ q}
}][q]:>EEE[k][{
 {\[CurlyPhi]},
 {z}
}][q]+Sum[1/Factorial[l] EEE[k-l][{
 {\[CurlyPhi]},
 {z}
}][q],{l,1,k}],
EEE[k_][{
 {\[CurlyPhi]_},
 {z_ q^nn_}
}][q]:>EEE[k][{
 {\[CurlyPhi]},
 {z}
}][q]+Sum[nn^l/Factorial[l] EEE[k-l][{
 {\[CurlyPhi]},
 {z}
}][q],{l,1,k}]
}/.{EEE[0][{
 {\[CurlyPhi]_},
 {z_}
}][q]:>-1}
//.{MMDO[nn_,ff_]/;nn>0:>
SerreDD[2nn-2,MMDO[nn-1,ff]]-DDbbi[i0][1,MMDO[nn-1,ff]]+\[ScriptCapitalK]\[Tau] MMDO[nn-1,ff]
}
//.MMDO[0,ff_]:>ff
//.{DDbi[i_][nn_/;nn>=1,ff_]:>DDbbi[i][1,DDbi[i][nn-1,ff]]+\[ScriptCapitalK]b[i] DDbi[i][nn-1,ff]}
//.DDbi[i_][0,ff_]:>ff
/.DDbi[i_][nn_/;nn>=1,ff_]:>DDbbi[i][nn,ff]
);
result=(shifted/.{DDbbi->DDbi,MMDDO->MMDO}/.{DDbi[i_][nn_,0]:>0,MMDO[nn_,0]:>0});

result
];

bShiftMDE[eq_][$n_List]:=Module[{rank},
MDOInit[];
rank=Length[$n];
shifted=(eq/.{b[i_]:>b[i] q^$n[[i]]}/.EEE[k_][{
 {\[CurlyPhi]_},
 {z_}
}][q]:>EEE[k][{
 {\[CurlyPhi]},
 {z//Simplify//PowerExpand}
}][q]
);
shifted=shifted/.{
EEE[k_][{
 {\[CurlyPhi]_},
 {z_ q}
}][q]:>Sum[1/Factorial[l] EEE[k-l][{
 {\[CurlyPhi]},
 {z}
}][q],{l,0,k}],
EEE[k_][{
 {\[CurlyPhi]_},
 {z_ q^nn_}
}][q]:>Sum[nn^l/Factorial[l] EEE[k-l][{
 {\[CurlyPhi]*E^(\[Pi] I 2nn)},
 {z}
}][q],{l,0,k}]
}/.{EEE[0][{
 {\[CurlyPhi]_},
 {z_}
}][q]:>-1};
shifted=(shifted//.{
MMDO[nn_,ff_]/;nn>0:>
SerreDD[2nn-2,MMDO[nn-1,ff]]-Sum[$n[[ii]]DDbbi[ii][1,MMDO[nn-1,ff]],{ii,rank}]+\[ScriptCapitalK]\[Tau] MMDO[nn-1,ff]
}
//.MMDO[0,ff_]:>ff
//.{DDbi[i_][nn_/;nn>=1,ff_]:>DDbbi[i][1,DDbi[i][nn-1,ff]]+\[ScriptCapitalK]b[i] DDbi[i][nn-1,ff]}
//.DDbi[i_][0,ff_]:>ff
/.DDbi[i_][nn_/;nn>=1,ff_]:>DDbbi[i][nn,ff]);
result=(shifted/.{DDbbi->DDbi,MMDDO->MMDO}/.{DDbi[i_][nn_,0]:>0,MMDO[nn_,0]:>0});
result
];


(* ::Input::Initialization:: *)
Print["Elliptic Functions v0.7 by Yiwen Pan, Sun Yat-sen university"]
Print["Collect commonly used operations and transformations for Jacobi theta, Eisenstein and other related functions"]
Print["Useful for symbolic computations, efficient series expansions and modular differential equations analysis"]

