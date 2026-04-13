(* ====================================================================== *)
(* Tau-derivative to z-derivative Conversion
(* DTauToDz *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
Clear[D\[Tau]ToDz]
D\[Tau]ToDz[f_]:=f//.{
D[EllipticTheta[i_,z_,qhalf_],qhalf_]:>(-(1/(4qhalf))D[EllipticTheta[i,zz,qhalf],{zz,2}]/.zz->z),
D[EllipticThetaPrime[i_,z_,qhalf_],qhalf_]:>(-(1/(4qhalf))D[EllipticThetaPrime[i,zz,qhalf],{zz,2}]/.{zz->z}),
\!\(\*SuperscriptBox[\(EllipticTheta\),
TagBox[
RowBox[{"(",
RowBox[{"0", ",", "m_", ",",
RowBox[{"n_", "/;",
RowBox[{"n", "\[GreaterEqual]", "1"}]}]}], ")"}],
Derivative],
MultilineFunction->None]\)[i_,z_,qhalf_]:>(D[-(1/(4qqhalf))D[\!\(\*SuperscriptBox[\(EllipticTheta\),
TagBox[
RowBox[{"(",
RowBox[{"0", ",", "m", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[i,zz,qqhalf],{zz,2}],{qqhalf,n-1}]/.{qqhalf->qhalf,zz->z}),
\!\(\*SuperscriptBox[\(EllipticThetaPrime\),
TagBox[
RowBox[{"(",
RowBox[{"0", ",", "m_", ",",
RowBox[{"n_", "/;",
RowBox[{"n", "\[GreaterEqual]", "1"}]}]}], ")"}],
Derivative],
MultilineFunction->None]\)[i_,z_,qhalf_]:>(D[-(1/(4qqhalf))D[\!\(\*SuperscriptBox[\(EllipticThetaPrime\),
TagBox[
RowBox[{"(",
RowBox[{"0", ",", "m", ",", "0"}], ")"}],
Derivative],
MultilineFunction->None]\)[i,zz,qqhalf],{zz,2}],{qqhalf,n-1}]/.{qqhalf->qhalf,zz->z})
}

