set ( SOURCES main.cpp )

u_add_executable( TARGET param_bin SOURCES ${SOURCES} LIBRARIES "z" INSTALL "${CMAKE_INSTALL_BINDIR}" )
