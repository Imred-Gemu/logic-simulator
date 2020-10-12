#When calling the cmake command, or in your IDE cmake options:
#Set -DCLIENT_BUILD_CMAKE_TOOLCHAIN="<EmscriptenRoot>/cmake/Modules/Platform/Emscripten.cmake" where "EmscriptenRoot" is your Emscripten SDK
#location.
set(CLIENT_BUILD_CMAKE_TOOLCHAIN $ENV{CLIENT_BUILD_CMAKE_TOOLCHAIN})

if(WIN32)
    set(CLIENT_BUILD_MAKEFILES "MinGW Makefiles")
else()
    set(CLIENT_BUILD_MAKEFILES "Unix Makefiles")
endif()
#Client directory setup.
set(CLIENT_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/../Client")
string(TOLOWER "${CMAKE_BUILD_TYPE}" CLIENT_BUILD_DIR)
set(CLIENT_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/client-build-${CLIENT_BUILD_DIR}")
file(MAKE_DIRECTORY "${CLIENT_BUILD_DIR}")
#Generate client make files.
message("Configuring client project " ${CLIENT_BUILD_DIR})
execute_process(COMMAND ${CMAKE_COMMAND} "-DCMAKE_TOOLCHAIN_FILE=${CLIENT_BUILD_CMAKE_TOOLCHAIN}"
                                         "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
                                         "-G" "${CLIENT_BUILD_MAKEFILES}"
                                         "-DCMAKE_SH=SH-NOTFOUND"
                                         "${CLIENT_SOURCE_DIR}"
                WORKING_DIRECTORY "${CLIENT_BUILD_DIR}")
#Build the client.
add_custom_target(build-client ALL COMMAND ${CMAKE_COMMAND} "--build" "${CLIENT_BUILD_DIR}" "--target" "all")
#Copy the built client to a folder in the server build directory.
set(CLIENT_FILES "${CLIENT_SOURCE_DIR}/index.html" "${CLIENT_SOURCE_DIR}/clinit.jsx"
                "${CLIENT_BUILD_DIR}/client.wasm.js" "${CLIENT_BUILD_DIR}/client.wasm.wasm")
set(CLIENT_OUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/Client")
file(MAKE_DIRECTORY "${CLIENT_OUT_DIR}")
add_custom_target(copy-client ALL COMMAND ${CMAKE_COMMAND} "-E" "copy_if_different" ${CLIENT_FILES} "${CLIENT_OUT_DIR}")
add_dependencies(copy-client build-client)

if(${CMAKE_BUILD_TYPE} MATCHES "Debug")

    set(DEBUG_OUT_DIR "${CLIENT_OUT_DIR}/wasm_cpp_src")
    file(MAKE_DIRECTORY "${DEBUG_OUT_DIR}")
    add_custom_target(copy-debug-map ALL COMMAND ${CMAKE_COMMAND} "-E" "copy" "${CLIENT_BUILD_DIR}/client.wasm.wasm.map"
            "${DEBUG_OUT_DIR}")
    add_dependencies(copy-debug-map build-client)
    add_custom_target(copy-debug-src ALL COMMAND ${CMAKE_COMMAND} "-E" "copy_directory" "${CLIENT_SOURCE_DIR}/wasm_cpp_src"
            "${DEBUG_OUT_DIR}")
    add_dependencies(copy-debug-src build-client)

endif()