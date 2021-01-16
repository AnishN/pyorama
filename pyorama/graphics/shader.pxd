from pyorama.graphics.graphics_manager cimport *

cdef class Shader:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef ShaderC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef ShaderC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef ShaderC *get_ptr(self) except *
    
    cpdef void create(self, ShaderType type, bytes source) except *
    cpdef void create_from_file(self, ShaderType type, bytes file_path) except *
    cpdef void delete(self) except *