from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.vertex_buffer cimport *

cdef class View:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef ViewC *get_ptr(self) except *
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void set_clear_flags(self, uint32_t clear_flags) except *
    cpdef void set_clear_color(self, Vec4 color) except *
    cpdef void set_clear_depth(self, float depth) except *
    cpdef void set_clear_stencil(self, uint32_t stencil) except *
    cpdef void set_rect(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
    cpdef void set_program(self, Program program) except *
    cpdef void set_uniforms(self, list uniforms) except *
    cpdef void set_vertex_buffer(self, VertexBuffer buffer) except *
    cpdef void set_index_buffer(self, IndexBuffer buffer) except *
    cpdef void set_textures(self, dict textures) except *
    cpdef void set_frame_buffer(self, FrameBuffer frame_buffer) except *