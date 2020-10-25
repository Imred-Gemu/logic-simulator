set(BOOST_REQUESTED_VERSION 1.73.0)
set(BOOST_COMPONENTS system thread filesystem coroutine context)
include("cmake/GetBoost.cmake")

include("cmake/GetOpenSSL.cmake")

set(dep_build_type "Release")
include("cmake/InstallDep.cmake")

install_dep_subdir(efsw "https://github.com/SpartanJ/efsw" "master")
install_dep_subdir(simple-web-server "https://gitlab.com/eidheim/Simple-Web-Server" "master")
install_dep_subdir(simple-websocket-server "https://gitlab.com/eidheim/Simple-WebSocket-Server" "master")

add_executable(server Server/main.cpp)

target_link_libraries(server efsw simple-web-server simple-websocket-server ${Boost_LIBRARIES})

set(CLIENT_BUILD_COMMAND "\\\"${CMAKE_COMMAND}\\\" --build ${CMAKE_CURRENT_BINARY_DIR} --target copy-client")

if(WIN32)
	#STRING(REPLACE "/" "\\\\" CLIENT_BUILD_COMMAND "${CLIENT_BUILD_COMMAND}")
endif()

target_compile_definitions(server PRIVATE CLIENT_SRC_PATH="${CLIENT_SOURCE_DIR}" CLIENT_BUILD_COMMAND="${CLIENT_BUILD_COMMAND}")

set(SERVER_BIN_DIR "${CMAKE_CURRENT_BINARY_DIR}/bin/")

set_target_properties(server
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${SERVER_BIN_DIR}"
    LIBRARY_OUTPUT_DIRECTORY "${SERVER_BIN_DIR}"
    RUNTIME_OUTPUT_DIRECTORY "${SERVER_BIN_DIR}"
)

list(APPEND SERVER_DEPENDENCIES_DLL "$<TARGET_FILE:efsw>")

add_custom_target(copy-server-dll ALL
    COMMAND ${CMAKE_COMMAND} "-E" "copy_if_different" ${SERVER_DEPENDENCIES_DLL} "$<TARGET_FILE_DIR:server>")
add_dependencies(copy-server-dll server)