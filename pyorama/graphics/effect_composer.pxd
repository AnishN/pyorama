from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *

ctypedef struct EffectComposerC:
    Handle handle
    Handle render_pass
    Handle[32] effect_passes

cdef class EffectComposer:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef EffectComposerC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *