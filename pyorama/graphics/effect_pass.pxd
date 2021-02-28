from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *

ctypedef struct EffectPassC:
    Handle handle
    Handle[16] uniforms
    Handle[16] in_textures
    Handle[16] out_textures

cdef class EffectPass:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef EffectPassC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef EffectPassC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef EffectPassC *get_ptr(self) except *
    
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *