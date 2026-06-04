(* predicates.wls - Type-checking predicates for roots and weights *)
Clear[IsRoot,IsPositiveRoot,IsSimpleRoot,IsPositiveAffineRoot,IsRealAffineRoot,IsZeroWeight,IsPositiveRealAffineRoot]

IsWeight[\[Lambda]_]:=MatchQ[Head[\[Lambda]],Weight[_]]||MatchQ[Head[\[Lambda]],RootOmega[_]]||\[Lambda]==0;
IsZeroWeight[\[Lambda]_]:=(TrueQ[\[Lambda]==ConstantArray[0,rankg]//Simplify])||DynkinLabel[\[Lambda]]==ConstantArray[0,rankg]

IsRoot[\[Alpha]_]:=MemberQ[roots,\[Alpha]]||MemberQ[roots/.RootOmega->Weight,\[Alpha]]||MemberQ[rootsSTDBasis,\[Alpha]]
IsPositiveRoot[\[Alpha]_]:=MemberQ[positiveRoots,\[Alpha]]||MemberQ[positiveRoots/.RootOmega->Weight,\[Alpha]]||MemberQ[positiveRootsSTDBasis,\[Alpha]]
IsSimpleRoot[\[Alpha]_]:=MemberQ[simpleRoots,\[Alpha]]||MemberQ[simpleRoots/.RootOmega->Weight,\[Alpha]]||MemberQ[simpleRootsSTDBasis,\[Alpha]]

IsAffineRoot[\[Alpha]_]:=MatchQ[\[Alpha],{_,_,_}]&&(IsRoot[\[Alpha][[1]]]||IsZeroWeight[\[Alpha][[1]]]);
IsAffineWeight[\[Lambda]_]:=MatchQ[\[Lambda],{_,_,_}]&&IsWeight[\[Lambda][[1]]]

IsPositiveAffineRoot[\[Alpha]_]:=False;
IsPositiveAffineRoot[\[Alpha]_?IsAffineRoot]:=(IsPositiveRoot[\[Alpha][[1]]]&&\[Alpha][[3]]==0)||(IsRoot[\[Alpha][[1]]]&&\[Alpha][[3]]>=1)||(IsZeroWeight[\[Alpha][[1]]]&&\[Alpha][[3]]>=1)

IsRealAffineRoot[\[Alpha]_]:=False;
IsRealAffineRoot[\[Alpha]_?IsAffineRoot]:=!TrueQ[\[Alpha][[1]]!=0fundamentalWeights[[1]]]

IsPositiveRealAffineRoot[\[Alpha]_]:=False;
IsPositiveRealAffineRoot[\[Alpha]_?IsAffineRoot]:=IsPositiveAffineRoot[\[Alpha]]&&IsRealAffineRoot[\[Alpha]];
