cdef uint8_t ITEM_TYPE = GRAPHICS_ITEM_TYPE_IMAGE
ctypedef ImageC ItemTypeC

cdef class Image:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    @staticmethod
    cdef ItemTypeC *get_ptr_by_index(GraphicsManager manager, size_t index) except *:
        cdef:
            PyObject *slot_map_ptr
        slot_map_ptr = manager.slot_maps[<uint8_t>ITEM_TYPE]
        return <ItemTypeC *>(<ItemSlotMap>slot_map_ptr).items.c_get_ptr(index)

    @staticmethod
    cdef ItemTypeC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *:
        return <ItemTypeC *>manager.get_ptr(handle)

    cdef ItemTypeC *get_ptr(self) except *:
        return Image.get_ptr_by_handle(self.manager, self.handle)

    cpdef void create(self, uint16_t width, uint16_t height, uint8_t[::1] data=None, size_t bytes_per_channel=1, size_t num_channels=4) except *:
        cdef:
            ImageC *image_ptr
        if width == 0:
            raise ValueError("Image: width cannot be zero pixels")
        if height == 0:
            raise ValueError("Image: height cannot be zero pixels")
        self.handle = self.manager.create(ITEM_TYPE)
        image_ptr = self.get_ptr()
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.bytes_per_channel = bytes_per_channel
        image_ptr.num_channels = num_channels
        image_ptr.data_size = <uint64_t>width * <uint64_t>height * bytes_per_channel * num_channels
        image_ptr.data = <uint8_t *>calloc(image_ptr.data_size, sizeof(uint8_t))
        if image_ptr.data == NULL:
            raise MemoryError("Image: cannot allocate memory for data")
        self.set_data(data)
    
    cpdef void create_from_file(self, bytes file_path, bint flip_x=False, bint flip_y=False, bint premultiply_alpha=True) except *:
        cdef:
            SDL_Surface *surface
            SDL_Surface *converted_surface
            uint16_t width
            uint16_t height
            size_t data_size
            size_t left, right, top, bottom
            size_t x, y, z
            size_t src, dst
            uint8_t *data_ptr
            uint8_t[::1] data
        surface = IMG_Load(file_path)
        if surface == NULL:
            print(IMG_GetError())
            raise ValueError("Image: cannot load from path")
        converted_surface = SDL_ConvertSurfaceFormat(surface, SDL_PIXELFORMAT_RGBA32, 0)
        if converted_surface == NULL:
            raise ValueError("Image: cannot convert to RGBA format")
        width = converted_surface.w
        height = converted_surface.h
        data_size = width * height * 4
        data_ptr = <uint8_t *>converted_surface.pixels
        data = <uint8_t[:data_size]>data_ptr
        if flip_x:
            c_image_data_flip_x(width, height, data_ptr)
        if not flip_y:#NOT actually flips the data to match OpenGL coordinate system
            c_image_data_flip_y(width, height, data_ptr)
        if premultiply_alpha:
            c_image_data_premultiply_alpha(width, height, data_ptr)
        self.create(width, height, data)
        SDL_FreeSurface(surface)
        SDL_FreeSurface(converted_surface)
    
    cpdef void delete(self) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.get_ptr()
        free(image_ptr.data)
        self.manager.delete(self.handle)
        self.handle = 0
    
    cpdef void set_data(self, uint8_t[::1] data=None) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.get_ptr()
        if data != None:
            if data.shape[0] != image_ptr.data_size:
                raise ValueError("Image: invalid data size")
            memcpy(image_ptr.data, &data[0], image_ptr.data_size)
        else:
            memset(image_ptr.data, 0, image_ptr.data_size)

    cpdef uint16_t get_width(self) except *:
        return self.get_ptr().width

    cpdef uint16_t get_height(self) except *:
        return self.get_ptr().height
    
    cpdef uint8_t[::1] get_data(self) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.get_ptr()
        return <uint8_t[:image_ptr.data_size]>image_ptr.data