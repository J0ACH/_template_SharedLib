
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
		ARCHIVE_OUTPUT_DIRECTORY_${configType} ${CMAKE_BINARY_DIR}/lib
		LIBRARY_OUTPUT_DIRECTORY_${configType} ${CMAKE_BINARY_DIR}/lib
		RUNTIME_OUTPUT_DIRECTORY_${configType} ${CMAKE_BINARY_DIR}/bin
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
)

# PACKAGE SETUP ###################################################

include(CMakePackageConfigHelpers)
configure_package_config_file (
	${CMAKE_CURRENT_SOURCE_DIR}/${CMAKE_PROJECT_NAME}Config.cmake.in
	${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake
	INSTALL_DESTINATION lib/cmake
	#PATH_VARS foo_INCLUDE_DIRS
)
write_basic_package_version_file(
	${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY AnyNewerVersion 
)
string(TOLOWER ${CMAKE_CONFIGURATION_TYPES} buildConfig)
export ( 
	TARGETS ${CMAKE_PROJECT_NAME}
	FILE ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Targets-${buildConfig}.cmake 
)

# LIB INSTALL ###################################################

install(
	FILES ${library_hdr}
	DESTINATION include
)
install(
	TARGETS ${CMAKE_PROJECT_NAME} 
	EXPORT ${CMAKE_PROJECT_NAME}Config
	ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
	RUNTIME DESTINATION bin
)
install(
	EXPORT ${CMAKE_PROJECT_NAME}Config 
	DESTINATION lib/cmake
)
install(
	FILES ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
	DESTINATION	lib/cmake 
)