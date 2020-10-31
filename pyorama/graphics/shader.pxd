from pyorama.graphics.graphics_manager cimport *

cdef class Shader:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef ShaderC *get_ptr(self) except *
    cpdef void create(self, ShaderType type, bytes source) except *
    cpdef void create_from_file(self, ShaderType type, bytes file_path) except *
    cpdef void delete(self) except *