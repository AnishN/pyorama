from cpython.object cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.graphics.graphics_enums cimport *
from pyorama.graphics.graphics_manager cimport *

cdef class FrameBuffer:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef FrameBufferC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef FrameBufferC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef FrameBufferC *get_ptr(self) except *

    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void attach_textures(self, dict textures) except *