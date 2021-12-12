from pyorama.data.handle cimport *
from pyorama.data.buffer cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.c cimport *

cpdef enum IndexLayout:
    INDEX_LAYOUT_U16
    INDEX_LAYOUT_U32

ctypedef struct IndexBufferC:
    Handle handle
    bgfx_index_buffer_handle_t bgfx_id
    IndexLayout index_layout
    size_t num_indices
    bint dynamic

cdef class IndexBuffer(HandleObject):

    cdef IndexBufferC *get_ptr(self) except *
    cpdef void create(self, IndexLayout index_layout, Buffer index_data, bint dynamic=*) except *
    cpdef void delete(self) except *