cmake_policy(SET CMP0048 NEW)

project (SharedLib VERSION 0.2.1)
cmake_minimum_required( VERSION 3.7.2 )

message(STATUS "")
message(STATUS "SharedLib [${PROJECT_VERSION}] config init...")

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
set(CMAKE_AUTOMOC ON)

set(cacheDir ${CMAKE_SOURCE_DIR}/cache)
set(buildDir ${CMAKE_SOURCE_DIR}/build)
set(installDir ${CMAKE_SOURCE_DIR}/install)

message(STATUS "\t cacheDir: ${cacheDir}")
message(STATUS "\t buildDir: ${buildDir}")
message(STATUS "\t installDir: ${installDir}")

add_subdirectory(source)

#export ( PACKAGE ${CMAKE_PROJECT_NAME} ) 

message(STATUS "SharedLib config done...\n")


# CPACK SETUP ###################################################
# otevri SharedLib.sln - pMouse - Open dev cmd propmpt - "cpack -G WIX -C Release"

if(WIN32)
	set(CPACK_GENERATOR WIX)
	set(CPACK_PACKAGE_NAME ${CMAKE_PROJECT_NAME})
	set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})

	set(CPACK_PACKAGE_INSTALL_DIRECTORY ${CMAKE_PROJECT_NAME})
	set(CPACK_WIX_UPGRADE_GUID "12725C7F-BB8F-45BA-8616-DEA091488B9D")
	
	include(CPack)
endif()

#[[
install(CODE 
	"execute_process (
		COMMAND cpack --config CPackConfig.cmake
	)"
)
#]]