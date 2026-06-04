(* representation.wls - Irreducible representations and quantum dimension *)

Irrep[a_/;(a//Head//Head)==Algebra][label__]:=If[Length[List[label]]==Rank[a],Irrep[a//AlgebraClass][label],Text["Algebra rank != Dynkin label length"]];

Irrep[a_/;(a//Head//Head)==Algebra][label__]:=If[Length[List[label]]==Rank[a],Irrep[a//AlgebraClass][label],Text["Algebra rank != Dynkin label length"]];

Irrep[a_/;(a//Head//Head)==Algebra][label_/;Head[label]==List]:=If[
Length[label]==Rank[a],
Irrep[a//AlgebraClass]@@label,
Text["Algebra rank != Dynkin label length"]];

Irrep[a_/;(a//Head//Head)==Algebra][label_/;MemberQ[{RootOmega,Weight},Head[Head[label]]]]:=Module[{DynkinLabelList},
DynkinLabelList=Table[label[[i]],{i,rankg}];
Irrep[a][DynkinLabelList]
];

Irrep[a_/;MemberQ[{E6,E7,E8,G2,F4},a]][label_/;MemberQ[{RootOmega,Weight},Head[Head[label]]]]:=Module[{DynkinLabelList},

DynkinLabelList=Table[label[[i]],{i,rankg}];
If[Length[DynkinLabelList]==Rank[a],
Irrep[a]@@DynkinLabelList,
Text["Algebra rank != Dynkin label length"]]

];


(* Quantum dimension *)
Dimq[\[Lambda]_][q_]:=Product[(q^(ScalarProduct[\[Lambda]+WeylVector,positiveRoots[[i]]]/2)-q^(-(ScalarProduct[\[Lambda]+WeylVector,positiveRoots[[i]]]/2)))/(q^(ScalarProduct[WeylVector,positiveRoots[[i]]]/2)-q^(-(ScalarProduct[WeylVector,positiveRoots[[i]]]/2))),{i,Length[positiveRoots]}]
