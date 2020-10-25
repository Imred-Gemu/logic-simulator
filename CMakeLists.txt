cmake_minimum_required(VERSION 3.15)
include(FetchContent)  

project(logic_simulator)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS_RELEASE -O3)

set(CLIENT_SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/Client")

include("cmake/BuildClient.cmake")
include("cmake/BuildServer.cmake")