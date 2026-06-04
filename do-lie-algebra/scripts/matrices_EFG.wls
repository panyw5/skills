(* matrices_EFG.wls - Matrix representations for Type G2, F4, E6, E7 algebras *)

GetMatrices[G2]:=Module[{Commutator,NN,II,i,j,\[Alpha],$\[Lambda],$$\[Lambda],hD4,ro1,ro2,lo1,lo2,a,b,\[Lambda],r,J,JJx,JJy,sols,Esols},
\[ScriptG]=G2;
GetAlgebra[\[ScriptG]];
r=rankg;
Commutator[X_,Y_]:=X . Y-Y . X;
Clear[Hmatrix];
J=({
 {0, x[3], -x[2], x[5], -x[4], -x[7], -x[6]+y[6]},
 {-x[3], 0, x[1], x[6], -x[7]+y[7], x[4]-y[4], x[5]+y[5]},
 {x[2], -x[1], 0, -y[7], y[6], y[5], y[4]},
 {-x[5], -x[6], y[7], 0, -x[1]+y[1], -x[2]+y[2], -x[3]+y[3]},
 {x[4], x[7]-y[7], -y[6], x[1]-y[1], 0, y[3], -y[2]},
 {x[7], -x[4]+y[4], -y[5], x[2]-y[2], -y[3], 0, y[1]},
 {x[6]-y[6], -x[5]-y[5], -y[4], x[3]-y[3], y[2], -y[1], 0}
});
JJx[a_]:=Coefficient[J,x[a]];
JJy[a_]:=Coefficient[J,y[a]];

Clear[sols];

Hmatrix={I JJx[1],I JJy[1]};
sols=Solve[{
Commutator[Hmatrix[[1]],Sum[a[i]JJx[i]+b[i]JJy[i],{i,7}]]==\[Lambda][1] (Sum[a[i]JJx[i]+b[i]JJy[i],{i,7}]),
Commutator[Hmatrix[[2]],Sum[a[i]JJx[i]+b[i]JJy[i],{i,7}]]==\[Lambda][2] (Sum[a[i]JJx[i]+b[i]JJy[i],{i,7}])},Table[a[i],{i,7}]~Join~Table[b[i],{i,7}]~Join~{\[Lambda][1],\[Lambda][2]}];
Esols=Table[(Sum[a[i]JJx[i]+b[i]JJy[i],{i,7}]/.sols[[k]]),{k,Length[sols]}];
Ematrices=Join@@Table[(Table[Esols[[s]]//SeriesCoefficient[#,{a[i],0,1}]&,{i,7}])~Join~(Table[Esols[[s]]//SeriesCoefficient[#,{b[i],0,1}]&,{i,7}])//DeleteCases[#,0IdentityMatrix[7]]&,{s,Length[Esols]}];
rootsSTDBasis={};

For[i=1,i<15,i++,

rootSol=Solve[{Commutator[Hmatrix[[1]],Ematrices[[i]]]-\[Alpha][1]Ematrices[[i]]==0IdentityMatrix[7],
Commutator[Hmatrix[[2]],Ematrices[[i]]]-\[Alpha][2]Ematrices[[i]]==0IdentityMatrix[7]
}];

If[({\[Alpha][1],\[Alpha][2]}/.rootSol[[1]])!={0,0},
rootsSTDBasis=rootsSTDBasis~Join~({{\[Alpha][1],\[Alpha][2]}/.rootSol[[1]]});
EEmatrix[{\[Alpha][1],\[Alpha][2]}/.rootSol[[1]]//Simplify]=Ematrices[[i]]
]
];
EEmatrix[\[Alpha]_/;Head[\[Alpha]]==RootOmega[\[ScriptG]]]:=EEmatrix[\[Alpha]//ToSTD];
positiveRootsSTDBasis=Select[rootsSTDBasis,(#[[1]]>0)||(#[[1]]==0&&#[[2]]>0)&];
negativeRootsSTDBasis=Select[rootsSTDBasis,(#[[1]]<0)||(#[[1]]==0&&#[[2]]<0)&];
simpleRootsSTDBasis={positiveRootsSTDBasis[[5]],positiveRootsSTDBasis[[1]]};

GetKillingForm[Hmatrix,EEmatrix];

fundamentalWeightsSTDBasis=Inverse[CartanMatrix[\[ScriptG]]] . simpleRootsSTDBasis;
simplecoRootsSTDBasis=Table[(2simpleRootsSTDBasis[[i]])/ScalarProduct[simpleRootsSTDBasis[[i]],simpleRootsSTDBasis[[i]]],{i,rankg}];

GetStructureConstants[Hmatrix,EEmatrix]
];


GetMatrices[F4]:=Module[{NN,II,i,j,\[Alpha],$\[Lambda],$$\[Lambda],hD4,ro1,ro2,lo1,lo2,a,b,\[Lambda],r,Timer},
\[ScriptG]=F4;
GetAlgebra[\[ScriptG]];
r=rankg;
Commutator[X_,Y_]:=X . Y-Y . X;

SetDirectory[NotebookDirectory[]];
F4EMatrices=Import["F4EMatrices.txt"]//ToExpression//SparseArray;
F4e=Import["F4e.txt"]//ToExpression//SparseArray;

Hmatrix=Import["F4H.txt"]//ToExpression//SparseArray;

Ematrices=F4EMatrices;


rootsSTDBasis={};


For[i=1,i<=Length[Ematrices],i++,
rootSol=Solve[
Table[Commutator[Hmatrix[[II]],Ematrices[[i]]]-\[Alpha][II]Ematrices[[i]]==0Hmatrix[[II]],{II,rankg}]//Normal
];

If[(Table[\[Alpha][II],{II,rankg}]/.rootSol[[1]])!={0,0},
rootsSTDBasis=rootsSTDBasis~Join~({Table[\[Alpha][II],{II,rankg}]/.rootSol[[1]]});
EEmatrix[Table[\[Alpha][II],{II,rankg}]/.rootSol[[1]]//Simplify]=Ematrices[[i]]
];
];
EEmatrix[\[Alpha]_/;IsRoot[\[Alpha]]]:=EEmatrix[\[Alpha]//ToSTD];

positiveRootsSTDBasis=Select[rootsSTDBasis,(#[[1]]>0)||(#[[1]]==0&&#[[2]]>0)&];
negativeRootsSTDBasis=Select[rootsSTDBasis,(#[[1]]<0)||(#[[1]]==0&&#[[2]]<0)&];

simpleRootsSTDBasis=Table[Table[\[Alpha][i],{i,rankg}]/.(Table[Commutator[Hmatrix[[II]],F4e[[i]]]-\[Alpha][II]F4e[[i]]==0Hmatrix[[II]]//Normal,{II,rankg}]//Solve)[[1]],{i,rankg}];

GetKillingForm[Hmatrix,EEmatrix];

fundamentalWeightsSTDBasis=Inverse[CartanMatrix[\[ScriptG]]] . simpleRootsSTDBasis;
simplecoRootsSTDBasis=Table[(2simpleRootsSTDBasis[[i]])/ScalarProduct[simpleRootsSTDBasis[[i]],simpleRootsSTDBasis[[i]]],{i,rankg}];

GetStructureConstants[Hmatrix,EEmatrix];
];


GetMatrices[E6]:=Module[{Commutator,NN,II,i,j,\[Alpha],$\[Lambda],$$\[Lambda],hD4,ro1,ro2,lo1,lo2,a,b,\[Lambda],
GetAlphaiSequences,GetEMatrices,$counter,$E,r
},
Clear[IsMatrix];
IsMatrix[X_]:=(Dimensions[X]==Dimensions[hChevalley[1]]);

\[ScriptG]=E6;
GetAlgebra[\[ScriptG]];
r=rankg;
Commutator[X_,Y_]:=X . Y-Y . X;
SetDirectory[NotebookDirectory[]];

<<E6e.mx;
<<E6f.mx;
<<E6h.mx;
Clear[hChevalley];
hChevalley[i_]:=E6h[[i]];

Clear[EEmatrix];
For[i=1,i<rankg+1,i++,
EEmatrix[simpleRoots[[i]]]=E6e[[i]];
EEmatrix[-simpleRoots[[i]]]=E6f[[i]];
];

Clear[GetAlphaiSequences,GetEMatrices];
GetAlphaiSequences[m_/;m!=ConstantArray[0,6]&&AllTrue[m,#>=0&]]:=Module[{},
(Table[ConstantArray[i,m[[i]]],{i,rankg}]//Flatten//DeleteDuplicates)~Join~(GetAlphaiSequences[Map[Function[x,If[x>0,x-1,x]],m]]//RandomSample)
];

GetAlphaiSequences[m_/;m!=ConstantArray[0,6]&&AllTrue[m,#<=0&]]:=Module[{},
(Table[ConstantArray[-i,-m[[i]]],{i,rankg}]//Flatten//DeleteDuplicates)~Join~(GetAlphaiSequences[Map[Function[x,If[x<0,x+1,x]],m]]//RandomSample)
];

GetAlphaiSequences[\[Alpha]_/;\[Alpha]==ConstantArray[0,6]]:={};

GetEMatrices[m_/;m!=ConstantArray[0,6]&&AllTrue[m,#>=0&]]:=Module[{EList,is},
is=GetAlphaiSequences[m];
EList=Table[E6e[[is[[j]]]],{j,Length[is]}];
Fold[Commutator,EList[[1]],EList[[2;;-1]]]
];

GetEMatrices[m_/;m!=ConstantArray[0,6]&&AllTrue[m,#<=0&]]:=Module[{EList,is},
is=GetAlphaiSequences[m];
EList=Table[E6f[[-is[[j]]]],{j,Length[is]}];
Fold[Commutator,EList[[1]],EList[[2;;-1]]]
];


For[i=1,i<dimg-rankg+1,i++,

$counter=0;

While[!TrueQ[Head[EEmatrix[roots[[i]]]]==SparseArray]&&$counter<100,
$E=GetEMatrices[(roots//AlphaBasis)[[i]]/.{RootAlpha[E6][x___]:>List[x]}];


If[TrueQ[Head[$E]==SparseArray]&&($E//Normal//Simplify)!=ConstantArray[0,{dimg,dimg}],
EEmatrix[roots[[i]]]=$E;
];
$counter=$counter+1;
];
];
EEmatrix[\[Alpha]_/;IsRoot[\[Alpha]]]:=EEmatrix[\[Alpha]//ToSTD];

Clear[Kij,KDij];
Kij=Table[ScalarProduct[simpleCoRoots[[i]],simpleCoRoots[[j]]],{i,rankg},{j,rankg}];
KDij=Inverse[Kij];

Clear[KillingForm,KillingFormD];
KillingForm[X_/;IsMatrix[X],Y_/;IsMatrix[Y]]:=1/(2hcheck) Tr[X . Y];
KillingForm[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]]:=1/(2hcheck) Tr[EEmatrix[\[Alpha]] . EEmatrix[\[Beta]]]//Simplify;

KillingFormD[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]]:=1/KillingForm[\[Alpha],\[Beta]]/;((\[Alpha]+\[Beta]==ConstantArray[0,rankg]//Simplify)||(\[Alpha]+\[Beta]/.RootOmega[E6]->List)==ConstantArray[0,rankg]);
KillingFormD[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]]:=0;


Clear[fabcChevalley];
fabcChevalley[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]][i_/;1<=i<=rankg]:=((\[Alpha]//AlphaBasis)[[i]] KillingForm[\[Alpha],-\[Alpha]]/2 ScalarProduct[simpleRoots[[i]],simpleRoots[[i]]])/;(\[Alpha]+\[Beta]==ConstantArray[0,rankg]//Simplify)||(\[Alpha]+\[Beta]/.RootOmega[E6]->List)==ConstantArray[0,rankg];

fabcChevalley[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]][\[Gamma]_]:=KillingForm[(EEmatrix[\[Alpha]] . EEmatrix[\[Beta]]-EEmatrix[\[Beta]] . EEmatrix[\[Alpha]]),EEmatrix[-\[Alpha]-\[Beta]//Simplify]]/KillingForm[\[Alpha]+\[Beta]//Simplify,-(\[Alpha]+\[Beta])//Simplify]/;IsRoot[\[Alpha]+\[Beta]//Simplify]&&(\[Alpha]+\[Beta]==\[Gamma]//Simplify);

fabcChevalley[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]][\[Gamma]_]:=0/;!IsRoot[\[Alpha]+\[Beta]//Simplify]||(\[Alpha]+\[Beta]!=\[Gamma]//Simplify);

];


GetMatrices[E7]:=Module[{NN,II,i,j,\[Alpha],$\[Lambda],$$\[Lambda],hD4,ro1,ro2,lo1,lo2,a,b,\[Lambda],r,Timer},
\[ScriptG]=E7;
GetAlgebra[\[ScriptG]];
r=rankg;
Commutator[X_,Y_]:=X . Y-Y . X;

SetDirectory[NotebookDirectory[]];
E7Matrices=Import["E7Matrices.txt"]//ToExpression//SparseArray;
E7e=Import["E7e.txt"]//ToExpression//SparseArray;
E7e={E7e[[1]]}~Join~E7e[[3;;7]]~Join~{E7e[[2]]};
Hmatrix=E7Matrices[[1;;rankg]];

Ematrices=E7Matrices[[rankg+1;;dimg]];


rootsSTDBasis={};


For[i=1,i<=Length[Ematrices],i++,
rootSol=Solve[
Table[Commutator[Hmatrix[[II]],Ematrices[[i]]]-\[Alpha][II]Ematrices[[i]]==0Hmatrix[[II]],{II,rankg}]//Normal
];
If[(Table[\[Alpha][II],{II,rankg}]/.rootSol[[1]])!={0,0},
rootsSTDBasis=rootsSTDBasis~Join~({Table[\[Alpha][II],{II,rankg}]/.rootSol[[1]]});
EEmatrix[Table[\[Alpha][II],{II,rankg}]/.rootSol[[1]]//Simplify]=Ematrices[[i]]
]
];
EEmatrix[\[Alpha]_/;IsRoot[\[Alpha]]]:=EEmatrix[\[Alpha]//ToSTD];

positiveRootsSTDBasis=Select[rootsSTDBasis,(#[[1]]>0)||(#[[1]]==0&&#[[2]]>0)&];
negativeRootsSTDBasis=Select[rootsSTDBasis,(#[[1]]<0)||(#[[1]]==0&&#[[2]]<0)&];
simpleRootsSTDBasis=Table[Table[\[Alpha][i],{i,rankg}]/.(Table[Commutator[Hmatrix[[II]],E7e[[i]]]-\[Alpha][II]E7e[[i]]==0Hmatrix[[II]]//Normal,{II,rankg}]//Solve)[[1]],{i,rankg}];

Hmatrix=Table[Hmatrix[[i]],{i,rankg}];
GetKillingForm[Hmatrix,EEmatrix];

fundamentalWeightsSTDBasis=Inverse[CartanMatrix[\[ScriptG]]] . simpleRootsSTDBasis;
simplecoRootsSTDBasis=Table[(2simpleRootsSTDBasis[[i]])/ScalarProduct[simpleRootsSTDBasis[[i]],simpleRootsSTDBasis[[i]]],{i,rankg}];

GetStructureConstants[Hmatrix,EEmatrix];
]
