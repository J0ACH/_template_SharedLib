
ADD_SUBDIRECTORY(MyLib)

MESSAGE(STATUS "project: " ${CMAKE_PROJECT_NAME} )
MESSAGE(STATUS "headers: " ${library_hdr} )
MESSAGE(STATUS "sources: " ${library_src} )

FIND_PACKAGE(Qt5 COMPONENTS Widgets REQUIRED)

ADD_LIBRARY(${CMAKE_PROJECT_NAME} SHARED
	${library_hdr}
	${library_src}
	${library_res}
)

TARGET_INCLUDE_DIRECTORIES(${CMAKE_PROJECT_NAME} PUBLIC ${BUILD_DIR}/include)

QT_ADDMODULE(${CMAKE_PROJECT_NAME} Core)
QT_ADDMODULE(${CMAKE_PROJECT_NAME} Widgets)

INSTALL(FILES ${library_hdr} DESTINATION ${BUILD_DIR}/include COMPONENT Devel)


# PACKAGE SETUP ###################################################

RegPackage(${CMAKE_PROJECT_NAME} ${BUILD_DIR})
