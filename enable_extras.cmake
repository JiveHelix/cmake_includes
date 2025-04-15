macro(enable_extras)

    # Add test directory if testing is enabled and allowed
    if (ENABLE_TESTING AND
            (PROJECT_IS_TOP_LEVEL OR RECURSIVE_BUILD_TESTS))

        if (EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/test/CMakeLists.txt")
            add_subdirectory(test)
        endif ()

    endif ()

    # Only add examples if this is the top-level project
    if (PROJECT_IS_TOP_LEVEL)

        if (BUILD_EXAMPLES AND
                EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/examples/CMakeLists.txt")

            add_subdirectory(examples)

        endif ()

    endif ()

endmacro()
