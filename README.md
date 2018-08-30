## GurobiML

GurobiML provides a MathLink interface to Gurobi's LP/MIP/QP solvers. It provides
high and low entry points to the solvers' functionalities, for example,
`GurobiSolve` is a high level function that mimics Mathematica's own
`LinearProgramming` function's argument signature. For example,

    GurobiSolve[{2, -3}, {{-1, -2}}, {{3, -1}}, {{-Infinity, 1},{-Infinity, 1}}]

will return `{-5, 1}`.

### Installation

#### Linux & OS X
* `mkdir build && cd build`
* `cmake ..`
* `make`
* `make install`

Eventually one has to adapt the Gurobi part of [CMakeLists.txt](CMakeLists.txt) due to the current lack of a CMake Gurobi module. Or one can do

    export GUROBI_HOME=/path/to/gurobi # for example /Library/gurobi510/mac64 on a mac and Gurobi 5.10

An OS X binary is provided [here](https://www.amazon.com/clouddrive/share/PgDVtVfuMrNeySw9Tnb3AyGCBjxRdowudEZcY9MR9gd).

#### Windows
A binary is provided [here](https://www.amazon.com/clouddrive/share/eKLNC7JrtUbATqAHlvUQHT9gKV2gNuyArYxhYIiIvNi). Work on compilation support on Windows hosts is in progress.

### Usage
* Use either ``Needs["GurobiML`"]`` or ``<<GurobiML` `` to load the package definitions.
* Read the `LinearProgramming` [documentation](http://reference.wolfram.com/mathematica/ref/LinearProgramming.html) to understand how to use `GurobiSolve`.

### License
GurobiML is licensed under the "Modified BSD License". Details can be found in the LICENSE file in the top level directory.
The [CMake](CMake) directory is not part of GurobiML. The CMake [Mathematica](CMake/Mathematica) module is a part of the incredibly helpful [FindMathematica](https://github.com/sakra/FindMathematica) project.
