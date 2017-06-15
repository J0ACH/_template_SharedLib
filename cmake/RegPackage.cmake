MESSAGE(STATUS "RegPackage")

FUNCTION(RegPackage PackageName PackageConfig_Dir)

	SET(PKGDIR "${PackageConfig_Dir}/cmake")

	INCLUDE(CMakePackageConfigHelpers)

	CONFIGURE_PACKAGE_CONFIG_FILE(
		${CMAKE_SOURCE_DIR}/${PackageName}Config.cmake.in
		${PKGDIR}/${PackageName}Config.cmake
		INSTALL_DESTINATION ${CMAKE_INSTALL_PREFIX}/lib/cmake/SharedLibConfig.cmake
		#PATH_VARS ${CMAKE_BINARY_DIR@/bin}
	)

	EXPORT(TARGETS ${PackageName}
		FILE ${PKGDIR}/${CMAKE_CONFIGURATION_TYPES}/${PackageName}Targets.cmake
	)

	MESSAGE(STATUS "RegPackage")
	MESSAGE(STATUS "PackageName: " ${target})
	MESSAGE(STATUS "PackageConfig_Dir: " ${PackageConfig_Dir})

	MESSAGE(STATUS "CMAKE_CONFIGURATION_TYPES : " ${CMAKE_CONFIGURATION_TYPES})

	if (WIN32)
		install (CODE
		"execute_process (
			COMMAND reg add \"HKCU\\\\Software\\\\Kitware\\\\CMake\\\\Packages\\\\${PackageName}\" /v \"${PackageName}\" /d \"${PKGDIR}\" /t REG_SZ /f
			RESULT_VARIABLE RT
			ERROR_VARIABLE  ERR
			OUTPUT_QUIET
		)
		if (RT EQUAL 0)
			message (STATUS \"Register:   Added HKEY_CURRENT_USER\\\\Software\\\\Kitware\\\\CMake\\\\Packages\\\\${PackageName}\\\\${CMAKE_CONFIGURATION_TYPES}\")
		else ()
			 string (STRIP \"\${ERR}\" ERR)
			message (STATUS \"Register:   Failed to add registry entry: \${ERR}\")
		endif ()"
		)
	elseif (IS_DIRECTORY "$ENV{HOME}")
		file (WRITE "${BINARY_CONFIG_DIR}/${PackageName}RegistryFile" "${PackageConfig_Dir}")
		install (
			FILES       "${BINARY_CONFIG_DIR}/${PackageName}RegistryFile"
			DESTINATION "$ENV{HOME}/.cmake/packages/${PackageName}"
			RENAME      "${CMAKE_CONFIGURATION_TYPES}"
		)
	endif ()

	
ENDFUNCTION(RegPackage)

