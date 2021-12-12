from pyorama.data.handle cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct ProgramC:
    Handle handle
    bgfx_program_handle_t bgfx_id
    Handle vertex_shader
    Handle fragment_shader
    Handle compute_shader

cdef class Program(HandleObject):
    cdef ProgramC *get_ptr(self) except *
    
    cpdef void create(self, Shader vertex_shader, Shader fragment_shader) except *
    cpdef void delete(self) except *