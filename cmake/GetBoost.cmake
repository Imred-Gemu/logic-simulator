
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR}/deps/boost/)

find_package(Boost ${BOOST_REQUESTED_VERSION} CONFIG COMPONENTS ${BOOST_COMPONENTS})

if(NOT Boost_FOUND)
	string(REPLACE "." "_" BOOST_REQUESTED_VERSION_UNDERSCORE ${BOOST_REQUESTED_VERSION})
	set(BOOST_URL https://managedway.dl.sourceforge.net/project/boost/boost/${BOOST_REQUESTED_VERSION}/boost_${BOOST_REQUESTED_VERSION_UNDERSCORE}.zip)
	 
	foreach(component ${BOOST_COMPONENTS})
	    list(APPEND BOOST_COMPONENTS_FOR_BUILD --with-${component})
	endforeach()

    message("Downloading Boost at ${BOOST_URL}")
    FetchContent_Declare(boost
        URL ${BOOST_URL}
        SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/deps-src/boost
        BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR}/deps/boost
     ) 

    if(NOT Boost_POPULATED)
        FetchContent_Populate(boost)
           set(install_path ${CMAKE_CURRENT_BINARY_DIR}/deps/boost)

            if(WIN32)
                set(BOOT_BOOTSTRAP "bootstrap.bat")
            else()
                set(BOOT_BOOTSTRAP "bootstrap.sh")
            endif()

            message("CONVIGURING BOOST WITH IN " ${boost_SOURCE_DIR})

            execute_process(
                COMMAND ${BOOT_BOOTSTRAP} "--prefix=${install_path}"
                WORKING_DIRECTORY "${boost_SOURCE_DIR}"
            )

            if(WIN32)
            	set(BOOT_BUILD "b2.bat")
            else()
            	set(BOOT_BUILD "b2.sh")
            endif()

            message("BUILDING BOOST WITH " ${BOOST_COMPONENTS_FOR_BUILD})
            message("INSTALL DIRECTORY ${install_path}")

            execute_process(
                COMMAND b2 "--prefix=${install_path}" ${BOOST_COMPONENTS_FOR_BUILD} install
                WORKING_DIRECTORY "${boost_SOURCE_DIR}"
            )
    endif()

	find_package(Boost ${BOOST_REQUESTED_VERSION} CONFIG COMPONENTS ${Boost_COMPONENTS} REQUIRED)
endif()
