find_program(GLSLANG_VALIDATOR glslangValidator REQUIRED)

function(AddShaders targetName)

    set(shaderSourceDir "${CMAKE_CURRENT_SOURCE_DIR}/shaders")
    set(shaderBinaryDir "${CMAKE_CURRENT_BINARY_DIR}/shaders")

    file(MAKE_DIRECTORY "${shaderBinaryDir}")

    set(shaderOutputs)
    set(shaderSources)

    foreach(shaderSource IN LISTS ARGN)

        set(outputPath "${shaderBinaryDir}/${shaderSource}.spv")
        set(sourcePath "${shaderSourceDir}/${shaderSource}")

        add_custom_command(
            OUTPUT
                ${outputPath}
            COMMAND
                "${GLSLANG_VALIDATOR}"
                -DUSE_SAMPLER
                -V "${sourcePath}"
                -o "${outputPath}"
            DEPENDS "${sourcePath}")

        list(APPEND shaderSources ${sourcePath})
        list(APPEND shaderOutputs ${outputPath})

    endforeach ()

    target_sources(
        "${targetName}"
        PRIVATE
        ${shaderSources})

    set_property(
        TARGET "${targetName}"
        APPEND
        PROPERTY SHADER_ASSETS ${shaderOutputs})

    add_custom_target(
        "${targetName}Shaders"
        DEPENDS
            ${shaderOutputs})

    add_dependencies(
        "${targetName}"
        "${targetName}Shaders")

endfunction ()
