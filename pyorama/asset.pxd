from cpython.mem cimport PyMem_Malloc, PyMem_Realloc, PyMem_Free
from pyorama.graphics cimport *
from pyorama.libs.assimp cimport *
from pyorama.libs.c cimport *
from pyorama.math3d.common cimport *

cdef class AssetManager:
    cdef void c_scene_parse_material(self, aiMaterial *ai_material, GraphicsManager graphics, Handle material) except *
    cdef void c_scene_parse_mesh(self, aiMesh *ai_mesh, GraphicsManager graphics, Handle mesh) except *
    #cdef void c_scene_parse_nodes(self, aiScene *ai_scene, GraphicsManager graphics) except *
    #cdef void c_scene_parse_node(self, aiNode *ai_node, GraphicsManager graphics, Handle node) except *