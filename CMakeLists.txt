cmake_minimum_required(VERSION 3.31)

project(cmake-externalproject-test C)

include(ExternalProject)

ExternalProject_Add(gmp_ext
    SOURCE_DIR          ${CMAKE_CURRENT_SOURCE_DIR}/gmp
    CONFIGURE_COMMAND   rsync -a ${CMAKE_CURRENT_SOURCE_DIR}/gmp/ . &&
                        ./configure-gmp.sh
    INSTALL_COMMAND     ""
    BUILD_COMMAND       ./build-gmp.sh ${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include/gmp.h ${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/lib/libempty.a
    PREFIX              gmp-build
    INSTALL_DIR         gmp-prefix
    BUILD_BYPRODUCTS    gmp-prefix/include/gmp.h gmp-prefix/lib/libempty.a
)

file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include")

add_library(GMP::GMP UNKNOWN IMPORTED)
add_dependencies(GMP::GMP gmp_ext)
set_target_properties(GMP::GMP PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/include"
    IMPORTED_LOCATION "${CMAKE_CURRENT_BINARY_DIR}/gmp-prefix/lib/libempty.a"
)

add_library(GMP ALIAS GMP::GMP)

add_executable(cmake-externalproject-test main.c)
target_link_libraries(cmake-externalproject-test GMP)

add_library(bar STATIC bar.c)
# fix the following "missing statement" automatically
# target_link_libraries(bar GMP)

add_library(foo STATIC foo.c)
# set_target_properties(libfoo PROPERTIES NAMESPACE GMPNS)
target_link_libraries(foo bar GMP)

function (_get_all_cmake_targets out_var current_dir)
    get_property(targets DIRECTORY ${current_dir} PROPERTY BUILDSYSTEM_TARGETS)
    get_property(subdirs DIRECTORY ${current_dir} PROPERTY SUBDIRECTORIES)

    foreach(subdir ${subdirs})
        _get_all_cmake_targets(subdir_targets ${subdir})
        list(APPEND targets ${subdir_targets})
    endforeach()

    set(${out_var} ${targets} PARENT_SCOPE)
endfunction()

# Run at end of top-level CMakeLists
_get_all_cmake_targets(all_targets ${CMAKE_CURRENT_LIST_DIR})
message(WARNING "targets: ${all_targets}")
