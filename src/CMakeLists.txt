

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

TARGET_LINK_LIBRARIES(${CMAKE_PROJECT_NAME} PUBLIC Qt5::Widgets)