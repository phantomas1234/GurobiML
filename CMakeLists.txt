# Copyright (c) 2013 Nikolaus Sonnenschein. All rights reserved.
# Use of this source code is governed by a BSD-style license that can
# be found in the LICENSE file.

cmake_minimum_required (VERSION 2.6)
cmake_policy(SET CMP0012 NEW)
project (GurobiML)

set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMake/Mathematica" ${CMAKE_MODULE_PATH})

find_package(Mathematica)

find_path(GUROBI_INCLUDE_DIR 
    NAMES gurobi_c.h
    PATHS "$ENV{GUROBI_HOME}/include" "/Library/gurobi510/mac64/include" # Add other paths here
)

find_library(GUROBI_LIBRARY 
    NAMES gurobi gurobi52 gurobi55
    PATHS "$ENV{GUROBI_HOME}/lib" "/Library/gurobi510/mac64/lib" # Add other paths here
)

# set (GUROBI_INCLUDE_DIR "/Library/gurobi550/mac64/include")

include_directories(${Mathematica_INCLUDE_DIRS} ${GUROBI_INCLUDE_DIR})
# link_directories(${GUROBI_LIBS})

Mathematica_MathLink_add_executable (GurobiML.exe gurobi_mathlink.tm gurobi_mathlink.c)
set_target_properties(GurobiML.exe PROPERTIES FOLDER "MathLink")
list (APPEND _Targets GurobiML.exe)


# export mprep header and trailer code for the current target platform
#Mathematica_MathLink_MPREP_EXPORT_FRAMES(
    #OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/mprep-frames"
    #SYSTEM_ID ${Mathematica_SYSTEM_ID})

# fix MathLink shared library references under Mac OS X
Mathematica_ABSOLUTIZE_LIBRARY_DEPENDENCIES(GurobiML.exe)

target_link_libraries(GurobiML.exe ${GUROBI_LIBRARY})

install (DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/GurobiML" DESTINATION "${Mathematica_USERBASE_DIR}/Applications/")
install (TARGETS GurobiML.exe DESTINATION "${Mathematica_USERBASE_DIR}/Applications/GurobiML")
