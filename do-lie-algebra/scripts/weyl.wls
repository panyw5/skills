(* weyl.wls - Weyl group operations and affine Weyl reflections *)

Clear[Weyl,WeylDot,ss];
Weyl[i_Integer][weight_]:=Reflect[weight,{simpleRoots[[i]]}][[1]];
WeylDot[i_Integer][weight_]:=Weyl[i][weight+WeylVector]-WeylVector;
WeylShifted[i_Integer][w_]:=WeylDot
Weyl[\[Alpha]_?(MatchQ[#,RootOmega[_][___]]&)][weight_]:=weight-ScalarProduct[weight,(2\[Alpha])/ScalarProduct[\[Alpha],\[Alpha]]]\[Alpha]

ss[i_][weight_]:=Weyl[simpleRoots[[i]]][weight]


Clear[WeylAffine]

WeylAffine[\[Alpha]_?IsAffineWeight][weight_?IsAffineWeight]:=weight-ScalarProduct[weight,(2\[Alpha])/ScalarProduct[\[Alpha],\[Alpha]]]\[Alpha];
WeylAffine[\[Alpha]_?IsWeight][weight_?IsWeight]:={weight,0,0}-ScalarProduct[weight,(2\[Alpha])/ScalarProduct[\[Alpha],\[Alpha]]]{\[Alpha],0,0}

WeylAffine[\[Alpha]_?IsWeight][weight_?IsAffineWeight]:=weight-ScalarProduct[weight[[1]],(2\[Alpha])/ScalarProduct[\[Alpha],\[Alpha]]]{\[Alpha],0,0};
WeylAffine[\[Alpha]_?IsAffineWeight][weight_?IsWeight]:={weight,0,0}-ScalarProduct[weight,(2\[Alpha][[1]])/ScalarProduct[\[Alpha][[1]],\[Alpha][[1]]]]\[Alpha]



(* Translation operator on affine weights *)
(* t_{\alpha^v} \hat{\lambda} = (\lambda + k\alpha^v; k; n - [(\lambda,\alpha^v) + k/2(\alpha^v,\alpha^v)]) *)
Translation[\[Alpha]check_?IsAffineWeight][weight_?IsAffineWeight]:=With[{\[Lambda]=weight[[1]],k=weight[[2]],n=weight[[3]]},
{\[Lambda]+k \[Alpha]check[[1]],
k,
n+(-ScalarProduct[\[Lambda],\[Alpha]check[[1]]]-k/2 ScalarProduct[\[Alpha]check[[1]],\[Alpha]check[[1]]])}
];
Translation[\[Alpha]check_?IsWeight][weight_?IsAffineWeight]:=Translation[{\[Alpha]check,0,0}][weight]


(* Weyl group for A_r as permutation matrices *)
WeylGroupAr[g_:\[ScriptG]]:=Module[
{permMatrix,WeylByPermutation,perms,tempfn,SignatureOfWeyl},
If[((g//Head)==Algebra[A])//TrueQ,True,Print["Not of type A"];Return[]];

permMatrix[perm_]:=Module[{temp},
temp=0IdentityMatrix[Length[perm]];
For[i=1,i<=Length[perm],i++,
temp[[i,perm[[i]]]]=1;
];
temp
];

WeylByPermutation[perm_][w_]:=Module[{wList},
wList=Table[(w//OrthogonalBasis)[[j]],{j,Length[perm]}];
WeightOrthogonal[A]@@(permMatrix[perm] . wList)
];

perms=Permutations[Table[i,{i,1,Rank[g]+1}]];

tempfn[i_]:=(WeylByPermutation[perms[[i]]][#]//OmegaBasis)&;
SignatureOfWeyl[i_]:=Det[permMatrix[perms[[i]]]];

Table[{tempfn[i],SignatureOfWeyl[i]},{i,Factorial[Rank[g]+1]}]

]
