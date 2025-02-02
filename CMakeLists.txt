cmake_minimum_required(VERSION 3.31)

project(cmake-externalproject-test C)

include(ExternalProject)

ExternalProject_Add(gmp_ext
    SOURCE_DIR          ${CMAKE_CURRENT_SOURCE_DIR}/gmp
    CONFIGURE_COMMAND   rsync -a ${CMAKE_CURRENT_SOURCE_DIR}/gmp/ .
    INSTALL_COMMAND     ""
    BUILD_COMMAND       ./build-gmp.sh ${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include/gmp.h ${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/lib/libempty.a
    PREFIX              gmp-build
    INSTALL_DIR         gmp-prefix
    BUILD_BYPRODUCTS    gmp-prefix/include/gmp.h gmp-prefix/lib/libempty.a
)

file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include")

add_library(GMP::GMP UNKNOWN IMPORTED)
add_dependencies(GMP::GMP ${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include/gmp.h)
set_target_properties(GMP::GMP PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include"
    IMPORTED_LOCATION "${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/lib/libempty.a"
)

add_library(GMP ALIAS GMP::GMP)

add_executable(cmake-externalproject-test main.c)
target_link_libraries(cmake-externalproject-test GMP)

add_library(libfoo STATIC lib.c)
target_link_libraries(libfoo GMP)
