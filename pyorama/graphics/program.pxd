from pyorama.core.handle cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct ProgramC:
    Handle handle
    bgfx_program_handle_t bgfx_id
    Handle vertex_shader
    Handle fragment_shader
    Handle compute_shader

cdef ProgramC *c_program_get_ptr(Handle handle) except *
cdef Handle c_program_create() except *
cdef void c_program_delete(Handle handle) except *

cdef class Program(HandleObject):
    @staticmethod
    cdef Program c_from_handle(Handle handle)
    cdef ProgramC *c_get_ptr(self) except *
    cpdef void create(self, Shader vertex_shader, Shader fragment_shader) except *
    cpdef void delete(self) except *