

find_package(Qt5 COMPONENTS Core Widgets Gui REQUIRED)

add_subdirectory(MyLib)

add_library( ${CMAKE_PROJECT_NAME} SHARED
	${library_hdr}
	${library_src}
	${library_res}
)

set_target_properties( ${CMAKE_PROJECT_NAME}
    PROPERTIES
	    ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_INSTALL_PREFIX}/debug/lib
		ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_INSTALL_PREFIX}/lib
		LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_INSTALL_PREFIX}/debug/lib
		LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_INSTALL_PREFIX}/lib
		RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_INSTALL_PREFIX}/debug/bin
		RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_INSTALL_PREFIX}/bin
)


add_custom_command(TARGET ${CMAKE_PROJECT_NAME}
	POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/include
		COMMAND ${CMAKE_COMMAND} -E copy_if_different ${library_hdr} ${CMAKE_INSTALL_PREFIX}/include
)

get_target_property(qtCoreInclude Qt5::Core INTERFACE_INCLUDE_DIRECTORIES) 
get_target_property(qtGuiInclude Qt5::Gui INTERFACE_INCLUDE_DIRECTORIES) 
get_target_property(qtWidgetsInclude Qt5::Widgets INTERFACE_INCLUDE_DIRECTORIES) 
#get_target_property(qtWinMainInclude Qt5::WinMain INTERFACE_INCLUDE_DIRECTORIES) 

target_include_directories(${CMAKE_PROJECT_NAME} 
	PRIVATE
		${library_hdr}
	PUBLIC
		${qtCoreInclude}
		${qtGuiInclude}
		${qtWidgetsInclude}
		${qtWinMainInclude}
		#$<TARGET_PROPERTY:Qt5::Core,INTERFACE_INCLUDE_DIRECTORIES>
		#$<TARGET_PROPERTY:Qt5::Gui,INTERFACE_INCLUDE_DIRECTORIES>
		#$<TARGET_PROPERTY:Qt5::Widgets,INTERFACE_INCLUDE_DIRECTORIES>
	INTERFACE 
		${CMAKE_INSTALL_PREFIX}/include
)

get_target_property(qtCoreLib Qt5::Core IMPORTED_IMPLIB_RELEASE) 
get_target_property(qtGuiLib Qt5::Gui IMPORTED_IMPLIB_RELEASE) 
get_target_property(qtWidgetsLib Qt5::Widgets IMPORTED_IMPLIB_RELEASE) 
get_target_property(qtWinMainLib Qt5::WinMain IMPORTED_LOCATION_RELEASE) 

target_link_libraries(${CMAKE_PROJECT_NAME} 
	PRIVATE 
		$<TARGET_LINKER_FILE:Qt5::Core> 
		$<TARGET_LINKER_FILE:Qt5::Gui>
		$<TARGET_LINKER_FILE:Qt5::Widgets>
	INTERFACE
		${qtCoreLib}
		${qtGuiLib}
		${qtWidgetsLib}
		${qtWinMainLib}
		#$<TARGET_PROPERTY:Qt5::Widgets,INTERFACE_IMPORTED_IMPLIB>
		#Qt5::Widgets
		#$<INSTALL_INTERFACE:Qt5::Widgets>
		#$<TARGET_PROPERTY:Qt5::Core,IMPORTED_IMPLIB_RELEASE>
		
)

#[[
install(
	TARGETS ${CMAKE_PROJECT_NAME} EXPORT MyLibraryConfig
	#EXPORT ${CMAKE_PROJECT_NAME}Targets
	ARCHIVE DESTINATION install/lib
    LIBRARY DESTINATION install/lib
	RUNTIME DESTINATION install/bin
	#COMPONENT applications
)
install(EXPORT MyLibraryConfig DESTINATION install/cmake)
#]]

# PACKAGE SETUP ###################################################

include(RegisterModule)
PackageAdd(
	TARGETS ${CMAKE_PROJECT_NAME}
	VERSION ${PROJECT_VERSION}
	PATH ${CMAKE_INSTALL_PREFIX}/cmake
)
