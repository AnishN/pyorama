cdef class Image(HandleObject):

    @staticmethod
    cdef Image c_from_handle(Handle handle):
        cdef Image obj
        if handle == 0:
            raise ValueError("Image: invalid handle")
        obj = Image.__new__(Image)
        obj.handle = handle
        return obj

    cdef ImageC *c_get_ptr(self) except *:
        return <ImageC *>graphics.slots.c_get_ptr(self.handle)
    
    @staticmethod
    def init_create_from_data(uint8_t[::1] pixels, uint16_t width, uint16_t height):
        cdef:
            Image image
        image = Image.__new__(Image)
        image.create_from_data(pixels, width, height)
        return image

    cpdef void create_from_data(self, uint8_t[::1] pixels, uint16_t width, uint16_t height, size_t num_channels=4) except *:
        cdef:
            ImageC *image_ptr
            size_t num_pixel_bytes
        
        num_pixel_bytes = height * width * num_channels
        if num_pixel_bytes != pixels.shape[0]:
            raise ValueError("Image: pixels does not match width * height * num_channels")
        
        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_IMAGE)
        image_ptr = self.c_get_ptr()
        image_ptr.pixels = <uint8_t *>calloc(num_pixel_bytes, sizeof(uint8_t))
        if image_ptr.pixels == NULL:
            raise MemoryError("Image: cannot allocate pixels")
        memcpy(image_ptr.pixels, &pixels[0], num_pixel_bytes)
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.num_channels = num_channels

    @staticmethod
    def init_create_from_file(bytes file_path, size_t num_channels=4):
        cdef:
            Image image
        image = Image.__new__(Image)
        image.create_from_file(file_path, num_channels)
        return image

    cpdef void create_from_file(self, bytes file_path, size_t num_channels=4) except *:
        cdef:
            ImageC *image_ptr
            void *stbi_pixels
            uint8_t[::1] pixels
            int num_channels_in_file
            size_t num_pixel_bytes
            int width
            int height
            char *stbi_error

        stbi_set_flip_vertically_on_load(True)#TODO: move this line elsewhere
        stbi_pixels = stbi_load(<char *>file_path, &width, &height, &num_channels_in_file, num_channels)
        if stbi_pixels == NULL:
            stbi_error = stbi_failure_reason()
            raise ValueError("Image: cannot load file:", stbi_error)
        else:
            num_pixel_bytes = height * width * num_channels
            pixels = <uint8_t[:num_pixel_bytes]>stbi_pixels
            self.create_from_data(pixels, width, height, num_channels)
            free(stbi_pixels)

    cpdef void delete(self) except *:
        cdef:
            ImageC *image_ptr

        image_ptr = self.c_get_ptr()
        free(image_ptr.pixels); image_ptr.pixels = NULL
        image_ptr.width = 0
        image_ptr.height = 0
        image_ptr.num_channels = 0
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef uint8_t[::1] get_pixels(self):
        cdef:
            ImageC *image_ptr
            uint16_t h
            uint16_t w
            size_t c
        image_ptr = self.c_get_ptr()
        h = image_ptr.height
        w = image_ptr.width
        c = image_ptr.num_channels
        return <uint8_t[:h * w * c]>image_ptr.pixels

    cpdef uint8_t[:, :, ::1] get_shaped_pixels(self):
        cdef:
            ImageC *image_ptr
            uint16_t h
            uint16_t w
            size_t b
        image_ptr = self.c_get_ptr()
        h = image_ptr.height
        w = image_ptr.width
        c = image_ptr.num_channels
        return <uint8_t[:h, :w, :c]>image_ptr.pixels

    cpdef uint16_t get_width(self) except *:
        return self.c_get_ptr().width
    
    cpdef uint16_t get_height(self) except *:
        return self.c_get_ptr().height