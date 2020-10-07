cmake_minimum_required(VERSION 3.16)
project(logic_simulator_client)
set(CMAKE_CXX_STANDARD 17)
add_compile_options(-std=c++17)
set(CMAKE_CXX_FLAGS_RELEASE -O3)
#Generates the debug symbols for in browser source debugging.
set(CMAKE_CXX_FLAGS_DEBUG "-g4 --source-map-base /wasm_cpp_src/")
#Build the client as a wasm file.
add_executable(client "wasm_cpp_src/Main.cpp")
set(CMAKE_EXECUTABLE_SUFFIX ".wasm.js")
set_target_properties(client PROPERTIES LINK_FLAGS "-s WASM=1 -s EXPORTED_FUNCTIONS=['_main']")
