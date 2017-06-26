
FUNCTION(InitCofigFile Target)
	
	SET(CurrentDir ${CMAKE_CURRENT_LIST_DIR})
	MESSAGE(STATUS "\t - Package_Config_Dir_IN: ${CurrentDir}")
		
	SET(ConfigLines 
		"@PACKAGE_INIT@\n"

		"MESSAGE(STATUS \"@PROJECT_NAME@ package init...\\n\")\n"

		"MESSAGE(STATUS \"CMAKE_CURRENT_LIST_DIR: \${CMAKE_CURRENT_LIST_DIR}\")"
		"INCLUDE(\${CMAKE_CURRENT_LIST_DIR}/lib/\${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAME@Targets.cmake)\n"

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

FUNCTION(RegPackage Target Package_Config_Dir)

	#STRING(TOUPPER ${CMAKE_CONFIGURATION_TYPES} ConfigType)
	MESSAGE(STATUS "RegPackage macro for ${Target} init")
	MESSAGE(STATUS "\t - Package_Config_Dir: ${Package_Config_Dir}")

	InitCofigFile(${Target})
	#SET(PKG_CMAKE_DIR ${Package_Build_Dir}/cmake)
	#SET(PKG_INSTALL_DIR ${Package_Build_Dir}/install)
	
	#MESSAGE(STATUS "\nRegPackage [" ${PackageName} "]")
	#MESSAGE(STATUS "Package_Build_Dir: " ${Package_Build_Dir})
	#MESSAGE(STATUS "PKG_CMAKE_DIR: " ${PKG_CMAKE_DIR})
	#MESSAGE(STATUS "PKG_INSTALL_DIR: " ${PKG_INSTALL_DIR})
	#MESSAGE(STATUS "CMAKE_CONFIGURATION_TYPES : " ${CMAKE_CONFIGURATION_TYPES})

	#SET(PACKAGE_CONFIG_DIR ${CMAKE_BINARY_DIR}/src)

	INCLUDE(CMakePackageConfigHelpers)

	CONFIGURE_PACKAGE_CONFIG_FILE(
		${CMAKE_SOURCE_DIR}/src/${Target}Config.cmake.in
		#${PACKAGE_CONFIG_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
		${Package_Config_Dir}/${Target}Config.cmake
		INSTALL_DESTINATION ${Package_Config_Dir}/install
		#PATH_VARS BUILD_INSTALL_DIR
	)
	
	EXPORT(TARGETS ${Target}
		#FILE ${PACKAGE_CONFIG_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake
		FILE ${Package_Config_Dir}/lib/${CMAKE_CONFIGURATION_TYPES}/${Target}Targets.cmake
	)

	
	#EXPORT(PACKAGE ${CMAKE_PROJECT_NAME})


	#INCLUDE(CMakePackageConfigHelpers)

	#CONFIGURE_PACKAGE_CONFIG_FILE(
	#	${CMAKE_SOURCE_DIR}/${PackageName}Config.cmake.in
	#	${PKG_CMAKE_DIR}/${PackageName}Config.cmake
		#INSTALL_DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/SharedLibConfig.cmake
	#	INSTALL_DESTINATION ${PKG_INSTALL_DIR}/
	#	PATH_VARS PKG_INSTALL_DIR
	#)

	#EXPORT(TARGETS ${PackageName}
	#	FILE ${PKG_CMAKE_DIR}/${CMAKE_CONFIGURATION_TYPES}/${PackageName}Targets.cmake
	#)
	#EXPORT(PACKAGE ${PackageName})
	

#ADD_CUSTOM_COMMAND(TARGET ${PackageName}
#	POST_BUILD
#   COMMAND ${CMAKE_COMMAND} -E write_regv "HKCU/Software/Kitware/CMake/Packages/${PackageName}" "${PKG_CMAKE_DIR}"
#	#COMMAND ${CMAKE_COMMAND} -E write_regv \"HKCU\\\\Software\\\\Kitware\\\\CMake\\\\Packages\\\\${PackageName}\" \"${PKG_CMAKE_DIR}\"
#)
#write_regv key value

#	if (WIN32)
#		install (CODE
#		"execute_process (
#			COMMAND reg add \"HKCU\\\\Software\\\\Kitware\\\\CMake\\\\Packages\\\\${PackageName}\" /v \"${PackageName}\" /d \"${PKG_CMAKE_DIR}\" /t REG_SZ /f
#			RESULT_VARIABLE RT
#			ERROR_VARIABLE  ERR
#			OUTPUT_QUIET
#		)
#		if (RT EQUAL 0)
#			message (STATUS \"Register:   Added HKEY_CURRENT_USER\\\\Software\\\\Kitware\\\\CMake\\\\Packages\\\\${PackageName}\\\\${CMAKE_CONFIGURATION_TYPES}\")
#		else ()
#			 string (STRIP \"\${ERR}\" ERR)
#			message (STATUS \"Register:   Failed to add registry entry: \${ERR}\")
#		endif ()"
#		)
#	elseif (IS_DIRECTORY "$ENV{HOME}")
#		file (WRITE "${BINARY_CONFIG_DIR}/${PackageName}RegistryFile" "${PackageConfig_Dir}")
#		install (
#			FILES       "${BINARY_CONFIG_DIR}/${PackageName}RegistryFile"
#			DESTINATION "$ENV{HOME}/.cmake/packages/${PackageName}"
#			RENAME      "${CMAKE_CONFIGURATION_TYPES}"
#		)
#	endif ()

MESSAGE(STATUS "RegPackage macro done...\n")
	
ENDFUNCTION(RegPackage)

