cmake_minimum_required(VERSION 3.15)

project(logic_simulator_client)
set(CMAKE_CXX_STANDARD 20)
add_compile_options(-std=c++20)
set(CMAKE_CXX_FLAGS_RELEASE -O3)
#Generates the debug symbols for in browser source debugging.
set(CMAKE_CXX_FLAGS_DEBUG "-g4 --source-map-base /debug/")
#Build the client as a wasm file.

file(GLOB SRC_FILES ${PROJECT_SOURCE_DIR}/src/cpp/*.cpp)
file(GLOB HEADER_FILES ${PROJECT_SOURCE_DIR}/src/cpp/*.hpp)

set(files_content "")

set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS ${SRC_FILES} ${HEADER_FILES})

foreach(file_path IN LISTS SRC_FILES HEADER_FILES)
	file(READ ${file_path} file_content)
	set(files_content "${files_content}\n${file_content}")
endforeach()

set(EXPORT_REGEX "//EM_EXPORT ([A-Za-z0-9_]+)")

set(EXPORT_MATCHES "")
string(REGEX MATCHALL ${EXPORT_REGEX} EXPORT_MATCHES ${files_content})

foreach(MATCH IN LISTS EXPORT_MATCHES)
	string(REGEX REPLACE ${EXPORT_REGEX} "'_\\1'" MATCH ${MATCH})
	list(APPEND EXPORT_LIST ${MATCH})
endforeach()

list(JOIN EXPORT_LIST ", " EXPORT_LIST)

add_executable(client ${SRC_FILES})
set(CMAKE_EXECUTABLE_SUFFIX ".wasm.js")
set_target_properties(client PROPERTIES LINK_FLAGS "-s WASM=1 -s \"EXPORTED_FUNCTIONS=[${EXPORT_LIST}]\"")
