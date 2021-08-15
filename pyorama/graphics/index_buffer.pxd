from pyorama.data.handle cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.c cimport *

cpdef enum IndexLayout:
    INDEX_LAYOUT_UINT16
    INDEX_LAYOUT_UINT32

ctypedef struct IndexBufferC:
    Handle handle
    bgfx_index_buffer_handle_t bgfx_id
    IndexLayout index_layout
    size_t num_indices

cdef IndexBufferC *index_buffer_get_ptr(Handle index_buffer) except *
cpdef Handle index_buffer_create(IndexLayout index_layout, uint8_t[::1] index_data) except *
cpdef void index_buffer_delete(Handle index_buffer) except *