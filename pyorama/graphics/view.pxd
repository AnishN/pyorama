from pyorama.core.handle cimport *
from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.texture cimport *
from pyorama.graphics.uniform cimport *
from pyorama.graphics.vertex_buffer cimport *
from pyorama.math cimport *

cpdef enum ViewClearFlags:
    VIEW_CLEAR_COLOR = BGFX_CLEAR_COLOR
    VIEW_CLEAR_DEPTH = BGFX_CLEAR_DEPTH
    VIEW_CLEAR_STENCIL = BGFX_CLEAR_STENCIL

ctypedef struct ViewRectC:
    uint16_t x
    uint16_t y
    uint16_t width
    uint16_t height

ctypedef struct ViewClearC:
    uint32_t flags
    uint32_t color
    float depth
    uint8_t stencil

ctypedef struct ViewTransformC:
    Mat4C model
    Mat4C view
    Mat4C projection

cpdef enum ViewMode:
    VIEW_MODE_DEFAULT = BGFX_VIEW_MODE_DEFAULT
    VIEW_MODE_SEQUENTIAL = BGFX_VIEW_MODE_SEQUENTIAL
    VIEW_MODE_DEPTH_ASCENDING = BGFX_VIEW_MODE_DEPTH_ASCENDING
    VIEW_MODE_DEPTH_DESCENDING = BGFX_VIEW_MODE_DEPTH_DESCENDING

cpdef enum ViewWriteState:
    VIEW_WRITE_STATE_NONE = 0
    VIEW_WRITE_STATE_R = BGFX_STATE_WRITE_R
    VIEW_WRITE_STATE_G = BGFX_STATE_WRITE_G
    VIEW_WRITE_STATE_B = BGFX_STATE_WRITE_B
    VIEW_WRITE_STATE_A = BGFX_STATE_WRITE_A
    VIEW_WRITE_STATE_Z = BGFX_STATE_WRITE_Z
    VIEW_WRITE_STATE_RGB = BGFX_STATE_WRITE_RGB
    VIEW_WRITE_STATE_RGBA = BGFX_STATE_WRITE_RGB | BGFX_STATE_WRITE_A
    VIEW_WRITE_STATE_RGBAZ = BGFX_STATE_WRITE_RGB | BGFX_STATE_WRITE_A | BGFX_STATE_WRITE_Z

cpdef enum ViewDepthState:
    VIEW_DEPTH_STATE_NONE = 0
    VIEW_DEPTH_STATE_LESS = BGFX_STATE_DEPTH_TEST_LESS
    VIEW_DEPTH_STATE_LEQUAL = BGFX_STATE_DEPTH_TEST_LEQUAL
    VIEW_DEPTH_STATE_EQUAL = BGFX_STATE_DEPTH_TEST_EQUAL
    VIEW_DEPTH_STATE_GEQUAL = BGFX_STATE_DEPTH_TEST_GEQUAL
    VIEW_DEPTH_STATE_GREATER = BGFX_STATE_DEPTH_TEST_GREATER
    VIEW_DEPTH_STATE_NOTEQUAL = BGFX_STATE_DEPTH_TEST_NOTEQUAL
    VIEW_DEPTH_STATE_NEVER = BGFX_STATE_DEPTH_TEST_NEVER
    VIEW_DEPTH_STATE_ALWAYS = BGFX_STATE_DEPTH_TEST_ALWAYS

cpdef enum ViewCullState:
    VIEW_CULL_STATE_NONE = 0
    VIEW_CULL_STATE_CW = BGFX_STATE_CULL_CW
    VIEW_CULL_STATE_CCW = BGFX_STATE_CULL_CCW

cpdef enum ViewBlendFunction:
    VIEW_BLEND_FUNCTION_ZERO = BGFX_STATE_BLEND_ZERO
    VIEW_BLEND_FUNCTION_ONE = BGFX_STATE_BLEND_ONE
    VIEW_BLEND_FUNCTION_SRC_COLOR = BGFX_STATE_BLEND_SRC_COLOR
    VIEW_BLEND_FUNCTION_INV_SRC_COLOR = BGFX_STATE_BLEND_INV_SRC_COLOR
    VIEW_BLEND_FUNCTION_SRC_ALPHA = BGFX_STATE_BLEND_SRC_ALPHA
    VIEW_BLEND_FUNCTION_INV_SRC_ALPHA = BGFX_STATE_BLEND_INV_SRC_ALPHA
    VIEW_BLEND_FUNCTION_DST_ALPHA = BGFX_STATE_BLEND_DST_ALPHA
    VIEW_BLEND_FUNCTION_INV_DST_ALPHA = BGFX_STATE_BLEND_INV_DST_ALPHA
    VIEW_BLEND_FUNCTION_DST_COLOR = BGFX_STATE_BLEND_DST_COLOR
    VIEW_BLEND_FUNCTION_INV_DST_COLOR = BGFX_STATE_BLEND_INV_DST_COLOR
    VIEW_BLEND_FUNCTION_SRC_ALPHA_SAT = BGFX_STATE_BLEND_SRC_ALPHA_SAT
    VIEW_BLEND_FUNCTION_FACTOR = BGFX_STATE_BLEND_FACTOR
    VIEW_BLEND_FUNCTION_INV_FACTOR = BGFX_STATE_BLEND_INV_FACTOR

