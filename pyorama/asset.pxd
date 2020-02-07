from cpython.mem cimport PyMem_Malloc, PyMem_Realloc, PyMem_Free
from pyorama.graphics cimport *
from pyorama.libs.assimp cimport *
from pyorama.libs.c cimport *
from pyorama.math3d.common cimport *

cdef class AssetManager:
    cdef void c_scene_parse_material(self, aiScene ai_scene, GraphicsManager graphics, Handle material) except *