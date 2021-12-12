cdef class Image(HandleObject):

    cdef ImageC *get_ptr(self) except *:
        return <ImageC *>graphics.slots.c_get_ptr(self.handle)
    
    @staticmethod
    def init_create_from_data(uint8_t[::1] pixels, uint16_t width, uint16_t height):
        cdef:
            Image image
        image = Image.__new__(Image)
        image.create_from_data(pixels, width, height)
        return image

    cpdef void create_from_data(self, uint8_t[::1] pixels, uint16_t width, uint16_t height) except *:
        cdef:
            ImageC *image_ptr
            size_t bpp = 4
            size_t pixels_size
        
        pixels_size = width * height * bpp
        if pixels_size != pixels.shape[0]:
            raise ValueError("Image: pixels does not match width * height * 4")
        
        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_IMAGE)
        image_ptr = self.get_ptr()
        image_ptr.pixels = <uint8_t *>calloc(pixels_size, sizeof(uint8_t))
        if image_ptr.pixels == NULL:
            raise MemoryError("Image: cannot allocate pixels")
        memcpy(image_ptr.pixels, &pixels[0], pixels_size)
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.bytes_per_pixel = bpp

    cpdef void delete(self) except *:
        cdef:
            ImageC *image_ptr

        image_ptr = self.get_ptr()
        free(image_ptr.pixels); image_ptr.pixels = NULL
        image_ptr.width = 0
        image_ptr.height = 0
        image_ptr.bytes_per_pixel = 0
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef uint8_t[::1] get_pixels(self):
        cdef:
            ImageC *image_ptr
            uint16_t h
            uint16_t w
            size_t b
        image_ptr = self.get_ptr()
        h = image_ptr.height
        w = image_ptr.width
        b = image_ptr.bytes_per_pixel
        return <uint8_t[:h * w * b]>image_ptr.pixels

    cpdef uint8_t[:, :, ::1] get_shaped_pixels(self):
        cdef:
            ImageC *image_ptr
            uint16_t h
            uint16_t w
            size_t b
        image_ptr = self.get_ptr()
        h = image_ptr.height
        w = image_ptr.width
        b = image_ptr.bytes_per_pixel
        return <uint8_t[:h, :w, :b]>image_ptr.pixels

    cpdef uint16_t get_width(self) except *:
        return self.get_ptr().width
    
    cpdef uint16_t get_height(self) except *:
        return self.get_ptr().height