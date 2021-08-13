from pyorama.data.handle cimport *
from pyorama.graphics.graphics_system cimport *

cpdef enum ShaderType:
    SHADER_TYPE_VERTEX
    SHADER_TYPE_FRAGMENT
    SHADER_TYPE_COMPUTE

ctypedef struct ShaderC:
    Handle handle
    ShaderType type_
    bgfx_shader_handle_t bgfx_id

cdef ShaderC *shader_get_ptr(Handle shader) except *
cpdef Handle shader_create(ShaderType type_) except *
cpdef void shader_delete(Handle shader) except *
cpdef void shader_compile_from_file(Handle shader, bytes file_path) except *
cpdef void shader_compile_from_bytes(Handle shader, bytes source) except *
cpdef ShaderType shader_get_type(Handle shader) except *
