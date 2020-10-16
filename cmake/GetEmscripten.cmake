include("cmake/CheckPython.cmake")

if($ENV{EMSCRIPTEN_TOOLCHAIN})
    set(EMSCRIPTEN_TOOLCHAIN $ENV{EMSCRIPTEN_TOOLCHAIN})
endif()

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/deps/emscripten/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake)
    set(EMSCRIPTEN_SDK ${CMAKE_CURRENT_SOURCE_DIR}/deps/emscripten)
    set(EMSCRIPTEN_TOOLCHAIN ${EMSCRIPTEN_SDK}/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake)
endif()

if(EMSCRIPTEN_TOOLCHAIN)
    if(NOT EXISTS ${EMSCRIPTEN_TOOLCHAIN})
        message(FATAL_ERROR "Emscripten path is set but could not find the file: " ${EMSCRIPTEN_TOOLCHAIN})
    endif()
else()
    message("Variable \"EMSCRIPTEN_TOOLCHAIN\" doesn't exist, downloading Emscripten")

    FetchContent_Declare(emscripten
        GIT_REPOSITORY "https://github.com/emscripten-core/emsdk"         
        GIT_TAG "master"
        SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps/emscripten
        BINARY_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps/emscripten
     ) 

    FetchContent_Populate(emscripten)

    set(install_path ${CMAKE_CURRENT_SOURCE_DIR}/deps/emscripten)

    if(WIN32)
        set(EM_SDK_COMMAND "emsdk.bat")
        set(EM_SOURCE_COMMAND "emsdk_env.bat")
    else()
        set(EM_SDK_COMMAND "./emsdk")
        set(EM_SOURCE_COMMAND "source ./emsdk_env.sh")
    endif()

    execute_process(
        COMMAND ${EM_SDK_COMMAND} install latest
        WORKING_DIRECTORY "${emscripten_SOURCE_DIR}"
    )

    execute_process(
        COMMAND ${EM_SDK_COMMAND} activate latest
        WORKING_DIRECTORY "${emscripten_SOURCE_DIR}"
    )

    execute_process(
        COMMAND ${EM_SOURCE_COMMAND}
        WORKING_DIRECTORY "${emscripten_SOURCE_DIR}"
    )
endif()