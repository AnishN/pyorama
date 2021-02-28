from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *

cdef class EffectComposer:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef EffectComposerC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef EffectComposerC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef EffectComposerC *get_ptr(self) except *
    
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *