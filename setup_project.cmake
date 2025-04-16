set(_DECLARE_PROJECT_DIR ${CMAKE_CURRENT_LIST_DIR} CACHE INTERNAL "")

include(${_DECLARE_PROJECT_DIR}/prevent_in_source_builds.cmake)

#! setup_project
# Configures project settings and conan dependencies.
macro (setup_project)

    if (${CMAKE_VERSION} VERSION_LESS "3.21")
        # Compute our own top-level check
        if (${CMAKE_PROJECT_NAME} STREQUAL ${PROJECT_NAME})
            set(PROJECT_IS_TOP_LEVEL TRUE)
        else ()
            set(PROJECT_IS_TOP_LEVEL FALSE)
        endif ()
    endif ()

    if (${PROJECT_IS_TOP_LEVEL})

        include(${_DECLARE_PROJECT_DIR}/top_level_options.cmake)
        include(${_DECLARE_PROJECT_DIR}/standard_project_settings.cmake)
        include(${_DECLARE_PROJECT_DIR}/add_version_header.cmake)
        include(${_DECLARE_PROJECT_DIR}/add_catch2_test.cmake)
        include(${_DECLARE_PROJECT_DIR}/find_packages.cmake)
        include(${_DECLARE_PROJECT_DIR}/enable_extras.cmake)

        if (ENABLE_TESTING)
            enable_testing()
        endif ()

        if (NOT CONAN_EXPORTED)
            include(GNUInstallDirs)
        endif ()

    endif ()

    if (${ENABLE_UNITY})
        # Add for any project you want to apply unity builds for
        set_target_properties(${PROJECT_NAME} PROPERTIES UNITY_BUILD ON)
    endif ()

endmacro ()
