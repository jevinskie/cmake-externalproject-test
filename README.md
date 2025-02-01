# cmake-externalproject-test
Because I can't figure out how to get an autotools project built by
`ExternalProject_Add` built as a depenency before `make install`
installs the library and header files. It might be `BUILD_BYPRODUCTS`
and Ninja related - hurray.
