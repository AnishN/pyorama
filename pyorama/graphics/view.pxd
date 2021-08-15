from pyorama.data.handle cimport *
from pyorama.libs.c cimport *
from pyorama.libs.bgfx cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.math cimport *

cpdef enum ViewClearFlags:
    VIEW_CLEAR_COLOR = BGFX_CLEAR_COLOR
    VIEW_CLEAR_DEPTH = BGFX_CLEAR_DEPTH
    VIEW_CLEAR_STENCIL = BGFX_CLEAR_STENCIL

ctypedef struct ViewC:
    Handle handle
    uint16_t index

cdef ViewC *view_get_ptr(Handle view) except *
cpdef Handle view_create() except *
cpdef void view_delete(Handle view) except *
cpdef void view_set_name(Handle view, bytes name) except *
cpdef void view_set_rect(Handle view, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
#cpdef void view_set_rect_ratio(Handle view, uint16_t x, uint16_t y, bgfx_backbuffer_ratio_t ratio) except *
#cpdef void view_set_scissor(Handle view, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *
cpdef void view_set_clear(Handle view, uint16_t flags, uint32_t rgba, float depth, uint8_t stencil) except *
#cpdef void view_set_clear_mrt(Handle view, uint16_t flags, float depth, uint8_t stencil, uint8_t c0, uint8_t c1, uint8_t c2, uint8_t c3, uint8_t c4, uint8_t c5, uint8_t c6, uint8_t c7) except *
#cpdef void view_set_mode(Handle view, bgfxmode_t mode) except *
cpdef void view_set_frame_buffer(Handle view, Handle frame_buffer) except *
cpdef void view_set_transform(Handle view, Mat4 view_mat, Mat4 proj_mat) except *
cpdef void view_set_vertex_buffer(Handle view, Handle vertex_buffer) except *
cpdef void view_set_index_buffer(Handle view, Handle index_buffer) except *
#cpdef void view_set_order(Handle view, uint16_t num, bgfx_view_id_t* order) except *
cpdef void view_submit(Handle view, Handle program) except *
cpdef void view_touch(Handle view) except *