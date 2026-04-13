(* ====================================================================== *)
(* Simplification Utilities
(* simplifyArgs, simplify *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
Clear[simplifyArgs]
Clear[simplify]
simplifyArgs[g_]:=g/.{f_[x_]:>f[x//Expand]};

simplify[f_]:=f/.Table[
(* Subscript[\[CurlyTheta], 1]^(2l)(0) = 0 *)
Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",2ll])][1][0,q_]:>0,{ll,0,maxDerivativeOrder}
]~Join~Table[
(* Subscript[\[CurlyTheta], 1]^(2l)(0) = 0, note that \[CurlyTheta][1][\[Tau],q^n]\[NotEqual]0 *)
Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",2ll])][1][m_+n_. \[Tau],q]/;IntegerQ[m]&&IntegerQ[n]:>0,{ll,0,maxDerivativeOrder}
]~Join~Table[
(* Subscript[\[CurlyTheta], 1]^(2l)(0) = 0 *)
Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",2ll])][1][n_. \[Tau],q]/;IntegerQ[n]:>0,{ll,0,maxDerivativeOrder}
]~Join~Table[
(* Subscript[\[CurlyTheta], 1]^(2l)(0) = 0 *)
Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",2ll])][1][m_,q_]/;IntegerQ[m]:>0,{ll,0,maxDerivativeOrder}
]~Join~Table[
Symbol[StringJoin@@("\[CurlyTheta]"<>ConstantArray["p",2ll+1])][i_][0,q_]/;MemberQ[{2,3,4},i]:>0,{ll,0,maxDerivativeOrder}
](* Subscript[\[CurlyTheta], 2,3,4]^(2l+1)(0) = 0 *);

