
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
		ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
		LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
		RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
		DEBUG_POSTFIX _d
		#QT5_NO_LINK_QTMAIN ON
)

add_custom_command(TARGET ${CMAKE_PROJECT_NAME}
	POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/include
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${library_hdr} ${CMAKE_BINARY_DIR}/include
)

get_target_property(qtCoreInclude Qt5::Core INTERFACE_INCLUDE_DIRECTORIES) 
get_target_property(qtGuiInclude Qt5::Gui INTERFACE_INCLUDE_DIRECTORIES) 
get_target_property(qtWidgetsInclude Qt5::Widgets INTERFACE_INCLUDE_DIRECTORIES) 

target_include_directories(${CMAKE_PROJECT_NAME} 
	PRIVATE
		${library_hdr}	
	INTERFACE 
		$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>
		$<INSTALL_INTERFACE:include>
		${qtCoreInclude}
		${qtGuiInclude}
		${qtWidgetsInclude}
)

get_target_property(qtCoreLib Qt5::Core IMPORTED_IMPLIB_RELEASE) 
get_target_property(qtGuiLib Qt5::Gui IMPORTED_IMPLIB_RELEASE) 
get_target_property(qtWidgetsLib Qt5::Widgets IMPORTED_IMPLIB_RELEASE) 
get_target_property(qtWinMainLib Qt5::WinMain IMPORTED_LOCATION_RELEASE) 

target_link_libraries(${CMAKE_PROJECT_NAME} 
	PRIVATE
		Qt5::Core
		Qt5::Gui
		Qt5::Widgets
	INTERFACE
		${qtCoreLib}
		${qtGuiLib}
		${qtWidgetsLib}
		${qtWinMainLib}
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
	EXPORT ${CMAKE_PROJECT_NAME}Targets
	DESTINATION lib/cmake/${CMAKE_PROJECT_NAME}
	FILE ${CMAKE_PROJECT_NAME}Targets.cmake
	CONFIGURATIONS Release
	EXPORT_LINK_INTERFACE_LIBRARIES
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
install(
	FILES ${library_hdr}
	DESTINATION include
)
install(
	FILES 
		${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
		${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
	DESTINATION	lib/cmake/${CMAKE_PROJECT_NAME}
)

# PACKAGE SETUP ###################################################

include(CMakePackageConfigHelpers)
configure_package_config_file (
	${CMAKE_CURRENT_SOURCE_DIR}/${CMAKE_PROJECT_NAME}Config.cmake.in
	${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
	INSTALL_DESTINATION lib/cmake
)
write_basic_package_version_file(
	${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY AnyNewerVersion 
)
cmake_policy(SET CMP0022 NEW)
export ( 
	TARGETS ${CMAKE_PROJECT_NAME}
	FILE ${CMAKE_BINARY_DIR}/lib/${CMAKE_CONFIGURATION_TYPES}/${CMAKE_PROJECT_NAME}Targets.cmake 
	#FILE ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake 
	EXPORT_LINK_INTERFACE_LIBRARIES
)
#[[
export ( 
	EXPORT ${CMAKE_PROJECT_NAME}Targets
	FILE ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake 
	#EXPORT_LINK_INTERFACE_LIBRARIES
)
#]]
