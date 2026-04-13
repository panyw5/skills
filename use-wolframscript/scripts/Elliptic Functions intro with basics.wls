#!/usr/bin/env wolframscript
(* ::Package:: *)

(* ::Input:: *)
(*SetOptions[EvaluationNotebook[],Background->RGBColor[0,0,0]]*)


(* ::Input::Initialization:: *)
(* <<<< make background white >>>> *)
SetOptions[EvaluationNotebook[],Background->RGBColor[0,0,0]]


(* ::Input::Initialization:: *)
(* load Elliptic Functions package *)
SetDirectory[NotebookDirectory[]];
Import["Elliptic Functions.m"]


(* ::Title:: *)
(*Mathematica basics*)


(* ::Chapter::Closed:: *)
(*syntax and shortcuts*)


(* ::Input:: *)
(*{a,b}[1]*)
(*1[x]*)


(* ::Input:: *)
(*Sin[{{a},b}]*)
(*Tan[{{a},b}]*)
(*{{a},b}^3*)
(*Sqrt[{{a},b}]*)
(*1/{{a},b}*)


(* ::Input:: *)
(*{a,b}*)
(*%//Head*)


(* ::Subsection:: *)
(*variables*)


(* ::Input:: *)
(*a(* Mathematica \:53d8\:91cf\:4e0d\:9700\:8981\:4e8b\:5148\:58f0\:660e\:6216\:5b9a\:4e49\:ff0c\:6b64\:65f6\:90fd\:662f\:7b26\:53f7 Symbol *)*)
(*a//Head*)


(* ::Input:: *)
(*f[0](* \:51fd\:6570\:4e5f\:53ef\:4ee5\:672a\:7ecf\:5b9a\:4e49\:76f4\:63a5\:8c03\:7528 *)*)
(*f[x](* \:51fd\:6570\:4e5f\:53ef\:4ee5\:672a\:7ecf\:5b9a\:4e49\:76f4\:63a5\:8c03\:7528 *)*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(*V={a,b,c,d};*)
(*V[[1]]*)
(**)
(*V=Table[a[i,j]b^i c^j,{i,4},{j,4}](* \:7528 Table \:751f\:6210\:591a\:7ef4\:5217\:8868 *)*)
(*%//MatrixForm (* % \:6307\:4ee3\:4e0a\:4e00\:4e2a\:547d\:4ee4\:7684\:7ed3\:679c *)*)


(* ::Input:: *)
(*Clear[V]*)
(*V[[1]](* \:5217\:8868\:5143\:7d20\:4e0d\:80fd\:672a\:7ecf\:5b9a\:4e49\:8c03\:7528 *)*)
(*Length[V]*)


(* ::Input:: *)
(*\[Lambda] IdentityMatrix[4]//Inverse*)
(*Det[\[Lambda] IdentityMatrix[4]]*)


(* ::Input:: *)
(**)


(* ::Subsection::Closed:: *)
(*List creation*)


(* ::Input:: *)
(*Array[ff,{3}]*)
(*Array[ff,{2,2}]*)
(*Table[ff[i,j],{i,2},{j,2}]*)
(*Range[10]*)
(*Range[2,11]*)


(* ::Input:: *)
(*ConstantArray[a,{2,2}]*)


(* ::Input:: *)
(*IdentityMatrix[5]*)
(*SparseArray[{*)
(*{i_,j_}:>1/;j==i+1,*)
(*{i_,i_}:>\[Lambda]*)
(*},*)
(*{4,4}]//MatrixForm*)


(* ::Input:: *)
(*\[Sigma]={({*)
(* {0, 1},*)
(* {1, 0}*)
(*}),({*)
(* {0, -I},*)
(* {I, 0}*)
(*}),({*)
(* {1, 0},*)
(* {0, -1}*)
(*})};*)
(*ArrayFlatten[({*)
(* {\[Sigma][[1]], 0},*)
(* {0, \[Sigma][[3]]}*)
(*})]//MatrixForm*)


(* ::Input:: *)
(*Clear[f];*)
(*f[i_]:=Table[aa[i],{i,4}]*)


(* ::Subsection::Closed:: *)
(*Matrix operation*)


(* ::Input:: *)
(*M=({*)
(* {a, b},*)
(* {c, d}*)
(*});*)
(*M . M*)
(*M//Det*)
(*M//Inverse*)
(*M//Eigenvalues*)
(*M//Eigenvectors*)
(*M//Eigensystem*)


(* ::Input:: *)
(*M . ((M//Eigenvectors)[[1]])-(M//Eigenvalues)[[1]](M//Eigenvectors)[[1]]//Simplify*)


(* ::Input:: *)
(*MatrixExp[-I \[Pi] \[Sigma][[3]]]//Simplify*)


(* ::Input:: *)
(*-I E^((\[Pi] I \[Tau])/4) (E^(\[Pi] I u)-E^(-\[Pi] I u))Product[(1-E^(2\[Pi] I k \[Tau]))(1-E^(2\[Pi] I(k \[Tau]+u)))(1-E^(2\[Pi] I(k \[Tau]-u))),{k,1,order}]/.{\[Tau]->1/(2\[Pi] I) Log[q]}//RemoveLog//qSeries//FullSimplify*)
(**)
(*\[Theta][1][u]//qSeries*)
(*%-%%//Simplify*)


(* ::Subsection:: *)
(*Function definitions and basics*)


(* ::Input:: *)
(*Clear[f];*)
(*(* Key point: \:4e0b\:5212\:7ebf\:ff0c:= \:53f7 *)*)
(*f[x_]:=x^2;*)
(*f[1]*)
(*f[2]*)
(*f[y]*)


(* ::Input:: *)
(*(* \:65e0\:6761\:4ef6\:91cd\:590d\:5b9a\:4e49 *)*)
(*Clear[f]*)
(*f[x_]:=x0;*)
(*f[x_]:=x1;*)
(*f[1] (*\:7b2c\:4e00\:884c\:5b9a\:4e49\:88ab\:7b2c\:4e8c\:884c\:7ed9 override \:4e86*)*)


(* ::Input:: *)
(*(* \:7279\:6b8a\:503c\:5b9a\:4e49 *)*)
(*Clear[f]*)
(*f[1]=3;*)
(*f[x]=Sin[x];*)
(*f[x_]:=x^2;*)
(**)
(*f[1]*)
(*f[x]*)


(* ::Input:: *)
(*(* \:4e24\:4e2a\:81ea\:53d8\:91cf *)*)
(*Clear[f];*)
(*f[x_,y_]:=x^2+y^3;*)
(*f[1](* \:65e0\:5b9a\:4e49 *)*)
(*f[a,b]*)
(*f[a,b,c](* \:65e0\:5b9a\:4e49 *)*)
(**)


(* ::Input:: *)
(*Clear[f];*)
(*(* \:4e00\:4e2a\:51fd\:6570\:53ef\:4ee5\:6709\:4e00\:4e2a\:81ea\:53d8\:91cf\:ff0c\:6216\:591a\:4e2a\:81ea\:53d8\:91cf\:ff0c\:4e0d\:540c\:60c5\:51b5 *)*)
(*(* \:51fd\:6570\:7684\:975e\:91cd\:590d\:8865\:5145\:5b9a\:4e49 *)*)
(**)
(*f[x_]:=x^2;*)
(*f[x_,y_]:=x^2/y^2;*)
(*f[1]*)
(*f[a,b]*)


(* ::Input:: *)
(*(* \:81f3\:5c11\:4e00\:4e2a\:53d8\:91cf *)*)
(*(* y \:4f5c\:4e3a Sequence (\:4e00\:79cd\:6570\:636e\:683c\:5f0f) \:8fdb\:5165 F *)*)
(*Clear[f];*)
(*f[x_,y__]:=a^x F[y];*)
(*f[x]*)
(*f[x,y]*)
(*f[x,y,z]*)


(* ::Input:: *)
(*Clear[f];*)
(*f[1]=0;*)
(*f[x_]:=x^2;*)
(*f[1]*)
(*f[x]*)
(*f[2]*)
(**)
(*f[Cos[\[Theta]]^2+Sin[\[Theta]]^2](* Mathematica \:4e0d\:8ba4\:5f97 Cos[\[Theta]]^2+Sin[\[Theta]]^2=1\:ff0c\:9ed8\:8ba4\:975e 1 *)*)
(*f[Cos[\[Theta]]^2+Sin[\[Theta]]^2//FullSimplify]*)


(* ::Subsection:: *)
(*Advanced Function definitions*)


(* ::Input:: *)
(*Clear[f,a]*)
(*f[x_/;x>3]:=a x^3;*)
(*f[x_/;x<=3]:=b x^2;*)
(*f[4]*)
(*f[2]*)
(*f[x](*Mathematica \:4e0d\:77e5\:9053 x \:7684\:4efb\:4f55\:4fe1\:606f\:ff0c\:4e0a\:9762\:5bf9\:6b64\:60c5\:51b5\:65e0\:5b9a\:4e49 *)*)


(* ::Input:: *)
(*Clear[f,a]*)
(*f[x_/;x>3]:=a x^3;*)
(*f[x_/;x<=3]:=b x^2;*)
(*f[x_]:=1/x*)
(*f[4]*)
(*f[2]*)
(*f[x](*Mathematica \:4e0d\:77e5\:9053 x \:7684\:4efb\:4f55\:4fe1\:606f\:ff0c\:56e0\:6b64\:91c7\:7528\:6700\:540e\:4e00\:6761 f[x] \:7684\:5b9a\:4e49 *)*)


(* ::Input:: *)
(*Clear[f,a]*)
(*f[x_]:=1/x;(* \:65e0\:7ea6\:675f\:60c5\:51b5\:7684\:5b9a\:4e49\:53ef\:4ee5\:653e\:5f00\:5934\:6216\:7ed3\:5c3e\:5747\:53ef *)*)
(*f[x_/;x>3]:=a x^3;*)
(*f[x_/;x<=3]:=b x^2;*)
(**)
(*f[4]*)
(*f[2]*)
(*f[x](*Mathematica \:4e0d\:77e5\:9053 x \:7684\:4efb\:4f55\:4fe1\:606f\:ff0c\:56e0\:6b64\:91c7\:7528\:7b2c\:4e00\:6761 f[x] \:7684\:5b9a\:4e49 *)*)
(**)


(* ::Input:: *)
(*Clear[f,a]*)
(*f[x_/;x>3]:=a x^3;*)
(*f[x_/;x>5]:=1/x;*)
(*f[x_/;x<=3]:=b x^2;*)
(**)
(*f[6](* \:82e5\:6761\:4ef6\:4e4b\:95f4\:6709\:91cd\:53e0\:60c5\:51b5\:ff0c\:5219\:5148\:5b9a\:4e49\:7684\:4f18\:5148\:8c03\:7528 *)*)


(* ::Input:: *)
(*Clear[f,a]*)
(*f[x_/;x>5]:=1/x;*)
(*f[x_/;x>3]:=a x^3;*)
(*f[x_/;x<=3]:=b x^2;*)
(**)
(*f[6](* \:82e5\:6761\:4ef6\:4e4b\:95f4\:6709\:91cd\:53e0\:60c5\:51b5\:ff0c\:5219 \:5148\:5b9a\:4e49 \:7684\:4f18\:5148\:8c03\:7528 *)*)
(*(* \:8fd9\:4e2a\:8ddf\:65e0\:6761\:4ef6\:91cd\:590d\:5b9a\:4e49\:51fd\:6570 \:521a\:597d\:76f8\:53cd *)*)


(* ::Input:: *)
(*Clear[f];*)
(*f[x_][y_]:=x^2;*)
(*f[a][b]*)
(*f[a,b](* f[a,b] \:672a\:5b9a\:4e49 *)*)


(* ::Input:: *)
(*Clear[Com]*)
(*Com[a[p_],SuperDagger[a][q_]]:=(2\[Pi])^3 \[Delta][p-q]*)
(*Com[a[p],SuperDagger[a][k]]*)


(* ::Input:: *)
(*Clear[f];*)
(*f[g[x_]][y_]:=x^2 y^g[z];(* \:51fd\:6570\:5b9a\:4e49\:5f0f\:5de6\:8fb9\:53ef\:4ee5\:4f7f\:7528 pattern\:ff0c\:5373\:51fd\:6570\:7684\:5b9a\:4e49\:6837\:5f0f\:53ef\:4ee5\:975e\:5e38\:4e30\:5bcc\:ff0c\:975e\:5e38\:7075\:6d3b\:ff0cMathematica \:4e5f\:4f1a\:81ea\:52a8\:63d0\:53d6\:76f8\:5e94\:7684\:5143\:7d20\:5e76\:5728\:53f3\:8fb9\:8c03\:7528 *)*)
(*f[E^x_,E^y_]:=E^(f[x]/f[y])*)
(**)
(*f[a][b](* \:8ba4\:4e0d\:51fa *)*)
(*f[g[a]][b]*)
(*f[g[a,b]][u](* \:8ba4\:4e0d\:51fa *)*)
(**)
(*f[E^x,E^\[Lambda][y]]*)
(*f[E^x,E^(2y)]*)


(* ::Input:: *)
(*Clear[f];*)
(*f[Op[{E^x_,E^y_}]]:=G[x,y]E^x E^y*)
(*f[Op[{E^X[z],E^X[w]}]]*)
(**)
(*f[{E^X[z],E^X[w]}](* \:6ca1\:6709 Op\:ff0c\:8ba4\:4e0d\:51fa*)*)


(* ::Input:: *)
(*Clear[f];*)
(*f[Op[{E^field1_[z_],E^field2_[w_]}]]:=TwoPt[field1[z],field2[w]]g[z,w]E^field1[z] E^field2[w]*)
(*f[Op[{E^X1[zz],E^X2[ww]}]]*)
(**)
(*f[Op[{E^X,E^Y}]](* \:6307\:6570\:4e0a \:6ca1\:6709 field[x] \:7ed3\:6784\:ff0c\:8ba4\:4e0d\:51fa*)*)


(* ::Input:: *)
(*Clear[f,a]*)
(*f[x_,y_]:=Module[{a,b,c,d}(* \:6307\:5b9a\:5c40\:90e8\:53d8\:91cf *),*)
(*a=x^2;*)
(*b=x^y;*)
(*c=1000;*)
(*d=(a b)/c(*\:6700\:540e\:4e00\:884c\:6ca1\:6709\:5206\:53f7\:ff0c\:8868\:793a\:8f93\:51fa*)*)
(*]*)
(*a=3;*)
(*f[x,y](* Module \:91cc\:9762\:7684 a \:4e0d\:53d7 Module \:5916\:7684\:4e3b\:7a0b\:5e8f\:4e2d\:7684 a \:503c\:5f71\:54cd *)*)
(**)
(*Clear[f,a]*)
(*f[x_,y_]:=Module[{a,b,c,d},*)
(*Print[a];(* Print \:5e38\:7528\:4e8eDebug *)*)
(*a=x^2;*)
(*b=x^y;*)
(*c=1000;*)
(*d=(a b)/c*)
(*]*)
(*a=3;*)
(*f[x,y](* Module \:91cc\:9762\:7684 a \:4e0d\:53d7 Module \:5916\:7684\:4e3b\:7a0b\:5e8f\:4e2d\:7684 a \:503c\:5f71\:54cd; Module \:91cc\:9762\:7684 a \:662f\:4e34\:65f6\:53d8\:91cf\:ff0c\:6709\:4e34\:65f6\:52a0\:7684\:968f\:673a\:540e\:7f00 *)*)
(**)


(* ::Input:: *)
(*Clear[f,a]*)
(*f[x_,y_]:=Module[{b,c,d},*)
(*a*)
(*]*)
(*a=3;*)
(*f[x,y](* Module \:91cc\:9762\:6ca1\:6709\:6307\:5b9a\:5c40\:90e8\:53d8\:91cf a\:ff0c\:56e0\:6b64\:76f4\:63a5\:8c03\:7528\:4e3b\:7a0b\:5e8f\:4e2d\:7684\:6574\:4f53\:53d8\:91cf a *)*)
(**)
(**)
(*Clear[f,a]*)
(*f[x_,y_]:=Module[{b,c,d},*)
(*a*)
(*]*)
(*f[x,y](* Module \:91cc\:9762\:6ca1\:6709\:6307\:5b9a\:5c40\:90e8\:53d8\:91cf a\:ff0c\:56e0\:6b64\:76f4\:63a5\:8c03\:7528\:4e3b\:7a0b\:5e8f\:4e2d\:7684\:6574\:4f53\:53d8\:91cf a\:ff0c\:76ee\:524d\:662f\:672a\:8d4b\:503c\:7684\:7b26\:53f7 *)*)
(**)


(* ::Input:: *)
(*Clear[f]*)
(*f[x]*)
(*f@x(* @ \:7b97\:7b26\:76f8\:5f53\:4e8e\[OpenCurlyDoubleQuote]\:4f5c\:7528\[CloseCurlyDoubleQuote]\:7b97\:7b26 *)*)
(*f@{x}*)
(*f@{x,y}*)
(*f@@{x,y} (* @@ \:662f\:5bf9 level-one \:7684\:4f5c\:7528\:7b97\:7b26\:ff0c\:5148\:62c6\:89e3\:7b2c\:4e00\:5c42 {} *)*)
(*f@@{{x,y},{z,w}}*)
(**)
(*g@f@x(* \:53ef\:4ee5\:51cf\:5c11\:5d4c\:5957 *)*)
(**)
(**)
(*Plus[x,y,z,w]*)
(*Plus@@{x,y,z,w}*)
(**)
(*Times[x,y,z,w]*)
(*Times@@{x,y,z,w}*)


(* ::Input:: *)
(*Clear[f];*)
(*f[x_/;x>3]:=x^a;*)
(*f[4]*)
(*4//f(* \:51fd\:6570\:4f5c\:7528\:540e\:7f6e\:ff0c\:5176\:4e2d f \:53ea\:9700\:8981\:4e00\:4e2a\:81ea\:53d8\:91cf *)*)


(* ::Input:: *)
(*Clear[f];*)
(*f[x_/;x>3,y_]:=x^a y;*)
(*4//f(* \:7531\:4e8e f \:9700\:8981\:4e24\:4e2a\:53d8\:91cf\:ff0c\:540e\:7f6e\:5931\:6548 *)*)
(*4//f[#,y]&(* \:53ef\:4ee5\:7528 # \:6765\:6307\:4ee3 \:5f85\:690d\:5165 \:7684\:7269\:4f53\:ff0c\:7528 & \:4f5c\:7ed3\:5c3e\:ff0c\:5b9a\:4e49\:4e34\:65f6\:51fd\:6570 *)*)
(**)
(*(f[#,y]&)[x]*)
(*f[x,y] (* f[#,y]& \:7684\:786e\:5b9a\:4e49\:4e86\:4e00\:4e2a\:65b0\:7684\:51fd\:6570\:ff0c\:8fd9\:4e2a\:51fd\:6570\:5df2\:7ecf\:4e8b\:5148\:8bbe\:597d\:7b2c\:4e8c\:4e2a\:53d8\:91cf y\:ff0c *)*)
(**)
(**)
(*(f[#,y]&)[4]*)
(*f[4,y] (* f[#,y]& \:7684\:786e\:5b9a\:4e49\:4e86\:4e00\:4e2a\:65b0\:7684\:51fd\:6570\:ff0c\:8fd9\:4e2a\:51fd\:6570\:5df2\:7ecf\:4e8b\:5148\:8bbe\:597d\:7b2c\:4e8c\:4e2a\:53d8\:91cf y\:ff0c *)*)


(* ::Input:: *)
(*(f[#1,#2,y]&)[z,w]*)
(*(f[#1,#2,#3,y]&)[z,w,p]*)
(*(f[#1,#2,#4,y]&)[z,w,p](* \:4e0d\:80fd\:8df3\:8fc7 #3 *)*)


(* ::Chapter:: *)
(*replacement rules*)


(* ::Subsection::Closed:: *)
(*simple replacement*)


(* ::Input:: *)
(*x^2+y^2/.{x->3}*)
(*x^2+y^2/.{x^2->x2}*)
(*x^2 z^2+y^2/.{x^2->x2}*)
(*x^2 z^2+y^3/.{x^2 z^2->x2 z2}*)
(*x^2+y^2+z^2/.{x^2+y^2->1}*)
(*1/(4\[Pi]^2 x^2)+y^2+z^2/.{1/(4\[Pi]^2 x^2)->4}*)


(* ::Input:: *)
(*x^4+y^4+z^4/.{x^2->x2} (* \:6ca1\:6709\:663e\:5f0f\:7684 x^2 *)*)
(*x^4+1/(3+x^6)+y^4+z^4/.{x->Sqrt[x2]}*)


(* ::Subsection::Closed:: *)
(*Pattern matching and replacement*)


(* ::Input:: *)
(*Clear[x,\[Gamma],y]*)
(*x+\[Gamma][k]+\[Gamma][l]+\[Gamma][p]+y/.{\[Gamma]:>\[CapitalGamma]}(* \:51fd\:6570\:540d\:53ef\:4ee5\:88ab\:66ff\:6362 *)*)
(*x+\[Gamma][k]+\[Gamma][l]+\[Gamma][p]+y/.{\[Gamma][k_]:>\[CapitalGamma][k]} (* \:8bc6\:522b\:7ed3\:6784 \[Gamma][k_]\:ff0c\:5e76\:4f5c\:66ff\:6362\:ff0c\:5e76\:4e14\:4fdd\:6301\:8ffd\:8e2a\:81ea\:53d8\:91cf k *)*)
(*x+\[Gamma][k]+\[Gamma][l]+\[Gamma][p,l]+y/.{\[Gamma][k_]:>\[CapitalGamma][k]} (* \[Gamma][k_] \:53ea\:8bc6\:522b\:542b\:5355\:4e00\:53d8\:91cf\:7684 \[Gamma] *)*)
(**)
(*x+\[Gamma][1]+\[Gamma][2]+\[Gamma][3]+y/.{\[Gamma][k_/;k>2]:>\[CapitalGamma][k]} (* \:8bc6\:522b\:7ed3\:6784\:65f6\:8fd8\:53ef\:4ee5\:52a0\:7504\:522b\:6761\:4ef6 *)*)
(*x+\[Gamma][1]+\[Gamma][2]+\[Gamma][3]+y/.{\[Gamma][k_/;k>2]:>a^k} (* \:8bc6\:522b\:7ed3\:6784\:65f6\:8fd8\:53ef\:4ee5\:52a0\:7504\:522b\:6761\:4ef6 *)*)
(**)
(*x^a y^b+x^(2a) y^b/.{x^m_ y^n_:>m^x n^y}*)
(*x y^b+x^(2a) y^b/.{x^m_ y^n_:>m^x n^y}(* x y^b \:4e2d x \:6ca1\:6709\:5e42\:6b21\:ff0c\:5bf9\:4e0d\:4e0a x^m_y^n_ \:7ed3\:6784 *)*)
(*x y^b+x^(2a) y^b/.{x^m_ y^n_:>m^x n^y,x y^n_:>one^x n^y}*)


(* ::Input:: *)
(**)


(* ::Input:: *)
(**)
(*E^(p[1]+p[2])/(\[Gamma][p[1]]\[Gamma][p[2]])+E^(p[1]+2 q[2])/(\[Gamma][p[1]]\[Gamma][p[2]]^2) \[Gamma][p[3]]+\[Gamma][p[3]]/.{1/(\[Gamma][pp_]\[Gamma][qq_])}*)


(* ::Input:: *)
(*\[Delta][k-p]g[k]/.{\[Delta][k-PP_]x_:>(x/.k->PP)}*)
(*\[Delta][k1-p1]\[Delta][k2-p2]g[k1,k2]/.{\[Delta][k_-p_]x_:>(x/.k->p)}*)
(*\[Delta][k1-p1]\[Delta][k2-p2]g[k1,k2]/.{\[Delta][k_-p_]x_:>(x/.k->p)}/.{\[Delta][k_-p_]x_:>(x/.k->p)}*)
(**)
(*\[Delta][k1-p1]\[Delta][k2-p2]g[k1,k2]/.{\[Delta][k_-p_]x_:>(x/.k->p)}/.{\[Delta][k_-p_]x_:>(x/.k->p)}/.{\[Delta][k_-p_]x_:>(x/.k->p)}*)
(**)
(**)
(**)
(*\[Delta][k1-p1]\[Delta][k2-p2]g[k1,k2]//.{\[Delta][k_-p_]x_:>(x/.k->p)}(* \:91cd\:590d\:4f5c\:540c\:4e00\:4e2a\:66ff\:6362\:ff0c\:76f4\:5230\:7ed3\:679c\:7a33\:5b9a\:4e0b\:6765 *)*)


(* ::Chapter:: *)
(*functions and temporary functions*)


(* ::Title::Closed:: *)
(*Elliptic functions*)


(* ::Input:: *)
(*order=5;*)
(*expression=a[1]q^(1/2)+(a[2]+3a[3])q^(1/2+1/2)+(a[3]-1)q^(3/2)*)
(*SolveqSeries[expression,{}][order]*)
(*SolveqSeries[expression,Array[a,10]][order]*)


(* ::Input:: *)
(*(\[CurlyTheta]ppp[1][1/2,q]//qShift)*)
(*(\[CurlyTheta]ppp[1][z+1/2+5/6 \[Tau],q]//qShift//Simplify)/.{\[Tau]->1/(2\[Pi] I) Log[q]}//makeqSeries*)


(* ::Input:: *)
(*(\[CurlyTheta]ppp[1][z+w,q]/\[CurlyTheta]p[1][a-b,q]//STransForm//SDualFrame//PowerExpand//simplify//Simplify)//FlipSign[#][a]&*)
(*(\[CurlyTheta]ppp[4][z+w,q]/\[CurlyTheta]p[4][a-b,q]//TTransForm//PowerExpand//simplify//Simplify)//FlipSign[#][a]&*)


(* ::Input:: *)
(*(* \[Theta][i][z,q] are the Jacobi-theta functions (using the built-in EllipticTheta ) *)*)
(*(* Note that \[Theta] can be inputted by typing [ESC]theta[ESC] *)*)
(*\[Theta][1][z,q]*)
(*\[Theta][4][z,q]*)
(*Print["----------"];*)
(*(* z-derivatives of \[Theta][i][z,q] *)*)
(*\[Theta]p[1][z,q]*)
(*D[\[Theta][1][z,q],z]==\[Theta]p[1][z,q]//Simplify*)
(*\[Theta]pp[1][z,q]  *)
(*D[\[Theta][1][z,q],{z,2}]==\[Theta]pp[1][z,q]//Simplify*)
(*\[Theta]ppp[1][z,q]*)


(* ::Input:: *)
(*(* \[CurlyTheta]: abstract symbol for theta functions and their derivatives *)*)
(*(* \[CurlyTheta] can be inputed by typing [ESC]cq[ESC] *)*)
(*(* !!! Note that \[CurlyTheta] is NOT equal to \[Theta].*)*)
(**)
(*\[CurlyTheta][1][z,q]*)
(*\[CurlyTheta]p[1][z,q] (* represents \!\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]\(\(\[CurlyTheta][1]\)[z, q]\)\) *)*)
(*\[CurlyTheta]pp[1][z,q] (* represents \!\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]\(\[CurlyTheta][1]\)[z, q]\)\), the 2nd derivative with respect to z *)*)
(*\[CurlyTheta]ppp[1][z,q] (* 3rd derivative *)*)
(*Print["--------"];*)
(*(* calls the built-in EllipticTheta functions and their derivatives *)*)
(*\[Theta][1][z,q]*)
(*\[Theta]p[1][z,q] (* represents \!\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]\(\(\[Theta][1]\)[z, q]\)\) *)*)
(*\[Theta]pp[1][z,q] (* represents \!\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]\(\[Theta][1]\)[z, q]\)\) *)*)
(**)


(* ::Input:: *)
(*(* Going between \[CurlyTheta] and \[Theta] notation *)*)
(*\[Theta]pppp[4][z,q]//MakeAbstract*)
(*\[CurlyTheta]pppp[4][z,q]//MakeTheta*)
(*\[CurlyTheta]pppp[4][z,q]/\[CurlyTheta]pp[1][w,q]//MakeTheta//MakeAbstract*)


(* ::Input:: *)
(*D[\[Theta][1][z,q],{q,3}]//D\[Tau]ToDz//Simplify*)


(* ::Input:: *)
(*D[\[Theta][1][z,q],q]*)
(*D[\[Theta][1][z,q],q]//MakeAbstract*)
(*D[\[Theta][1][z,q],{q,2}]//MakeAbstract*)
(*D[\[Theta][1][z,q],q]//D\[Tau]ToDz//makeAbstract (* Apply identity \!\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(q\)]\( *)
(*\(\*SubscriptBox[\(\[Theta]\), \(i\)]\)[z, q]\)\)+1/(8\[Pi]^2)\!\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]*)
(*\(\*SubscriptBox[\(\[Theta]\), \(i\)]\)[z, q]\)\) *)*)
(*D[\[Theta][1][z,q],{q,2}]//D\[Tau]ToDz//makeAbstract //Expand(* Apply identity \!\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(q\)]\( *)
(*\(\*SubscriptBox[\(\[Theta]\), \(i\)]\)[z, q]\)\)+1/(8\[Pi]^2)\!\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]\( *)
(*\*SubscriptBox[\(\[PartialD]\), \(z\)]*)
(*\(\*SubscriptBox[\(\[Theta]\), \(i\)]\)[z, q]\)\) *)*)
(**)


(* ::Input:: *)
(*(* qShift: perform half and full period shifts for \[CurlyTheta] functions *)*)
(*\[CurlyTheta][1][z+3,q]//qShift*)
(*\[CurlyTheta][4][z+3\[Tau],q]//qShift*)
(*\[CurlyTheta][4][z+1/2 \[Tau],q]//qShift*)


(* ::Input:: *)
(*(* turns the built-in function into shorter abstract symbol for easy reading *)*)
(*\[Theta][2][z,q]//makeAbstract*)
(**)
(*(* controls the order of series expansion *)*)
(*order=2;*)
(**)
(*(* makeqSeries turns abstract symbols of \[CurlyTheta][i][z,q] into q-series *)*)
(*\[Theta][1][z,q]//makeAbstract//makeqSeries*)
(*\[Theta][1][z,q]/\[Theta][2][z+\[Pi],q]//makeAbstract//makeqSeries*)
(*\[Theta][1][z,q]/\[Theta][2][z+\[Pi],q]//makeAbstract//makeqSeries//qSeries//Simplify*)
(*\[Theta][1][z,q]/\[Theta][2][z,q]/.{z->1/(2\[Pi] I) Log[Z]}//makeAbstract//makeqSeries//RemoveLog//qSeries//Simplify*)
(*(\[Theta][1][z,q]/\[Theta][2][z+\[Tau],q]//qShift)/.{z->1/(2\[Pi] I) Log[Z],\[Tau]->1/(2\[Pi] I) Log[q]}//makeAbstract//makeqSeries//RemoveLog//qSeries//Simplify*)


(* ::Input:: *)
(*(* turns q-derivative (or equivalently, \[Tau] derivative) into double z-derivative *)*)
(*q D[\[Theta]p[1][z,q],q]//makeAbstract*)
(*q D[\[Theta]p[1][z,q],q]//D\[Tau]ToDz//makeAbstract*)
(**)
(*q D[\[Theta]p[1][z,q],{q,2}]//makeAbstract//Expand*)
(*q D[\[Theta]p[1][z,q],{q,2}]//D\[Tau]ToDz//makeAbstract//Expand*)


(* ::Input:: *)
(*(* simplify some simple \[Theta] functions using symmetry *)*)
(*\[Theta][1][0,q]//simplify*)
(*\[Theta]p[4][0,q]//simplify*)
(**)
(*(* expand in the z variable *)*)
(*D[\[Theta][1][z,q]/\[Theta][4][z+a,q],z]//Series[#,{z,0,2}]&//makeAbstract//simplify//FullSimplify*)
(*D[\[Theta][1][z,q]/\[Theta][4][z+a,q],z]//SeriesCoefficient[#,{z,0,0}]&//makeAbstract//simplify//FullSimplify*)
(*%//makeqSeries//qSeries*)


(* ::Input:: *)
(*(* Flip the signs of arguments of \[CurlyTheta] functions *)*)
(**)
(*\[CurlyTheta][1][-z,q]//FlipSign[#][z]&*)
(*\[CurlyTheta][4][-z+c,q]//FlipSign[#][z]&*)
(**)
(*\[Theta][4][-z+c,q]//makeAbstract//FlipSign[#][z]&*)


(* ::Input:: *)
(*(* perform full-period and half-period shifts for \[CurlyTheta] functions *)*)
(**)
(*\[CurlyTheta][1][z+(5\[Tau])/6+5/4,q]//qShift*)
(*\[CurlyTheta]pp[1][z+(5\[Tau])/6+5/4,q]//qShift*)
(*\[CurlyTheta]ppp[4][z+(5\[Tau])/7+7/4,q]//qShift*)


(* ::Input:: *)
(*(* Eisenstein series *)*)
(*E2[q]*)
(*Ei[2][q]*)
(*Ei[4][q]*)
(*E4[q]*)
(*Ei[8][q]*)
(*Ei[14][q]*)
(**)
(*(* twisted Eisenstein series *)*)
(*EE[1][{*)
(* {-1},*)
(* {\[Theta]}*)
(*}][q]*)
(*EE[2][{*)
(* {-1},*)
(* {\[Theta]}*)
(*}][q]*)
(*EE[2][{*)
(* {1},*)
(* {\[Theta]}*)
(*}][q]*)
(*EE[4][{*)
(* {-1},*)
(* {\[Theta]}*)
(*}][q]*)


(* ::Input:: *)
(*(* Translate Eisenstein series to Jacobi-theta *)*)
(**)
(*EEE[1][{*)
(* {1},*)
(* {z}*)
(*}][q]//EisensteinToTheta*)
(*EEE[4][{*)
(* {-1},*)
(* {E^(2\[Pi] I \[ScriptB])}*)
(*}][q]//EisensteinToTheta*)
(*%//makeqSeries//Simplify*)


(* ::Input:: *)
(*\[Eta][q]//makeAbstract//makeqSeries//qSeries*)
(*\[WeierstrassP][\[ScriptZ],q]//D\[Tau]ToDz//makeAbstract//makeqSeries//qSeries//Simplify*)
(*\[Zeta][\[ScriptZ],q]//makeAbstract//makeqSeries//qSeries//Simplify*)
(*D[\[Zeta][\[ScriptZ],q],z]+\[WeierstrassP][\[ScriptZ],q]//D\[Tau]ToDz//makeAbstract//makeqSeries//qSeries//Simplify*)


(* ::Input:: *)
(*(* "contour-integral" of elliptic functions *)*)
(*integrand=\[CurlyTheta][1][2\[ScriptA],q]^2/(2\[CurlyTheta][4][2\[ScriptA]+\[ScriptB],q]\[CurlyTheta][4][-2\[ScriptA]+\[ScriptB],q]);(* check that integrand is elliptic (doubly periodic) with respect to \[ScriptA] *)*)
(*(integrand/.\[ScriptA]->\[ScriptA]+\[Tau])/integrand//qShift//Simplify*)
(*(integrand/.\[ScriptA]->\[ScriptA]+1)/integrand//qShift//Simplify*)
(*(* contour integral of integrand *)*)
(*integrand/.{\[ScriptA]->1/(2\[Pi] I) Log[a],\[ScriptB]->1/(2\[Pi] I) Log[b]}//makeqSeries//Simplify//Normal//SeriesCoefficient[#,{a,0,0}]&//qSeries//Simplify*)



