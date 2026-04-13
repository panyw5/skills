(* ====================================================================== *)
(* Quasi-Periodic Shift Operations
(* qShift, qShiftInteger, qShiftOld, qShift0, ThetaExpand, CurlyThetapToDerivative, FlipSign *) *)
(* ====================================================================== *)

(* qshift only recognize nome q  *)
Clear[qShift,qShiftInteger];

qShift[f_]:=Module[{\[Alpha]\[Beta],\[CurlyTheta]ps,shiftfn,IntegerShift,FractionalLargeShift,FractionalSmallShift,EisensteinHalfIntegerShift,result,$ZERO,AddZero,qRescale,qRescaled,$w,w,DEFER,EisensteinNonHalfIntegerShift,qq},
\[Alpha]\[Beta][1]={1,1};\[Alpha]\[Beta][2]={1,0};\[Alpha]\[Beta][3]={0,0};\[Alpha]\[Beta][4]={0,1};\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];

shiftfn[i_][m_,n_][z_,q_]:=(-1)^(n \[Alpha]\[Beta][i][[1]]-m \[Alpha]\[Beta][i][[2]]) (E^(-2 \[Pi] I z))^m q^(-(m^2/2));

(* some Preprocess *)
(* Add a $ZERO to \[CurlyTheta][i][z,q^n]->\[CurlyTheta][i][z+$ZERO,q^n] *)
AddZero[$f_]:=$f/. {\!\(\*SuperscriptBox[\(\[CurlyTheta][i_]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_,q]:>\!\(\*SuperscriptBox[\(\[CurlyTheta][i]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z+$ZERO,q],
\[CurlyTheta][i_][z_,q]:>\[CurlyTheta][i][z+$ZERO,q]};

(* Rescale \[CurlyTheta][i][z+k\[Tau],q^n]->\[CurlyTheta][i][z+k/n\[Tau],q], and keep track of n *)
qRescale[$f_]:=$f/.{
\[CurlyTheta][i_][z_,q^n_]:>qRescaled[n][\[CurlyTheta][i][z/.{\[Tau]->\[Tau]/n},q]],
\!\(\*SuperscriptBox[\(\[CurlyTheta][i_]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_,q^n_]:>qRescaled[n][\!\(\*SuperscriptBox[\(\[CurlyTheta][i]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z/.{\[Tau]->\[Tau]/n},q]],
EEE[k_][{
 {x_},
 {y_}
}][q^n_]:>qRescaled[n][EEE[k][{
 {x},
 {y/.q->q^(1/n)}
}][q]]
};

IntegerShift[$f_]:=$f//. {
\!\(\*SuperscriptBox[\(\[CurlyTheta][i_]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_Integer \[Tau],q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({$w, pnum}\)]\((
\*SuperscriptBox[\((\(-1\))\), \(\(-m\)\ \(\[Alpha]\[Beta][i]\)[\([2]\)]\)]\
\*SuperscriptBox[\(E\), \(\(-\[Pi]\)\ I\ m\ \((2\ $w + m\ \[Tau])\)\)]\ \(\[CurlyTheta][i]\)[$w, q])\)\)/. {$w->z}),\!\(\*SuperscriptBox[\(\[CurlyTheta][i_]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+\[Tau],q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({$w, pnum}\)]\((
\*SuperscriptBox[\((\(-1\))\), \(-\(\[Alpha]\[Beta][i]\)[\([2]\)]\)]\
\*SuperscriptBox[\(E\), \(\(-\[Pi]\)\ I\ \((2\ $w + \[Tau])\)\)]\ \(\[CurlyTheta][i]\)[$w, q])\)\)/. {$w->z}),\!\(\*SuperscriptBox[\(\[CurlyTheta][i_]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+n_Integer,q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({$w, pnum}\)]\((
\*SuperscriptBox[\((\(-1\))\), \(\(+n\)\ \(\[Alpha]\[Beta][i]\)[\([1]\)]\)]\ \(\[CurlyTheta][i]\)[$w, q])\)\)/. {$w->z}),

\[CurlyTheta][i_][z_+m_Integer \[Tau],q]:>(((-1)^(-m \[Alpha]\[Beta][i][[2]]) E^(-\[Pi] I m (2 $w+m \[Tau])) \[CurlyTheta][i][$w,q])/. {$w->z}),\[CurlyTheta][i_][z_+\[Tau],q]:>(((-1)^-\[Alpha]\[Beta][i][[2]] E^(-\[Pi] I (2 $w+\[Tau])) \[CurlyTheta][i][$w,q])/. {$w->z}),\[CurlyTheta][i_][z_+n_Integer,q]:>(((-1)^(+n \[Alpha]\[Beta][i][[1]]) \[CurlyTheta][i][$w,q])/. {$w->z})
};

FractionalLargeShift[$f_]:=$f//.{
(* perform sign flip for -n *)
\!\(\*SuperscriptBox[\(\[CurlyTheta][i_ /; 2 \[LessEqual] i \[LessEqual] 4]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+n_,q]:>(-1)^pnum \!\(\*SuperscriptBox[\(\[CurlyTheta][i]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[-z-n,q]/;n\[Element]Reals&&n<0,\!\(\*SuperscriptBox[\(\[CurlyTheta][1]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+n_,q]:>-(-1)^pnum \!\(\*SuperscriptBox[\(\[CurlyTheta][1]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[-z-n,q]/;n\[Element]Reals&&n<0,
\[CurlyTheta][i_/;2<=i<=4][z_+n_,q]:> \[CurlyTheta][i][-z-n,q]/;n\[Element]Reals&&n<0,
\[CurlyTheta][1][z_+n_,q]:>- \[CurlyTheta][1][-z-n,q]/;n\[Element]Reals&&n<0,

(* perform n shift *)
\!\(\*SuperscriptBox[\(\[CurlyTheta][i_]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+n_,q]:>IntegerShift[\!\(\*SuperscriptBox[\(\[CurlyTheta][i]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z+DEFER[n-Floor[n]]+Floor[n],q]]/;n\[Element]Reals&&n>1,
\[CurlyTheta][i_][z_+n_,q]:>IntegerShift[\[CurlyTheta][i][z+DEFER[n-Floor[n]]+Floor[n],q]]/;n\[Element]Reals&&n>1}//. {
(* perform m\[Tau] shift *)
\!\(\*SuperscriptBox[\(\[CurlyTheta][i_]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_ \[Tau],q]:>IntegerShift[\!\(\*SuperscriptBox[\(\[CurlyTheta][i]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z+DEFER[m-Floor[m]] \[Tau]+Floor[m] \[Tau],q]]/;m\[Element]Reals&&m>1,
\[CurlyTheta][i_][z_+m_ \[Tau],q]:>IntegerShift[\[CurlyTheta][i][z+DEFER[m-Floor[m]] \[Tau]+Floor[m] \[Tau],q]]/;m\[Element]Reals&&m>1,

(* perform sign flip for -m\[Tau] *)
\!\(\*SuperscriptBox[\(\[CurlyTheta][i_ /; 2 \[LessEqual] i \[LessEqual] 4]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_ \[Tau],q]:>(-1)^pnum \!\(\*SuperscriptBox[\(\[CurlyTheta][i]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[-z-m \[Tau],q]/;m\[Element]Reals&&m<0,
\!\(\*SuperscriptBox[\(\[CurlyTheta][1]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_ \[Tau],q]:>-(-1)^pnum \!\(\*SuperscriptBox[\(\[CurlyTheta][1]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[-z-m \[Tau],q]/;m\[Element]Reals&&m<0,
\[CurlyTheta][i_/;2<=i<=4][z_+m_ \[Tau],q]:> \[CurlyTheta][i][-z-m \[Tau],q]/;m\[Element]Reals&&m<0,
\[CurlyTheta][1][z_+m_ \[Tau],q]:>- \[CurlyTheta][1][-z-m \[Tau],q]/;m\[Element]Reals&&m<0

}/. {DEFER->Identity};

FractionalSmallShift[$f_]:=$f//. {
\!\(\*SuperscriptBox[\(\[CurlyTheta][1]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_ \[Tau],q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({w, pnum}\)]\((I\
\*SuperscriptBox[\(E\), \(\(-\[Pi]\)\ I\ \((w +
\*FractionBox[\(\[Tau]\), \(4\)])\)\)]\ \(\[CurlyTheta][4]\)[w, q])\)\)/. {w->z+(m-1/2) \[Tau]})/;1/2<=m<1,\!\(\*SuperscriptBox[\(\[CurlyTheta][4]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_ \[Tau],q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({w, pnum}\)]\((I\
\*SuperscriptBox[\(E\), \(\(-\[Pi]\)\ I\ \((w +
\*FractionBox[\(\[Tau]\), \(4\)])\)\)]\ \(\[CurlyTheta][1]\)[w, q])\)\)/. {w->z+(m-1/2) \[Tau]})/;1/2<=m<1,\!\(\*SuperscriptBox[\(\[CurlyTheta][3]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_ \[Tau],q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({w, pnum}\)]\((I\
\*SuperscriptBox[\(E\), \(\(-\[Pi]\)\ I\ \((w +
\*FractionBox[\(\[Tau]\), \(4\)])\)\)]\ \(\[CurlyTheta][2]\)[w, q])\)\)/. {w->z+(m-1/2) \[Tau]})/;1/2<=m<1,\!\(\*SuperscriptBox[\(\[CurlyTheta][2]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_ \[Tau],q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({w, pnum}\)]\((I\
\*SuperscriptBox[\(E\), \(\(-\[Pi]\)\ I\ \((w +
\*FractionBox[\(\[Tau]\), \(4\)])\)\)]\ \(\[CurlyTheta][3]\)[w, q])\)\)/. {w->z+(m-1/2) \[Tau]})/;1/2<=m<1,

\[CurlyTheta][1][z_+m_ \[Tau],q]:>(I E^(-\[Pi] I (w+\[Tau]/4)) \[CurlyTheta][4][w,q]/. {w->z+(m-1/2) \[Tau]})/;1/2<=m<1,\[CurlyTheta][4][z_+m_ \[Tau],q]:>(I E^(-\[Pi] I (w+\[Tau]/4)) \[CurlyTheta][1][w,q]/. {w->z+(m-1/2) \[Tau]})/;1/2<=m<1,\[CurlyTheta][3][z_+m_ \[Tau],q]:>(I E^(-\[Pi] I (w+\[Tau]/4)) \[CurlyTheta][2][w,q]/. {w->z+(m-1/2) \[Tau]})/;1/2<=m<1,\[CurlyTheta][2][z_+m_ \[Tau],q]:>(I E^(-\[Pi] I (w+\[Tau]/4)) \[CurlyTheta][3][w,q]/. {w->z+(m-1/2) \[Tau]})/;1/2<=m<1,

\!\(\*SuperscriptBox[\(\[CurlyTheta][1]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+n_,q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({w, pnum}\)]\(\(\[CurlyTheta][2]\)[w, q]\)\)/. {w->z+(n-1/2)})/;1/2<=n<1,\!\(\*SuperscriptBox[\(\[CurlyTheta][2]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+n_,q]:>(-\!\(
\*SubscriptBox[\(\[PartialD]\), \({w, pnum}\)]\(\(\[CurlyTheta][1]\)[w, q]\)\)/. {w->z+(n-1/2) })/;1/2<=n<1,\!\(\*SuperscriptBox[\(\[CurlyTheta][3]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+n_,q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({w, pnum}\)]\(\(\[CurlyTheta][4]\)[w, q]\)\)/. {w->z+(n-1/2) })/;1/2<=n<1,\!\(\*SuperscriptBox[\(\[CurlyTheta][4]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+n_,q]:>(\!\(
\*SubscriptBox[\(\[PartialD]\), \({w, pnum}\)]\(\(\[CurlyTheta][3]\)[w, q]\)\)/. {w->z+(n-1/2) })/;1/2<=n<1,

\[CurlyTheta][1][z_+n_,q]:>(\[CurlyTheta][2][w,q]/. {w->z+(n-1/2)})/;1/2<=n<1,\[CurlyTheta][2][z_+n_,q]:>(-\[CurlyTheta][1][w,q]/. {w->z+(n-1/2) })/;1/2<=n<1,\[CurlyTheta][3][z_+n_,q]:>(\[CurlyTheta][4][w,q]/. {w->z+(n-1/2) })/;1/2<=n<1,\[CurlyTheta][4][z_+n_,q]:>(\[CurlyTheta][3][w,q]/. {w->z+(n-1/2) })/;1/2<=n<1,

\!\(\*SuperscriptBox[\(\[CurlyTheta][i_ /; 2 \[LessEqual] i \[LessEqual] 4]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_ \[Tau],q]:>(-1)^pnum \!\(\*SuperscriptBox[\(\[CurlyTheta][i]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[-z-m \[Tau],q]/;m\[Element]Reals&&m<0,\!\(\*SuperscriptBox[\(\[CurlyTheta][1]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_+m_ \[Tau],q]:>-(-1)^pnum \!\(\*SuperscriptBox[\(\[CurlyTheta][1]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[-z-m \[Tau],q]/;m\[Element]Reals&&m<0}/. {DEFER->Identity};

EisensteinHalfIntegerShift[$f_]:=$f//.{
(* deal with half integer shift *)
EEE[$k_][{
 {pm_},
 {$q_ x_}
}][$q_]:>Sum[1/$l! EEE[$k-$l][{
 {pm},
 {x}
}][$q],{$l,0,$k}],
EEE[$k_][{
 {pm_},
 {$q_^$n_ x_}
}][$q_]:>Sum[($n)^$l 1/$l! EEE[$k-$l][{
 {(-1)^(2$n) pm},
 {x}
}][$q],{$l,0,$k}]/;IntegerQ[2$n],
(*EEE[$k_][pm_
$q_^$n_ x_

][$q_^$m_]\[RuleDelayed]Sum[($n/$m)^$l1/$l!EEE[$k-$l][(-1)^(2$n)pm
x

][$q^$m],{$l,0,$k}]/;IntegerQ[2$n/$m],*)
EEE[0][{
 {\[Alpha]_},
 {\[Beta]_}
}][$q_]:>-1};

EisensteinNonHalfIntegerShift[$f_]:=$f//.{
(* deal with non-half integer shift *)
EEE[k_][{
 {\[Alpha]_},
 {$q_^(\[Lambda]_/;Abs[\[Lambda]]>=1) x_}
}][$q_]/;!IntegerQ[2\[Lambda]]:>((EEE[k][{
 {\[Alpha]},
 {qq^(\[Lambda]-Sign[\[Lambda]]Floor[Abs[\[Lambda]]]) x $q^(Sign[\[Lambda]]Floor[Abs[\[Lambda]]])}
}][$q]//EisensteinHalfIntegerShift)/.qq->$q),
EEE[k_][{
 {\[Alpha]_},
 {$q_^(\[Lambda]_/;1/2<Abs[\[Lambda]]<=1) x_}
}][$q_]/;!IntegerQ[2\[Lambda]]:>((EEE[k][{
 {\[Alpha]},
 {qq^(\[Lambda]-Sign[\[Lambda]] 1/2) x $q^(Sign[\[Lambda]] 1/2)}
}][$q]//EisensteinHalfIntegerShift)/.qq->$q),
EEE[k_][{
 {\[Alpha]_},
 {$q_^(\[Lambda]_/;Abs[\[Lambda]]>=1)}
}][$q_]/;!IntegerQ[2\[Lambda]]:>((EEE[k][{
 {\[Alpha]},
 {qq^(\[Lambda]-Sign[\[Lambda]]Floor[Abs[\[Lambda]]]) $q^(Sign[\[Lambda]]Floor[Abs[\[Lambda]]])}
}][$q]//EisensteinHalfIntegerShift)/.qq->$q),
EEE[k_][{
 {\[Alpha]_},
 {$q_^(\[Lambda]_/;1/2<Abs[\[Lambda]]<=1)}
}][$q_]/;!IntegerQ[2\[Lambda]]:>((EEE[k][{
 {\[Alpha]},
 {qq^(\[Lambda]-Sign[\[Lambda]] 1/2) $q^(Sign[\[Lambda]] 1/2)}
}][$q]//EisensteinHalfIntegerShift)/.qq->$q)
};

result=f//Expand\[CurlyTheta]//\[CurlyTheta]pTo\[CurlyTheta]Derivative//qRescale//AddZero;


result=result//IntegerShift//FractionalLargeShift//FractionalSmallShift//EisensteinHalfIntegerShift//EisensteinNonHalfIntegerShift;

result=result/.$ZERO->0/.qRescaled[n_][exp_]:>(exp/.{\[Tau]->n \[Tau]}/.{
\[CurlyTheta][i_][z_,$q_]:>\[CurlyTheta][i][z,$q^n],
\!\(\*SuperscriptBox[\(\[CurlyTheta][i_]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum_", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z_,$q_]:>\!\(\*SuperscriptBox[\(\[CurlyTheta][i]\),
TagBox[
RowBox[{"(",
RowBox[{"pnum", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[z,$q^n],
EEE[k_][{
 {x_},
 {y_}
}][$q_]:>EEE[k][{
 {x},
 {y}
}/.$q->$q^n][$q^n]
});
result//\[CurlyTheta]DerivativeTo\[CurlyTheta]p
];


qShiftInteger[f_]:=Module[{\[CurlyTheta]ps,shiftfn,\[Alpha]\[Beta],\[Epsilon],integerShiftRules},
\[Alpha]\[Beta][1]={1,1};
\[Alpha]\[Beta][2]={1,0};
\[Alpha]\[Beta][3]={0,0};
\[Alpha]\[Beta][4]={0,1};
\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];
shiftfn[i_][m_,n_][z_,q_]:=(-1)^(n \[Alpha]\[Beta][i][[1]]-m \[Alpha]\[Beta][i][[2]]) (E^(-2\[Pi] I  z))^m q^(-(m^2/2));

integerShiftRules=(Table[\[CurlyTheta]ps[pnum][i][z_+m_. \[Tau],q_]/;m\[Element]Integers:>Evaluate[D[(-1)^(-m \[Alpha]\[Beta][i][[2]]) E^(-\[Pi] I m(2w+m \[Tau])) \[Theta][i][w,q],{w,pnum}]/.{w->z}//makeAbstract],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten)~Join~(Table[\[CurlyTheta]ps[pnum][i][z_+n_,q_]/;n\[Element]Integers:>Evaluate[D[(-1)^(+n \[Alpha]\[Beta][i][[1]]) \[Theta][i][w,q],{w,pnum}]/.{w->z}//makeAbstract],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);

f/.{EllipticTheta[i_,z_,qhalf_]:>EllipticTheta[i,z//Expand,qhalf],
EllipticThetaPrime[i_,z_,qhalf_]:>EllipticThetaPrime[i,z//Expand,qhalf]
}/.{
EllipticTheta[i_,z_+n_. \[Pi]+m_. \[Pi] \[Tau],qhalf_]:>shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,n][z,qhalf^2]EllipticTheta[i,z,qhalf]/;n\[Element]Integers,
EllipticTheta[i_,z_+n_. \[Pi],qhalf_]:>shiftfn[i][0,n][z,qhalf^2]EllipticTheta[i,z,qhalf]/;n\[Element]Integers,
EllipticTheta[i_,z_+m_. \[Pi] \[Tau],qhalf_]:>shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,0][z/\[Pi],qhalf^2]EllipticTheta[i,z,qhalf]/;m\[Element]Integers,

EllipticTheta[i_,n_. \[Pi]+m_. \[Pi] \[Tau],qhalf_]:>shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,n][0,qhalf^2]EllipticTheta[i,0,qhalf]/;n\[Element]Integers,
EllipticTheta[i_,n_. \[Pi],qhalf_]:>shiftfn[i][0,n][0,qhalf^2]EllipticTheta[i,0,qhalf]/;n\[Element]Integers,
EllipticTheta[i_,m_. \[Pi] \[Tau],qhalf_]:>shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,0][0/\[Pi],qhalf^2]EllipticTheta[i,0,qhalf]/;m\[Element]Integers,

EllipticThetaPrime[i_,z_+n_. \[Pi]+m_. \[Pi] \[Tau],qhalf_]:>(D[shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,n][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->z})/;n\[Element]Integers,
EllipticThetaPrime[i_,z_+n_. \[Pi],qhalf_]:>(D[shiftfn[i][0,n][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->z})/;n\[Element]Integers,
EllipticThetaPrime[i_,z_+m_. \[Pi] \[Tau],qhalf_]:>(D[shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,0][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->z})/;m\[Element]Integers,

EllipticThetaPrime[i_,n_. \[Pi]+m_. \[Pi] \[Tau],qhalf_]:>(D[shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,n][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->0})/;n\[Element]Integers,
EllipticThetaPrime[i_,n_. \[Pi],qhalf_]:>(D[shiftfn[i][0,n][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->0})/;n\[Element]Integers,
EllipticThetaPrime[i_,m_. \[Pi] \[Tau],qhalf_]:>(D[shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,0][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->0})/;m\[Element]Integers

}/.{\[CurlyTheta]_[i_][z_,q_]:>\[CurlyTheta][i][z//Expand,q]/;MemberQ[Table[\[CurlyTheta]ps[pnum],{pnum,0,maxDerivativeOrder}],\[CurlyTheta]]}/.integerShiftRules
];




(* ::Input::Initialization:: *)
Clear[qShiftOld]
qShiftOld[f_]:=Block[{\[CurlyTheta]ps,l,m,n,i,shiftfn,pnum,\[Alpha]\[Beta],\[Epsilon]$,\[Epsilon]$$,z,z$,w,zp,rescalingRules,
integer1Shift,integer\[Tau]Shift,rational1ShiftSignFlip,rational\[Tau]ShiftSignFlip,
rational1Shift,rational\[Tau]Shift,rationalShiftSignFlip2,rationalShift2,half1ShiftPrep,half\[Tau]ShiftPrep,half1Shift,half\[Tau]Shift,expansionRules},
\[Alpha]\[Beta][1]={1,1};
\[Alpha]\[Beta][2]={1,0};
\[Alpha]\[Beta][3]={0,0};
\[Alpha]\[Beta][4]={0,1};
\[CurlyTheta]ps[pnum_]:=\[CurlyTheta]ps[pnum]=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];
shiftfn[i_][m_,n_][z_,q_]:=(-1)^(n \[Alpha]\[Beta][i][[1]]-m \[Alpha]\[Beta][i][[2]]) (E^(-2\[Pi] I  z))^m q^(-(m^2/2));

rescalingRules=(Table[\[CurlyTheta]ps[pnum][i][z_,q_]:>Evaluate[\[CurlyTheta]ps[pnum][i][z//Expand,q]],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);

expansionRules=(Table[\[CurlyTheta]ps[pnum][i][z_,q_]:>Evaluate[\[CurlyTheta]ps[pnum][i][z//Expand,q]],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);

integer1Shift=(Table[\[CurlyTheta]ps[pnum][i][z_+m_. \[Tau],q_]/;(m\[Element]Integers//Simplify):>Evaluate[D[(-1)^(-m \[Alpha]\[Beta][i][[2]]) E^(-\[Pi] I m(2w+m \[Tau])) \[Theta][i][w,q],{w,pnum}]/.{w->z}//makeAbstract],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);
integer\[Tau]Shift=(Table[\[CurlyTheta]ps[pnum][i][z_+n_,q_]/;(n\[Element]Integers//Simplify):>Evaluate[D[(-1)^(+n \[Alpha]\[Beta][i][[1]]) \[Theta][i][w,q],{w,pnum}]/.{w->z}//makeAbstract],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);

rational1ShiftSignFlip=(Table[\[CurlyTheta]ps[pnum][i][z_+l_,q_]/;l\[Element]Rationals&&l<0:>Evaluate[(-1)^pnum \[CurlyTheta]ps[pnum][i][-z-l,q]],{pnum,0,maxDerivativeOrder},{i,2,4}]//Flatten)~Join~(Table[\[CurlyTheta]ps[pnum][i][z_+l_,q_]/;l\[Element]Rationals&&l<0:>Evaluate[(-1)^(1+pnum) \[CurlyTheta]ps[pnum][i][-z-l,q]],{pnum,0,maxDerivativeOrder},{i,1,1}]//Flatten);

(* shift l with rational l > 1 into (l - [l]) *)
rational1Shift=(Table[\[CurlyTheta]ps[pnum][i][z_+l_,q_]/;l\[Element]Rationals&&l>1:>Evaluate[(-1)^Floor[l] \[CurlyTheta]ps[pnum][i][z+l-Floor[l],q]],{pnum,0,maxDerivativeOrder},{i,1,2}]//Flatten)~Join~(Table[\[CurlyTheta]ps[pnum][i][z_+l_,q_]/;l\[Element]Rationals&&l>1:>Evaluate[\[CurlyTheta]ps[pnum][i][z+l-Floor[l],q]],{pnum,0,maxDerivativeOrder},{i,3,4}]//Flatten);


rational\[Tau]ShiftSignFlip=(Table[\[CurlyTheta]ps[pnum][i][z_+l_ \[Tau],q_]/;l\[Element]Rationals&&l<0:>Evaluate[(-1)^pnum \[CurlyTheta]ps[pnum][i][-z-l \[Tau],q]],{pnum,0,maxDerivativeOrder},{i,2,4}]//Flatten)~Join~(Table[\[CurlyTheta]ps[pnum][i][z_+l_ \[Tau],q_]/;l\[Element]Rationals&&l<0:>Evaluate[(-1)^(1+pnum) \[CurlyTheta]ps[pnum][i][-z-l \[Tau],q]],{pnum,0,maxDerivativeOrder},{i,1,1}]//Flatten);

(* shift l\[Tau] with rational l > 1 into (l - [l])\[Tau] *)
rational\[Tau]Shift=(Table[\[CurlyTheta]ps[pnum][i][z_+l_ \[Tau],q_]/;l\[Element]Rationals&&l>1:>Evaluate[D[-E^(-\[Pi] I(2(w+l \[Tau]-\[Tau])+\[Tau]))\[Theta][i][w+l \[Tau]-\[Tau],q],{w,pnum}]/.{w->z}//makeAbstract],{pnum,0,maxDerivativeOrder},{i,1,4,3}]//Flatten)~Join~(Table[\[CurlyTheta]ps[pnum][i][z_+l_ \[Tau],q_]/;l\[Element]Rationals&&l>1:>Evaluate[D[E^(-\[Pi] I(2(w+l \[Tau]-\[Tau])+\[Tau])) \[Theta][i][w+l \[Tau]-\[Tau],q],{w,pnum}]/.{w->z}//makeAbstract],{pnum,0,maxDerivativeOrder},{i,2,3}]//Flatten);

(* half shift is only done when the nome is precisely q *)
half1ShiftPrep=(Table[\[CurlyTheta]ps[pnum][i][l_+z_,q]/;l\[Element]Rationals&&1/2<=l<1:>Evaluate[\[CurlyTheta]ps[pnum][i][(l-1/2)+\[Epsilon]$/2+z,q]],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);
(* half shift is only done when the nome is precisely q *)
half1Shift=Table[{
\[CurlyTheta]ps[pnum][1][z_+1/2,q]:>Evaluate[\[CurlyTheta]ps[pnum][2][z,q]],\[CurlyTheta]ps[pnum][2][z_+1/2,q]:>Evaluate[-\[CurlyTheta]ps[pnum][1][z,q]],
\[CurlyTheta]ps[pnum][3][z_+1/2,q]:>Evaluate[\[CurlyTheta]ps[pnum][4][z,q]],\[CurlyTheta]ps[pnum][4][z_+1/2,q]:>Evaluate[\[CurlyTheta]ps[pnum][3][z,q]],

\[CurlyTheta]ps[pnum][1][z_+\[Epsilon]$/2,q]:>Evaluate[\[CurlyTheta]ps[pnum][2][z,q]],\[CurlyTheta]ps[pnum][2][z_+\[Epsilon]$/2,q]:>Evaluate[-\[CurlyTheta]ps[pnum][1][z,q]],
\[CurlyTheta]ps[pnum][3][z_+\[Epsilon]$/2,q]:>Evaluate[\[CurlyTheta]ps[pnum][4][z,q]],\[CurlyTheta]ps[pnum][4][z_+\[Epsilon]$/2,q]:>Evaluate[\[CurlyTheta]ps[pnum][3][z,q]]
},{pnum,0,maxDerivativeOrder}]//Flatten;

half\[Tau]ShiftPrep=(Table[\[CurlyTheta]ps[pnum][i][l_ \[Tau]+z_,q]/;l\[Element]Rationals&&1/2<=l<1:>Evaluate[\[CurlyTheta]ps[pnum][i][(l-1/2)\[Tau]+\[Epsilon]$$/2 \[Tau]+z,q]],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);
(* half shift is only done when the nome is precisely q *)
half\[Tau]Shift=Table[{
\[CurlyTheta]ps[pnum][1][z_+\[Tau]/2,q]:>Evaluate[D[I E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][4][w,q],{w,pnum}]/.{w->z}//makeAbstract],
\[CurlyTheta]ps[pnum][4][z_+\[Tau]/2,q]:>Evaluate[D[I E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][1][w,q],{w,pnum}]/.{w->z}//makeAbstract],
\[CurlyTheta]ps[pnum][3][z_+\[Tau]/2,q]:>Evaluate[D[E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][2][w,q],{w,pnum}]/.{w->z}//makeAbstract],
\[CurlyTheta]ps[pnum][2][z_+\[Tau]/2,q]:> Evaluate[D[E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][3][w,q],{w,pnum}]/.{w->z}//makeAbstract],

\[CurlyTheta]ps[pnum][1][z_+(\[Epsilon]$$ \[Tau])/2,q]:>Evaluate[D[I E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][4][w,q],{w,pnum}]/.{w->z}//makeAbstract],
\[CurlyTheta]ps[pnum][4][z_+(\[Epsilon]$$ \[Tau])/2,q]:>Evaluate[D[I E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][1][w,q],{w,pnum}]/.{w->z}//makeAbstract],
\[CurlyTheta]ps[pnum][3][z_+(\[Epsilon]$$ \[Tau])/2,q]:> Evaluate[D[E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][2][w,q],{w,pnum}]/.{w->z}//makeAbstract],
\[CurlyTheta]ps[pnum][2][z_+(\[Epsilon]$$ \[Tau])/2,q]:> Evaluate[D[E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][3][w,q],{w,pnum}]/.{w->z}//makeAbstract],

\[CurlyTheta]ps[pnum][1][(\[Epsilon]$$ \[Tau])/2,q]:>Evaluate[D[I E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][4][w,q],{w,pnum}]/.{w->0}//makeAbstract],
\[CurlyTheta]ps[pnum][4][(\[Epsilon]$$ \[Tau])/2,q]:>Evaluate[D[I E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][1][w,q],{w,pnum}]/.{w->0}//makeAbstract],
\[CurlyTheta]ps[pnum][3][(\[Epsilon]$$ \[Tau])/2,q]:> Evaluate[D[E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][2][w,q],{w,pnum}]/.{w->0}//makeAbstract],
\[CurlyTheta]ps[pnum][2][(\[Epsilon]$$ \[Tau])/2,q]:> Evaluate[D[E^(-\[Pi] I(w+\[Tau]/4)) \[Theta][3][w,q],{w,pnum}]/.{w->0}//makeAbstract]
},{pnum,0,maxDerivativeOrder}]//Flatten;
(f/.{EllipticTheta[i_,z_,qhalf_]:>EllipticTheta[i,z//Expand,qhalf],
EllipticThetaPrime[i_,z_,qhalf_]:>EllipticThetaPrime[i,z//Expand,qhalf]
}
/.{
EllipticTheta[i_,z_+n_. \[Pi]+m_. \[Pi] \[Tau],qhalf_]:>shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,n][z,qhalf^2]EllipticTheta[i,z,qhalf]/;n\[Element]Integers,
EllipticTheta[i_,z_+n_. \[Pi],qhalf_]:>shiftfn[i][0,n][z,qhalf^2]EllipticTheta[i,z,qhalf]/;n\[Element]Integers,
EllipticTheta[i_,z_+m_. \[Pi] \[Tau],qhalf_]:>shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,0][z/\[Pi],qhalf^2]EllipticTheta[i,z,qhalf]/;m\[Element]Integers,

EllipticTheta[i_,n_. \[Pi]+m_. \[Pi] \[Tau],qhalf_]:>shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,n][0,qhalf^2]EllipticTheta[i,0,qhalf]/;n\[Element]Integers,
EllipticTheta[i_,n_. \[Pi],qhalf_]:>shiftfn[i][0,n][0,qhalf^2]EllipticTheta[i,0,qhalf]/;n\[Element]Integers,
EllipticTheta[i_,m_. \[Pi] \[Tau],qhalf_]:>shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,0][0/\[Pi],qhalf^2]EllipticTheta[i,0,qhalf]/;m\[Element]Integers,

EllipticThetaPrime[i_,z_+n_. \[Pi]+m_. \[Pi] \[Tau],qhalf_]:>(D[shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,n][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->z})/;n\[Element]Integers,
EllipticThetaPrime[i_,z_+n_. \[Pi],qhalf_]:>(D[shiftfn[i][0,n][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->z})/;n\[Element]Integers,
EllipticThetaPrime[i_,z_+m_. \[Pi] \[Tau],qhalf_]:>(D[shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,0][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->z})/;m\[Element]Integers,

EllipticThetaPrime[i_,n_. \[Pi]+m_. \[Pi] \[Tau],qhalf_]:>(D[shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,n][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->0})/;n\[Element]Integers,
EllipticThetaPrime[i_,n_. \[Pi],qhalf_]:>(D[shiftfn[i][0,n][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->0})/;n\[Element]Integers,
EllipticThetaPrime[i_,m_. \[Pi] \[Tau],qhalf_]:>(D[shiftfn[i][(m \[Tau])/(1/(2\[Pi] I) Log[qhalf^2])//PowerExpand,0][zp/\[Pi],qhalf^2]EllipticTheta[i,zp,qhalf],zp]/.{zp->0})/;m\[Element]Integers

}/.{\[CurlyTheta]_[i_][z_,q_]:>\[CurlyTheta][i][z$+z//Expand,q]/;MemberQ[Table[\[CurlyTheta]ps[pnum],{pnum,0,maxDerivativeOrder}],\[CurlyTheta]]}/. integer1Shift/. rational1ShiftSignFlip//. rational1Shift//. half1ShiftPrep//. half1Shift/. integer\[Tau]Shift/. rational\[Tau]ShiftSignFlip//. rational\[Tau]Shift/. rational\[Tau]ShiftSignFlip//. rational\[Tau]Shift//. half\[Tau]ShiftPrep//. half\[Tau]Shift/.{z$->0}
)
];


(* ::Input::Initialization:: *)
Clear[qShift0];
(* simplified version of qShift, much better performance *)
qShift0[f_]:=Module[{\[Alpha]\[Beta],shiftfn},
\[Alpha]\[Beta][1]={1,1};
\[Alpha]\[Beta][2]={1,0};
\[Alpha]\[Beta][3]={0,0};
\[Alpha]\[Beta][4]={0,1};
(* shiftfn[m,n] is for \[CurlyTheta][i][z+n+m\[Tau]], note the position of m, n *)
shiftfn[i_][n_,m_][z_,q_]:=shiftfn[i][n,m][z,q]=(-1)^(n \[Alpha]\[Beta][i][[1]]-m \[Alpha]\[Beta][i][[2]]) (E^(-2\[Pi] I  z))^m q^(-(m^2/2));
(f//Expand\[CurlyTheta])/.{\[CurlyTheta][1][m_+n_. \[Tau]+z_,q]:>shiftfn[1][m,n][z,q]\[CurlyTheta][1][z,q]/;IntegerQ[m]&&IntegerQ[n],\[CurlyTheta][1][m_+z_,q]:>shiftfn[1][m,0][z,q]\[CurlyTheta][1][z,q]/;IntegerQ[m],\[CurlyTheta][1][n_. \[Tau]+z_,q]:>shiftfn[1][0,n][z,q]\[CurlyTheta][1][z,q]/;IntegerQ[n],

\[CurlyTheta][2][m_+n_. \[Tau]+z_,q]:>shiftfn[2][m,n][z,q]\[CurlyTheta][2][z,q]/;IntegerQ[m]&&IntegerQ[n],\[CurlyTheta][2][m_+z_,q]:>shiftfn[2][m,0][z,q]\[CurlyTheta][2][z,q]/;IntegerQ[m],\[CurlyTheta][2][n_. \[Tau]+z_,q]:>shiftfn[2][0,n][z,q]\[CurlyTheta][2][z,q]/;IntegerQ[n],

\[CurlyTheta][3][m_+n_. \[Tau]+z_,q]:>shiftfn[3][m,n][z,q]\[CurlyTheta][3][z,q]/;IntegerQ[m]&&IntegerQ[n],\[CurlyTheta][3][m_+z_,q]:>shiftfn[3][m,0][z,q]\[CurlyTheta][3][z,q]/;IntegerQ[m],\[CurlyTheta][3][n_. \[Tau]+z_,q]:>shiftfn[3][0,n][z,q]\[CurlyTheta][3][z,q]/;IntegerQ[n],

\[CurlyTheta][4][m_+n_. \[Tau]+z_,q]:>shiftfn[4][m,n][z,q]\[CurlyTheta][4][z,q]/;IntegerQ[m]&&IntegerQ[n],\[CurlyTheta][4][m_+z_,q]:>shiftfn[4][m,0][z,q]\[CurlyTheta][4][z,q]/;IntegerQ[m],\[CurlyTheta][4][n_. \[Tau]+z_,q]:>shiftfn[4][0,n][z,q]\[CurlyTheta][4][z,q]/;IntegerQ[n]
}/.{\[CurlyTheta][1][\[Tau] n_.+m_,q]:>shiftfn[1][m,n][0,q] \[CurlyTheta][1][0,q]/;IntegerQ[m]&&IntegerQ[n],\[CurlyTheta][1][m_,q]:>shiftfn[1][m,0][0,q] \[CurlyTheta][1][0,q]/;IntegerQ[m],
\[CurlyTheta][1][n_. \[Tau],q]:>shiftfn[1][0,n][0,q] \[CurlyTheta][1][0,q]/;IntegerQ[n],

\[CurlyTheta][2][n_. \[Tau]+m_,q]:>shiftfn[2][m,n][0,q] \[CurlyTheta][2][0,q]/;IntegerQ[m]&&IntegerQ[n],\[CurlyTheta][2][m_,q]:>shiftfn[2][m,0][0,q] \[CurlyTheta][2][0,q]/;IntegerQ[m],
\[CurlyTheta][2][n_. \[Tau],q]:>shiftfn[2][0,n][0,q] \[CurlyTheta][2][0,q]/;IntegerQ[n],

\[CurlyTheta][3][n_. \[Tau]+m_,q]:>shiftfn[3][m,n][0,q] \[CurlyTheta][3][0,q]/;IntegerQ[m]&&IntegerQ[n],\[CurlyTheta][3][m_,q]:>shiftfn[3][m,0][0,q] \[CurlyTheta][3][0,q]/;IntegerQ[m],
\[CurlyTheta][3][n_. \[Tau],q]:>shiftfn[3][0,n][0,q] \[CurlyTheta][3][0,q]/;IntegerQ[n],

\[CurlyTheta][4][ n_. \[Tau]+m_,q]:>shiftfn[4][m,n][0,q] \[CurlyTheta][4][0,q]/;IntegerQ[m]&&IntegerQ[n],\[CurlyTheta][4][m_,q]:>shiftfn[4][m,0][0,q] \[CurlyTheta][4][0,q]/;IntegerQ[m],\[CurlyTheta][4][n_. \[Tau],q]:>shiftfn[4][0,n][0,q] \[CurlyTheta][4][0,q]/;IntegerQ[n]}/.{E^x_:>(E^x/.{\[Tau]->1/(2\[Pi] I) Log[q]}//Simplify)}
]


(* ::Input::Initialization:: *)
Clear[\[Theta]Expand,\[CurlyTheta]Expand];

\[Theta]Expand[f_]:=Block[{\[CurlyTheta]ps,expansionRules,EExpand},

\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];

expansionRules=(Table[\[CurlyTheta]ps[pnum][i][z_,q_]:>Evaluate[\[CurlyTheta]ps[pnum][i][z//EExpand,q]],{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten);

f/.expansionRules/.EExpand->Expand
];
\[CurlyTheta]Expand=\[Theta]Expand;
Expand\[CurlyTheta]=\[CurlyTheta]Expand;


\[CurlyTheta]pTo\[CurlyTheta]Derivative[f_]:=Block[{\[CurlyTheta]ps},

\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];

rules=(Table[\[CurlyTheta]ps[pnum][i][z_,q_]:>Evaluate[D[\[CurlyTheta][i][$w,q],{$w,pnum}]]/.{$w->z},{pnum,0,maxDerivativeOrder},{i,1,4}]//Flatten)~Join~{\[CurlyTheta][i_][z_,q]:>Derivative[0,0][\[CurlyTheta][i]][z,q]};

f/.rules

];

\[CurlyTheta]DerivativeTo\[CurlyTheta]p[f_]:=Module[{\[CurlyTheta]ps},
\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];

f//.{Derivative[n_,0][\[CurlyTheta][i_]][z_,q_]:>\[CurlyTheta]ps[n][i][z,q]}]


(* ::Input::Initialization:: *)
Clear[FlipSignAll\[ScriptB],FlipSign]
FlipSign[f_][var_]:=Block[{\[CurlyTheta]ps,pnum,signRules,x},
\[CurlyTheta]ps[pnum_]:=Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",pnum])];
signRules=(Table[\[CurlyTheta]ps[pnum][i][\[Lambda]_ var,q_]/;\[Lambda]<0:>Evaluate[(-1)^pnum \[CurlyTheta]ps[pnum][i][-\[Lambda] var,q]],{pnum,0,maxDerivativeOrder},{i,2,4}]~Join~
Table[\[CurlyTheta]ps[pnum][i][\[Lambda]_ var,q_]/;\[Lambda]<0:>Evaluate[(-1)^(pnum+1) \[CurlyTheta]ps[pnum][i][-\[Lambda] var,q]],{pnum,0,maxDerivativeOrder},{i,1,1}]~Join~
Table[\[CurlyTheta]ps[pnum][i][\[Lambda]_ var+x_,q_]/;\[Lambda]<0:>Evaluate[(-1)^pnum \[CurlyTheta]ps[pnum][i][-\[Lambda] var-x,q]],{pnum,0,maxDerivativeOrder},{i,2,4}]~Join~
Table[\[CurlyTheta]ps[pnum][i][\[Lambda]_ var+x_,q_]/;\[Lambda]<0:>Evaluate[(-1)^(pnum+1) \[CurlyTheta]ps[pnum][i][-\[Lambda] var-x,q]],{pnum,0,maxDerivativeOrder},{i,1,1}]
~Join~{EEE[k_][{
 {\[Alpha]_/;MemberQ[{1,-1},\[Alpha]]},
 {E^(\[Lambda]_ var+x_)}
}][q]:>(-1)^k EEE[k][{
 {\[Alpha]},
 {E^(-\[Lambda] var-x)}
}][q]/;\[Lambda]/(2\[Pi] I)<0}
~Join~{EEE[k_][{
 {\[Alpha]_/;MemberQ[{1,-1},\[Alpha]]},
 {E^(\[Lambda]_ var)}
}][q]:>(-1)^k EEE[k][{
 {\[Alpha]},
 {E^(-\[Lambda] var)}
}][q]/;\[Lambda]/(2\[Pi] I)<0}
~Join~{EEE[k_][{
 {\[Alpha]_/;MemberQ[{1,-1},\[Alpha]]},
 {var^\[Lambda]_ x_}
}][q]:>(-1)^k EEE[k][{
 {\[Alpha]},
 {var^-\[Lambda] x^-1}
}][q]/;\[Lambda]<0}
~Join~{EEE[k_][{
 {\[Alpha]_/;MemberQ[{1,-1},\[Alpha]]},
 {var^\[Lambda]_}
}][q]:>(-1)^k EEE[k][{
 {\[Alpha]},
 {var^-\[Lambda]}
}][q]/;\[Lambda]<0}
~Join~{EEE[k_][{
 {\[Alpha]_/;MemberQ[{1,-1},\[Alpha]]},
 {1/var}
}][q]:>(-1)^k EEE[k][{
 {\[Alpha]},
 {var}
}][q]}
//Flatten);
(f//\[CurlyTheta]Expand)/.EEE[k_][{
 {\[Alpha]_},
 {E^x_}
}][q]:>EEE[k][{
 {\[Alpha]},
 {E^(x//Expand)}
}][q]/.signRules
];

FlipSignAll\[ScriptB][f_]:=f//FlipSign[#][\[ScriptB][1]]&//FlipSign[#][\[ScriptB][2]]&//FlipSign[#][\[ScriptB][3]]&//FlipSign[#][\[ScriptB][4]]&//FlipSign[#][\[ScriptB][5]]&//FlipSign[#][\[ScriptB][6]]&//FlipSign[#][\[ScriptB][7]]&//FlipSign[#][\[ScriptB][8]]&//FlipSign[#][\[ScriptB][1]]&//FlipSign[#][\[ScriptB]]&;


