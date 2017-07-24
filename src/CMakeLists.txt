
# LIB SETUP ###################################################

find_package(Qt5 COMPONENTS Core Widgets Gui REQUIRED)

add_subdirectory(MyLib)

add_library( ${CMAKE_PROJECT_NAME} SHARED
	${library_hdr}
	${library_src}
	${library_res}
)

string(TOUPPER ${CMAKE_CONFIGURATION_TYPES} configType)
set_target_properties( ${CMAKE_PROJECT_NAME}
    PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY_${configType} ${CMAKE_BINARY_DIR}/lib/${CMAKE_CONFIGURATION_TYPES}
		LIBRARY_OUTPUT_DIRECTORY_${configType} ${CMAKE_BINARY_DIR}/lib/${CMAKE_CONFIGURATION_TYPES}
		RUNTIME_OUTPUT_DIRECTORY_${configType} ${CMAKE_BINARY_DIR}/bin/${CMAKE_CONFIGURATION_TYPES}
		DEBUG_POSTFIX _d
)

add_custom_command(TARGET ${CMAKE_PROJECT_NAME}
	POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/include
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${library_hdr} ${CMAKE_BINARY_DIR}/include
)

target_include_directories(${CMAKE_PROJECT_NAME} 
	PRIVATE
		${library_hdr}
	INTERFACE 
		$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>
		$<INSTALL_INTERFACE:include>
)

target_link_libraries(${CMAKE_PROJECT_NAME} 
	PRIVATE 
		Qt5::Core
		Qt5::Gui
		Qt5::Widgets
	INTERFACE
		$<TARGET_LINKER_FILE:Qt5::Core>
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
	DESTINATION lib/cmake
)
install(
	FILES ${library_hdr}
	DESTINATION include
)
install(
	FILES 
		${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
		${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
	DESTINATION	lib/cmake 
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
	#FILE ${CMAKE_BINARY_DIR}/lib/${CMAKE_CONFIGURATION_TYPES}/${CMAKE_PROJECT_NAME}Targets.cmake 
	FILE ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake 
	EXPORT_LINK_INTERFACE_LIBRARIES
)
#[[
export ( 
	EXPORT ${CMAKE_PROJECT_NAME}Targets
	FILE ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Targets.cmake 
	#EXPORT_LINK_INTERFACE_LIBRARIES
)
#]]
