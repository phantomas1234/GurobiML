cmake_minimum_required (VERSION 2.6)
project (GurobiML)

set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMake/Mathematica" ${CMAKE_MODULE_PATH})

find_package(Mathematica)

include_directories(${Mathematica_INCLUDE_DIRS} /Library/gurobi461/mac64/include)
link_directories(/Library/gurobi461/mac64/lib/)

Mathematica_MathLink_add_executable (GurobiML gurobi_mathlink.tm gurobi_mathlink.c)
set_target_properties(GurobiML PROPERTIES FOLDER "MathLink")
list (APPEND _Targets GurobiML)


# export mprep header and trailer code for the current target platform
#Mathematica_MathLink_MPREP_EXPORT_FRAMES(
    #OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/mprep-frames"
    #SYSTEM_ID ${Mathematica_SYSTEM_ID})

# fix MathLink shared library references under Mac OS X
Mathematica_ABSOLUTIZE_LIBRARY_DEPENDENCIES(GurobiML)

target_link_libraries(GurobiML gurobi46)

