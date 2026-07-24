option(ENABLE_UNITY "Enable Unity builds of projects" OFF)

if (MSVC)
    # Force MSVC to conform to the standard
    # https://devblogs.microsoft.com/cppblog/
    # msvc-now-correctly-reports-__cplusplus/
    add_compile_options(/Zc:__cplusplus)
    add_compile_options(/Zc:alignedNew)
    add_compile_options(/bigobj)
    add_compile_options(/MP)
    add_compile_options(/diagnostics:caret /FC)

    option(
        ENABLE_AVX2
        "Enable AVX2 vector instructions"
        ON)

    option(
        ENABLE_LTO
        "Enable link-time optimization"
        OFF)

    if (ENABLE_AVX2)
        # Add AVX2 to all configs except Debug.
        add_compile_options("$<$<NOT:$<CONFIG:Debug>>:/arch:AVX2>")
    endif ()

    if (ENABLE_LTO)
        # Add LTO to release builds only.
        add_compile_options("$<$<CONFIG:Release>:/GL>")
        add_link_options("$<$<CONFIG:Release>:/LTCG>")
    endif ()

    # Makes static libraries by default.
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    set(CMAKE_CXX_FLAGS_DEBUG "/MTd /Od /Zi /DDEBUG")
    set(CMAKE_CXX_FLAGS_RELEASE "/MT /DNDEBUG /O2")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "/MT /DNDEBUG /O2")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "/MT /DNDEBUG /O2")
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

set(ENABLES_DEFAULT ON)

option(ENABLE_TESTING "Enable Test Builds" ${ENABLES_DEFAULT})

option(ENABLE_PCH "Enable Precompiled Headers" OFF)
option(RECURSIVE_BUILD_TESTS "Build tests of all subprojects" OFF)
option(BUILD_EXAMPLES "Build the example targets" ON)

option(
    ENABLE_IPO
    "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)"
    OFF)

