set(BOOST_REQUESTED_VERSION 1.73.0)
set(BOOST_COMPONENTS system thread filesystem coroutine context)
include("cmake/GetBoost.cmake")

include("cmake/GetOpenSSL.cmake")

set(dep_build_type "Release")
include("cmake/InstallDep.cmake")

install_dep_subdir(simple-web-server "https://gitlab.com/eidheim/Simple-Web-Server" "master")
install_dep_subdir(simple-websocket-server "https://gitlab.com/eidheim/Simple-WebSocket-Server" "master")

add_executable(server Server/main.cpp)

target_link_libraries(server simple-web-server simple-websocket-server ${Boost_LIBRARIES})

set_target_properties(server
    PROPERTIES
    ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin/"
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin/"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/bin/"
)