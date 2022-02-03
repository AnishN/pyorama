from pyorama.core.handle cimport *
from pyorama.core.vector cimport *
from pyorama.core.array cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.c cimport *
from cython cimport view as cy_view

cpdef enum IndexLayout:
    INDEX_LAYOUT_U16
    INDEX_LAYOUT_U32

cpdef enum IndexBufferType:
    INDEX_BUFFER_TYPE_STATIC
    INDEX_BUFFER_TYPE_DYNAMIC
    INDEX_BUFFER_TYPE_TRANSIENT

ctypedef union IndexBufferDataC:
    ArrayC fixed
    VectorC resizable

ctypedef union bgfx_generic_index_buffer_handle_t:
    bgfx_index_buffer_handle_t static
    bgfx_dynamic_index_buffer_handle_t dynamic
    bgfx_transient_index_buffer_t transient

ctypedef struct IndexBufferC:
    Handle handle
    IndexLayout layout
    char[2] format_
    IndexBufferType type_
    bgfx_generic_index_buffer_handle_t bgfx_id
    bgfx_memory_t *memory_ptr
    bint resizable
    IndexBufferDataC data

ctypedef union IndexValueC:
    uint16_t u16
    uint32_t u32

cdef IndexBufferC *c_index_buffer_get_ptr(Handle handle) except *
cdef Handle c_index_buffer_create() except *
cdef void c_index_buffer_delete(Handle handle) except *

cdef class IndexBuffer(HandleObject):
    @staticmethod
    cdef IndexBuffer c_from_handle(Handle handle)
    cdef IndexBufferC *c_get_ptr(self) except *
    cpdef void create_static(self, IndexLayout layout, list indices) except *
    cpdef void create_static_from_array(self, IndexLayout layout, uint8_t[::1] indices, bint copy=*) except *
    cpdef void create_dynamic_fixed(self, IndexLayout layout, size_t num_indices) except *
    cpdef void create_dynamic_resizable(self, IndexLayout layout) except *
    cpdef void delete(self) except *
    cpdef void update(self) except *
    cpdef size_t get_num_indices(self) except *
    cpdef size_t get_index_size(self) except *
    cdef char *c_get_index_format(self) except *
    cpdef bytes get_index_format(self)
    cpdef uint8_t *c_get_indices(self) except *
    cpdef cy_view.array get_view_array(self)
    cpdef uint8_t[::1] get_raw_view_array(self) except *