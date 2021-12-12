from pyorama.data.handle cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.asset.shader_loader cimport *

cpdef enum ShaderType:
    SHADER_TYPE_VERTEX
    SHADER_TYPE_FRAGMENT
    SHADER_TYPE_COMPUTE

ctypedef struct ShaderC:
    Handle handle
    ShaderType type_
    bgfx_shader_handle_t bgfx_id

cdef class Shader(HandleObject):

    cdef ShaderC *get_ptr(self) except *
    cpdef void create_from_binary_file(self, ShaderType type_, bytes file_path) except *
    cpdef void create_from_source_file(self, ShaderType type_, bytes file_path) except *
    cpdef void delete(self) except *
    cpdef ShaderType get_type(self) except *
