function(FindPackages)
    foreach(pkgname IN LISTS ARGN)
        # Normalize package name
        string(TOLOWER "${pkgname}" pkg_lower)

        # Check if any existing target matches ${pkgname}::
        get_property(all_targets GLOBAL PROPERTY TARGETS)
        set(already_found FALSE)

        foreach(tgt IN LISTS all_targets)
            string(FIND "${tgt}" "${pkgname}::" found_at)
            if (NOT found_at EQUAL -1)
                set(already_found TRUE)
                break()
            endif()
        endforeach()

        if (NOT already_found)
            message(STATUS "find_packages: Finding ${pkgname}")
            find_package(${pkgname} REQUIRED)
        else()
            message(STATUS "find_packages: ${pkgname} already available")
        endif()
    endforeach()
endfunction()
