(* lattice.wls - Root and coroot lattice generation *)

Clear[CoRootLattice,RootLattice]

RootLattice[g_:g,order_:order]:=Module[{DynamicLattice,rankg,range,simpleRoots},
rankg=Rank[g];
range=Table[{m[i],-order,order},{i,1,rankg}];
DynamicLattice[summand_][range__]:=Table[summand,range];
simpleRoots=OrthogonalSimpleRoots[g]//OmegaBasis;
DynamicLattice[Sum[m[i]coRoots[[i]],{i,rankg}]]@@range
]

CoRootLattice[g_:g,order_:order]:=Module[{DynamicLattice,rankg,range,coRoots},
rankg=Rank[g];
range=Table[{m[i],-order,order},{i,1,rankg}];
DynamicLattice[summand_][range__]:=Table[summand,range];
coRoots=OrthogonalSimpleCoRoots[g]//OmegaBasis;
DynamicLattice[Sum[m[i]coRoots[[i]],{i,rankg}]]@@range
]
