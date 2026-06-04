(* matrices_A.wls - Matrix representations for Type A algebras *)
Clear[GetMatrices]
GetMatrices[Algebra[A][r_]]:=Module[{Commutator,NN,II,i,j,\[Alpha],$\[Lambda],eqs,\[Alpha]components,sol},
Clear[Eij,Hmatrix,EEmatrix];

Print["GetMatrices"];
\[ScriptG]=Algebra[A][r];
rootsSTDBasis={};
simpleRootsSTDBasis={};
positiveRootsSTDBasis={};
simplecoRootsSTDBasis={};
fundamentalWeightsSTDBasis={};
NN=r+1;
Commutator[X_,Y_]:=X . Y-Y . X;


Eij[NN_][i_,j_]:=SparseArray[{{i,j}->1},{NN,NN}];
Hmatrix=Table[0,{II,r}];
For[II=1,II<=r,II++,
Hmatrix[[II]]=ArrayFlatten[({
 {IdentityMatrix[II], 0},
 {0, 0*IdentityMatrix[NN-II]}
})];
Hmatrix[[II]][[II+1,II+1]]=-II;
Hmatrix[[II]]=1/Sqrt[II+(-II)^2] Hmatrix[[II]];
];

For[i=1,i<=NN,i++,
For[j=i+1,j<=NN,j++,
eqs=Table[Commutator[Hmatrix[[II]],Eij[NN][i,j]]-\[Alpha][II]Eij[NN][i,j]==0,{II,1,r}]//Flatten;
\[Alpha]components=Table[\[Alpha][II],{II,1,r}];
sol=Solve[eqs,\[Alpha]components];
If[j==i+1,
simpleRootsSTDBasis=simpleRootsSTDBasis~Join~{\[Alpha]components/.sol[[1]]}//FullSimplify;
simplecoRootsSTDBasis=simpleRootsSTDBasis~Join~{2/(\[Alpha]components/.sol[[1]]) . (\[Alpha]components/.sol[[1]]) (\[Alpha]components/.sol[[1]])}//FullSimplify
];

EEmatrix[\[Alpha]components/.sol[[1]]]=Eij[NN][i,j]//FullSimplify;
rootsSTDBasis=rootsSTDBasis~Join~{\[Alpha]components/.sol[[1]]}//FullSimplify;
positiveRootsSTDBasis=positiveRootsSTDBasis~Join~{\[Alpha]components/.sol[[1]]}//FullSimplify;

];
];



For[i=1,i<=NN,i++,
For[j=1,j<=i-1,j++,
eqs=Table[Commutator[Hmatrix[[II]],Eij[NN][i,j]]-\[Alpha][II]Eij[NN][i,j]==0,{II,1,r}]//Flatten;
sol=Solve[eqs,Table[\[Alpha][II],{II,1,r}]];
rootsSTDBasis=rootsSTDBasis~Join~{Table[\[Alpha][II],{II,1,r}]/.sol[[1]]};
EEmatrix[\[Alpha]components/.sol[[1]]]=Eij[NN][i,j];
]
];
EEmatrix[\[Alpha]_/;IsRoot[\[Alpha]]]:=EEmatrix[\[Alpha]//ToSTD//Simplify];

GetKillingForm[Hmatrix,EEmatrix];


simplecoRootsSTDBasis=Table[(2simpleRootsSTDBasis[[i]])/ScalarProduct[simpleRootsSTDBasis[[i]],simpleRootsSTDBasis[[i]]],{i,rankg}];

fundamentalWeightsSTDBasis=Inverse[CartanMatrix[\[ScriptG]]] . simpleRootsSTDBasis;

GetStructureConstants[Hmatrix,EEmatrix];

Clear[CasimirChevalley,CasimirDChevalley];
CasimirChevalley[3][a_,b_,c_]:=CasimirChevalley[3][a,b,c]=Tr[($J[a] . $J[b]+$J[b] . $J[a]) . $J[c]]/.{$J[i_?IntegerQ]:>hChevalley[i],
$J[\[Alpha]_?IsRoot]:>EEmatrix[\[Alpha]]
};

CasimirDChevalley[3][a_,b_,c_]:=CasimirDChevalley[3][a,b,c]=Table[KillingFormDChevalley[a,ap]KillingFormDChevalley[b,bp]KillingFormDChevalley[c,cp]CasimirChevalley[3][ap,bp,cp],{ap,indices},{bp,indices},{cp,indices}]//Flatten//Total;
];
