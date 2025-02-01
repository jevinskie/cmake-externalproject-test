cmake_minimum_required(VERSION 3.31)
cmake_policy(SET CMP0077 NEW)

project(cmake-externalproject-test C)

include(ExternalProject)

add_executable(cmake-externalproject-test main.c)
