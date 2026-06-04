(* load_all.wls - Master loader for Lie Algebras package *)
(* Load all modules in dependency order *)

SetDirectory[DirectoryName[$InputFileName]];

Get["init.wls"];
Get["algebra.wls"];
Get["utilities.wls"];
Get["predicates.wls"];
Get["affine.wls"];
Get["killing_form.wls"];
Get["translators.wls"];
Get["structure_constants.wls"];
Get["simplify.wls"];
Get["matrices_A.wls"];
Get["matrices_BD.wls"];
Get["matrices_EFG.wls"];
Get["weyl.wls"];
Get["representation.wls"];
Get["lattice.wls"];
