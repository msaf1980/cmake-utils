file(GLOB cmakeFiles ${CMAKE_CURRENT_LIST_DIR}/*/*.cmake)
foreach(cmakeFile ${cmakeFiles})
	include( ${cmakeFile} )
endforeach(cmakeFile)
