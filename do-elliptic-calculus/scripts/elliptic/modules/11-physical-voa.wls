(* ====================================================================== *)
(* Physical / VOA Quantities
(* ScriptCapitalS, Lambda, Ign, Itgn, IgnUnflavored, ItgnUnflavored *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
Clear[\[ScriptCapitalS],\[Lambda],\[Lambda]t,Ign]
Clear[\[Lambda]]

\[ScriptCapitalS][l_]:=SeriesCoefficient[1/2*y/Sinh[y/2],{y,0,l}];
(* \[Lambda][n,k] = Subsuperscript[\[Lambda], k, (n)] *)
\[Lambda][k_/;OddQ[k],l_/;EvenQ[l]]:=\[Lambda][k,l]=0;
\[Lambda][k_/;EvenQ[k],l_/;OddQ[l]]:=\[Lambda][k,l]=0;
\[Lambda][twokplus2_/;EvenQ[twokplus2],0]:=\[Lambda][twokplus2,0]=0;
\[Lambda][1,1]=1;
\[Lambda][2,2]=1;
\[Lambda][twokplus1_/;OddQ[twokplus1],1]:=\[Lambda][twokplus1,1]=Sum[\[Lambda][twokplus1-1,2l](\[ScriptCapitalS][2l]-BernoulliB[2l]/Factorial[2l]),{l,1,(twokplus1-1)/2}];
\[Lambda][twokplus1_/;OddQ[twokplus1],twomplus1_/;twomplus1>1]:= \[Lambda][twokplus1,twomplus1]=Sum[\[Lambda][twokplus1-1,2l]\[ScriptCapitalS][2(l-(twomplus1-1)/2)],{l, (twomplus1-1)/2,(twokplus1-1)/2}];

\[Lambda][twokplus2_/;EvenQ[twokplus2],twomplus2_]:=\[Lambda][twokplus2,twomplus2]=Sum[\[Lambda][twokplus2-1,2l+1]\[ScriptCapitalS][2(l-(twomplus2-2)/2)],{l,(twomplus2-2)/2,(twokplus2-2)/2}]


\[Lambda]t[n_,l_][k_]:=Sum[(k/2)^(lp-l)*1/Factorial[lp-l] \[Lambda][n,lp],{lp,l,n}];
Clear[Ign,Itgn]
Ign[g_,n_]:=I^n/2*\[Eta]\[Eta][q]^(n+2g-2)/Product[\[CurlyTheta][1][2\[ScriptB][i],q],{i,n}] (DynamicSum[Product[\[Alpha][i],{i,n}]Sum[\[Lambda][n+2g-2,kkk]EEE[kkk][{
 {(-1)^n},
 {Product[E^(2\[Pi] I \[ScriptB][i]\[Alpha][i]),{i,n}]}
}][q],{kkk,1,n+2g-2}]]@@Table[{\[Alpha][i],-1,1,2},{i,n}])/;n>0;
Ign[g_,0]:=1/2 \[Eta]\[Eta][q]^(2g-2) Sum[\[Lambda][2g-2,2k](EEi[2k][q]+BernoulliB[2k]/Factorial[2k]),{k,g-1}]

Itgn[g_,n_][k_]:=(-1)^k*\[Eta]\[Eta][q]^(n+2g-2)/Product[\[CurlyTheta][1][2\[ScriptB][i],q],{i,n}] DynamicSum[
Product[\[Alpha][i],{i,n}]Sum[\[Lambda]t[n+1+2g-2,l][k+1]EEE[l][{
 {(-1)^(n+k)},
 {Product[E^(2\[Pi] I \[ScriptB][i]\[Alpha][i]),{i,n}]}
}][q],{l,1,n+2g-2}]
]@@Table[{\[Alpha][i],-1,1,2},{i,n}];

(* \:6ce8\:610f TakeResidue[f] = Res[1/b*f[b],b] = Res[f[\[ScriptB]],\[ScriptB]] *)
Itgn[g_,0][k_]:=((2(2\[Pi] I)(-1)^k q^(-(1/2) (1+k)^2)*\[Eta]\[Eta][q]^2 Ign[g,1]//EisensteinToTheta//FlipSignAll\[ScriptB])/.{\[ScriptB][1]->\[ScriptB][1]+(k+1) \[Tau]/2}//qShift//Simplify//MakeTheta//SeriesCoefficient[#,{\[ScriptB][1],0,-1}]&)/.{\[Tau]->1/(2\[Pi] I) Log[q]}//MakeAbstract//simplify;

IgnUnflavored[g_,0]:=Ign[g,0]
IgnUnflavored[g_,n_?OddQ]:=IgnUnflavored[g,n]=Ign[g,n]/.{\[ScriptB][i_]:>\[ScriptB][1]}//EisensteinToTheta//FlipSignAll\[ScriptB]//MakeTheta//SeriesCoefficient[#,{\[ScriptB][1],0,0}]&//MakeAbstract//simplify//Expand

IgnUnflavored[g_,n_?EvenQ]:=IgnUnflavored[g,n]=Ign[g,n]/.{\[ScriptB][i_/;i>1]:>\[ScriptB][2]}//EisensteinToTheta//FlipSignAll\[ScriptB]//MakeTheta//SeriesCoefficient[#,{\[ScriptB][1],0,0}]&//SeriesCoefficient[#,{\[ScriptB][2],0,0}]&//MakeAbstract//simplify//Expand



ItgnUnflavored[g_,0][k_]:=Itgn[g,0][k]
ItgnUnflavored[g_,n_?OddQ][k_]:=ItgnUnflavored[g,n][k]=Itgn[g,n][k]/.{\[ScriptB][i_]:>\[ScriptB][1]}//EisensteinToTheta//FlipSignAll\[ScriptB]//MakeTheta//SeriesCoefficient[#,{\[ScriptB][1],0,0}]&//MakeAbstract//simplify//Expand

ItgnUnflavored[g_,n_?EvenQ][k_]:=ItgnUnflavored[g,n][k]=Itgn[g,n][k]/.{\[ScriptB][i_/;i>1]:>\[ScriptB][2]}//EisensteinToTheta//FlipSignAll\[ScriptB]//MakeTheta//SeriesCoefficient[#,{\[ScriptB][1],0,0}]&//SeriesCoefficient[#,{\[ScriptB][2],0,0}]&//MakeAbstract//simplify//Expand


