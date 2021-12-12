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

cdef class Uniform(HandleObject):

    cdef UniformC *get_ptr(self) except *
    cpdef void create(self, bytes name, UniformType type_) except *
    cpdef void delete(self) except *
    cpdef void set_sampler(self, uint32_t value) except *
    cpdef void set_vec4(self, Vec4 value) except *
    cpdef void set_mat3(self, Mat3 value) except *
    cpdef void set_mat4(self, Mat4 value) except *
    cpdef void set_value(self, object value) except *
    cpdef bytes get_name(self)
    cpdef UniformType get_type(self) except *