
include(RegPackageMacro)

find_package(Qt5 COMPONENTS Core Widgets Gui REQUIRED)
add_subdirectory(MyLib)

add_library( ${CMAKE_PROJECT_NAME} SHARED
	${library_hdr}
	${library_src}
	${library_res}
)

add_custom_command(TARGET ${CMAKE_PROJECT_NAME}
	POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/include
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${library_hdr} ${CMAKE_INSTALL_PREFIX}/include
)

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC 
	${CMAKE_INSTALL_PREFIX}/include
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE 
	$<TARGET_PROPERTY:Qt5::Core,INTERFACE_INCLUDE_DIRECTORIES>
	$<TARGET_PROPERTY:Qt5::Gui,INTERFACE_INCLUDE_DIRECTORIES>
	$<TARGET_PROPERTY:Qt5::Widgets,INTERFACE_INCLUDE_DIRECTORIES>
)

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE 
	$<TARGET_LINKER_FILE:Qt5::Core> 
	$<TARGET_LINKER_FILE:Qt5::Gui>
	$<TARGET_LINKER_FILE:Qt5::Widgets>
)

install(
	TARGETS ${CMAKE_PROJECT_NAME} 
	EXPORT ${CMAKE_PROJECT_NAME}Targets
	ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
	RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
	#COMPONENT applications
)

# PACKAGE SETUP ###################################################

#RegPackage(${CMAKE_PROJECT_NAME} ${CMAKE_INSTALL_PREFIX})


#[[

include(CMakePackageConfigHelpers)

configure_package_config_file(
	${CMAKE_SOURCE_DIR}/src/${CMAKE_PROJECT_NAME}Config.cmake.in
	${CMAKE_INSTALL_PREFIX}/lib/cmake/${CMAKE_PROJECT_NAME}Config.cmake
	INSTALL_DESTINATION ${CMAKE_INSTALL_PREFIX}
)

export(
	TARGETS ${CMAKE_PROJECT_NAME}		
	FILE ${CMAKE_INSTALL_PREFIX}/lib/cmake/${CMAKE_PROJECT_NAME}Targets.cmake
)

export(PACKAGE ${CMAKE_PROJECT_NAME})

#]]

