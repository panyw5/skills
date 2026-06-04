(* matrices_BD.wls - Matrix representations for Type B, D, and D4 algebras *)

GetMatrices[Algebra[B][r_]]:=Module[{\[Delta]\[Delta]},
GetAlgebra[Algebra[B][r]];
\[Delta]\[Delta]=KroneckerDelta;
Hmatrix=Table[ArrayFlatten[({
 {Table[-I(\[Delta]\[Delta][j,2II-1]\[Delta]\[Delta][k,2II]-\[Delta]\[Delta][k,2II-1]\[Delta]\[Delta][j,2II]),{j,2r},{k,2r}], 0},
 {0, 0}
})],{II,rankg}];
Ematrices=Table[ArrayFlatten[({
 {KroneckerProduct[SparseArray[{{II,JJ}->1},r],({
   {1, I \[Eta]p},
   { I \[Eta], -\[Eta] \[Eta]p}
  })], 0},
 {0, 0}
})],
{II,r},{JJ,r},{\[Eta],-1,1,2},{\[Eta]p,-1,1,2}];
Ematrices=Table[Ematrices[[II,JJ,\[Eta],\[Eta]p]]-Transpose[Ematrices[[II,JJ,\[Eta],\[Eta]p]]],
{II,r},{JJ,II+1,r},{\[Eta],-1,1,2},{\[Eta]p,-1,1,2}]//Flatten[#,3]&;

Ematrices=Ematrices~Join~(Table[SparseArray[{{2II-1,2rankg+1}->1,{2rankg+1,2II-1}->-1,{2II,2rankg+1}->I \[Eta],{2rankg+1,2II}->-I \[Eta]}],{II,rankg},{\[Eta],-1,1,2}]//Flatten[#,1]&);

For[\[Alpha]=1,\[Alpha]<=4*(rankg(rankg-1))/2+2rankg,\[Alpha]++,
\[Alpha]\[Alpha]Sol=(Table[Hmatrix[[II]] . Ematrices[[\[Alpha]]]-Ematrices[[\[Alpha]]] . Hmatrix[[II]]-\[Alpha]\[Alpha][II]Ematrices[[\[Alpha]]],{II,rankg}]==0//Solve)[[1]];
EEmatrix[RootOrthogonal[B]@@(({Table[\[Alpha]\[Alpha][II],{II,rankg}]}/.\[Alpha]\[Alpha]Sol)[[1]])//OmegaBasis]=Ematrices[[\[Alpha]]];

EEmatrix[({Table[\[Alpha]\[Alpha][II],{II,rankg}]}/.\[Alpha]\[Alpha]Sol)[[1]]]=Ematrices[[\[Alpha]]];
];

rootsSTDBasis=Table[(roots[[\[Alpha]]]//OrthogonalBasis)/.{RootOrthogonal[B][l__]:>List[l]},{\[Alpha],Length[roots]}];
positiveRootsSTDBasis=Table[(positiveRoots[[\[Alpha]]]//OrthogonalBasis)/.{RootOrthogonal[B][l__]:>List[l]},{\[Alpha],Length[positiveRoots]}];
simpleRootsSTDBasis=Table[(simpleRoots[[\[Alpha]]]//OrthogonalBasis)/.{RootOrthogonal[B][l__]:>List[l]},{\[Alpha],Length[simpleRoots]}];

GetKillingForm[Hmatrix,EEmatrix];

simplecoRootsSTDBasis=Table[(2simpleRootsSTDBasis[[i]])/ScalarProduct[simpleRootsSTDBasis[[i]],simpleRootsSTDBasis[[i]]],{i,rankg}];

fundamentalWeightsSTDBasis=Inverse[CartanMatrix[\[ScriptG]]] . simpleRootsSTDBasis;

GetStructureConstants[Hmatrix,EEmatrix]
]/;r!=4



GetMatrices[D4]:=Module[{Commutator,NN,II,i,j,\[Alpha],$\[Lambda],hD4,ro1,ro2,lo1,lo2,r},
Print["GetMatrices[D4]"];
\[ScriptG]=D4;
r=4;

Commutator[X_,Y_]:=X . Y-Y . X;
Clear[Hmatrix,EEmatrix];

Hmatrix={DiagonalMatrix[{1/2,1/2,0,0,-1/2,-1/2,0,0}],DiagonalMatrix[{1/2,-1/2,0,0,-1/2,1/2,0,0}],DiagonalMatrix[{0,0,1/2,-1/2,0,0,-1/2,1/2}],DiagonalMatrix[{0,0,1/2,1/2,0,0,-1/2,-1/2}]};
ro1=Table[ArrayFlatten[{{Table[KroneckerDelta[k,i]KroneckerDelta[l,j],{k,1,4},{l,1,4}],0},{0,Table[-KroneckerDelta[k,j]KroneckerDelta[l,i],{k,1,4},{l,1,4}]}}],{i,1,3},{j,i+1,4}]//Flatten[#,1]&;
ro2=Table[ArrayFlatten[{{0,Table[KroneckerDelta[k,i]KroneckerDelta[l,j]-KroneckerDelta[k,j]KroneckerDelta[l,i],{k,1,4},{l,1,4}]},{Table[0,{m,1,4},{n,1,4}],0}}],{i,1,3},{j,i+1,4}]//Flatten[#,1]&;
lo1=Table[Transpose[ro1[[i]]],{i,1,6}];
lo2=Table[Transpose[ro2[[i]]],{i,1,6}];
J=Join[Hmatrix,ro1,ro2,lo1,lo2];
JC=Join[Hmatrix,1/2 lo1,1/2 lo2,1/2 ro1,1/2 ro2];
ladderOps=J[[r+1;;]];
ladderOpCs=JC[[r+1;;]];
rootsSTDBasis=Table[Table[Tr[(Hmatrix[[II]] . ladderOps[[\[Alpha]]]-ladderOps[[\[Alpha]]] . Hmatrix[[II]]) . ladderOpCs[[\[Alpha]]]],{II,r}],{\[Alpha],Length[ladderOps]}];
EEmatrix[\[Alpha]_]:=ladderOps[[Position[rootsSTDBasis,\[Alpha]][[1,1]]]];
EEmatrix[\[Alpha]_/;Head[\[Alpha]]==RootOmega[D]]:=EEmatrix[\[Alpha]//ToSTD];

positiveRootsSTDBasis=rootsSTDBasis[[1;;12]];
negativeRootsSTDBasis=rootsSTDBasis[[13;;24]];

simpleRootsSTDBasis={{0,1,0,0},{1/2,-1/2,-1/2,-1/2},{0,0,1,0},{0,0,0,1}};

GetKillingForm[Hmatrix,EEmatrix];

fundamentalWeightsSTDBasis=Inverse[CartanMatrix[\[ScriptG]]] . simpleRootsSTDBasis;
simplecoRootsSTDBasis=Table[(2simpleRootsSTDBasis[[i]])/ScalarProduct[simpleRootsSTDBasis[[i]],simpleRootsSTDBasis[[i]]],{i,rankg}];

GetStructureConstants[Hmatrix,EEmatrix]
];



GetMatrices[Algebra[D][r_]]:=Module[{\[Delta]\[Delta]},
GetAlgebra[Algebra[D][r]];
\[Delta]\[Delta]=KroneckerDelta;
Hmatrix=Table[Table[-I(\[Delta]\[Delta][j,2II-1]\[Delta]\[Delta][k,2II]-\[Delta]\[Delta][k,2II-1]\[Delta]\[Delta][j,2II]),{j,2r},{k,2r}],{II,rankg}];
Ematrices=Table[1/2 KroneckerProduct[SparseArray[{{II,JJ}->1},r],({
 {1, I \[Eta]p},
 { I \[Eta], -\[Eta] \[Eta]p}
})],
{II,r},{JJ,r},{\[Eta],-1,1,2},{\[Eta]p,-1,1,2}];
Ematrices=Table[Ematrices[[II,JJ,\[Eta],\[Eta]p]]-Transpose[Ematrices[[II,JJ,\[Eta],\[Eta]p]]],
{II,r},{JJ,II+1,r},{\[Eta],-1,1,2},{\[Eta]p,-1,1,2}]//Flatten[#,3]&;

For[\[Alpha]=1,\[Alpha]<=4*(rankg(rankg-1))/2,\[Alpha]++,
\[Alpha]\[Alpha]Sol=(Table[Hmatrix[[II]] . Ematrices[[\[Alpha]]]-Ematrices[[\[Alpha]]] . Hmatrix[[II]]-\[Alpha]\[Alpha][II]Ematrices[[\[Alpha]]],{II,rankg}]==0//Solve)[[1]];
EEmatrix[RootOrthogonal[D]@@(({Table[\[Alpha]\[Alpha][II],{II,rankg}]}/.\[Alpha]\[Alpha]Sol)[[1]])//OmegaBasis]=Ematrices[[\[Alpha]]];

EEmatrix[({Table[\[Alpha]\[Alpha][II],{II,rankg}]}/.\[Alpha]\[Alpha]Sol)[[1]]]=Ematrices[[\[Alpha]]];
];

rootsSTDBasis=Table[(roots[[\[Alpha]]]//OrthogonalBasis)/.{RootOrthogonal[D][l__]:>List[l]},{\[Alpha],Length[roots]}];
positiveRootsSTDBasis=Table[(positiveRoots[[\[Alpha]]]//OrthogonalBasis)/.{RootOrthogonal[D][l__]:>List[l]},{\[Alpha],Length[positiveRoots]}];
simpleRootsSTDBasis=Table[(simpleRoots[[\[Alpha]]]//OrthogonalBasis)/.{RootOrthogonal[D][l__]:>List[l]},{\[Alpha],Length[simpleRoots]}];

GetKillingForm[Hmatrix,EEmatrix];

simplecoRootsSTDBasis=Table[(2simpleRootsSTDBasis[[i]])/ScalarProduct[simpleRootsSTDBasis[[i]],simpleRootsSTDBasis[[i]]],{i,rankg}];

fundamentalWeightsSTDBasis=Inverse[CartanMatrix[\[ScriptG]]] . simpleRootsSTDBasis;

GetStructureConstants[Hmatrix,EEmatrix]
]/;r!=4
