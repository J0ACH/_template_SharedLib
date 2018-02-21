
# LIB SETUP ###################################################

find_package(Qt5 COMPONENTS Core Gui Widgets REQUIRED)

add_library( ${CMAKE_PROJECT_NAME} SHARED "")

add_subdirectory(MyLib)

string(TOUPPER ${CMAKE_CONFIGURATION_TYPES} configType)
set_target_properties( ${CMAKE_PROJECT_NAME}
    PROPERTIES
		ARCHIVE_OUTPUT_DIRECTORY_${configType} ${CMAKE_BINARY_DIR}/lib
		LIBRARY_OUTPUT_DIRECTORY_${configType} ${CMAKE_BINARY_DIR}/lib
		RUNTIME_OUTPUT_DIRECTORY_${configType} ${CMAKE_BINARY_DIR}/bin
		DEBUG_POSTFIX d
)

target_link_libraries(${CMAKE_PROJECT_NAME} 
	PRIVATE
		Qt5::Core
		Qt5::Gui
		Qt5::Widgets
)

add_custom_command(TARGET ${CMAKE_PROJECT_NAME}
	POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/include
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${library_hdr} ${CMAKE_BINARY_DIR}/include
)

#[[
add_custom_command(TARGET ${CMAKE_PROJECT_NAME}
	PRE_BUILD
		COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/include
		COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_PROPERTY:SharedLib,INTERFACE_SOURCES> ${CMAKE_BINARY_DIR}/include
)
#]]

# PACKAGE SETUP ###################################################

include(CMakePackageConfigHelpers)
configure_package_config_file (
	${CMAKE_CURRENT_LIST_DIR}/${CMAKE_PROJECT_NAME}Config.cmake.in
	${CMAKE_BINARY_DIR}/cmake/${CMAKE_PROJECT_NAME}Config.cmake
	INSTALL_DESTINATION ${PROJECT_NAME}_${PROJECT_VERSION}/cmake
)
write_basic_package_version_file(
	${CMAKE_BINARY_DIR}/cmake/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
	VERSION ${PROJECT_VERSION}
	COMPATIBILITY AnyNewerVersion 
)
cmake_policy(SET CMP0022 NEW)
export ( 
	TARGETS ${CMAKE_PROJECT_NAME}
	FILE ${CMAKE_BINARY_DIR}/cmake/${CMAKE_PROJECT_NAME}Targets-${CMAKE_CONFIGURATION_TYPES}.cmake 
	EXPORT_LINK_INTERFACE_LIBRARIES
)

# LIB INSTALL ###################################################

install(
	TARGETS ${CMAKE_PROJECT_NAME} 
	EXPORT ${CMAKE_PROJECT_NAME}Targets
	ARCHIVE DESTINATION ${PROJECT_NAME}_${PROJECT_VERSION}/lib
    LIBRARY DESTINATION ${PROJECT_NAME}_${PROJECT_VERSION}/lib
	RUNTIME DESTINATION ${PROJECT_NAME}_${PROJECT_VERSION}/bin
	#CONFIGURATIONS Release
)
install(
	#FILES $<TARGET_PROPERTY:SharedLib,INTERFACE_SOURCES>
	FILES ${library_hdr}
	DESTINATION ${PROJECT_NAME}_${PROJECT_VERSION}/include
)
install(
	FILES
		${CMAKE_BINARY_DIR}/cmake/${CMAKE_PROJECT_NAME}Config.cmake
		${CMAKE_BINARY_DIR}/cmake/${CMAKE_PROJECT_NAME}ConfigVersion.cmake
	DESTINATION	${PROJECT_NAME}_${PROJECT_VERSION}/cmake
)
install(
	EXPORT ${CMAKE_PROJECT_NAME}Targets
	DESTINATION ${PROJECT_NAME}_${PROJECT_VERSION}/cmake
	FILE ${CMAKE_PROJECT_NAME}Targets.cmake
)

