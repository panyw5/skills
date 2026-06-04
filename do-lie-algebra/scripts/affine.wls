(* affine.wls - Affine Lie algebra initialization *)
Clear[GetAffineAlgebra]
GetAffineAlgebra[g_:A2]:=Module[{},
Clear[SimpleAffineRoot,FundamentalAffineWeight,rankAffineg];
GetAlgebra[g];
rankAffineg=Rank[g]+1;
SimpleAffineRoot[0]={-highestRoot,0,1};
SimpleAffineRoot[i_]:={simpleRoots[[i]],0,0};
finiteAffineRoots=Table[{\[Alpha],0,0},{\[Alpha],roots}];
FundamentalAffineWeight[0]={zeroWeight,1,0};
FundamentalAffineWeight[i_]:={fundamentalWeights[[i]],coMarks[[i]],0};
fundamentalAffineWeights=Table[FundamentalAffineWeight[i],{i,0,rankAffineg-1}];

simpleAffineRoots=Table[SimpleAffineRoot[i],{i,0,rankAffineg-1}];
\[Delta]={0fundamentalWeights[[1]],0,1};
\[Rho]hat=Sum[FundamentalAffineWeight[i],{i,0,rankg}];
affineHighestRoot={highestRoot,0,0};
ScalarProduct[\[Mu]_?IsAffineWeight,\[Nu]_?IsAffineWeight]:=ScalarProduct[\[Mu][[1]],\[Nu][[1]]]+\[Mu][[2]]\[Nu][[3]]+\[Mu][[3]]\[Nu][[2]];
];
