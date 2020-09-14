import ctypes, glob

lib_base_path = "./pyorama/libs/shared/*.so"
lib_paths = glob.glob(lib_base_path)
libs = []
for lib_path in lib_paths:
    lib = ctypes.CDLL(lib_path)
    libs.append(lib)

from pyorama.core.app cimport *
from pyorama.libs.freetype cimport *

cdef:
    FT_Library library
error = FT_Init_FreeType(&library)
print(error)
