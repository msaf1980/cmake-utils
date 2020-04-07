option(EXTERNAL "Install from git" OFF)

set ( DEP_INSTALL_DIR ${CMAKE_BINARY_DIR}/external )
if (NOT EXISTS ${DEP_INSTALL_DIR} )
	file( MAKE_DIRECTORY ${DEP_INSTALL_DIR} )
endif()

include(GNUInstallDirs)
include("${CMAKE_CURRENT_LIST_DIR}/cmake-utils.cmake")
