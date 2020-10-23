function(TEST_MINGW)
    set(MINGW_TEST_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/mingw-test)

    set(MINGW_TEST_CMAKEFILES "cmake_minimum_required(VERSION 3.15)\nproject(mingw_test)")

    file(WRITE ${MINGW_TEST_PATH}/CMakeLists.txt ${MINGW_TEST_CMAKEFILES})
 
    execute_process(COMMAND ${CMAKE_COMMAND} 
                                     "-G" "MinGW Makefiles"
                                     "-DCMAKE_SH=SH-NOTFOUND"
                                     "-DCMAKE_C_COMPILER_WORKS=1"
                                     "-DCMAKE_CXX_COMPILER_WORKS=1"
                                     "${MINGW_TEST_PATH}"
                    WORKING_DIRECTORY "${MINGW_TEST_PATH}"
                    RESULT_VARIABLE MINGW_TEST_RESULT)
    
    file(REMOVE_RECURSE ${MINGW_TEST_PATH})

    set(MINGW_TEST_RESULT ${MINGW_TEST_RESULT} PARENT_SCOPE)
endfunction()

if(WIN32)
    set(MINGW_PATH "${EMSCRIPTEN_SDK}/mingw/4.6.2_32bit")
    STRING(REPLACE "/" "\\" MINGW_PATH "${MINGW_PATH}")

    set(ENV{PATH} "$ENV{PATH};${MINGW_PATH}")

    TEST_MINGW()
    if(${MINGW_TEST_RESULT} EQUAL 0)
        message("Mingw found!")
    else()
        message("Mingw Not Found!")

        if(EMSCRIPTEN_SDK)
            message("Mingw was not found, but Emcripten's SDK was found, attempting to install")

            set(EM_SDK_COMMAND "emsdk.bat")
            set(MINGW_VERSION "mingw-4.6.2-32bit")

            execute_process(
                COMMAND ${EM_SDK_COMMAND} install ${MINGW_VERSION}
                WORKING_DIRECTORY "${EMSCRIPTEN_SDK}"
            )

            execute_process(
                COMMAND ${EM_SDK_COMMAND} activate ${MINGW_VERSION}
                WORKING_DIRECTORY "${EMSCRIPTEN_SDK}"
            )

            message($ENV{PATH})
            message(ENV{PATH})

            TEST_MINGW()
            if(NOT ${MINGW_TEST_RESULT} EQUAL 0)
                message(FATAL_ERROR "Mingw install failed")
            endif()
        else()
            message(FATAL_ERROR "Mingw was not found, please install")
        endif()
    endif()
endif()