from pyorama.data.handle cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.c cimport *

ctypedef struct VertexBufferC:
    Handle handle
    bgfx_vertex_buffer_handle_t bgfx_id
    Handle vertex_layout
    size_t num_vertices

cdef VertexBufferC *vertex_buffer_get_ptr(Handle vertex_buffer) except *
cpdef Handle vertex_buffer_create(Handle vertex_layout, uint8_t[::1] vertex_data) except *
cpdef void vertex_buffer_delete(Handle vertex_buffer) except *