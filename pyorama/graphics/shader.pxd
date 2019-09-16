from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.libs.gl cimport *

cdef class Shader:
    cdef readonly GraphicsManager graphics
    cdef readonly Handle handle

    @staticmethod
    cdef ShaderC *c_get_ptr(GraphicsManager graphics, Handle shader) nogil
    cdef ShaderC *c_get_checked_ptr(self) except *

    @staticmethod
    cdef void c_init(GraphicsManager graphics, Handle shader, ShaderType type_, char *source, size_t source_len) nogil

    @staticmethod
    cdef void c_clear(GraphicsManager graphics, Handle shader)

    @staticmethod
    cdef Error c_compile(GraphicsManager graphics, Handle shader) nogil

    @staticmethod
    cdef Error c_get_compile_error(GraphicsManager graphics, Handle shader, char **error, size_t *error_len) nogil