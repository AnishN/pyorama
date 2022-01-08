from pyorama.data.handle cimport *
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
    int32_t index_offset
    int32_t index_count
    Handle program
    Handle textures[256]
    Handle samplers[256]

cdef class View(HandleObject):
    
    cdef ViewC *get_ptr(self) except *
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
    cpdef void submit(self) except *
    cpdef void touch(self) except *