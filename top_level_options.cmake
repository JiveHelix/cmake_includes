option(ENABLE_UNITY "Enable Unity builds of projects" OFF)

if (MSVC)
    # Force MSVC to conform to the standard
    # https://devblogs.microsoft.com/cppblog/
    # msvc-now-correctly-reports-__cplusplus/
    add_compile_options(/Zc:__cplusplus)
    add_compile_options(/Zc:alignedNew)
endif ()

if (${CMAKE_CXX_COMPILER_ID} MATCHES ".*Clang")
    option(
        ENABLE_BUILD_WITH_TIME_TRACE
        "Enable -ftime-trace to generate time tracing .json files on clang"
        OFF)

    if (ENABLE_BUILD_WITH_TIME_TRACE)
        add_compile_definitions(project_options INTERFACE -ftime-trace)
    endif ()
endif ()

option(ENABLE_TESTING "Enable Test Builds" ON)
option(ENABLE_PCH "Enable Precompiled Headers" OFF)
option(RECURSIVE_BUILD_TESTS "Build tests of all subprojects" OFF)

option(ENABLE_IPO
       "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)"
       OFF)
