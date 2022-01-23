from pyorama.data.handle cimport *
from pyorama.graphics.vertex_layout cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.c cimport *

cdef union bgfx_generic_vertex_buffer_handle_t:
    bgfx_vertex_buffer_handle_t static
    bgfx_dynamic_vertex_buffer_handle_t dynamic
    bgfx_transient_vertex_buffer_t transient

cpdef enum VertexBufferType:
    VERTEX_BUFFER_TYPE_STATIC
    VERTEX_BUFFER_TYPE_DYNAMIC
    VERTEX_BUFFER_TYPE_TRANSIENT

ctypedef struct VertexBufferC:
    Handle handle
    bgfx_generic_vertex_buffer_handle_t bgfx_id
    Handle layout
    uint8_t *data
    size_t num_vertices
    VertexBufferType type_

ctypedef union VertexValueC:
    uint8_t u8
    int16_t i16
    float f32

cdef class VertexBuffer(HandleObject):
    cdef VertexBufferC *get_ptr(self) except *
    cpdef void create_static(self, VertexLayout layout, list vertices) except *
    cpdef void delete(self) except *
    cpdef void update(self) except *