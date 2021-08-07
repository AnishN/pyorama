from pyorama.data.handle cimport *
from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.graphics.frame_buffer cimport *

cpdef enum ViewClearFlags:
    VIEW_CLEAR_COLOR = BGFX_CLEAR_COLOR
    VIEW_CLEAR_DEPTH = BGFX_CLEAR_DEPTH
    VIEW_CLEAR_STENCIL = BGFX_CLEAR_STENCIL

ctypedef struct ViewC:
    Handle handle
    uint16_t index

cdef class View:
    cdef:
        readonly Handle handle
    
    cdef ViewC *c_get_ptr(self) except *
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void set_name(self, bytes name) except *
    cpdef void set_rect(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
    #cpdef void set_rect_ratio(self, uint16_t x, uint16_t y, bgfx_backbuffer_ratio_t ratio) except *
    #cpdef void set_scissor(self, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
    cpdef void set_clear(self, uint16_t flags, uint32_t rgba, float depth, uint8_t stencil) except *
    #cpdef void set_clear_mrt(self, uint16_t flags, float depth, uint8_t stencil, uint8_t c0, uint8_t c1, uint8_t c2, uint8_t c3, uint8_t c4, uint8_t c5, uint8_t c6, uint8_t c7) except *
    #cpdef void set_mode(self, bgfxmode_t mode) except *
    cpdef void set_frame_buffer(self, FrameBuffer fbo) except *
    #cpdef void set_transform(self, void* view, void* proj) except *
    #cpdef void set_order(self, uint16_t num, bgfx_view_id_t* order) except *
    cpdef void submit(self) except *