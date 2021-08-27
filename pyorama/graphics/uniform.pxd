from pyorama.math cimport *
from pyorama.data.handle cimport *
from pyorama.graphics.graphics_system cimport *

cpdef enum UniformType:
    UNIFORM_TYPE_SAMPLER = BGFX_UNIFORM_TYPE_SAMPLER
    #BGFX_UNIFORM_TYPE_END is reserved, so do not use
    UNIFORM_TYPE_VEC4 = BGFX_UNIFORM_TYPE_VEC4
    UNIFORM_TYPE_MAT3 = BGFX_UNIFORM_TYPE_MAT3
    UNIFORM_TYPE_MAT4 = BGFX_UNIFORM_TYPE_MAT4
    #BGFX_UNIFORM_TYPE_COUNT wrapping not needed

ctypedef struct UniformC:
    Handle handle
    bgfx_uniform_handle_t bgfx_id

cdef UniformC *uniform_get_ptr(Handle uniform) except *
cpdef Handle uniform_create(bytes name, UniformType type_) except *
cpdef void uniform_delete(Handle uniform) except *
cpdef void uniform_set_sampler(Handle uniform, uint32_t value) except *
cpdef void uniform_set_vec4(Handle uniform, Vec4 value) except *
cpdef void uniform_set_mat3(Handle uniform, Mat3 value) except *
cpdef void uniform_set_mat4(Handle uniform, Mat4 value) except *
cpdef void uniform_set(Handle uniform, object value) except *
cpdef bytes uniform_get_name(Handle uniform)
cpdef UniformType uniform_get_type(Handle uniform) except *
#cpdef size_t uniform_get_count(Handle uniform) except *