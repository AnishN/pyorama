from pyorama.data.handle cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.c cimport *

cpdef enum IndexLayout:
    INDEX_LAYOUT_U16
    INDEX_LAYOUT_U32

cpdef enum IndexBufferType:
    INDEX_BUFFER_TYPE_STATIC
    INDEX_BUFFER_TYPE_DYNAMIC
    INDEX_BUFFER_TYPE_TRANSIENT

cdef union bgfx_generic_index_buffer_handle_t:
    bgfx_index_buffer_handle_t static
    bgfx_dynamic_index_buffer_handle_t dynamic
    bgfx_transient_index_buffer_t transient

ctypedef struct IndexBufferC:
    Handle handle
    bgfx_generic_index_buffer_handle_t bgfx_id
    IndexLayout layout
    uint8_t *data
    size_t num_indices
    IndexBufferType type_

ctypedef union IndexValueC:
    uint16_t u16
    uint32_t u32

cdef class IndexBuffer(HandleObject):
    cdef IndexBufferC *get_ptr(self) except *
    cpdef void create_static(self, IndexLayout layout, list indices) except *
    cpdef void delete(self) except *
    cpdef void update(self) except *