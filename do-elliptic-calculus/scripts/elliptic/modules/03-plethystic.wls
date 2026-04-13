(* ====================================================================== *)
(* Plethystic Exponential and Logarithm
(* PE, PE0, PLog *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* Compute Plethystic exponential *)
Clear[PE]
order=5;

PE[X_Plus][q_]:= Module[{$i},Product[PE[X[[$i]]][q],{$i,Length[X]}]]
PE[1/(1-q_^n_.) \[Lambda]_Integer x_][q_]:=PE[1/(1-q^n) x][q]^\[Lambda]
PE[1/(1-q_^n_.) y_Plus][q_]:=PE[1/(1-q^n) y//Expand][q]
PE[1/(1-q_^n_.) x_ y_Plus][q_]:=PE[1/(1-q^n) x y//Expand][q]
PE[1/(1-q_^n_.) x_Times][q_]:=1/QPochhammer[x,q^n]
PE[1/(1-q_^n_.) x_Power][q_]:=1/QPochhammer[x,q^n];
PE[1/(1-q_^n_.) x_Symbol][q_]:=1/QPochhammer[x,q^n];
PE[1/(q_^n_.-1) x_][q_]:= PE[1/(1-q^n) x][q]^-1;


PE0[x_]:=PE[1/(1-qtemp) x][qtemp]//SeriesCoefficient[#,{qtemp,0,0}]&


(* test *)

{PE[1/(1-q) 3x][q]==1/QPochhammer[x,q]^3,
PE[1/(1-q) (-3)x][q]==QPochhammer[x,q]^3,
PE[1/(1-q) (-3)q x][q]==QPochhammer[q x,q]^3,
PE[1/(1-q) 3 x^2][q]==QPochhammer[x^2,q]^-3,
PE[1/(1-q^3) 3 x^2][q]==QPochhammer[x^2,q^3]^-3,
PE[1/(1-q) (3x+4y)][q]==1/QPochhammer[x,q]^3 1/QPochhammer[y,q]^4,
PE[1/(1-q^4) (3 x/z+4y^2)][q]==1/QPochhammer[x/z,q^4]^3 1/QPochhammer[y^2,q^4]^4,
(*PE0[x]==1/(1-x),
PE0[x+y]==1/(1-x)1/(1-y)//FullSimplify,*)
PE[a/(1-q^3)][q]==1/QPochhammer[a,q^3],
PE[q^i/(1-q^(-2+NN/2))+q^(1+i)/(1-q^(-2+NN/2))][q]==1/(QPochhammer[q^i,q^(-2+NN/2)] QPochhammer[q^(1+i),q^(-2+NN/2)])

}


(* ::Input::Initialization:: *)
PLog[f_][aList_][q]:=Module[{rule$},
rule$[k_]:=rule$[k]=Table[aList[[i]]->aList[[i]]^k,{i,Length[aList]}];
Series[(1-q) Sum[MoebiusMu[k]/k Log[((f//Normal)/.{q->q^k}/.rule$[k])],{k,1,2order}],{q,0,order}]//PowerExpand
];

