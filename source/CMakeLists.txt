
# LIB SETUP ###################################################

find_package(Qt5 COMPONENTS Core Gui Widgets REQUIRED)

add_subdirectory(MyLib)

add_library( ${CMAKE_PROJECT_NAME} SHARED
	${library_hdr}
	${library_src}
	${library_res}
)

string(TOUPPER ${CMAKE_CONFIGURATION_TYPES} configType)
set_target_properties( ${CMAKE_PROJECT_NAME}
    PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY_${configType} ${buildDir}/lib
		LIBRARY_OUTPUT_DIRECTORY_${configType} ${buildDir}/lib
		RUNTIME_OUTPUT_DIRECTORY_${configType} ${buildDir}/bin
		DEBUG_POSTFIX _d
)

add_custom_command(TARGET ${CMAKE_PROJECT_NAME}
	POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E make_directory ${buildDir}/include
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${library_hdr} ${buildDir}/include
)

get_target_property(qtCoreInclude Qt5::Core INTERFACE_INCLUDE_DIRECTORIES) 
get_target_property(qtGuiInclude Qt5::Gui INTERFACE_INCLUDE_DIRECTORIES) 
get_target_property(qtWidgetsInclude Qt5::Widgets INTERFACE_INCLUDE_DIRECTORIES) 
list(APPEND qtIncludeDirs ${qtCoreInclude})
list(APPEND qtIncludeDirs ${qtGuiInclude})
list(APPEND qtIncludeDirs ${qtWidgetsInclude})
list(REMOVE_DUPLICATES qtIncludeDirs)

target_include_directories(${CMAKE_PROJECT_NAME} 
	PRIVATE
		${library_hdr}	
	PUBLIC
		${qtIncludeDirs}
	INTERFACE 
		$<BUILD_INTERFACE:${buildDir}/include>
		$<INSTALL_INTERFACE:include>
)

get_target_property(qtCoreLib Qt5::Core IMPORTED_IMPLIB_RELEASE) 
get_target_property(qtGuiLib Qt5::Gui IMPORTED_IMPLIB_RELEASE) 
get_target_property(qtWidgetsLib Qt5::Widgets IMPORTED_IMPLIB_RELEASE) 
get_target_property(qtWinMainLib Qt5::WinMain IMPORTED_LOCATION_RELEASE) 
list(APPEND qtLinkLibs ${qtCoreLib})
list(APPEND qtLinkLibs ${qtGuiLib})
list(APPEND qtLinkLibs ${qtWidgetsLib})
list(APPEND qtLinkLibs ${qtWinMainLib})

target_link_libraries(${CMAKE_PROJECT_NAME} 
	PUBLIC
		${qtLinkLibs}
)

# PACKAGE SETUP ###################################################

include(CMakePackageConfigHelpers)
configure_package_config_file (
	${CMAKE_CURRENT_SOURCE_DIR}/${CMAKE_PROJECT_NAME}Config.cmake.in
	${buildDir}/cmake/${CMAKE_PROJECT_NAME}Config.cmake
	INSTALL_DESTINATION lib/cmake
)
write_basic_package_version_file(
	${buildDir}/cmake/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY AnyNewerVersion 
)
export ( 
	TARGETS ${CMAKE_PROJECT_NAME}
	FILE ${buildDir}/cmake/${CMAKE_PROJECT_NAME}Targets.cmake 
)

# LIB INSTALL ###################################################

install(
	TARGETS ${CMAKE_PROJECT_NAME} 
	EXPORT ${CMAKE_PROJECT_NAME}Targets
	ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
	CONFIGURATIONS Release
)
install(
	FILES ${library_hdr}
	DESTINATION include
)
install(
	FILES 
		${buildDir}/cmake/${CMAKE_PROJECT_NAME}Config.cmake
		${buildDir}/cmake/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
	DESTINATION	lib/cmake/${CMAKE_PROJECT_NAME}-${PROJECT_VERSION}
)
install(
	EXPORT ${CMAKE_PROJECT_NAME}Targets
	DESTINATION lib/cmake/${CMAKE_PROJECT_NAME}-${PROJECT_VERSION}
	FILE ${CMAKE_PROJECT_NAME}Targets.cmake
	CONFIGURATIONS Release
)
#[[
install(
	FILES 
		$<TARGET_FILE:Qt5::Core>
		$<TARGET_FILE:Qt5::Gui>
		$<TARGET_FILE:Qt5::Widgets>
	DESTINATION bin
)
#]]


