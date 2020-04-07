# Simple cmake project file example.

cmake_minimum_required(VERSION 2.8.11)

project(01-simplebin)

set ( SUB_DIRS "src" )

include("../init.cmake")

foreach(dir ${SUB_DIRS})
	message( "INCLUDE ${dir}" )
	add_subdirectory( ${CMAKE_CURRENT_SOURCE_DIR}/${dir} )
endforeach(dir)

