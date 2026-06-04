(* translators.wls - Conversions between LieART and STD basis *)
Clear[DynkinLabel,Heights];
DynkinLabel[w_/;Head[w]==List]:=Table[\[Lambda][i],{i,rankg}]/.Solve[Sum[\[Lambda][i]fundamentalWeightsSTDBasis[[i]],{i,rankg}]-w==ConstantArray[0,rankg],Table[\[Lambda][i],{i,rankg}]][[1]]//FullSimplify;

DynkinLabel[w_/;Head[Head[w]]==RootOmega]:=w/.RootOmega[x_]:>List
DynkinLabel[w_/;Head[Head[w]]==Weight]:=w/.Weight[x_]:>List


Heights[\[Alpha]_/;Head@Head@\[Alpha]==RootOmega]:=\[Alpha]//AlphaBasis;
Heights[\[Alpha]_/;Head@Head@\[Alpha]==Weight]:=\[Alpha]//AlphaBasis;

Heights[\[Alpha]_/;IsRoot[\[Alpha]]]:=Heights[\[Alpha]]=Table[m[i],{i,rankg}]/.Solve[Sum[m[i]simpleRootsSTDBasis[[i]],{i,rankg}]-\[Alpha]==ConstantArray[0,rankg],Table[m[i],{i,rankg}]][[1]]//FullSimplify;


Clear[ToLieArt,ToSTD]

ToLieArt[w_/;Head[w]==List]:=RootOmega[\[ScriptG]/.Algebra[t_][r_]:>t]@@(w//DynkinLabel);
ToLieArt[w_]:=w;

ToSTD[\[Lambda]_/;Head[Head[\[Lambda]]]==Weight]:=Sum[\[Lambda][[i]]fundamentalWeightsSTDBasis[[i]],{i,rankg}];
ToSTD[\[Lambda]_/;Head[Head[\[Lambda]]]==RootOmega]:=Sum[\[Lambda][[i]]fundamentalWeightsSTDBasis[[i]],{i,rankg}]
