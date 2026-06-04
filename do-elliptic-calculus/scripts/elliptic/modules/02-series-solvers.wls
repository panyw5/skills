(* ====================================================================== *)
(* q-Series Equation Solvers
(* SolveqSeries, SolveqSeriesExistence, SolveqbSeries, SolveqbiSeries, SolveqbiSeriesNumerics *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* Functions that solve q-series equations q-series = 0 *)
Clear[SolveqSeries]

(* solve unflavored equation q-series=0, whose coefficients are just numbers *)
SolveqSeries[expression_,vars_][solOrder_]:=Block[{coeffs},
coeffs=LaurentCoefficientList[expression//Normal,q,solOrder];
Solve[coeffs==0,vars]
];

(* Check existence of unflavored q-series=0, whose coefficients are just numbers *)
SolveqSeriesExistence[expression_][solOrder_]:=Block[{coeffs,vars,constantVector,coefficientMatrix},
coeffs=LaurentCoefficientList[expression//Normal,q,solOrder];
vars=Variables[coeffs];
{constantVector,coefficientMatrix}=CoefficientArrays[coeffs,vars]//Normal;
(MapThread[Append,{coefficientMatrix,constantVector}]//MatrixRank)-(coefficientMatrix//MatrixRank)==0
];

(* solve flavored equation q-series=0, whose coefficients are rational functions of b *)
Clear[SolveqbSeries]
SolveqbSeries[expression_,vars_][solOrder_]:=Block[{qcoeffs,qbcoeffs},
qcoeffs=LaurentCoefficientList[expression//Normal,q,2solOrder]//DeleteCases[#,0]&;
qbcoeffs=qcoeffs//Together//Numerator//CoefficientList[#,b]&//Flatten//DeleteCases[#,0]&;

Solve[qbcoeffs==0,vars]
];

(* solve flavored equation q-series=0, whose coefficients are rational functions of b[1], b[2], ... *)
Clear[SolveqbiSeries]
SolveqbiSeries[expression_,vars_][solOrder_]:=Block[{qcoeffs,qbcoeffs},
(* First extract the coefficient of q;
LaurentCoefficientList will replace q\[Rule]q^2, hence 2order *)
qcoeffs=LaurentCoefficientList[expression,q,2solOrder]//DeleteCases[#,0]&;

Print["coeffcients of q extracted"];
(* each coefficients of q is a complicated sum of rational function of b[i] *)
(* Together will be too slow *)
(* first isolate each summand, Factor to simplify *)
(* extract the denominators, find the LeastCommonMultiplier of the denominators *)
(* multiply each term with the LCM, then sum *)

(* \:63d0\:53d6\:6bcf\:4e00\:9879 q \:7684\:7cfb\:6570\:7684\:5206\:5b50 *)
Print["extracting numerators "];
qbcoeffs=Table[RationalFunctionNumerator[qcoeffs[[i]]],{i,Length[qcoeffs]}];

(* \:628a\:6bcf\:4e00\:9879 q \:7684\:7cfb\:6570\:6309\:7167 Log[b[i]], \[Tau] \:7684\:591a\:9879\:5f0f\:63d0\:53d6 refined coefficients *)
qbcoeffs=qbcoeffs//CoefficientList[#,
Array[b,6]
~Join~Table[\[ScriptB][$i],{$i,6}]
~Join~Table[Log[b[$i]],{$i,6}]
~Join~{\[ScriptB],b,\[Tau],Log[q]}]&//Flatten//DeleteCases[#,0]&;

Print["coeffcients of q and \!\(\*SubscriptBox[\(b\), \(i\)]\) extracted; begin solving"];
Print["qbcoeffs = ",qbcoeffs//Length];

(qbcoeffs==0)//Solve[#,vars]&
];

Clear[SolveqbiSeriesNumerics]
(* Numerically solve flavored equation q-series=0,
whose coefficients are rational functions of b[1], b[2], ... *)
SolveqbiSeriesNumerics[expression_,vars_][solOrder_]:=Block[{qcoeffs,qbcoeffs},
(* First extract the coefficient of q;
LaurentCoefficientList will replace q\[Rule]q^2, hence 2order *)
qcoeffs=LaurentCoefficientList[expression,q,2solOrder]//DeleteCases[#,0]&;
Print["coeffcients of q extracted"];
(* each coefficients of q is a complicated sum of rational function of b[i] *)
(* Together will be too slow *)
(* first isolate each summand, Factor to simplify *)
(* extract the denominators, find the LeastCommonMultiplier of the denominators *)
(* multiply each term with the LCM, then sum *)


If[Head[qbcoeffs]==Plus,
qbcoeffs=Table[PolynomialLCM@@Denominator/@(List@@qcoeffs[[i]]//Factor)List@@qcoeffs[[i]]//Factor//Total,{i,Length[qcoeffs]}]//CoefficientList[#,Table[b[i],{i,4}]]&//Flatten//DeleteCases[#,0]&,
qbcoeffs=qcoeffs//Together//Numerator//CoefficientList[#,Table[b[i],{i,4}]]&//Flatten//DeleteCases[#,0]&;
];
(* coefficients of vars are just \[Pi]'s, replace with numerics *)
Print["coeffcients of q and \!\(\*SubscriptBox[\(b\), \(i\)]\) extracted; begin solving"];
(qbcoeffs/.\[Pi]->(\[Pi]//N))==0//Solve[#,vars]&
];

(* ::Input::Initialization:: *)
(* Script-variable conversion utilities *)
Clear[\[ScriptP]]
Clear[ToStraight,ToScript]
letters=ToExpression/@Alphabet[];
scriptLetters=ToExpression["\\[Script"<>(#//ToString//ToUpperCase)<>"]"]&/@Alphabet[];


ToStraight[exp_]:=exp/.{\[ScriptA][j_]:>-((I Log[a[j]])/(2 \[Pi])),\[ScriptB][j_]:>-((I Log[b[j]])/(2 \[Pi])),\[ScriptC][j_]:>-((I Log[c[j]])/(2 \[Pi])),\[ScriptD][j_]:>-((I Log[d[j]])/(2 \[Pi])),\[ScriptE][j_]:>-((I Log[e[j]])/(2 \[Pi])),\[ScriptF][j_]:>-((I Log[f[j]])/(2 \[Pi])),\[ScriptG][j_]:>-((I Log[g[j]])/(2 \[Pi])),\[ScriptH][j_]:>-((I Log[h[j]])/(2 \[Pi])),\[ScriptI][j_]:>-((I Log[9[j]])/(2 \[Pi])),\[ScriptJ][j_]:>-((I Log[j[j]])/(2 \[Pi])),\[ScriptK][j_]:>-((I Log[k[j]])/(2 \[Pi])),\[ScriptL][j_]:>-((I Log[l[j]])/(2 \[Pi])),\[ScriptM][j_]:>-((I Log[m[j]])/(2 \[Pi])),\[ScriptN][j_]:>-((I Log[n[j]])/(2 \[Pi])),\[ScriptO][j_]:>-((I Log[o[j]])/(2 \[Pi])),\[ScriptP][j_]:>-((I Log[p[j]])/(2 \[Pi])),\[ScriptQ][j_]:>-((I Log[q[j]])/(2 \[Pi])),\[ScriptR][j_]:>-((I Log[r[j]])/(2 \[Pi])),\[ScriptS][j_]:>-((I Log[s[j]])/(2 \[Pi])),\[ScriptT][j_]:>-((I Log[t[j]])/(2 \[Pi])),\[ScriptU][j_]:>-((I Log[u[j]])/(2 \[Pi])),\[ScriptV][j_]:>-((I Log[v[j]])/(2 \[Pi])),\[ScriptW][j_]:>-((I Log[w[j]])/(2 \[Pi])),\[ScriptX][j_]:>-((I Log[x[j]])/(2 \[Pi])),\[ScriptY][j_]:>-((I Log[y[j]])/(2 \[Pi])),\[ScriptZ][j_]:>-((I Log[z[j]])/(2 \[Pi])),\[ScriptA]->-((I Log[a])/(2 \[Pi])),\[ScriptB]->-((I Log[b])/(2 \[Pi])),\[ScriptC]->-((I Log[c])/(2 \[Pi])),\[ScriptD]->-((I Log[d])/(2 \[Pi])),\[ScriptE]->-((I Log[e])/(2 \[Pi])),\[ScriptF]->-((I Log[f])/(2 \[Pi])),\[ScriptG]->-((I Log[g])/(2 \[Pi])),\[ScriptH]->-((I Log[h])/(2 \[Pi])),\[ScriptI]->-((I Log[9])/(2 \[Pi])),\[ScriptJ]->-((I Log[j])/(2 \[Pi])),\[ScriptK]->-((I Log[k])/(2 \[Pi])),\[ScriptL]->-((I Log[l])/(2 \[Pi])),\[ScriptM]->-((I Log[m])/(2 \[Pi])),\[ScriptN]->-((I Log[n])/(2 \[Pi])),\[ScriptO]->-((I Log[o])/(2 \[Pi])),\[ScriptP]->-((I Log[p])/(2 \[Pi])),\[ScriptQ]->-((I Log[q])/(2 \[Pi])),\[ScriptR]->-((I Log[r])/(2 \[Pi])),\[ScriptS]->-((I Log[s])/(2 \[Pi])),\[ScriptT]->-((I Log[t])/(2 \[Pi])),\[ScriptU]->-((I Log[u])/(2 \[Pi])),\[ScriptV]->-((I Log[v])/(2 \[Pi])),\[ScriptW]->-((I Log[w])/(2 \[Pi])),\[ScriptX]->-((I Log[x])/(2 \[Pi])),\[ScriptY]->-((I Log[y])/(2 \[Pi])),\[ScriptZ]->-((I Log[z])/(2 \[Pi]))}~Join~{\[Tau]->1/(2\[Pi] I) Log[q]};

ToScript[exp_]:=exp/.q->E^(2\[Pi] I \[Tau])/.{a[j_]:>E^(2 I \[Pi] \[ScriptA][j]),b[j_]:>E^(2 I \[Pi] \[ScriptB][j]),c[j_]:>E^(2 I \[Pi] \[ScriptC][j]),d[j_]:>E^(2 I \[Pi] \[ScriptD][j]),e[j_]:>E^(2 I \[Pi] \[ScriptE][j]),f[j_]:>E^(2 I \[Pi] \[ScriptF][j]),g[j_]:>E^(2 I \[Pi] \[ScriptG][j]),h[j_]:>E^(2 I \[Pi] \[ScriptH][j]),9[j_]:>E^(2 I \[Pi] \[ScriptI][j]),j[j_]:>E^(2 I \[Pi] \[ScriptJ][j]),k[j_]:>E^(2 I \[Pi] \[ScriptK][j]),l[j_]:>E^(2 I \[Pi] \[ScriptL][j]),m[j_]:>E^(2 I \[Pi] \[ScriptM][j]),n[j_]:>E^(2 I \[Pi] \[ScriptN][j]),o[j_]:>E^(2 I \[Pi] \[ScriptO][j]),p[j_]:>E^(2 I \[Pi] \[ScriptP][j]),q[j_]:>E^(2 I \[Pi] \[ScriptQ][j]),r[j_]:>E^(2 I \[Pi] \[ScriptR][j]),s[j_]:>E^(2 I \[Pi] \[ScriptS][j]),t[j_]:>E^(2 I \[Pi] \[ScriptT][j]),u[j_]:>E^(2 I \[Pi] \[ScriptU][j]),v[j_]:>E^(2 I \[Pi] \[ScriptV][j]),w[j_]:>E^(2 I \[Pi] \[ScriptW][j]),x[j_]:>E^(2 I \[Pi] \[ScriptX][j]),y[j_]:>E^(2 I \[Pi] \[ScriptY][j]),z[j_]:>E^(2 I \[Pi] \[ScriptZ][j]),a->E^(2 I \[Pi] \[ScriptA]),b->E^(2 I \[Pi] \[ScriptB]),c->E^(2 I \[Pi] \[ScriptC]),d->E^(2 I \[Pi] \[ScriptD]),e->E^(2 I \[Pi] \[ScriptE]),f->E^(2 I \[Pi] \[ScriptF]),g->E^(2 I \[Pi] \[ScriptG]),h->E^(2 I \[Pi] \[ScriptH]),9->E^(2 I \[Pi] \[ScriptI]),j->E^(2 I \[Pi] \[ScriptJ]),k->E^(2 I \[Pi] \[ScriptK]),l->E^(2 I \[Pi] \[ScriptL]),m->E^(2 I \[Pi] \[ScriptM]),n->E^(2 I \[Pi] \[ScriptN]),o->E^(2 I \[Pi] \[ScriptO]),p->E^(2 I \[Pi] \[ScriptP]),q->E^(2 I \[Pi] \[ScriptQ]),r->E^(2 I \[Pi] \[ScriptR]),s->E^(2 I \[Pi] \[ScriptS]),t->E^(2 I \[Pi] \[ScriptT]),u->E^(2 I \[Pi] \[ScriptU]),v->E^(2 I \[Pi] \[ScriptV]),w->E^(2 I \[Pi] \[ScriptW]),x->E^(2 I \[Pi] \[ScriptX]),y->E^(2 I \[Pi] \[ScriptY]),z->E^(2 I \[Pi] \[ScriptZ])}//RemoveLog//Simplify//Expand;
ProductToScriptSum[f_]:=1/(2\[Pi] I) Log[f]//ToScript
