cdef class Image:

    def __init__(self):
        raise NotImplementedError()

    def init(self, size_t width, size_t height, uint8_t[:] pixels):
        cdef ImageC *image_ptr
        image_ptr = self.c_get_checked_ptr()
        Image.c_init(image_ptr, width, height, &pixels[0])

    def init_from_file(self, str file_path):
        cdef ImageC *image_ptr
        image_ptr = self.c_get_checked_ptr()
        Image.c_init_from_file(image_ptr, file_path)

    def clear(self):
        cdef ImageC *image_ptr
        image_ptr = self.c_get_checked_ptr()
        Image.c_clear(image_ptr)

    @property
    def width(self):
        cdef ImageC *image_ptr
        image_ptr = self.c_get_checked_ptr()
        return image_ptr.width
    
    @property
    def height(self):
        cdef ImageC *image_ptr
        image_ptr = self.c_get_checked_ptr()
        return image_ptr.height
    
    @property
    def size(self):
        cdef ImageC *image_ptr
        image_ptr = self.c_get_checked_ptr()
        return (image_ptr.width, image_ptr.height)

    @property
    def pixels(self):
        cdef:
            ImageC *image_ptr
            uint8_t[::1] pixels
            size_t w
            size_t h
        image_ptr = self.c_get_checked_ptr()
        w = image_ptr.width
        h = image_ptr.height
        return <uint8_t[:h * w * 4]>image_ptr.pixels

    cdef ImageC *c_get_checked_ptr(self) except *:
        cdef ImageC *image_ptr
        item_slot_map_get_ptr(&self.graphics.images, self.handle, <void **>&image_ptr)
        if image_ptr == NULL:
            raise MemoryError("Image: cannot get ptr from invalid handle")
        return image_ptr

    @staticmethod
    cdef void c_init(ImageC *image_ptr, size_t width, size_t height, uint8_t *pixels) nogil:
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.pixels = pixels

    @staticmethod
    cdef void c_init_from_file(ImageC *image_ptr, str file_path) except *:
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
        b_file_path = file_path.encode("utf-8")
        surface = IMG_Load(b_file_path)
        if surface == NULL:
            raise ValueError("Image: cannot load file")
        converted_surface = SDL_ConvertSurfaceFormat(surface, SDL_PIXELFORMAT_RGBA8888, 0)
        if converted_surface == NULL:
            raise ValueError("Image: cannot convert to RGBA8888 format")
        image_ptr.pixels = <uint8_t *>converted_surface.pixels
        image_ptr.width = converted_surface.w
        image_ptr.height = converted_surface.h
        SDL_FreeSurface(surface)
        free(converted_surface)#free the struct, not the void *pixels data!

    @staticmethod
    cdef void c_clear(ImageC *image_ptr) nogil:
        image_ptr.width = 0
        image_ptr.height = 0
        free(image_ptr.pixels)
        image_ptr.pixels = NULL