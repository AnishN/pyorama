"""
bgfx_texture_handle_t bgfx_create_texture(const bgfx_memory_t* _mem, uint64_t _flags, uint8_t _skip, bgfx_texture_info_t* _info)
bgfx_texture_handle_t bgfx_create_texture_2d(uint16_t _width, uint16_t _height, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
bgfx_texture_handle_t bgfx_create_texture_2d_scaled(bgfx_backbuffer_ratio_t _ratio, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags)
bgfx_texture_handle_t bgfx_create_texture_3d(uint16_t _width, uint16_t _height, uint16_t _depth, bint _hasMips, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
bgfx_texture_handle_t bgfx_create_texture_cube(uint16_t _size, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)

void bgfx_update_texture_2d(bgfx_texture_handle_t _handle, uint16_t _layer, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const bgfx_memory_t* _mem, uint16_t _pitch)
void bgfx_update_texture_3d(bgfx_texture_handle_t _handle, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _z, uint16_t _width, uint16_t _height, uint16_t _depth, const bgfx_memory_t* _mem)
void bgfx_update_texture_cube(bgfx_texture_handle_t _handle, uint16_t _layer, uint8_t _side, uint8_t _mip, uint16_t _x, uint16_t _y, uint16_t _width, uint16_t _height, const bgfx_memory_t* _mem, uint16_t _pitch)
uint32_t bgfx_read_texture(bgfx_texture_handle_t _handle, void* _data, uint8_t _mip)
void bgfx_set_texture_name(bgfx_texture_handle_t _handle, const char* _name, int32_t _len)
void* bgfx_get_direct_access_ptr(bgfx_texture_handle_t _handle)
void bgfx_destroy_texture(bgfx_texture_handle_t _handle)
"""

"""
bgfx_texture_handle_t bgfx_create_texture_2d(uint16_t _width, uint16_t _height, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
bgfx_texture_handle_t bgfx_create_texture_3d(uint16_t _width, uint16_t _height, uint16_t _depth, bint _hasMips, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
bgfx_texture_handle_t bgfx_create_texture_cube(uint16_t _size, bint _hasMips, uint16_t _numLayers, bgfx_texture_format_t _format, uint64_t _flags, const bgfx_memory_t* _mem)
"""

cdef class Texture(HandleObject):

    cdef TextureC *get_ptr(self) except *:
        return <TextureC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create_2d_from_image(Image image):
        cdef:
            Texture texture

        texture = Texture.__new__(Texture)
        texture.create_2d_from_image(image)
        return texture

    cpdef void create_2d_from_image(self, Image image) except *:
        cdef:
            TextureC *texture_ptr
            ImageC *image_ptr
            size_t num_pixel_bytes
            bgfx_memory_t *memory_ptr
        
        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_TEXTURE)
        texture_ptr = self.get_ptr()
        image_ptr = image.get_ptr()
        num_pixel_bytes = image_ptr.width * image_ptr.height * image_ptr.bytes_per_pixel
        memory_ptr = bgfx_copy(image_ptr.pixels, num_pixel_bytes)
        texture_ptr.bgfx_id = bgfx_create_texture_2d(
            image_ptr.width,
            image_ptr.height,
            False,
            0,
            #BGFX_TEXTURE_FORMAT_RGBA8,
            BGFX_TEXTURE_FORMAT_BGRA8,
            #BGFX_TEXTURE_FORMAT_ABGR8,
            0,#BGFX_TEXTURE_NONE | BGFX_SAMPLER_NONE,
            memory_ptr,
        )

    #cpdef void texture_update_2d_from_image(Handle image)

    cpdef void delete(self) except *:
        cdef:
            TextureC *texture_ptr
        texture_ptr = self.get_ptr()
        bgfx_destroy_texture(texture_ptr.bgfx_id)
        graphics.slots.c_delete(self.handle)
        self.handle = 0