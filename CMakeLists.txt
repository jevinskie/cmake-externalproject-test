cmake_minimum_required(VERSION 3.31)
cmake_policy(SET CMP0077 NEW)

project(cmake-externalproject-test C)

include(ExternalProject)

ExternalProject_Add(gmp_ext
    SOURCE_DIR          ${CMAKE_CURRENT_SOURCE_DIR}/gmp
    CONFIGURE_COMMAND   rsync -a ${CMAKE_CURRENT_SOURCE_DIR}/gmp/ &&
                        mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include
    INSTALL_COMMAND     ""
    BUILD_COMMAND       ./build-gmp.sh ${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include/gmp.h
    PREFIX              gmp-build
    INSTALL_DIR         gmp-prefix
    BUILD_BYPRODUCTS    ${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include/gmp.h
)

add_library(GMP::GMP UNKNOWN IMPORTED)
add_dependencies(GMP::GMP ${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include/gmp.h)
set_target_properties(GMP::GMP PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include"
)

add_library(GMP ALIAS GMP::GMP)

add_executable(cmake-externalproject-test main.c)
target_link_libraries(cmake-externalproject-test GMP)
