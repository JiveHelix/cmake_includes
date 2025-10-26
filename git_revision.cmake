message(STATUS "Resolving GIT Information")

set(buildRevision "unknown")
set(buildTag "unknown")

find_package(Git)

if (GIT_FOUND)

    execute_process(
        COMMAND ${GIT_EXECUTABLE} describe --always --abbrev=10 --dirty
        WORKING_DIRECTORY "${sourceDirectory}"
        OUTPUT_VARIABLE buildRevision
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    message(STATUS "GIT revision: ${buildRevision}")

    execute_process(
        COMMAND ${GIT_EXECUTABLE} describe --tags --abbrev=4 --dirty
        WORKING_DIRECTORY "${sourceDirectory}"
        OUTPUT_VARIABLE buildTag
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    message( STATUS "GIT tag: ${buildTag}")

else ()

    message(STATUS "GIT not found")

endif ()

string(TIMESTAMP buildTime UTC)
file(MAKE_DIRECTORY "${outputDirectory}")

configure_file("${templateFile}" "${outputDirectory}/git_revision.h" @ONLY)
