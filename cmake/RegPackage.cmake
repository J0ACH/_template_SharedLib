MESSAGE(STATUS "RegPackage")

FUNCTION(RegPackage PackageName Package_Build_Dir)

	SET(PKG_CMAKE_DIR ${Package_Build_Dir}/cmake)
	SET(PKG_INSTALL_DIR ${Package_Build_Dir}/install)
	
	MESSAGE(STATUS "\nRegPackage [" ${PackageName} "]")
	MESSAGE(STATUS "Package_Build_Dir: " ${Package_Build_Dir})
	MESSAGE(STATUS "PKG_CMAKE_DIR: " ${PKG_CMAKE_DIR})
	MESSAGE(STATUS "PKG_INSTALL_DIR: " ${PKG_INSTALL_DIR})
	MESSAGE(STATUS "CMAKE_CONFIGURATION_TYPES : " ${CMAKE_CONFIGURATION_TYPES})

	INCLUDE(CMakePackageConfigHelpers)

	CONFIGURE_PACKAGE_CONFIG_FILE(
		${CMAKE_SOURCE_DIR}/${PackageName}Config.cmake.in
		${PKG_CMAKE_DIR}/${PackageName}Config.cmake
		#INSTALL_DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/SharedLibConfig.cmake
		INSTALL_DESTINATION ${PKG_INSTALL_DIR}/
		PATH_VARS PKG_INSTALL_DIR
	)

	EXPORT(TARGETS ${PackageName}
		FILE ${PKG_CMAKE_DIR}/${CMAKE_CONFIGURATION_TYPES}/${PackageName}Targets.cmake
	)
	EXPORT(PACKAGE ${PackageName})
	

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

	
ENDFUNCTION(RegPackage)

