(* ====================================================================== *)
(* Flavored Modular Linear Differential Equation Generation
(* DerivativeComposition, UnflavoredMLDE, FMLDEGenAbstract, FMLDEGenSeries *) *)
(* ====================================================================== *)

(* ::Input::Initialization:: *)
Clear[FMLDEGenAbstract,FMLDEGenAbstractFull]


DerivativeComposition[exp_]:=(exp/.{MMDO[m_]^n_:>0,MMDO[m_]MMDO[n_]:>0}
//.{DDbi[i_]cch:>DDbi[i][1,cch],DDbi[i_]^n_ cch:>DDbi[i][n,cch],
DDb cch:>DDb[1,cch],DDb^n_ cch:>DDb[n,cch]}
//.{DDbi[i_]DDbi[j_][n_,f_]:>DDbi[i][1,DDbi[j][n,f]],DDbi[i_]^m_ DDbi[j_][n_,f_]:>DDbi[i][m,DDbi[j][n,f]]
}
//.{MMDO[n_]DDbi[i_][m_,f_]:>MMDO[n,DDbi[i][m,f]],
MMDO[n_]DDb[m_,f_]:>MMDO[n,DDb[m,f]]
}/.{MMDO[n_]cch:>MMDO[n,cch]}
);

UnflavoredMLDESL2ZGenAbs[nn_]:=Module[{},
MMDO[nn,cch]+Sum[If[4a+6b==2kk,aa[kk,a,b]EEi[4][q]^a EEi[6][q]^b MMDO[nn-kk,cch],0],{kk,1,nn},{a,0,kk},{b,0,kk}]/.{MMDO[0,cch]->cch}
];
UnflavoredMLDE\[CapitalGamma]02GenAbs[nn_]:=Module[{},
MMDO[nn,cch]+Sum[If[2c+4a==2kk,aa[kk,a,b]EEi[4][q]^a EEE[2][{
 {-1},
 {1}
}][q]^c MMDO[nn-kk,cch],0],{kk,1,nn},{a,0,kk},{c,0,kk}]/.{MMDO[0,cch]->cch}
];

(* generate FMLDE with Subscript[D, b], namely valid for one flavor fugacity *)
FMLDEGenAbstract[k_][seeds_]:=Module[{nn,combinations,raw,z},
raw=(k(E^(Sum[z^nn/nn Total[seeds/.{EEE[n_]->EEE[nn],EEi[n_]:>EEi[nn]}],{nn,1,40}]+z(DDb)+Sum[z^(2n)/(2n) MMDO[n],{n,1,20}]))//SeriesCoefficient[#,{z,0,k}]&)//Expand;

combinations=(((List@@raw)cch//DerivativeComposition)
/.{EEE[kk_/;OddQ[kk]][{
 {1},
 {1}
}][q]:>0,EEE[kk_/;OddQ[kk]][{
 {-1},
 {1}
}][q]:>0,EEi[kk_/;OddQ[kk]][q]:>0}
)//DeleteCases[#,0]&;
(Table[a[n]combinations[[n]],{n,Length[combinations]}]//Total)
];

(* generate FMLDE with Subscript[D, Subscript[b, 1]], ..., namely valid for multiple flavor fugacities *)
FMLDEGenAbstract[k_][seeds_,bList_]:=Module[{nn,combinations,raw,z},
raw=(k(E^(Sum[z^nn/nn Total[seeds/.{EEE[n_]->EEE[nn],EEi[n_]:>EEi[nn]}],{nn,1,40}]+z Sum[DDbi[i],{i,Length[bList]}]+Sum[z^(2n)/(2n) MMDO[n],{n,1,20}]))//SeriesCoefficient[#,{z,0,k}]&)//Expand;
combinations=(((List@@raw)cch//DerivativeComposition)
/.{EEE[kk_/;OddQ[kk]][{
 {1},
 {1}
}][q]:>0,EEE[kk_/;OddQ[kk]][{
 {-1},
 {1}
}][q]:>0,EEi[kk_/;OddQ[kk]][q]:>0}
)//DeleteCases[#,0]&;
(Table[a[n]combinations[[n]],{n,Length[combinations]}]//Total)
];

FMLDEGenAbstractQuasiJacobi[k_][seeds_,bList_]:=Module[{nn,combinations,raw,z},
raw=(k(E^(Sum[z^seed[[2]]/seed[[2]] seed[[1]],{seed, seeds}]+z Sum[DDbi[i],{i,Length[bList]}]+Sum[z^(2n)/(2n) MMDO[n],{n,1,20}]))//SeriesCoefficient[#,{z,0,k}]&)//Expand;
combinations=(((List@@raw)cch//DerivativeComposition)
/.{EEE[kk_/;OddQ[kk]][{
 {1},
 {1}
}][q]:>0,EEE[kk_/;OddQ[kk]][{
 {-1},
 {1}
}][q]:>0,EEi[kk_/;OddQ[kk]][q]:>0}
)//DeleteCases[#,0]&;
(Table[a[n]combinations[[n]],{n,Length[combinations]}]//Total)
];


FMLDEGenAbstractFull[k_][seeds_]:=Module[{nn,combinations,raw,z},
raw=(k(E^(Sum[z^nn/nn Total[seeds/.{EEE[n_]->EEE[nn],EEi[n_]:>EEi[nn]}],{nn,1,40}]+z(DDb)+Sum[z^(2n)/(2n) MMDO[n],{n,1,20}]))//SeriesCoefficient[#,{z,0,k}]&)//Expand;

combinations=((List@@raw)cch//.{Db^n_ cch:>DDb[n,cch],Db cch:>DDb[1,cch]}
/.{MMDO[n_]DDb[m_,cch]:>MMDO[n,DDb[m,cch]]}/.{MMDO[n_]cch:>MMDO[n,cch]}
//.{MMDO[m_]^n_:>0,MMDO[m_]MMDO[n_,cch_]:>0}
/.{EEE[kk_/;OddQ[kk]][{
 {1},
 {1}
}][q]:>0,EEE[kk_/;OddQ[kk]][{
 {-1},
 {1}
}][q]:>0,EEi[kk_/;OddQ[kk]][q]:>0}
)//DeleteCases[#,0]&;
(Table[a[n]combinations[[n]],{n,Length[combinations]}]//Total)
];
FMLDEGenSeries[k_][seeds_]:=FMLDEGenAbstract[k][seeds]/.{EEE->EE,EEi->Ei,cch->ch,MMDO->MDO,DDb->Db}//qSeries//Simplify

