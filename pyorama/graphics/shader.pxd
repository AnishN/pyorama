from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.libs.gl cimport *

cdef class Shader:
    cdef readonly GraphicsManager graphics
    cdef readonly Handle handle

    cdef ShaderC *c_get_checked_ptr(self) except *

    @staticmethod
    cdef void c_init(ShaderC *shader_ptr, ShaderType type_, char *source, size_t source_len) nogil

    @staticmethod
    cdef void c_clear(ShaderC *shader_ptr)

    @staticmethod
    cdef bint c_compile(ShaderC *shader_ptr) nogil