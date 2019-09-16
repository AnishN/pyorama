cdef class Image:

    def __init__(self):
        raise NotImplementedError()

    def init(self, size_t width, size_t height, uint8_t[:] pixels):
        cdef ImageC *image_ptr
        image_ptr = self.c_get_checked_ptr()
        Image.c_init(image_ptr, width, height, &pixels[0])

    def init_from_file(self, bytes file_path):
        cdef:
            ImageC *image_ptr
            Error check
        image_ptr = self.c_get_checked_ptr()
        check = Image.c_init_from_file(image_ptr, file_path)
        if check == ERROR_LOAD_FILE:
            raise ValueError("Image: cannot load file")

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
        cdef:
            ImageC *image_ptr
            Error check
        check = ItemSlotMap.c_get_ptr(&self.graphics.images, self.handle, <void **>&image_ptr)
        if check == ERROR_INVALID_HANDLE:
            raise MemoryError("Image: invalid handle")
        return image_ptr
    
    @staticmethod
    cdef void c_init(ImageC *image_ptr, size_t width, size_t height, uint8_t *pixels) nogil:
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.pixels = pixels

    @staticmethod
    cdef Error c_init_from_file(ImageC *image_ptr, char *file_path) nogil:
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
        surface = IMG_Load(file_path)
        if surface == NULL:
            return ERROR_LOAD_FILE
        converted_surface = SDL_ConvertSurfaceFormat(surface, SDL_PIXELFORMAT_RGBA8888, 0)
        if converted_surface == NULL:
            SDL_FreeSurface(surface)#free the surface at this exit point
            return ERROR_LOAD_FILE
        image_ptr.pixels = <uint8_t *>converted_surface.pixels
        image_ptr.width = converted_surface.w
        image_ptr.height = converted_surface.h
        SDL_FreeSurface(surface)
        free(converted_surface)#free the struct, not the void *pixels data!
        return ERROR_NONE

    @staticmethod
    cdef void c_clear(ImageC *image_ptr) nogil:
        image_ptr.width = 0
        image_ptr.height = 0
        free(image_ptr.pixels)
        image_ptr.pixels = NULL