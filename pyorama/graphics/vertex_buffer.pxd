from pyorama.core.handle cimport *
from pyorama.core.vector cimport *
from pyorama.core.array cimport *
from pyorama.graphics.vertex_layout cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.c cimport *
from cython cimport view as cy_view

cpdef enum VertexBufferType:
    VERTEX_BUFFER_TYPE_STATIC
    VERTEX_BUFFER_TYPE_DYNAMIC
    VERTEX_BUFFER_TYPE_TRANSIENT

ctypedef union VertexBufferDataC:
    ArrayC fixed
    VectorC resizable

ctypedef union bgfx_generic_vertex_buffer_handle_t:
    bgfx_vertex_buffer_handle_t static
    bgfx_dynamic_vertex_buffer_handle_t dynamic
    bgfx_transient_vertex_buffer_t transient

ctypedef struct VertexBufferC:
    Handle handle
    Handle layout
    VertexBufferType type_
    bgfx_generic_vertex_buffer_handle_t bgfx_id
    bgfx_memory_t *memory_ptr
    bint resizable
    VertexBufferDataC data

ctypedef union VertexValueC:
    uint8_t u8
    int16_t i16
    float f32

cdef class VertexBuffer(HandleObject):
    @staticmethod
    cdef VertexBuffer c_from_handle(Handle handle)
    cdef VertexBufferC *c_get_ptr(self) except *
    cpdef void create_static(self, VertexLayout layout, list vertices) except *
    cpdef void create_static_from_array(self, VertexLayout layout, uint8_t[::1] vertices, bint copy=*) except *
    cpdef void create_dynamic_fixed(self, VertexLayout layout, size_t num_vertices) except *
    cpdef void create_dynamic_resizable(self, VertexLayout layout) except *
    cpdef void delete(self) except *
    cpdef void update(self) except *
    cpdef size_t get_num_vertices(self) except *
    cpdef size_t get_vertex_size(self) except *
    cdef char *c_get_vertex_format(self) except *
    cpdef bytes get_vertex_format(self)
    cpdef uint8_t *c_get_vertices(self) except *
    cpdef cy_view.array get_view_array(self)
    cpdef uint8_t[::1] get_raw_view_array(self) except *