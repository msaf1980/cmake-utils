cmake_minimum_required(VERSION 2.8)

set ( PROJECT cmake-utils )
project ( ${PROJECT} )

set(MODULE_INSTALL_DIR "${CMAKE_BINARY_DIR}/cmake/${PROJECT}")

install(
    DIRECTORY cmake
    DESTINATION ${MODULE_INSTALL_DIR}
)
