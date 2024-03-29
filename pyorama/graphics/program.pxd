from pyorama.data.handle cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct ProgramC:
    Handle handle
    bgfx_program_handle_t bgfx_id
    Handle vertex_shader
    Handle fragment_shader
    Handle compute_shader

cdef ProgramC *program_get_ptr(Handle program) except *
cpdef Handle program_create(Handle vertex_shader, Handle fragment_shader) except *
cpdef void program_delete(Handle program) except *
