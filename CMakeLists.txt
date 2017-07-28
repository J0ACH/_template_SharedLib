cmake_policy(SET CMP0048 NEW)

project (SharedLib VERSION 0.2.1)
cmake_minimum_required( VERSION 3.7.2 )

message(STATUS "")
message(STATUS "SharedLib [${PROJECT_VERSION}] config init...")

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
set(CMAKE_AUTOMOC ON)
#set(CMAKE_INSTALL_PREFIX $ENV{ProgramFiles}/${PROJECT_NAME})

add_subdirectory(src)

#export ( PACKAGE ${CMAKE_PROJECT_NAME} ) 

message(STATUS "\t CMAKE_INSTALL_PREFIX: ${CMAKE_INSTALL_PREFIX}")
message(STATUS "SharedLib config done...\n")

