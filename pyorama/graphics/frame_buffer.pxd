from pyorama.data.handle cimport *
from pyorama.libs.bgfx cimport *
from pyorama.graphics.window cimport *

ctypedef struct FrameBufferC:
    Handle handle
    bgfx_frame_buffer_handle_t bgfx_id
    uint16_t width
    uint16_t height
    bgfx_texture_format_t texture_format
    uint64_t texture_flags
    char *name
    size_t name_length

cdef class FrameBuffer:
    cdef:
        readonly Handle handle
    
    cdef FrameBufferC *c_get_ptr(self) except *
    #cpdef void create(self, uint16_t width, uint16_t height, format, flags)
    #cpdef void create_scaled(self, ratio, format, flags)
    #cpdef void create_from_textures(self, list textures)
    #cpdef void create_from_attachment
    cpdef void create_from_window(self, Window window) except *
    #cpdef void set_name
    #cpdef Handle get_texture(self, uint8_t attachment)
    #cpdef destroy
    cpdef void delete(self) except *

"""
bgfx_frame_buffer_handle_t bgfx_create_frame_buffer(uint16_t _width, uint16_t _height, bgfx_texture_format_t _format, uint64_t _textureFlags)
bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_scaled(bgfx_backbuffer_ratio_t _ratio, bgfx_texture_format_t _format, uint64_t _textureFlags)
bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_from_handles(uint8_t _num, const bgfx_texture_handle_t* _handles, bint _destroyTexture)
bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_from_attachment(uint8_t _num, const bgfx_attachment_t* _attachment, bint _destroyTexture)
bgfx_frame_buffer_handle_t bgfx_create_frame_buffer_from_nwh(void* _nwh, uint16_t _width, uint16_t _height, bgfx_texture_format_t _format, bgfx_texture_format_t _depthFormat)
void bgfx_set_frame_buffer_name(bgfx_frame_buffer_handle_t _handle, const char* _name, int32_t _len)
bgfx_texture_handle_t bgfx_get_texture(bgfx_frame_buffer_handle_t _handle, uint8_t _attachment)
void bgfx_destroy_frame_buffer(bgfx_frame_buffer_handle_t _handle)
"""