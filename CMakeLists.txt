cmake_minimum_required(VERSION 3.15)
include(FetchContent)  

project(logic_simulator)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS_RELEASE -O3)

include("cmake/BuildClient.cmake")
include("cmake/BuildServer.cmake")