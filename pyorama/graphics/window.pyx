cdef class Window:

    cdef WindowC *c_get_ptr(self) except *:
        return <WindowC *>graphics.slots.c_get_ptr(self.handle)

    cpdef void create(self, uint16_t width, uint16_t height, bytes title) except *:
        cdef:
            Handle window
            WindowC *window_ptr
            size_t title_length
            FrameBuffer fbo
            uint32_t clear_flags = BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH | BGFX_CLEAR_STENCIL
            uint32_t debug = BGFX_DEBUG_TEXT
            uint32_t reset = BGFX_RESET_VSYNC


        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_WINDOW)
        window_ptr = self.c_get_ptr()
        window_ptr.sdl_ptr = SDL_CreateWindow(
            title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
            width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE,
        )
        window_ptr.width = width
        window_ptr.height = height
        self.set_title(title)
        fbo = FrameBuffer()
        fbo.create_from_window(self)
        window_ptr.fbo = fbo.handle

        bgfx_reset(width, height, reset, BGFX_TEXTURE_FORMAT_BGRA8)
        bgfx_set_debug(debug)
        bgfx_set_view_clear(1, clear_flags, 0x000000FF, 1.0, 0)
        bgfx_frame(False)

    cpdef void delete(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_DestroyWindow(window_ptr.sdl_ptr)
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef uint16_t get_width(self) except *:
        return self.c_get_ptr().width

    cpdef uint16_t get_height(self) except *:
        return self.c_get_ptr().height

    cpdef tuple get_size(self):
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        return (window_ptr.width, window_ptr.height)

    cpdef bytes get_title(self):
        return self.c_get_ptr().title

    cpdef uint32_t get_flags(self) except *:
        return self.c_get_ptr().flags
    
    cpdef void get_frame_buffer(self, FrameBuffer fbo) except *:
        fbo.handle = self.c_get_ptr().fbo

    cpdef void set_width(self, uint16_t width) except *:
        self.c_get_ptr().width = width

    cpdef void set_height(self, uint16_t height) except *:
        self.c_get_ptr().height = height

    cpdef void set_size(self, uint16_t width, uint16_t height) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        window_ptr.width = width
        window_ptr.height = height

    cpdef void set_title(self, bytes title) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        window_ptr.title = <char *>title
        window_ptr.title_length = len(title)

    cpdef void set_flags(self, uint32_t flags) except *:
        self.c_get_ptr().flags = flags