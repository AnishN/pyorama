from pyorama.graphics.graphics_manager cimport *

cpdef enum ShaderType:
    SHADER_TYPE_VERTEX
    SHADER_TYPE_FRAGMENT

ctypedef struct ShaderC:
    Handle handle
    uint32_t gl_id
    ShaderType type

cdef class Shader:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef ShaderC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef ShaderC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef ShaderC *get_ptr(self) except *
    
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, ShaderType type, bytes source) except *
    cpdef void create_from_file(self, ShaderType type, bytes file_path) except *
    cpdef void delete(self) except *