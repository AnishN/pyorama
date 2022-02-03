from pyorama.app cimport *
from pyorama.asset.shader_loader cimport *
from pyorama.core.handle cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.bgfx cimport *

cpdef enum ShaderType:
    SHADER_TYPE_VERTEX
    SHADER_TYPE_FRAGMENT
    SHADER_TYPE_COMPUTE

ctypedef struct ShaderC:
    Handle handle
    ShaderType type_
    bgfx_shader_handle_t bgfx_id

cdef ShaderC *c_shader_get_ptr(Handle handle) except *
cdef Handle c_shader_create() except *
cdef void c_shader_delete(Handle handle) except *

cdef class Shader(HandleObject):
    @staticmethod
    cdef Shader c_from_handle(Handle handle)
    cdef ShaderC *c_get_ptr(self) except *
    cpdef void create_from_binary_file(self, ShaderType type_, bytes file_path) except *
    cpdef void create_from_source_file(self, ShaderType type_, bytes file_path) except *
    cpdef void delete(self) except *
    cpdef ShaderType get_type(self) except *