cpdef enum ViewBlendEquation:
    VIEW_BLEND_EQUATION_ADD = BGFX_STATE_BLEND_EQUATION_ADD
    VIEW_BLEND_EQUATION_SUB = BGFX_STATE_BLEND_EQUATION_SUB
    VIEW_BLEND_EQUATION_REVSUB = BGFX_STATE_BLEND_EQUATION_REVSUB
    VIEW_BLEND_EQUATION_MIN = BGFX_STATE_BLEND_EQUATION_MIN
    VIEW_BLEND_EQUATION_MAX = BGFX_STATE_BLEND_EQUATION_MAX

cpdef enum ViewBlendMode:
    VIEW_BLEND_MODE_ADD = BGFX_STATE_BLEND_ADD
    VIEW_BLEND_MODE_ALPHA = BGFX_STATE_BLEND_ALPHA
    VIEW_BLEND_MODE_DARKEN = BGFX_STATE_BLEND_DARKEN
    VIEW_BLEND_MODE_LIGHTEN = BGFX_STATE_BLEND_LIGHTEN
    VIEW_BLEND_MODE_MULTIPLY = BGFX_STATE_BLEND_MULTIPLY
    VIEW_BLEND_MODE_NORMAL = BGFX_STATE_BLEND_NORMAL
    VIEW_BLEND_MODE_SCREEN = BGFX_STATE_BLEND_SCREEN
    VIEW_BLEND_MODE_LINEAR_BURN = BGFX_STATE_BLEND_LINEAR_BURN

ctypedef struct ViewBlendStateC:
    ViewBlendFunction rgb_src
    ViewBlendFunction rgb_dst
    ViewBlendEquation rgb_eq
    ViewBlendFunction alpha_src
    ViewBlendFunction alpha_dst
    ViewBlendEquation alpha_eq

"""
BGFX_STATE_BLEND_INDEPENDENT
BGFX_STATE_BLEND_ALPHA_TO_COVERAGE
"""

ctypedef struct ViewC:
    Handle handle
    uint16_t index
    char *name
    size_t name_length
    ViewMode mode
    ViewRectC rect
    ViewRectC scissor
    ViewClearC clear
    ViewTransformC transform
    Handle frame_buffer
    Handle vertex_buffer
    Handle index_buffer
    Handle program
    Handle textures[256]
    Handle samplers[256]
    ViewWriteState write_state
    ViewDepthState depth_state
    ViewCullState cull_state
    bint msaa
    bint blend
    ViewBlendStateC blend_state

cdef class View(HandleObject):
    @staticmethod
    cdef View c_from_handle(Handle handle)
    cdef ViewC *c_get_ptr(self) except *
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void set_name(self, bytes name) except *
    cpdef void set_mode(self, ViewMode mode) except *
    cpdef void set_rect(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
    cpdef void set_scissor(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
    cpdef void set_clear(self, uint16_t flags, uint32_t color, float depth, uint8_t stencil) except *
    cpdef void set_transform_model(self, Mat4 transform_model) except *
    cpdef void set_transform_view(self, Mat4 transform_view) except *
    cpdef void set_transform_projection(self, Mat4 transform_projection) except *
    cpdef void set_frame_buffer(self, FrameBuffer frame_buffer) except *
    cpdef void set_vertex_buffer(self, VertexBuffer vertex_buffer) except *
    cpdef void set_index_buffer(self, IndexBuffer index_buffer, int32_t offset=*, int32_t count=*) except *
    cpdef void set_program(self, Program program) except *
    cpdef void set_texture(self, Uniform sampler, Texture texture, uint8_t unit) except *
    cpdef void set_write_state(self, ViewWriteState state) except *
    cpdef void set_depth_state(self, ViewDepthState state) except *
    cpdef void set_cull_state(self, ViewCullState state) except *
    cpdef void set_msaa(self, bint state) except *
    cpdef void set_blend(self, bint state) except *
    cpdef void set_blend_rgb_state(self, ViewBlendFunction src, ViewBlendFunction dst, ViewBlendEquation eq=*) except *
    cpdef void set_blend_alpha_state(self, ViewBlendFunction src, ViewBlendFunction dst, ViewBlendEquation eq=*) except *
    cpdef void set_blend_rgba_state(self, ViewBlendFunction src, ViewBlendFunction dst, ViewBlendEquation eq=*) except *
    cpdef void submit(self) except *
    cpdef void touch(self) except *