(* algebra.wls - GetAlgebra: initialize basic quantities for a Lie algebra *)
GetAlgebra[g_]:=Module[{$a,sols},
\[ScriptG]=g;
rankg=Rank[g];
simpleRoots=OrthogonalSimpleRoots[g]//OmegaBasis;

simpleCoRoots=Table[(2simpleRoots[[i]])/ScalarProduct[simpleRoots[[i]],simpleRoots[[i]]],{i,rankg}];
positiveRoots=PositiveRoots[g];
roots=positiveRoots~Join~(-positiveRoots);

fundamentalWeights=OrthogonalFundamentalWeights[g]//OmegaBasis;
sols=Table[ScalarProduct[Sum[$a[i][ip]fundamentalWeights[[ip]],{ip,rankg}],simpleRoots[[j]]]==KroneckerDelta[i,j],{j,rankg},{i,rankg}]//Simplify//Flatten//Solve;
fundamentalCoWeights=Table[Sum[$a[i][j]fundamentalWeights[[j]],{j,rankg}],{i,rankg}]/.sols[[1]];

highestRoot=HighestRoot[g];
WeylVector=1/2 Total[positiveRoots];
\[Rho]=WeylVector;

zeroWeight=0fundamentalWeights[[1]];

dimg=2NumberOfPositiveRoots[g]+rankg;

coMarks=Table[ScalarProduct[highestRoot,fundamentalWeights[[i]]],{i,rankg}];
hcheck=Total[coMarks]+1;


Clear[K];
K[II_/;II\[Element]Integers,JJ_\[Element]Integers]:=IdentityMatrix[rankg][[II,JJ]];
K[\[Alpha]_,\[Beta]_]:=0/;!TrueQ[\[Alpha]+\[Beta]==RootOmega[Head[\[ScriptG]][[1]]][0,0]];
K[\[Alpha]_,\[Beta]_]:=2/ScalarProduct[\[Alpha],\[Alpha]]/;TrueQ[\[Alpha]+\[Beta]==RootOmega[Head[\[ScriptG]][[1]]][0,0]];
];
