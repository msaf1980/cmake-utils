# Add executable target
function(u_add_executable)
	set ( prefix ARG )
	set ( requiredArgs TARGET SOURCES )
	set ( noValues )
	set ( singleValues TARGET INSTALL )
	set	( multiValues SOURCES LIBRARIES INCLUDES DEPENDECIES )
	cmake_parse_arguments(
		${prefix}
		"${noValues}"
		"${singleValues}"
		"${multiValues}"
		${ARGN}
	)
	foreach(arg IN LISTS requiredArgs)
		if ("${${prefix}_${arg}}" STREQUAL "")
			message(FATAL_ERROR "errors in utils_add_executable: ${arg} not defined")
		endif()
	endforeach()

	add_executable( "${${prefix}_TARGET}" ${${prefix}_SOURCES} )
	if (NOT "${${prefix}_INCLUDES}" STREQUAL "")
		target_include_directories( "${${prefix}_TARGET}" PRIVATE ${${prefix}_INCLUDES} )
	endif()
	if (NOT "${${prefix}_LIBRARIES}" STREQUAL "")
		target_link_libraries( "${${prefix}_TARGET}" ${${prefix}_LIBRARIES} )
	endif()
	if (NOT "${${prefix}_DEPENDECIES}" STREQUAL "")
		add_dependencies( "${${prefix}_TARGET}" ${${prefix}_DEPENDECIES} )
	endif()
	if (NOT "${${prefix}_INSTALL}" STREQUAL "")
		install( TARGETS "${${prefix}_TARGET}" DESTINATION "${${prefix}_INSTALL}" )
	endif()
endfunction()

# Add library target
function(u_add_library)
	set ( prefix ARG )
	set ( requiredArgs TARGET SOURCES )
	set ( noValues )
	set ( singleValues TARGET INSTALL VERSION_MAJOR VERSION_MINOR )
	set	( multiValues SOURCES LIBRARIES INCLUDES DEPENDECIES )
	cmake_parse_arguments(
		${prefix}
		"${noValues}"
		"${singleValues}"
		"${multiValues}"
		${ARGN}
	)
	foreach(arg IN LISTS requiredArgs)
		if ("${${prefix}_${arg}}" STREQUAL "")
			message(FATAL_ERROR "errors in utils_add_library: ${arg} not defined")
		endif()
	endforeach()

	add_library( "${${prefix}_TARGET}" ${${prefix}_SOURCES} )
	if (NOT "${${prefix}_INCLUDES}" STREQUAL "")
		target_include_directories( "${${prefix}_TARGET}" PRIVATE ${${prefix}_INCLUDES} )
	endif()
	if (NOT "${${prefix}_LIBRARIES}" STREQUAL "")
		target_link_libraries( "${${prefix}_TARGET}" ${${prefix}_LIBRARIES} )
	endif()
	if (NOT "${${prefix}_DEPENDECIES}" STREQUAL "")
		add_dependencies( "${${prefix}_TARGET}" ${${prefix}_DEPENDECIES} )
	endif()
	if ("${${prefix}_VERSION_MAJOR}" STREQUAL "")
		if ("${${prefix}_VERSION_MINOR}" STREQUAL "")
			set ("${VERSION}" "${${prefix}_VERSION_MAJOR}.${${prefix}_VERSION_MINOR}" )
		else()
			set ("${VERSION}" "${${prefix}_VERSION_MAJOR}" )
		endif()
		set_target_properties("${${prefix}_TARGET}" PROPERTIES VERSION "${VERSION}" SOVERSION "${${prefix}_VERSION_MAJOR}")
	endif()
	if (NOT "${${prefix}_INSTALL}" STREQUAL "")
		install( TARGETS "${${prefix}_TARGET}" DESTINATION "${${prefix}_INSTALL}" )
	endif()
endfunction()

# Add test target
function(u_add_test)
	set ( prefix ARG )
	set ( requiredArgs TARGET SOURCES )
	set ( noValues )
	set ( singleValues TARGET INSTALL )
	set	( multiValues SOURCES LIBRARIES INCLUDES DEPENDECIES )
	cmake_parse_arguments(
		${prefix}
		"${noValues}"
		"${singleValues}"
		"${multiValues}"
		${ARGN}
	)
	foreach(arg IN LISTS requiredArgs)
		if ("${${prefix}_${arg}}" STREQUAL "")
			message(FATAL_ERROR "errors in utils_add_executable: ${arg} not defined")
		endif()
	endforeach()

	u_add_executable(
		TARGET "${${prefix}_TARGET}"
		SOURCES "${${prefix}_SOURCES}"
		LIBRARIES "${${prefix}_LIBRARIES}"
		INCLUDES "${${prefix}_INCLUDES}"
		DEPENDECIES "${${prefix}_DEPENDECIES}"
	)
	add_test(
		NAME "${${prefix}_TARGET}"
		COMMAND "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${${prefix}_TARGET}"
	)
endfunction()
