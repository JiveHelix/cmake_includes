
from boiler import LibraryConanFile, HeaderConanFile

from conan import ConanFile


class BoilerConan(ConanFile):
    name = "boiler"
    version = "0.1"
    exports = "boiler.py"
    package_type = "python-require"


# Make our classes visible to conan:
HeaderConanFile = HeaderConanFile
LibraryConanFile = LibraryConanFile
