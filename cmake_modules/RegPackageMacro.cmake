
FUNCTION(InitCofigFile Target)
	
	SET(CurrentDir ${CMAKE_CURRENT_LIST_DIR})
	MESSAGE(STATUS "\t - Package_Config_Dir_IN: ${CurrentDir}")
		
	SET(ConfigLines 
		"@PACKAGE_INIT@\n"

		"MESSAGE(STATUS \"@PROJECT_NAME@ package init...\\n\")\n"

		"MESSAGE(STATUS \"CMAKE_CURRENT_LIST_DIR: \${CMAKE_CURRENT_LIST_DIR}\")"
		"INCLUDE(\${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAME@Targets.cmake)\n"

		"STRING(TOUPPER \${CMAKE_CONFIGURATION_TYPES} PKGCONFIG)"
		"GET_TARGET_PROPERTY(@PROJECT_NAME@_INCLUDE_DIRS @PROJECT_NAME@ INTERFACE_INCLUDE_DIRECTORIES)"
		"GET_TARGET_PROPERTY(@PROJECT_NAME@_LIBRARIES @PROJECT_NAME@ IMPORTED_IMPLIB_\${PKGCONFIG})"
		"GET_TARGET_PROPERTY(@PROJECT_NAME@_LOCATION @PROJECT_NAME@ IMPORTED_LOCATION_\${PKGCONFIG})\n"

		"MESSAGE(STATUS \"@PROJECT_NAME@_LIBRARIES: \${@PROJECT_NAME@_LIBRARIES}\")"
		"MESSAGE(STATUS \"@PROJECT_NAME@_LOCATION: \${@PROJECT_NAME@_LOCATION}\")"
		"MESSAGE(STATUS \"@PROJECT_NAME@_INCLUDE_DIRS: \")"
		"FOREACH(onePath \${@PROJECT_NAME@_INCLUDE_DIRS})"
			"\tMESSAGE(STATUS \"\\t - \${onePath}\")"
		"ENDFOREACH(onePath)\n"

		"SET(@PROJECT_NAME@_INSTALL_DIR @BUILD_INSTALL_DIR@)"
		"MESSAGE(STATUS \"@PROJECT_NAME@_INSTALL_DIR: @BUILD_INSTALL_DIR@\")\n"

		"MESSAGE(STATUS \"@PROJECT_NAME@ package done...\\n\")"
	)

	SET(ConfigTxt "") 
	MESSAGE(STATUS "\t - ConfigTxt:")
	FOREACH(oneLine ${ConfigLines})
	 	MESSAGE(STATUS "\t\t - " ${oneLine})
		SET(ConfigTxt "${ConfigTxt} ${oneLine} \n")
	ENDFOREACH(oneLine)
	
	FILE(WRITE ${CurrentDir}/${Target}Config.cmake.in ${ConfigTxt})
ENDFUNCTION(InitCofigFile)

FUNCTION(RegPackage Target)

	SET(BUILD_DIR ${CMAKE_SOURCE_DIR}/build)
	SET(CONFIG_DIR ${BUILD_DIR}/lib/${CMAKE_CONFIGURATION_TYPES}/cmake)
	SET(INSTALL_DIR ${BUILD_DIR}/install)

	#STRING(TOUPPER ${CMAKE_CONFIGURATION_TYPES} ConfigType)
	MESSAGE(STATUS "RegPackage macro for ${Target} init")
	MESSAGE(STATUS "\t - PKG_INSTALL_DIR: ${INSTALL_DIR}")

	InitCofigFile(${Target})
	
	INCLUDE(CMakePackageConfigHelpers)

	CONFIGURE_PACKAGE_CONFIG_FILE(
		${CMAKE_SOURCE_DIR}/src/${Target}Config.cmake.in
		${CONFIG_DIR}/${Target}Config.cmake
		INSTALL_DESTINATION ${INSTALL_DIR}
		#PATH_VARS BUILD_INSTALL_DIR
	)
	
	EXPORT(
		TARGETS ${Target}		
		FILE ${CONFIG_DIR}/${Target}Targets.cmake
	)
	
	SET(REG_PATH HKEY_CURRENT_USER\\Software\\Kitware\\CMake\\Packages\\${Target})
	SET(REG_KEY ${CMAKE_CONFIGURATION_TYPES})
	SET(REG_DATA HKEY_CURRENT_USER\\Software\\Kitware\\CMake\\Packages\\${Target})
	IF (WIN32)
		EXECUTE_PROCESS (
			COMMAND reg add ${REG_PATH} /v ${REG_KEY} /d ${CONFIG_DIR} /t REG_SZ /f
			RESULT_VARIABLE RT
			ERROR_VARIABLE  ERR
			OUTPUT_QUIET
		)

		IF (RT EQUAL 0)
			MESSAGE (STATUS "\t - Added key to register: " ${REG_DATA})
		ELSE ()
			STRING (STRIP "${ERR}" ERR)
			MESSAGE (STATUS "Register: Failed to add registry entry: ${ERR}")
		ENDIF ()
	ENDIF (WIN32)

	#INSTALL(
	#	FILES 
	#		${CONFIG_DIR}/${Target}Config.cmake
	#		#${CONFIG_DIR}/${Target}Targets.cmake
	#	DESTINATION install
	#	CONFIGURATIONS Release
	#)

	#if (WIN32)
	#	INSTALL (CODE
	#		"execute_process (
	#			COMMAND reg add \"HKCU\\\\Software\\\\Kitware\\\\CMake\\\\Packages\\\\${Target}\" /v \"Release\" /d \"${INSTALL_DIR}\" /t REG_SZ /f
	#			RESULT_VARIABLE RT
	#			ERROR_VARIABLE  ERR
	#			OUTPUT_QUIET
	#		)"
	#	)
	#endif (WIN32)

	MESSAGE(STATUS "RegPackage macro done...\n")
	
ENDFUNCTION(RegPackage)


