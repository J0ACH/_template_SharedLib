cmake_policy(SET CMP0048 NEW)

project (SharedLib VERSION 0.0.1)
cmake_minimum_required( VERSION 3.7.2 )

message(STATUS "")
message(STATUS "SharedLib config init...")

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake_modules)
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS TRUE)
set(CMAKE_AUTOMOC ON)

add_subdirectory(src)

message(STATUS "SharedLib version " ${PROJECT_VERSION})

message(STATUS "SharedLib config done...\n")