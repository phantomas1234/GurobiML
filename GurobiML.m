(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



SetDirectory[StringReplace[FindFile["GurobiML`"],"Kernel/init.m"->""]];
Uninstall[gurobiMLlink];
gurobiMLlink=Install["GurobiML/GurobiML"];
ResetDirectory[];


BeginPackage["GurobiML`GurobiML`"];


GurobiSolve::usage="GurobiSolve provides the same function signature as Mathematica's own LinearProgramming function (check Mathematica's Help Center for documentation on how to use LinearProgramming).";


matrix2compressedSparseRow::usage="matrix2compressedSparseRow[matrix] translates matrix into condensed sparse row format (as described in Gurobi documentation).";


matrix2sparse::usage="matrix2sparse[matrix] returns rowID, colID, Values ...";


GurobiSolveMinimaMaxima::usage="...";


Begin["`Private`"];


GurobiML::badargs="There is no definition for '``' applicable to ``."


matrix2compressedSparseRow[mat_?MatrixQ]:=Module[{rind,cind,cval,cbeg},
{rind,cind,cval}=Transpose[ArrayRules[SparseArray[mat]][[;;-2]]/.r_Rule:>Append[r[[1]],r[[2]]]];
cbeg=Prepend[Accumulate[Tally[rind][[All,2]]][[;;-2]],0];
{cbeg,cind-1,cval}
];
matrix2sparse[mat_?MatrixQ]:=Transpose[Append[#[[1]]-1,#[[2]]]&/@ArrayRules[SparseArray[mat]][[;;-2]]]


Unprotect[GurobiSolve];
GurobiSolve::objerror="Objective function `1` is wrongly specified. Needs to be either a list of coefficients (LP/MIP), a matrix representing quadratic terms in compressed sparse row format (QP), or both ({{_?NumberQ..}, _MatrixQ}).";
GurobiSolve::rhserror="Righthand sides `1` are wrongly specified.";
GurobiSolve::bndserror="Variable bounds `1` are wrongly specified.";
GurobiSolve::domerror="Problem with domain specification `1`.";
GurobiSolve::lowlevelmessage="Gurobi interface returned the following status: `1`.";
GurobiSolve[c:({_?NumberQ..}|_?MatrixQ|{{_?NumberQ..},_?MatrixQ}),m_?MatrixQ,b:({_?NumberQ..}|{{_?NumberQ,(-1|-1.|0|0.|1|1.)}..}):{},l:({(_?NumberQ|-\[Infinity]|\[Infinity])..}|{{(_?NumberQ|-\[Infinity]|\[Infinity]),(_?NumberQ|-\[Infinity]|\[Infinity])}..}):{},
dom:(Integers|Reals|{(Integers|Reals)..}):Reals]:=Module[{procRhs,procDom,lb,ub,senses,cbeg,cind,cval,lClean},
{cbeg,cind,cval}=matrix2compressedSparseRow[m];
senses="";
Piecewise[{
{procRhs={},b=={}},
{procRhs=b,MatchQ[b,{_?NumberQ..}]},
{{procRhs,senses}={b[[All,1]],StringJoin[Sequence@@(b[[All,2]]/.{(0|0.)->"=",(-1|-1.)->"<",(1|1.)->">"})]},MatchQ[b,{{_?NumberQ,(-1|-1.|0|0.|1|1.)}..}]}
},Message[GurobiSolve::rhserror,b]];
(*Print["RHS: ",procRhs];
Print["Senses: ",senses];*)
lClean=l/.{-\[Infinity]->-10000,\[Infinity]->10000};
Piecewise[{
{{lb,ub}={{},{}},lClean=={}},
{{lb,ub}={lClean,{}},MatchQ[lClean,{_?NumberQ..}]},
{{lb,ub}=Transpose[lClean],MatchQ[lClean,{{_?NumberQ,_?NumberQ}..}]}
},Message[GurobiSolve::bndserror,lClean]];
(*Print["Lower bounds: ",lb," Upper bounds: ",ub];*)
Piecewise[{
{procDom="NULL",dom==Reals},
{procDom=StringJoin[Sequence@@Table["I",{Length[c]}]],dom==Integers},
{procDom=StringJoin[Sequence@@(dom/.{Integers->"I",Reals->"C"})],MatchQ[dom,{(Integers|Reals)..}]}
},Message[GurobiSolve::domerror,dom]];
(*GurobiML`GurobiML`GurobiSolveLowLevel[c,lb,ub,cbeg, cind, N@cval,procRhs,senses,procDom][[2]]*)
If[MatchQ[#,_List],#[[2]],Message[GurobiSolve::lowlevelmessage,#];Abort[];]&@
Switch[c,
_?MatrixQ,
GurobiML`GurobiML`GurobiSolveLowLevel[Array[0&,Length[Transpose[m]]],lb,ub,cbeg, cind, N@cval,procRhs,senses,procDom,Sequence@@matrix2sparse[c]],
{_?NumberQ..},
GurobiML`GurobiML`GurobiSolveLowLevel[c,lb,ub,cbeg, cind, N@cval,procRhs,senses,procDom,(*qrow*){},(*qcol*){},(*qval*){}],
{{_?NumberQ..},_?MatrixQ},
GurobiML`GurobiML`GurobiSolveLowLevel[c[[1]],lb,ub,cbeg, cind, N@cval,procRhs,senses,procDom,Sequence@@matrix2sparse[c[[2]]]],
_,
Message[GurobiSolve::objerror,c];Abort[];
]
];
def:GurobiSolve[___]:=(Message[GurobiML::badargs,GurobiSolve,Defer@def];Abort[])
Protect[GurobiSolve];


Unprotect[GurobiSolveMinimaMaxima];
GurobiSolveMinimaMaxima::rhserror="Righthand sides `1` are wrongly specified.";
GurobiSolveMinimaMaxima::bndserror="Variable bounds `1` are wrongly specified.";
GurobiSolveMinimaMaxima::domerror="Problem with domain specification `1`.";
GurobiSolveMinimaMaxima::lowlevelmessage="Gurobi interface returned the following status: `1`.";
GurobiSolveMinimaMaxima[m_?MatrixQ,b:({_?NumberQ..}|{{_?NumberQ,(-1|-1.|0|0.|1|1.)}..}):{},l:({(_?NumberQ|-\[Infinity]|\[Infinity])..}|{{(_?NumberQ|-\[Infinity]|\[Infinity]),(_?NumberQ|-\[Infinity]|\[Infinity])}..}):{},
dom:(Integers|Reals|{(Integers|Reals)..}):Reals]:=Module[{procRhs,procDom,lb,ub,senses,cbeg,cind,cval,c,lClean},
c=Table[0.,{Dimensions[m][[2]]}];
{cbeg,cind,cval}=matrix2compressedSparseRow[m];
senses="";
Piecewise[{
{procRhs={},b=={}},
{procRhs=b,MatchQ[b,{_?NumberQ..}]},
{{procRhs,senses}={b[[All,1]],StringJoin[Sequence@@(b[[All,2]]/.{(0|0.)->"=",(-1|-1.)->"<",(1|1.)->">"})]},MatchQ[b,{{_?NumberQ,(-1|-1.|0|0.|1|1.)}..}]}
},Message[GurobiSolveMinimaMaxima::rhserror,b]];
(*Print["RHS: ",procRhs];
Print["Senses: ",senses];*)
lClean=l/.{-\[Infinity]->-10000,\[Infinity]->10000};
Piecewise[{
{{lb,ub}={{},{}},lClean=={}},
{{lb,ub}={lClean,{}},MatchQ[lClean,{_?NumberQ..}]},
{{lb,ub}=Transpose[lClean],MatchQ[lClean,{{_?NumberQ,_?NumberQ}..}]}
},Message[GurobiSolveMinimaMaxima::bndserror,lClean]];
(*Print["Lower bounds: ",lb," Upper bounds: ",ub];*)
Piecewise[{
{procDom="NULL",dom==Reals},
{procDom=StringJoin[Sequence@@Table["I",{Length[c]}]],dom==Integers},
{procDom=StringJoin[Sequence@@(dom/.{Integers->"I",Reals->"C"})],MatchQ[dom,{(Integers|Reals)..}]}
},Message[GurobiSolveMinimaMaxima::domerror,dom]];
(*GurobiML`GurobiML`GurobiSolveLowLevel[c,lb,ub,cbeg, cind, N@cval,procRhs,senses,procDom][[2]]*)
GurobiML`GurobiML`GurobiSolveMinimaMaximaLowLevel[c,lb,ub,cbeg, cind, N@cval,procRhs,senses,procDom]
];
def:GurobiSolveMinimaMaxima[___]:=(Message[GurobiML::badargs,GurobiSolveMinimaMaxima,Defer@def];Abort[])
Protect[GurobiSolveMinimaMaxima];


End[];(*End `Private` Context.*)


EndPackage[];
