execute_process(COMMAND python "--version"
                RESULT_VARIABLE PYTHON_TEST_RESULT)

if(NOT ${PYTHON_TEST_RESULT} EQUAL 0)
    message(FATAL_ERROR "Python not found, please install python version 2.7 or superior ")
endif()