(* structure_constants.wls - Structure constants computation *)
(* Based on [J^A,J^B] = f^AB_C (J^C) *)
GetStructureConstants[Hmatrix_,EEmatrix_]:=Module[{},
Clear[fabc,fabcChevalley];
fabc[a_,b_][c_]:=0;
fabc[II_/;1<=II<=rankg,\[Beta]_/;IsRoot[\[Beta]]][\[Gamma]_]:=\[Beta][[II]]KroneckerDelta[\[Beta],\[Gamma]];
fabc[\[Beta]_/;IsRoot[\[Beta]],II_/;1<=II<=rankg][\[Gamma]_]:=-\[Beta][[II]]KroneckerDelta[\[Beta],\[Gamma]];
fabc[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]][II_/;1<=II<=rankg]:=KillingForm[\[Alpha],-\[Alpha]]Sum[KDab[[II,JJ]]\[Alpha][[JJ]],{JJ,rankg}]/; \[Alpha]+\[Beta]==ConstantArray[0,rankg];

fabc[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]][\[Gamma]_]:=KillingForm[(EEmatrix[\[Alpha]] . EEmatrix[\[Beta]]-EEmatrix[\[Beta]] . EEmatrix[\[Alpha]]),EEmatrix[-\[Alpha]-\[Beta]//Simplify]]/KillingForm[\[Alpha]+\[Beta]//Simplify,-(\[Alpha]+\[Beta])//Simplify]/;IsRoot[\[Alpha]+\[Beta]//Simplify]&&(\[Alpha]+\[Beta]==\[Gamma]//Simplify);

fabcChevalley[a_,b_][c_]:=0;
fabcChevalley[i_/;1<=i<=rankg,\[Alpha]_/;IsRoot[\[Alpha]]][\[Gamma]_/;IsRoot[\[Gamma]]]:= If[TrueQ[\[Alpha]==\[Gamma]],1,0]*(2ScalarProduct[simpleRoots[[i]],\[Alpha]//ToLieArt])/ScalarProduct[simpleRoots[[i]],simpleRoots[[i]]];

fabcChevalley[\[Alpha]_/;IsRoot[\[Alpha]],i_/;1<=i<=rankg][\[Gamma]_/;IsRoot[\[Gamma]]]:=- If[TrueQ[\[Alpha]==\[Gamma]],1,0]*ScalarProduct[2simpleRoots[[i]],\[Alpha]//ToLieArt]/ScalarProduct[simpleRoots[[i]],simpleRoots[[i]]];

fabcChevalley[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]][i_/;1<=i<=rankg]:=(Heights[\[Alpha]])[[i]]KillingForm[\[Alpha],-\[Alpha]]*ScalarProduct[simpleRootsSTDBasis[[i]],simpleRootsSTDBasis[[i]]]/2/;(TrueQ[\[Alpha]+\[Beta]==ConstantArray[0,rankg]//Simplify]||DynkinLabel[\[Alpha]+\[Beta]]==ConstantArray[0,rankg]);

fabcChevalley[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]][\[Gamma]_]:= KillingForm[(EEmatrix[\[Alpha]] . EEmatrix[\[Beta]]-EEmatrix[\[Beta]] . EEmatrix[\[Alpha]]),EEmatrix[-\[Alpha]-\[Beta]//Simplify]]/KillingForm[\[Alpha]+\[Beta]//Simplify,-(\[Alpha]+\[Beta])//Simplify]/;IsRoot[\[Alpha]+\[Beta]//Simplify]&&(\[Alpha]+\[Beta]==\[Gamma]//Simplify);
fabcChevalley[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]][\[Gamma]_]:=0/;!IsRoot[\[Alpha]+\[Beta]//Simplify]||!TrueQ[\[Alpha]+\[Beta]==\[Gamma]//Simplify];

fabcChevalley[][a_,b_,c_]:=Sum[KillingFormDChevalley[a,ap]KillingFormDChevalley[b,bp]fabcChevalley[ap,bp][c],
{ap,Table[i,{i,rankg}]~Join~roots},{bp,Table[i,{i,rankg}]~Join~roots}
];

fabcChevalley[a_,b_,c_][]:=Sum[KillingFormChevalley[c,cp]fabcChevalley[a,b][cp],
{cp,Table[i,{i,rankg}]~Join~roots}
];

];
