from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.vertex_buffer cimport *
from pyorama.graphics.texture cimport *
from pyorama.graphics.texture_enums cimport *
from pyorama.math3d cimport *

cpdef enum ViewClear:
    VIEW_CLEAR_COLOR = (1 << 0)
    VIEW_CLEAR_DEPTH = (1 << 1)
    VIEW_CLEAR_STENCIL = (1 << 2)

ctypedef enum DepthFunc:
    DEPTH_FUNC_NEVER
    DEPTH_FUNC_LESSER
    DEPTH_FUNC_EQUAL
    DEPTH_FUNC_LESSER_EQUAL
    DEPTH_FUNC_GREATER
    DEPTH_FUNC_NOT_EQUAL
    DEPTH_FUNC_GREATER_EQUAL
    DEPTH_FUNC_ALWAYS

cpdef enum BlendFunc:
    BLEND_FUNC_ZERO
    BLEND_FUNC_ONE
    BLEND_FUNC_SRC_COLOR
    BLEND_FUNC_ONE_MINUS_SRC_COLOR
    BLEND_FUNC_DST_COLOR
    BLEND_FUNC_ONE_MINUS_DST_COLOR
    BLEND_FUNC_SRC_ALPHA
    BLEND_FUNC_ONE_MINUS_SRC_ALPHA
    BLEND_FUNC_DST_ALPHA
    BLEND_FUNC_ONE_MINUS_DST_ALPHA
    BLEND_FUNC_CONSTANT_COLOR
    BLEND_FUNC_ONE_MINUS_CONSTANT_COLOR
    BLEND_FUNC_CONSTANT_ALPHA
    BLEND_FUNC_ONE_MINUS_CONSTANT_ALPHA

ctypedef struct ViewC:
    Handle handle
    uint32_t clear_flags
    Vec4C clear_color
    float clear_depth
    uint32_t clear_stencil
    uint16_t[4] rect
    bint[4] color_mask
    bint depth_mask
    bint stencil_mask
    bint depth
    DepthFunc depth_func
    bint blend
    BlendFunc src_rgb
    BlendFunc dst_rgb
    BlendFunc src_alpha
    BlendFunc dst_alpha
    Mat4C view_mat
    Mat4C proj_mat
    Handle program
    Handle[16] uniforms
    size_t num_uniforms
    Handle vertex_buffer
    Handle index_buffer
    Handle[16] textures
    TextureUnit[16] texture_units
    size_t num_texture_units
    Handle frame_buffer

cdef uint32_t c_clear_flags_to_gl(uint32_t flags) nogil
cdef uint32_t c_blend_func_to_gl(BlendFunc func) nogil
cdef uint32_t c_depth_func_to_gl(DepthFunc func) nogil

cdef class View:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef ViewC *c_get_ptr(self) except *
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