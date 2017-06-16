FUNCTION(QT_ADDMODULE TARGET MODULE)
	
	MESSAGE(STATUS "MODULE: " ${MODULE})
	FIND_PACKAGE(Qt5 REQUIRED COMPONENTS ${MODULE})
	
	STRING(TOUPPER ${CMAKE_CONFIGURATION_TYPES} BuildType)
	MESSAGE(STATUS "BuildType: ${BuildType}")

	GET_TARGET_PROPERTY(module_INCLUDE_DIRS Qt5::${MODULE} INTERFACE_INCLUDE_DIRECTORIES)
	#GET_TARGET_PROPERTY(module_LIBRARIES Qt5::${MODULE} IMPORTED_IMPLIB_RELEASE)
	GET_TARGET_PROPERTY(module_LIBRARIES Qt5::${MODULE} IMPORTED_IMPLIB_${BuildType})
	#GET_TARGET_PROPERTY(module_LOCATION Qt5::${MODULE} IMPORTED_LOCATION_RELEASE)
	GET_TARGET_PROPERTY(module_LOCATION Qt5::${MODULE} IMPORTED_LOCATION_${BuildType})
		
	TARGET_INCLUDE_DIRECTORIES(${TARGET} PUBLIC ${module_INCLUDE_DIRS})
	TARGET_LINK_LIBRARIES(${TARGET} PUBLIC ${module_LIBRARIES})
	
	INSTALL(FILES ${module_LOCATION} DESTINATION install)
	
	MESSAGE(STATUS "Qt5${MODULE}_LIBRARIES: " ${module_LIBRARIES})
	MESSAGE(STATUS "Qt5${MODULE}_LOCATION: " ${module_LOCATION})
	MESSAGE(STATUS "Qt5${MODULE}_INCLUDE_DIRS: ")
	FOREACH(onePath ${module_INCLUDE_DIRS})
	 	MESSAGE(STATUS "\t - " ${onePath})
	ENDFOREACH(onePath)

ENDFUNCTION(QT_ADDMODULE)