
SET(library_hdr
	${CMAKE_CURRENT_LIST_DIR}/MyClass.h
	PARENT_SCOPE
)

SET(library_src
	${CMAKE_CURRENT_LIST_DIR}/MyClass.cpp
	PARENT_SCOPE
)

#[[
target_sources(${CMAKE_PROJECT_NAME}
	PRIVATE 
		${CMAKE_CURRENT_LIST_DIR}/MyClass.cpp
		${CMAKE_CURRENT_LIST_DIR}/MyClass.h	 
	#PUBLIC
		#${CMAKE_CURRENT_LIST_DIR}/MyClass.h
	INTERFACE
		${CMAKE_CURRENT_LIST_DIR}/MyClass.h	 
		#MyClass.h
		#include/MyClass.h	 
		#include/MyClass.h	
		#$<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/MyClass.h>
		#$<INSTALL_INTERFACE:${PROJECT_NAME}_${PROJECT_VERSION}/include/MyClass.h>
)
#]]



#[[
get_target_property(print_SOURCES SharedLib SOURCES) 
message(STATUS "\t print_SOURCES: " ${print_SOURCES})
#]]