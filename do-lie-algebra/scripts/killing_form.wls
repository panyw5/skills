(* killing_form.wls - Killing form computation *)
Clear[GetKillingForm];

ScalarProduct[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]]:=Sum[KDab[[II,JJ]]\[Alpha][[II]]\[Beta][[JJ]],{II,rankg},{JJ,rankg}];
ScalarProduct[\[Alpha]_/;(Head[\[Alpha]]==List)&&Length[\[Alpha]]==rankg,\[Beta]_/;(Head[\[Beta]]==List)&&Length[\[Beta]]==rankg]:=Sum[KDab[[II,JJ]]\[Alpha][[II]]\[Beta][[JJ]],{II,rankg},{JJ,rankg}];


GetKillingForm[Hmatrix_List,EEmatrix_]:=Module[{$\[Lambda]},
Print["Getting Killing form"];
Clear[IsMatrix];
Clear[KillingForm,KillingFormD,Kab,KDab,Kij,KDij,
KillingFormD,hChevalley,
KillingFormChevalley,KillingFormDChevalley];

CW=Table[Hmatrix[[II]],{II,rankg}]~Join~Table[EEmatrix[rootsSTDBasis[[i]]],{i,Length[rootsSTDBasis]}];

IsMatrix[X_]:=(Dimensions[X]==Dimensions[CW[[1]]]);

$\[Lambda]=($\[Lambda]/.Solve[
Table[
Sum[rootsSTDBasis[[i]][[II]]*rootsSTDBasis[[i]][[JJ]],{i,Length[rootsSTDBasis]}]-$\[Lambda] Tr[Hmatrix[[II]] . Hmatrix[[JJ]]],{II,rankg},{JJ,rankg}]==0IdentityMatrix[rankg],$\[Lambda]][[1]]);

KillingForm[X_/;IsMatrix[X],Y_/;IsMatrix[Y]]:=$\[Lambda]/(2hcheck) Tr[X . Y];
KillingForm[II_/;1<=II<=rankg,JJ_/;1<=JJ<=rankg]:=KillingForm[Hmatrix[[II]],Hmatrix[[JJ]]];
KillingForm[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]]:=KillingForm[EEmatrix[\[Alpha]],EEmatrix[\[Beta]]];
KillingForm[II_/;1<=II<=rankg,\[Beta]_/;IsRoot[\[Beta]]]:=0;
KillingForm[\[Beta]_/;IsRoot[\[Beta]],II_/;1<=II<=rankg]:=0;


Kab=Table[KillingForm[CW[[a]],CW[[b]]],{a,dimg},{b,dimg}];
KDab=Kab//Inverse;

KillingFormD[II_/;1<=II<=rankg,JJ_/;1<=JJ<=rankg]:=KDab[[II,JJ]];
KillingFormD[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]]:=KDab[[Position[CW,EEmatrix[\[Alpha]]][[1,1]],Position[CW,EEmatrix[\[Beta]]][[1,1]]]];
KillingFormD[II_/;1<=II<=rankg,\[Beta]_/;IsRoot[\[Beta]]]:=0;
KillingFormD[\[Beta]_/;IsRoot[\[Beta]],II_/;1<=II<=rankg]:=0;

hChevalley[i_/;1<=i<=rankg]:=(2Sum[KDab[[II,JJ]]simpleRootsSTDBasis[[i]][[II]]Hmatrix[[JJ]],{II,rankg},{JJ,rankg}])/ScalarProduct[simpleRootsSTDBasis[[i]],simpleRootsSTDBasis[[i]]];
Kij=Table[$\[Lambda]/(2hcheck) Tr[hChevalley[i] . hChevalley[j]],{i,rankg},{j,rankg}];

KillingFormChevalley[i_/;1<=i<=rankg,j_/;1<=j<=rankg]:=KillingFormChevalley[i,j]=Kij[[i,j]];
KillingFormChevalley[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]]:=KillingFormChevalley[\[Alpha],\[Beta]]=KillingForm[\[Alpha],\[Beta]];
KillingFormChevalley[i_/;1<=i<=rankg,\[Alpha]_/;IsRoot[\[Alpha]]]:=0;
KillingFormChevalley[\[Alpha]_/;IsRoot[\[Alpha]],i_/;1<=i<=rankg]:=0;
KDij=Inverse[Kij];
KillingFormDChevalley[i_/;1<=i<=rankg,j_/;1<=j<=rankg]:=KillingFormDChevalley[i,j]=KDij[[i,j]];
KillingFormDChevalley[\[Alpha]_/;IsRoot[\[Alpha]],\[Beta]_/;IsRoot[\[Beta]]]:=KillingFormDChevalley[\[Alpha],\[Beta]]=KillingFormD[\[Alpha],\[Beta]];
KillingFormDChevalley[i_/;1<=i<=rankg,\[Alpha]_/;IsRoot[\[Alpha]]]:=KillingFormDChevalley[i,\[Alpha]]=0;
KillingFormDChevalley[\[Alpha]_/;IsRoot[\[Alpha]],i_/;1<=i<=rankg]:=KillingFormDChevalley[\[Alpha],i]=0
];
