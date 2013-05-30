# GurobiML

GurobiML provides a MathLink interface to Gurobi's LP/MIP/QP solvers. It provides
high and low entry points to the solvers' functionalities, for example,
`GurobiSolve` is a high level function that mimics Mathematica's own
`LinearProgramming` function's argument signature.

GurobiML is licensed under the "Modified BSD License". Details can be found in the LICENSE file in the top level directory.
The CMAKE directory is not part of GurobiML.


Reached milestones:

- Quadratic programming capabilities

Milestones:

1. Documentation (high and low level functions)
2. Provide cross platform installation instructions
3. Fine-grained access to GRBset*param() routines
4. Access to GRBoptimize, GRBcomputeIIS, 
