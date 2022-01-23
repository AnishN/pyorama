from pyorama.data.handle cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.graphics.mesh_utils cimport *
from pyorama.libs.assimp cimport *
from pyorama.libs.c cimport *

ctypedef struct MeshC:
    Handle handle
    uint8_t *vertices
    size_t num_vertices
    size_t vertex_size
    uint8_t *indices
    size_t index_size
    size_t num_indices

cdef class Mesh(HandleObject):

    cdef MeshC *get_ptr(self) except *
    cpdef void create_from_file(self, bytes file_path, bint load_texcoords=*, bint load_normals=*) except *
    cpdef void create_from_binary_file(self, bytes file_path) except *
    cpdef void create_from_source_file(self, bytes file_path) except *
    cdef void _process_node(self, aiNode *ai_node, aiScene *ai_scene)
    cdef void _process_mesh(self, aiMesh *ai_mesh, aiScene *ai_scene)
    #cpdef void get_vertices(self, Buffer vertices) except * 
    #cpdef void get_indices(self, Buffer indices) except *
    cpdef void mesh_delete(self) except *