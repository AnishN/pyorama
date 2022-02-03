cdef TextureC *c_texture_get_ptr(Handle handle) except *:
    cdef:
        TextureC *ptr
    CHECK_ERROR(slot_map_get_ptr(&graphics_system.textures, handle, <void **>&ptr))
    return ptr

cdef Handle c_texture_create() except *:
    cdef:
        Handle handle
    CHECK_ERROR(slot_map_create(&graphics_system.textures, &handle))
    return handle

cdef void c_texture_delete(Handle handle) except *:
    slot_map_delete(&graphics_system.textures, handle)

cdef class Texture(HandleObject):

    @staticmethod
    cdef Texture c_from_handle(Handle handle):
        cdef Texture obj
        if handle == 0:
            raise ValueError("Texture: invalid handle")
        obj = Texture.__new__(Texture)
        obj.handle = handle
        return obj

    cdef TextureC *c_get_ptr(self) except *:
        return c_texture_get_ptr(self.handle)

    @staticmethod
    def init_create_from_image(Image image):
        cdef:
            Texture texture

        texture = Texture.__new__(Texture)
        texture.create_from_image(image)
        return texture

    cpdef void create_from_image(self, Image image) except *:
        cdef:
            TextureC *texture_ptr
            ImageC *image_ptr
            size_t num_pixel_bytes
            bgfx_memory_t *memory_ptr
        
        self.handle = c_texture_create()
        texture_ptr = self.c_get_ptr()
        image_ptr = image.c_get_ptr()
        num_pixel_bytes = image_ptr.width * image_ptr.height * image_ptr.num_channels
        memory_ptr = bgfx_copy(image_ptr.pixels, num_pixel_bytes)
        texture_ptr.bgfx_id = bgfx_create_texture_2d(
            image_ptr.width,
            image_ptr.height,
            False,
            1,
            BGFX_TEXTURE_FORMAT_RGBA8,
            0,
            memory_ptr,
        )
    
    cpdef void delete(self) except *:
        cdef:
            TextureC *texture_ptr
        texture_ptr = self.c_get_ptr()
        bgfx_destroy_texture(texture_ptr.bgfx_id)
        c_texture_delete(self.handle)
        self.handle = 0