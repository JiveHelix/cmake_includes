function(add_catch2_test)
    cmake_parse_arguments(ARG
        "NO_MAIN"                      # Boolean flags
        "NAME"                         # Single-value argument
        "SOURCES;LINK"            # Multi-value arguments
        ${ARGN})

    find_package(Catch2 REQUIRED)

    set(test_libraries ${ARG_LINK} project_warnings project_options)

    if(NOT ARG_NO_MAIN)
        add_library(
            ${ARG_NAME}_catch_main
            STATIC ${CMAKE_CURRENT_SOURCE_DIR}/catch_main.cpp)

        target_link_libraries(${ARG_NAME}_catch_main PUBLIC Catch2::Catch2)

        list(PREPEND test_libraries ${ARG_NAME}_catch_main)
    endif()

    add_executable(${ARG_NAME} ${ARG_SOURCES})

    target_link_libraries(${ARG_NAME} PRIVATE ${test_libraries})

    if(COMMAND add_version_header)
        add_version_header(${ARG_NAME})
    endif()

    add_test(
        NAME ${ARG_NAME}_run
        COMMAND ${ARG_NAME}
        WORKING_DIRECTORY "${CMAKE_BINARY_DIR}")

endfunction()
