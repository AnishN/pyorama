from pyorama.data.handle cimport *
from pyorama.data.buffer cimport *
from pyorama.graphics.vertex_layout cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.c cimport *

cdef union bgfx_generic_vbo_handle_t:
    bgfx_vertex_buffer_handle_t static
    bgfx_dynamic_vertex_buffer_handle_t dynamic

ctypedef struct VertexBufferC:
    Handle handle
    bgfx_vertex_buffer_handle_t bgfx_id
    Handle vertex_layout
    size_t num_vertices
    bint dynamic

cdef class VertexBuffer(HandleObject):
    cdef VertexBufferC *get_ptr(self) except *
    cpdef void create(self, VertexLayout vertex_layout, Buffer vertex_data, bint dynamic=*) except *
    cpdef void delete(self) except *
    cpdef void update(self) except *