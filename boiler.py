import os
from conan import ConanFile
from conan.tools.files import copy
from conan.tools.cmake import CMake, CMakeToolchain, cmake_layout
from conan.errors import ConanInvalidConfiguration


class BaseConanFile(ConanFile):
    name = None
    settings = "os", "compiler", "build_type", "arch"

    def export_sources(self):
        if not self.name:
            raise ConanInvalidConfiguration("name must be defined in subclass")

        copy(
            self,
            "CMakeLists.txt",
            self.recipe_folder,
            self.export_sources_folder)

        copy(
            self,
            "*",
            src=os.path.join(self.recipe_folder, "cmake_includes"),
            dst=os.path.join(self.export_sources_folder, "cmake_includes"))

        copy(
            self,
            "*",
            src=os.path.join(self.recipe_folder, self.name),
            dst=os.path.join(self.export_sources_folder, self.name))

    def layout(self):
        if not self.name:
            raise ConanInvalidConfiguration("name must be defined in subclass")

        cmake_layout(self)
        self.cpp.source.includedirs = [""]
        self.cpp.package.includedirs = ["include"]
        self.cpp.build.libdirs = [f"{self.name}"]

    def package_info(self):
        if not self.name:
            raise ConanInvalidConfiguration("name must be defined in subclass")

        self.cpp_info.set_property("cmake_file_name", self.name)

        self.cpp_info.set_property(
            "cmake_target_name",
            f"{self.name}::{self.name}")

        self.cpp_info.includedirs = ["include"]

    def package(self):
        if not self.name:
            raise ConanInvalidConfiguration("name must be defined in subclass")

        # Copy headers
        copy(self,
             pattern="*.h",
             src=os.path.join(self.source_folder, f"{self.name}"),
             dst=os.path.join(self.package_folder, "include", f"{self.name}"))

        # Copy static libraries
        copy(self,
             pattern="*.a",
             src=os.path.join(self.build_folder, f"{self.name}"),
             dst=os.path.join(self.package_folder, "lib"),
             keep_path=False)

        # Copy shared libraries
        copy(self,
             pattern="*.so*",
             src=os.path.join(self.build_folder, f"{self.name}"),
             dst=os.path.join(self.package_folder, "lib"),
             keep_path=False)

        copy(self,
             pattern="*.dylib",
             src=os.path.join(self.build_folder, f"{self.name}"),
             dst=os.path.join(self.package_folder, "lib"),
             keep_path=False)


class HeaderConanFile(BaseConanFile):

    generators = "CMakeToolchain", "CMakeDeps"

    def package_info(self):
        super().package_info()
        self.cpp_info.bindirs = []
        self.cpp_info.libdirs = []

    def package_id(self):
        self.info.clear()


class LibraryConanFile(BaseConanFile):

    options = {
        "fPIC": [True, False],
        "shared": [True, False],
        "CMAKE_TRY_COMPILE_TARGET_TYPE": ["EXECUTABLE", "STATIC_LIBRARY", None]
    }

    default_options = {
        "fPIC": True,
        "shared": False,
        "CMAKE_TRY_COMPILE_TARGET_TYPE": None
    }

    generators = "CMakeDeps"

    def package_info(self):
        super().package_info()
        self.cpp_info.libs = [f"{self.name}"]

        self.output.info(
            f"{self.name}: includedirs = {self.cpp_info.includedirs}")

    def generate(self):
        tc = CMakeToolchain(self)

        if self.options.CMAKE_TRY_COMPILE_TARGET_TYPE:
            tc.variables["CMAKE_TRY_COMPILE_TARGET_TYPE"] = \
                str(self.options.CMAKE_TRY_COMPILE_TARGET_TYPE)

        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()
