from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.vertex_buffer cimport *

cdef class View:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle

    @staticmethod
    cdef ViewC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef ViewC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef ViewC *get_ptr(self) except *

    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void set_depth(self, bint depth) except *
    cpdef void set_depth_func(self, DepthFunc depth_func) except *
    cpdef void set_blend(self, bint blend) except *
    cpdef void set_blend_func(self, BlendFunc src_rgb, BlendFunc dst_rgb, BlendFunc src_alpha, BlendFunc dst_alpha) except *
    cpdef void set_clear_flags(self, uint32_t clear_flags) except *
    cpdef void set_clear_color(self, Vec4 color) except *
    cpdef void set_clear_depth(self, float depth) except *
    cpdef void set_clear_stencil(self, uint32_t stencil) except *
    cpdef void set_color_mask(self, bint r, bint g, bint b, bint a) except *
    cpdef void set_depth_mask(self, bint depth) except *
    cpdef void set_stencil_mask(self, bint stencil) except *
    cpdef void set_masks(self, bint r, bint g, bint b, bint a, bint depth, bint stencil) except *
    cpdef void set_rect(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
    cpdef void set_program(self, Program program) except *
    cpdef void set_uniforms(self, list uniforms) except *
    cpdef void set_vertex_buffer(self, VertexBuffer buffer) except *
    cpdef void set_index_buffer(self, IndexBuffer buffer) except *
    cpdef void set_textures(self, dict textures) except *
    cpdef void set_frame_buffer(self, FrameBuffer frame_buffer) except *