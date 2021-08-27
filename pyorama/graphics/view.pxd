from pyorama.data.handle cimport *
from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.texture cimport *
from pyorama.graphics.uniform cimport *
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

ctypedef struct ViewC:
    Handle handle
    uint16_t index
    char *name
    size_t name_length
    ViewRectC rect
    ViewClearC clear
    ViewTransformC transform
    Handle frame_buffer
    Handle vertex_buffer
    Handle index_buffer
    Handle program
    Handle textures[256]
    Handle samplers[256]

cdef ViewC *view_get_ptr(Handle view) except *
cpdef Handle view_create() except *
cpdef void view_delete(Handle view) except *
cpdef void view_set_name(Handle view, bytes name) except *
cpdef void view_set_rect(Handle view, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
cpdef void view_set_clear(Handle view, uint16_t flags, uint32_t color, float depth, uint8_t stencil) except *
cpdef void view_set_transform_model(Handle view, Mat4 transform_model) except *
cpdef void view_set_transform_view(Handle view, Mat4 transform_view) except *
cpdef void view_set_transform_projection(Handle view, Mat4 transform_projection) except *
cpdef void view_set_frame_buffer(Handle view, Handle frame_buffer) except *
cpdef void view_set_vertex_buffer(Handle view, Handle vertex_buffer) except *
cpdef void view_set_index_buffer(Handle view, Handle index_buffer) except *
cpdef void view_set_program(Handle view, Handle program) except *
cpdef void view_set_texture(Handle view, Handle sampler, Handle texture, uint8_t unit) except *
cpdef void view_submit(Handle view) except *
cpdef void view_touch(Handle view) except *