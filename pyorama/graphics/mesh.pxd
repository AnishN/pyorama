from pyorama.data.handle cimport *
from pyorama.data.buffer cimport *
from pyorama.graphics.graphics_system cimport *
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

cdef MeshC *mesh_get_ptr(Handle mesh) except *
cpdef Handle mesh_create_from_file(bytes file_path, bint load_tex_coords=*, bint load_normals=*) except *
cpdef void mesh_get_vertices(Handle mesh, Buffer vertices) except *
cpdef void mesh_get_indices(Handle mesh, Buffer indices) except *
cpdef void mesh_delete(Handle mesh) except *