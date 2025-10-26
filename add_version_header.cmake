set(
    GIT_REVISION_SCRIPT
    "${CMAKE_CURRENT_LIST_DIR}/git_revision.cmake"
    CACHE
    INTERNAL
    "")

set(
    templateFile
    "${CMAKE_CURRENT_LIST_DIR}/git_revision.h.in"
    CACHE
    INTERNAL
    "")


if (NOT TARGET GetGitRevision)

    add_custom_target(
        GetGitRevision
        COMMAND ${CMAKE_COMMAND}
            -DsourceDirectory="${CMAKE_SOURCE_DIR}"
            -DoutputDirectory="${CMAKE_BINARY_DIR}"
            -DtemplateFile="${templateFile}"
            -P "${GIT_REVISION_SCRIPT}"
        BYPRODUCTS "${CMAKE_BINARY_DIR}/git_revision.h"
        COMMENT "Retrieving git revision information..."
    )

endif ()

#! add_version_header
# Adds prebuild step to generate git_version.h
macro (add_version_header targetName)

    add_dependencies(${targetName} GetGitRevision)

    # for generated git_revision.h
    target_include_directories(
        ${targetName}
        PRIVATE
        ${CMAKE_BINARY_DIR})

endmacro ()
