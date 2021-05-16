from pyorama.core.handle cimport *

ctypedef struct MeshBatchC:
    Handle handle
    uint16_t num_meshes
    Handle[65536] meshes
    Handle vertex_buffer
    Handle index_buffer
    Handle texture

"""
    cpdef Handle mesh_batch_create(self) except *
    cpdef void mesh_batch_delete(self, Handle batch) except *
    cpdef void mesh_batch_set_meshes(self, Handle batch, Handle[::1] meshes) except *
    cpdef Handle mesh_batch_get_vertex_buffer(self, Handle batch) except *
    cpdef Handle mesh_batch_get_index_buffer(self, Handle batch) except *
    cdef void _mesh_batch_update(self, Handle batch) except *
"""