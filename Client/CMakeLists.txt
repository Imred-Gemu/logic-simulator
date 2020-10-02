cmake_minimum_required(VERSION 3.16)
project(logic_simulator_client)
set(CMAKE_CXX_STANDARD 17)
add_definitions(-std=c++17 -O3)

add_executable(client "wasm_cpp_src/Main.cpp")
set(CMAKE_EXECUTABLE_SUFFIX ".wasm.js")
set_target_properties(client PROPERTIES LINK_FLAGS "-s WASM=1 -s EXPORTED_FUNCTIONS=['_main']")
