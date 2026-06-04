(* utilities.wls - Small utility functions *)
Clear[CoRootBasis]
CoRootBasis[w_]:=Table[ScalarProduct[w,simpleCoRoots[[i]]],{i,rankg}]

Clear[LongRoots,LengthSquare,SimpleRoots]
LengthSquare[w_,g_:\[ScriptG]]:=ScalarProduct[w,w];
LongRoots[g_:\[ScriptG]]:=Cases[PositiveRoots[g],x_/;LengthSquare[x,x]==2];
SimpleRoots[g_:\[ScriptG]]:=OrthogonalSimpleRoots[g]//OmegaBasis

Clear[Dynkin]
Dynkin[l__]:=Weight[\[ScriptG]//AlgebraClass][l];
