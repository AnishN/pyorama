from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.program_enums cimport *

cpdef enum:
    PROGRAM_MAX_ATTRIBUTES = 16
    PROGRAM_MAX_UNIFORMS = 16

#Part of ProgramC, not directly created!
ctypedef struct ProgramAttributeC:
    char[256] name
    size_t name_length
    size_t size#in multiples of the type's size
    AttributeType type
    size_t location

#Part of ProgramC, not directly create!
ctypedef struct ProgramUniformC:
    char[256] name
    size_t name_length
    size_t size
    UniformType type
    size_t location

ctypedef struct ProgramC:
    Handle handle
    uint32_t gl_id
    Handle vertex
    Handle fragment
    ProgramAttributeC[16] attributes
    size_t num_attributes
    ProgramUniformC[16] uniforms
    size_t num_uniforms

cdef AttributeType c_attribute_type_from_gl(uint32_t gl_type) except *
cdef UniformType c_uniform_type_from_gl(uint32_t gl_type) except *

cdef class Program:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef ProgramC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, Shader vertex, Shader fragment) except *
    cpdef void delete(self) except *
    cdef void c_compile(self) except *
    cdef void c_setup_attributes(self) except *
    cdef void c_setup_uniforms(self) except *
    cdef void c_bind_attributes(self, Handle buffer) except *
    cdef void c_unbind_attributes(self) except *
    cdef void c_bind_uniform(self, Handle uniform) except *