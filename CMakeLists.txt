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


if(WIN32)
	set(CPACK_GENERATOR NSIS)
	set(CPACK_PACKAGE_NAME ${CMAKE_PROJECT_NAME})
	set(CPACK_PACKAGE_VENDOR "JP")
	set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "SharedLib - CPack Component Installation Example")
	set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
	#set(CPACK_PACKAGE_VERSION_MAJOR "1")
	#set(CPACK_PACKAGE_VERSION_MINOR "0")
	#set(CPACK_PACKAGE_VERSION_PATCH "0")
	set(CPACK_PACKAGE_INSTALL_DIRECTORY "Shared library") # default install folder name C:/ProgramFiles/Shared library
	set(CPACK_NSIS_MODIFY_PATH ON)
endif()
include(CPack)

#[[
install(CODE 
	"execute_process (
		COMMAND cpack --config CPackConfig.cmake
	)"
)
#]]