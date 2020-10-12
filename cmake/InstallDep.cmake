include(FetchContent)  

macro(install_dep dep repo tag build subdirectory install_in_root)
    FetchContent_Declare(${dep} 
        GIT_REPOSITORY "${repo}"         
        GIT_TAG "${tag}"
        SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps/src/${dep}
    ) 

    if(NOT ${dep}_POPULATED)
        FetchContent_Populate(${dep})

        if(${build})
            if(${install_in_root})
                set(install_path ${CMAKE_CURRENT_SOURCE_DIR}/deps/${dep})
            else()
                set(install_path ${CMAKE_CURRENT_BINARY_DIR}/deps/${dep})
            endif()

            execute_process(
                COMMAND ${CMAKE_COMMAND}
                    "-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH}"
                    "-DCMAKE_MODULE_PATH=${CMAKE_MODULE_PATH}"
                    "-DCMAKE_INSTALL_PREFIX:PATH=${install_path}"
                    "-DCMAKE_BUILD_TYPE=${dep_build_type}"
                    ${${dep}_SOURCE_DIR}
                WORKING_DIRECTORY "${${dep}_BINARY_DIR}"
            )

            execute_process(
                COMMAND ${CMAKE_COMMAND} --build . --target install --config ${dep_build_type}
                WORKING_DIRECTORY "${${dep}_BINARY_DIR}"
            )

            list(APPEND CMAKE_PREFIX_PATH ${install_path}/lib/cmake/${dep})
            list(APPEND CMAKE_PREFIX_PATH ${install_path})

            find_package(${dep} CONFIG REQUIRED)
        endif()
        
        if(${subdirectory})
           add_subdirectory(${${dep}_SOURCE_DIR})
        endif()
    endif()
endmacro()

macro(install_dep_subdir dep repo tag)
    install_dep(${dep} ${repo} ${tag} False True False)
endmacro()

macro(install_dep_install dep repo tag install_in_root)
    install_dep(${dep} ${repo} ${tag} True False ${install_in_root})
endmacro()