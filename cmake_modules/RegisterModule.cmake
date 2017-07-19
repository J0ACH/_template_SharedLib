################################################################################################
#[[

	prvni verze prece s registry
	
	RegisterAdd(
		NAME "Pokus"
			- nazev folderu v cilove ceste registru
		KEY "treba_aaa"
			- nazev klice
		VALUE "C:/aaa"
		- hodnota klice
	)

	RegisterGet(
		NAME "Pokus"
			- nazev folderu v cilove ceste registru
		KEY "treba_aaa"
			- nazev klice
		RETURN TEST_var
		- promena, ktera bude vyplnena dotazovanou hodnotou
	)

	RegisterCheckFunctionRequiredKeys(
		FUNCTION RegisterAdd
			- nazev kontrolavane funkce 
		KEYS NAME KEY VALUE
			- nazev kontrolavane klicu
		VERBATIM TRUE || FALSE
			- tisk hodnot
	)

#]]
################################################################################################

message(STATUS "Module ${CMAKE_CURRENT_LIST_FILE} loaded")

function (RegisterCheckFunctionRequiredKeys)

	set(oneValueArgs FUNCTION)
	set(multiValueArgs KEYS)
	set(options VERBATIM)

    cmake_parse_arguments( RegisterCheckRequiredKeys "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	if(RegisterCheckRequiredKeys_FUNCTION)
		if(RegisterCheckRequiredKeys_VERBATIM)
			message(STATUS "\t${RegisterCheckRequiredKeys_FUNCTION} keys:")
		endif(RegisterCheckRequiredKeys_VERBATIM)
	else()
		message( FATAL_ERROR "RegisterCheckRequiredKeys: 'FUNCTION' argument required." )
	endif(RegisterCheckRequiredKeys_FUNCTION)

	foreach(oneKey ${RegisterCheckRequiredKeys_KEYS})
		set(oneVar ${RegisterCheckRequiredKeys_FUNCTION}_${oneKey})
		if(${oneVar})
			if(RegisterCheckRequiredKeys_VERBATIM)
				message( STATUS "\t\t- " ${oneKey} ": " ${${oneVar}})
			endif()
		else()
			message( FATAL_ERROR "RegisterAdd: '" ${oneKey} "' argument required." )
		endif(${oneVar})
	endforeach(oneKey)
endfunction (RegisterCheckFunctionRequiredKeys)

################################################################################################

function (RegisterAdd)

	message(STATUS "")	
	message(STATUS "RegisterAdd macro init")

	set(oneValueArgs NAME KEY VALUE)
	set(multiValueArgs )
	set(options PATH VERBATIM)

    cmake_parse_arguments( RegisterAdd "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	RegisterCheckFunctionRequiredKeys(
		FUNCTION RegisterAdd
		KEYS NAME KEY VALUE
		VERBATIM TRUE
	)

	set(reg_path HKEY_CURRENT_USER\\Software\\Kitware\\CMake\\Packages\\${RegisterAdd_NAME})
	if (WIN32)
		execute_process (
			COMMAND reg add ${reg_path} /v ${RegisterAdd_KEY} /d ${RegisterAdd_VALUE} /t REG_SZ /f
			RESULT_VARIABLE RT
			ERROR_VARIABLE  ERR
			OUTPUT_QUIET
		)

		if (RT EQUAL 0)
			message (STATUS "\t- key [" ${RegisterAdd_KEY} "] added to register with value: " ${RegisterAdd_VALUE})
		else ()
			string (STRIP "${ERR}" ERR)
			message (STATUS "Register: Failed to add registry entry: ${ERR}")
		endif ()
	endif (WIN32)

	if (UNIX)
		message(STATUS "RegisterAdd: chybi definice pro Linux...\n")

		#[[
			if (WIN32)
				.......
			elseif (IS_DIRECTORY "$ENV{HOME}")
			file (WRITE "${BINARY_CONFIG_DIR}/${PackageName}RegistryFile" "${PackageConfig_Dir}")
			install (
				FILES       "${BINARY_CONFIG_DIR}/${PackageName}RegistryFile"
				DESTINATION "$ENV{HOME}/.cmake/packages/${PackageName}"
				RENAME      "${CMAKE_CONFIGURATION_TYPES}"
			)
			endif ()
		#]]

	endif (UNIX)
	
	message(STATUS "RegisterAdd macro done...\n")
endfunction (RegisterAdd)

################################################################################################

FUNCTION (RegisterGet)

	message(STATUS "")	
	message(STATUS "RegisterGet macro init")

	set(oneValueArgs NAME KEY RETURN)
	set(multiValueArgs )
	set(options VERBATIM)

    cmake_parse_arguments( RegisterGet "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	RegisterCheckFunctionRequiredKeys(
		FUNCTION RegisterGet
		KEYS NAME KEY
		VERBATIM TRUE
	)

	set(reg_path HKEY_CURRENT_USER\\Software\\Kitware\\CMake\\Packages\\${RegisterGet_NAME})
	get_filename_component(value "[${reg_path};${RegisterGet_KEY}]" ABSOLUTE)
	
	if(value STREQUAL "/registry")
		set(value "-NOTFOUND")
	endif(value STREQUAL "/registry")

	set(${RegisterGet_RETURN} ${value} PARENT_SCOPE)

	if(RegisterGet_VERBATIM)
		MESSAGE (STATUS "\t- key [" ${RegisterGet_KEY} "] get value from register: " ${value})
	endif(RegisterGet_VERBATIM)
	
	message(STATUS "RegisterGet macro done...\n")
ENDFUNCTION (RegisterGet)

################################################################################################

function(InitConfigFile)

	message(STATUS "")	
	message(STATUS "Register InitConfigFile macro init")

	set(oneValueArgs PATH TARGET)
	set(multiValueArgs)
	set(options VERBATIM)

    cmake_parse_arguments( InitConfigFile "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	RegisterCheckFunctionRequiredKeys(
		FUNCTION InitConfigFile
		KEYS TARGET PATH
		VERBATIM TRUE
	)
	
	SET(CurrentDir ${CMAKE_CURRENT_LIST_DIR})
	message(STATUS "\t - Package_Config_Dir_IN: ${CurrentDir}")
		
	set(ConfigLines 
		"@PACKAGE_INIT@\n"

		"MESSAGE(STATUS \"@PROJECT_NAME@ package init...\\n\")\n"

		"MESSAGE(STATUS \"CMAKE_CURRENT_LIST_DIR: \${CMAKE_CURRENT_LIST_DIR}\")"
		"INCLUDE(\${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAME@Targets.cmake)\n"
		"INCLUDE(\${CMAKE_CURRENT_LIST_DIR}/@PROJECT_NAME@ConfigVersion.cmake)\n"

		"STRING(TOUPPER \${CMAKE_CONFIGURATION_TYPES} PKGCONFIG)"
		"MESSAGE(STATUS \"PKGCONFIG: \${PKGCONFIG}\")"
		"GET_TARGET_PROPERTY(@PROJECT_NAME@_INCLUDE_DIRS @PROJECT_NAME@ INTERFACE_INCLUDE_DIRECTORIES)"
		"GET_TARGET_PROPERTY(@PROJECT_NAME@_LIBRARIES @PROJECT_NAME@ IMPORTED_IMPLIB_\${PKGCONFIG})"
		"GET_TARGET_PROPERTY(@PROJECT_NAME@_LOCATION @PROJECT_NAME@ IMPORTED_LOCATION_\${PKGCONFIG})\n"
		#"GET_TARGET_PROPERTY(@PROJECT_NAME@_LOCATION @PROJECT_NAME@ INTERFACE_LINK_LIBRARIES)\n"

		"MESSAGE(STATUS \"@PROJECT_NAME@_LIBRARIES: \${@PROJECT_NAME@_LIBRARIES}\")"
		"MESSAGE(STATUS \"@PROJECT_NAME@_LOCATION: \${@PROJECT_NAME@_LOCATION}\")"
		"MESSAGE(STATUS \"@PROJECT_NAME@_INCLUDE_DIRS: \")"
		"FOREACH(onePath \${@PROJECT_NAME@_INCLUDE_DIRS})"
			"\tMESSAGE(STATUS \"\\t - \${onePath}\")"
		"ENDFOREACH(onePath)\n"
		"MESSAGE(STATUS \"@PROJECT_NAME@_INCLUDE_DIRS: \")"

		"SET(@PROJECT_NAME@_INSTALL_DIR @BUILD_INSTALL_DIR@)"
		"MESSAGE(STATUS \"@PROJECT_NAME@_INSTALL_DIR: @BUILD_INSTALL_DIR@\")\n"
		#INTERFACE_LINK_LIBRARIES

		#"INSTALL(DIRECTORY \${@PROJECT_NAME@_INSTALL_DIR}/ DESTINATION install)"

		"MESSAGE(STATUS \"@PROJECT_NAME@ package done...\\n\")"
	)

	set(ConfigTxt "") 
	#MESSAGE(STATUS "\t - ConfigTxt:")
	foreach(oneLine ${ConfigLines})
	 	#MESSAGE(STATUS "\t\t - " ${oneLine})
		set(ConfigTxt "${ConfigTxt} ${oneLine} \n")
	endforeach(oneLine)
	
	file(WRITE ${CMAKE_SOURCE_DIR}/src/${InitConfigFile_TARGET}Config.cmake.in ${ConfigTxt})

	include(CMakePackageConfigHelpers)
	configure_package_config_file(
		${CMAKE_SOURCE_DIR}/src/${InitConfigFile_TARGET}Config.cmake.in
		${InitConfigFile_PATH}/${InitConfigFile_TARGET}Config.cmake
		INSTALL_DESTINATION ${InitConfigFile_PATH}
		#PATH_VARS BUILD_INSTALL_DIR
	)
endfunction(InitConfigFile)

################################################################################################

function (InitTargetFile)

	message(STATUS "")	
	message(STATUS "Register InitTargetFile macro init")

	set(oneValueArgs PATH TARGET)
	set(multiValueArgs)
	set(options VERBATIM)

    cmake_parse_arguments( InitTargetFile "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	RegisterCheckFunctionRequiredKeys(
		FUNCTION InitTargetFile
		KEYS TARGET PATH
		VERBATIM TRUE
	)

	export(
		TARGETS ${InitTargetFile_TARGET}		
		FILE ${InitTargetFile_PATH}/${InitTargetFile_TARGET}Config.cmake
	)
	
	message(STATUS "Register InitTargetFile macro done...\n")
endfunction (InitTargetFile)

################################################################################################

function (InitVersionFile)

	message(STATUS "")	
	message(STATUS "Register InitVersionFile macro init")

	set(oneValueArgs PATH VERSION TARGET)
	set(multiValueArgs)
	set(options VERBATIM)

    cmake_parse_arguments( InitVersionFile "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	RegisterCheckFunctionRequiredKeys(
		FUNCTION InitVersionFile
		KEYS VERSION PATH
		VERBATIM TRUE
	)
	
	include(CMakePackageConfigHelpers)
	write_basic_package_version_file(
		${InitVersionFile_PATH}/${InitVersionFile_TARGET}ConfigVersion.cmake
		VERSION ${PROJECT_VERSION}
		COMPATIBILITY SameMajorVersion 
	)
	
	message(STATUS "Register InitVersionFile macro done...\n")
endfunction (InitVersionFile)

################################################################################################

function (PackageAdd)
	message(STATUS "")	
	message(STATUS "Register PackageTargets macro init")

	set(oneValueArgs PATH VERSION)
	set(multiValueArgs TARGETS)
	set(options VERBATIM)

    cmake_parse_arguments( PackageAdd "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	RegisterCheckFunctionRequiredKeys(
		FUNCTION PackageAdd
		KEYS TARGETS PATH
		VERBATIM TRUE
	)

	foreach(oneTarget ${PackageAdd_TARGETS})
		InitTargetFile(
			TARGET ${oneTarget}
			PATH ${PackageAdd_PATH}
		)
		InitVersionFile(
			TARGET ${oneTarget}
			VERSION ${PackageAdd_VERSION}
			PATH ${PackageAdd_PATH}
		)
		#[[
		InitConfigFile(
			TARGET ${oneTarget}
			PATH ${PackageAdd_PATH}
		)
		#]]
		RegisterAdd(
			NAME ${oneTarget}
			KEY Release
			VALUE ${PackageAdd_PATH}
		)
	endforeach(oneTarget)	
	
	message(STATUS "Register PackageTargets macro done...\n")
endfunction (PackageAdd)