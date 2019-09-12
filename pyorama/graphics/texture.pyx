cdef class Texture:

    def __init__(self):
        raise NotImplementedError()

    def init(self, Sampler sampler, Image image):
        cdef TextureC *texture_ptr
        texture_ptr = self.c_get_checked_ptr()
        Texture.c_init(texture_ptr, sampler.handle, image.handle)

    def clear(self):
        cdef TextureC *texture_ptr
        texture_ptr = self.c_get_checked_ptr()
        Texture.c_clear(texture_ptr)

    cdef TextureC *c_get_checked_ptr(self) except *:
        cdef TextureC *texture_ptr
        ItemSlotMap.c_get_ptr(&self.graphics.textures, self.handle, <void **>&texture_ptr)
        if texture_ptr == NULL:
            raise MemoryError("Texture: cannot get ptr from invalid handle")
        return texture_ptr

    @staticmethod
    cdef void c_init(TextureC *texture_ptr, Handle sampler, Handle image) nogil:
        texture_ptr.sampler = sampler
        texture_ptr.image = image
    
    @staticmethod
    cdef void c_clear(TextureC *texture_ptr) nogil:
        texture_ptr.sampler = 0
        texture_ptr.image = 0