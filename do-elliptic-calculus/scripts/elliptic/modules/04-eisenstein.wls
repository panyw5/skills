(* ====================================================================== *)
(* Eisenstein Series Definitions
(* Ei, E2, E4, EiTwisted, EE, Gi, E2Wolfger, E4Wolfger *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
(* Functions for dealing with Eisenstein series Subscript[E, k](\[Tau]) and Subscript[E, k][\[Phi]
\[Theta]

][q]; k is referred to as the modular weight *)
(* Ei[k][q], EE[k][\[ImplicitPlus]\[Phi]
\[Theta]

][q] are explicit q-series *)
(* EEi[k][q], EEE[k][\[ImplicitPlus]\[Phi]
\[Theta]

][q] are just symbols used for symbolic computations *)
(* EEi[k][q] and EEE[k][\[Phi]
\[Theta]

][q] are mapped to explicit q-series using the makeqSeries function *)


(* ::Input::Initialization:: *)
(* Define Eisenstein series Ei[k][\[Tau]] = Subscript[E, k](\[Tau]) as q=\[ExponentialE]^(2\[Pi]\[ImaginaryI]\[Tau]) series *)
Clear[Ei,E2,E4];
(*Ei[k_][q_:q]:=(Series[-(BernoulliB[k]/Factorial[k])+2/Factorial[k-1]Sum[(n^(k-1)qtemp^n)/(1-qtemp^n),{n,1,order}],{qtemp,0,2order}]//Simplify//Normal)/.{qtemp\[Rule]q};*)
Ei[k_][q_:q]:=(-(BernoulliB[k]/Factorial[k])+2/(k-1)! SeriesData[q,0,DivisorSigma[k-1,#]&/@Range[order+1],1,order+1,1]);
Ei[k_][q_^p_]:=(-(BernoulliB[k]/Factorial[k])+2/(k-1)! SeriesData[q,0,Boole[Mod[#,p]==0]DivisorSigma[k-1,#/p]&/@Range[order+1],1,order+1,1]);
E2[q_:q]:=Ei[2][q];
E4[q_:q]:=Ei[4][q];


Ei\[Tau][i_][\[Tau]_]:=Ei[i][q]/.{q->E^(2\[Pi] I \[Tau])};
EiNorm[k_][q_:q]:=1/(2Zeta[k]) Ei[k][q]


(* ::Input::Initialization:: *)
(* Define the twisted Eisenstein series Subscript[E, k][\[ExponentialE]^(2\[Pi]\[ImaginaryI] \[Lambda])
\[Theta]

][q=\[ExponentialE]^(2\[Pi]\[ImaginaryI]\[Tau])] *)

(* TODO: optimize *)

Clear[EiTwisted];

EiTwisted[1,qq_:q,order_:order][0,z_]:=EiTwisted[k,qq,order][0,z]=EiTwistedOld[1,qq,order][0,z];

(* EE[k][-1
z

][q], only valid when q-power in z is less than 1; for other cases,
preprocess (below) using shift property is required *)
EiTwisted[k_/;k>1,qq_:q,order_:order][0,z_]:=(*EiTwisted[k,qq,order][0,z]=*)Module[{temp,result},

temp=order Denominator[Exponent[z,qq]]/(Denominator[Exponent[z,qq]]-Numerator[Exponent[z,qq]]);

result=-(BernoulliB[k,1]/Factorial[k])+1/(k-1)! Sum[((-1)^k z^n+z^-n)\!\(
\*UnderoverscriptBox[\(\[Sum]\), \(m = 1\), \(order\)]\(
\*SuperscriptBox[\(m\), \(k - 1\)]\
\*SuperscriptBox[\(qq\), \(n\ m\)]\)\),{n,1,temp}];
result//Collect[#,q]&//qTruncate
];

(* EE[k][-1
z

][q], only valid when q-power in z is less than 1/2; for other cases,
preprocess (below) using shift property is required *)
EiTwisted[k_/;k>=1,qq_:q,order_:order][1/2,z_]:=EiTwisted[k,qq,order][1/2,z]=Module[{qPowerInz,temp1,temp2,$z,$n,$q},

qPowerInz=Exponent[z,qq];

temp1=order Denominator[(1/2-qPowerInz)]/Numerator[(1/2-qPowerInz)];

temp2=(SeriesData[$q,0,#^(k-1) Boole[OddQ[#]]&/@Range[2order+2],1,2order+2,2]//Normal)/.$q->qq/.{qq->qq^$n}//PowerExpand;

(*Print[-(BernoulliB[k,1/2]/Factorial[k])];*)
-(BernoulliB[k,1/2]/Factorial[k])+1/(2^(k-1) (k-1)!) (
(((-1)^k SeriesData[$z,0,Table[temp2,{$n,1,Ceiling[temp1]+1}],1,Ceiling[temp1]+1,1]//Normal)/.{$z->z})
+((SeriesData[$z,0,Table[temp2,{$n,1,Ceiling[temp1]+1}],1,Ceiling[temp1]+1,1]//Normal)/.{$z->z^-1})
)//PowerExpand//Collect[#,q]&//qTruncate
];

EiTwisted[0,q_:q,order_:order][\[Lambda]_,\[Theta]_]:=-1;

(* Preprocess the Eisenstein series *)
Clear[EE]
EE[0][{
 {\[Alpha]_},
 {\[Beta]_}
}][q]:=-1;
(* peroform shift to reduce computation *)
(* q \:5e42\:6b21 \[Element] 1/2\[DoubleStruckCapitalZ] *)
EE[k_][{
 {\[Phi]_},
 {q_ x_.}
}][q_]:=Sum[1/$l! EE[k-$l][{
 {\[Phi]},
 {x}
}][q],{$l,0,k}];
EE[$k_][{
 {pm_},
 {q_^($n_/;IntegerQ[2$n]) x_.}
}][q_]:=Sum[$n^$l 1/$l! EE[$k-$l][{
 {(-1)^(2$n) pm},
 {x}
}][q],{$l,0,$k}];
(* q \:5e42\:6b21 \[GreaterEqual] 1 *)
EE[k_][{
 {\[Alpha]_},
 {q_^(\[Lambda]_/;Abs[\[Lambda]]>=1) x_.}
}][q_]/;!IntegerQ[2\[Lambda]]:= Module[{qq},(EE[k][{
 {\[Alpha]},
 {qq^(\[Lambda]-Sign[\[Lambda]]Floor[Abs[\[Lambda]]]) x q^(Sign[\[Lambda]]Floor[Abs[\[Lambda]]])}
}][q])/.qq->q]
(* 1/2< q \:5e42\:6b21 < 1 *)
EE[k_][{
 {\[Alpha]_},
 {q_^(\[Lambda]_/;1/2<Abs[\[Lambda]]<1) x_.}
}][q_]/;!IntegerQ[2\[Lambda]]:=Module[{qq},(EE[k][{
 {\[Alpha]},
 {qq^(\[Lambda]-Sign[\[Lambda]] 1/2) x q^(Sign[\[Lambda]] 1/2)}
}][q])/.qq->q]
EE[k_][{
 {\[Alpha]_},
 {q^m_ \[Beta]_}
}][q^n_?IntegerQ]:=(EE[k][{
 {\[Alpha]},
 {q^m \[Beta]/.q->q^(1/n)//PowerExpand}
}][q]//Normal)/.q->q^n//PowerExpand

EE[k_][{
 {\[Phi]_},
 {\[Theta]_}
}][q_]:=EiTwisted[k,q,order][1/(2\[Pi] I) Log[\[Phi]],\[Theta]];


(* ::Input::Initialization:: *)
Gi[k_][q_:q]:=2Zeta[k]+(2(2\[Pi] I)^k)/Factorial[k-1] Sum[(n^(k-1) q^n)/(1-q^n),{n,1,order}]//Normal
Table[Gi[2k][q]-(2\[Pi] I)^(2k) Ei[2k][q],{k,1,4}]//qSeries


(* ::Input::Initialization:: *)
E2Wolfger[q_,\[CapitalLambda]_] := 1 - 24 * \!\(
\*UnderoverscriptBox[\(\[Sum]\), \(n = 1\), \(\[CapitalLambda]\)]\ \(DivisorSigma[1, n]
\*SuperscriptBox[\(q\), \(n\)]\)\);
E4Wolfger[q_,\[CapitalLambda]_] := 1 + 240 * \!\(
\*UnderoverscriptBox[\(\[Sum]\), \(n = 1\), \(\[CapitalLambda]\)]\ \(DivisorSigma[3, n]
\*SuperscriptBox[\(q\), \(n\)]\)\);
E2[q]+1/12 E2Wolfger[q,order]
E4[q]-1/720 E4Wolfger[q,order]//Simplify
