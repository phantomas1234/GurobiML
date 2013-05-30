:: Copyright (c) 2013 Nikolaus Sonnenschein. All rights reserved.
:: Use of this source code is governed by a BSD-style license that can
:: be found in the LICENSE file.

:Evaluate: BeginPackage["GurobiML`GurobiML`"]
:Evaluate: GurobiSolveFromFile::usage = "GurobiSolveFromFile[path2file] solves optimization problem defined in file."
:Evaluate: GurobiSolveLowLevel::usage = "GurobiSolveLowLevel[obj, lb, ub, cbeg, cind, rhs, senses, vtype] solves LP/MILP optimization problems. Should be accessed from Mathematica function GurobiSolve."
:Evaluate: GurobiSolveMinimaMaximaLowLevel::usage = "GurobiSolveMinimaMaxima[obj, lb, ub, cbeg, cind, rhs, senses, vtype] ..."
:Evaluate: Begin["Private`"]

:Begin:
:Function:       solveLPfromFile
:Pattern:        GurobiSolveFromFile[path_String]
:Arguments:      {path}
:ArgumentTypes:  {String}
:ReturnType:     Manual
:End:

:Begin:
:Function:       solve
:Pattern:        GurobiSolveLowLevel[obj_List, lb_List, ub_List, cbeg_List, cind_List, cval_List, rhs_List, senses_String, vtype_String, qrow_List, qcol_List, qval_List, parampath_String, baspath_String, mstpath_String]
:Arguments:      {obj, lb, ub, cbeg, cind, cval, rhs, senses, vtype, qrow, qcol, qval, parampath, baspath, mstpath}
:ArgumentTypes:  {RealList, RealList, RealList, IntegerList, IntegerList, RealList, RealList, String, String, IntegerList, IntegerList, RealList, String, String, String}
:ReturnType:     Manual
:End:

:Begin:
:Function:       calcMinMaxForVariables
:Pattern:        GurobiSolveMinimaMaximaLowLevel[obj_List, lb_List, ub_List, cbeg_List, cind_List, cval_List, rhs_List, senses_String, vtype_String]
:Arguments:      {obj, lb, ub, cbeg, cind, cval, rhs, senses, vtype}
:ArgumentTypes:  {RealList, RealList, RealList, IntegerList, IntegerList, RealList, RealList, String, String}
:ReturnType:     Manual
:End:

:Evaluate: End[ ]
:Evaluate: EndPackage[ ]