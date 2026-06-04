(* simplify.wls - Lie algebra simplification rules and contraction helpers *)

Clear[simplifyLieAlgebra]
simplifyLieAlgebra[exp_]:=exp//.{
KK[aa_,bb_]KKD[cc_,dd_]:>\[Delta]@@Complement[Union[{aa,bb},{cc,dd}],Intersection[{aa,bb},{cc,dd}]]/;Length[Intersection[{aa,bb},{cc,dd}]]==1,

KK[a_,b_]KKD[c_,d_]:>dimg/;Length[Intersection[{a,b},{c,d}]]==2,

\[Delta][a_,b_]x_:>(x/.{a->b})/;(!TrueQ[D[x,a]==0]),
\[Delta][a_,b_]x_:>(x/.{b->a})/;(!TrueQ[D[x,b]==0]),

\[Delta][a_,a_]:>dimg,
\[Delta][a_,b_]\[Delta][c_,d_]:>dimg/;(Intersection[{a,b},{c,d}]//Length)==2,
\[Delta][a_,b_]^2:>dimg,


KK[aa_,bb_]f[ii___][jj___]:>KfContraction[KK[aa,bb],f[ii][jj]]/;Length[Intersection[{aa,bb},{jj}]]>=1,
KKD[aa_,bb_]f[ii___][jj___]:>KfContraction[KKD[aa,bb],f[ii][jj]]/;Length[Intersection[{aa,bb},{ii}]]>=1,

f[a_,b_][c_]:>0/;Length[Intersection[{a,b},{c}]]>0,
f[a_][b_,c_]:>0/;Length[Intersection[{a},{b,c}]]>0,

f[dd_,ee_,ff_][]:>Signature[{dd,ee,ff}](f@@Sort[{dd,ee,ff}])[]/;!TrueQ[{dd,ee,ff}==Sort[{dd,ee,ff}]],
f[][dd_,ee_,ff_]:>Signature[{dd,ee,ff}](f[]@@Sort[{dd,ee,ff}])/;!TrueQ[{dd,ee,ff}==Sort[{dd,ee,ff}]],

f[i___][j___]f[k___][l___]:>ffContraction[f[i][j],f[k][l]]/;Length[Intersection[{i}~Join~{j},{k}~Join~{l}]]==2,

f[i___][j___]f[k___][l___]:>ffContraction[f[i][j],f[k][l]]/;Length[Intersection[{i}~Join~{j},{k}~Join~{l}]]==3,


f[i1___][j1___]f[i2___][j2___]f[i3___][j3___]:>fffContraction[f[i1][j1],f[i2][j2],f[i3][j3]]/; Length[Intersection[{i1}~Join~{j1},{i2}~Join~{j2}]]==1&&Length[Intersection[{i3}~Join~{j3},{i2}~Join~{j2}]]==1&&Length[Intersection[{i1}~Join~{j1},{i3}~Join~{j3}]]==1,


f[a_][b_,c_]NNO[J[b_],J[c_]]:>I hcheck Derivative[1][J[a]],
f[a_][b_,c_]NNO[J[c_],J[b_]]:>-I hcheck Derivative[1][J[a]],

f[][d_,e_,f_]NNO[J[a_],NNO[J[b_],J[c_]]]:>Signature[{d,e,f}]Signature[{a,b,c}](I hcheck KKD[cc,dd]NNO[Derivative[1][J[dd]],J[cc]]/.{cc->c[RandomInteger[10000]],dd->d[RandomInteger[10000]]})/;Length[Intersection[{d,e,f},{a,b,c}]]==3

};

Clear[ffContraction]

(* full contraction of ff *)
ffContraction[f[i___][j___],f[k___][l___]]:=Module[{},
Signature[{i}~Join~{j}]Signature[{k}~Join~{l}]2hcheck  dimg
]/;Length[Intersection[{i}~Join~{j},{k}~Join~{l}]]==3;


KfContraction[KK[a_,b_],f[i___][j___]]:=Module[{raised,raisedTo},
raised=Intersection[{a,b},{j}][[1]];
raisedTo=Complement[{a,b},{raised}][[1]];
Signature[{j}]Signature[{raised}~Join~Complement[{j},{raised}]]f[i,raisedTo]@@Complement[{j},{raised}]
];

KfContraction[KKD[a_,b_],f[i___][j___]]:=Module[{lowered,loweredTo},
lowered=Intersection[{a,b},{i}][[1]];
loweredTo=Complement[{a,b},{lowered}][[1]];
Signature[{i}]Signature[Complement[{i},{lowered}]~Join~{lowered}](f@@Complement[{i},{lowered}])@@({loweredTo}~Join~{j})
];


fffContraction[f[i1___][j1___],f[i2___][j2___],f[i3___][j3___]]:=Module[{up1,down1,up2,down2,up3,down3,remain1,remain2,remain3,
inter12,inter13,inter23,up,down
},
up1={i1};
down1={j1};
up2={i2};
down2={j2};
up3={i3};
down3={j3};
inter12=Intersection[{i1}~Join~{j1},{i2}~Join~{j2}];
inter13=Intersection[{i1}~Join~{j1},{i3}~Join~{j3}];
inter23=Intersection[{i2}~Join~{j2},{i3}~Join~{j3}];

remain1=Complement[up1~Join~down1,inter12~Join~inter13];
remain2=Complement[up2~Join~down2,inter12~Join~inter23];
remain3=Complement[up3~Join~down3,inter13~Join~inter23];

up={};
down={};
If[MemberQ[up1,remain1[[1]]],up=up~Join~remain1,down=down~Join~remain1];
If[MemberQ[up2,remain2[[1]]],up=up~Join~remain2,down=down~Join~remain2];
If[MemberQ[up3,remain3[[1]]],up=up~Join~remain3,down=down~Join~remain3];

Signature[up1~Join~down1]Signature[up2~Join~down2]Signature[up3~Join~down3]Signature[inter13~Join~inter12~Join~remain1]Signature[inter23~Join~remain2~Join~inter12]Signature[remain3~Join~inter13~Join~inter23]Signature[up~Join~down]Signature[remain1~Join~remain2~Join~remain3]*(-hcheck)(f@@up)@@down

]/; Length[Intersection[{i1}~Join~{j1},{i2}~Join~{j2}]]==1&&Length[Intersection[{i3}~Join~{j3},{i2}~Join~{j2}]]==1&&Length[Intersection[{i1}~Join~{j1},{i3}~Join~{j3}]]==1


(* partial contraction of ff *)
ffContraction[f[i___][j___],f[k___][l___]]:=Module[{up1,down1,up2,down2,intersection,remain1,remain2,$m},
up1={i};
down1={j};
up2={k};
down2={l};

intersection=Intersection[{i}~Join~{j},{k}~Join~{l}];
remain1=Complement[{i}~Join~{j},intersection][[1]];
remain2=Complement[{k}~Join~{l},intersection][[1]];
If[MemberQ[up1,remain1]&&MemberQ[up2,remain2],$m=KK[remain1,remain2]];
If[MemberQ[down1,remain1]&&MemberQ[down2,remain2],$m=KKD[remain1,remain2]];
If[MemberQ[up1,remain1]&&MemberQ[down2,remain2]||MemberQ[down1,remain1]&&MemberQ[up2,remain2],$m=\[Delta][remain1,remain2]];
2hcheck Signature[{i}~Join~{j}]Signature[{k}~Join~{l}]Signature[intersection~Join~{remain1}]Signature[intersection~Join~{remain2}]$m

]/;Length[Intersection[{i}~Join~{j},{k}~Join~{l}]]==2;
