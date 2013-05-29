cmake_minimum_required (VERSION 2.6)
project (GurobiML)

set (CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/CMake/Mathematica" ${CMAKE_MODULE_PATH})

find_package(Mathematica)

# find_path(GUROBI_INCLUDE_DIR gurobi_c.h PATHS "/Library/gurobi501/"
#     PATH_SUFFIXES "mac64" "win64" "win32")
# message(STATUS "${GUROBI_INCLUDE_DIR}")

# find_path(GUROBI_INCLUDE_DIR 
#           NAMES gurobi_c++.h
#           PATHS "$ENV{GUROBI_HOME}/include"
#                   "/Library/gurobi502/mac64/include"
#                  "C:\\libs\\gurobi502\\include"
#           )

set (GUROBI_INCLUDE_DIR "/Library/gurobi550/mac64/include")

include_directories(${Mathematica_INCLUDE_DIRS} ${GUROBI_INCLUDE_DIR})
link_directories(${GUROBI_LIBS})

Mathematica_MathLink_add_executable (GurobiML.exe gurobi_mathlink.tm gurobi_mathlink.c)
set_target_properties(GurobiML.exe PROPERTIES FOLDER "MathLink")
list (APPEND _Targets GurobiML.exe)


# export mprep header and trailer code for the current target platform
#Mathematica_MathLink_MPREP_EXPORT_FRAMES(
    #OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/mprep-frames"
    #SYSTEM_ID ${Mathematica_SYSTEM_ID})

# fix MathLink shared library references under Mac OS X
Mathematica_ABSOLUTIZE_LIBRARY_DEPENDENCIES(GurobiML.exe)

target_link_libraries(GurobiML.exe gurobi55)

install (DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/GurobiML" DESTINATION "${Mathematica_USERBASE_DIR}/Applications/")
install (TARGETS GurobiML.exe DESTINATION "${Mathematica_USERBASE_DIR}/Applications/GurobiML")
