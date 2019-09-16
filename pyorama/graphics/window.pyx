cdef class Window:
    
    def __init__(self):
        raise NotImplementedError()

    def init(self, size_t width, size_t height, str title):
        cdef bytes b_title
        b_title = title.encode("utf-8")
        Window.c_init(self.graphics, self.handle, width, height, b_title, len(b_title))

    def clear(self):
        Window.c_clear(self.graphics, self.handle)

    def bind(self):
        Window.c_bind(self.graphics, self.handle)
    
    def unbind(self):
        Window.c_unbind(self.graphics, self.handle)

    def swap_buffers(self):
        Window.c_swap_buffers(self.graphics, self.handle)
    
    @staticmethod
    cdef WindowC *c_get_ptr(GraphicsManager graphics, Handle window) nogil:
        cdef WindowC *window_ptr
        ItemSlotMap.c_get_ptr(&graphics.windows, window, <void **>&window_ptr)
        return window_ptr

    cdef WindowC *c_get_checked_ptr(self) except *:
        cdef:
            WindowC *window_ptr
            Error check
        check = ItemSlotMap.c_get_ptr(&self.graphics.windows, self.handle, <void **>&window_ptr)
        if check == ERROR_INVALID_HANDLE:
            raise MemoryError("Window: invalid handle")
        return window_ptr
    
    @staticmethod
    cdef void c_init(GraphicsManager graphics, Handle window, size_t width, size_t height, char *title, size_t title_len) nogil:
        cdef:
            WindowC *window_ptr
            SDL_Window *sdl_window
            int center = SDL_WINDOWPOS_CENTERED
            int flags = SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL
            
        window_ptr = Window.c_get_ptr(graphics, window)
        if window_ptr == NULL:
            return
        sdl_window = SDL_CreateWindow(title, center, center, width, height, flags)
        window_ptr.id = SDL_GetWindowID(sdl_window)
        window_ptr.width = width
        window_ptr.height = height
        window_ptr.title = title
        window_ptr.title_len = title_len

    @staticmethod
    cdef void c_clear(GraphicsManager graphics, Handle window) nogil:
        cdef WindowC *window_ptr = Window.c_get_ptr(graphics, window)
        if window_ptr == NULL:
            return
        window_ptr.id = 0
        window_ptr.width = 0
        window_ptr.height = 0
        window_ptr.title = NULL
        window_ptr.title_len = 0

    @staticmethod
    cdef void c_bind(GraphicsManager graphics, Handle window) nogil:
        cdef:
            WindowC *window_ptr
            SDL_Window *sdl_window

        window_ptr = Window.c_get_ptr(graphics, window)
        if window_ptr == NULL:
            return
        sdl_window = SDL_GetWindowFromID(window_ptr.id)
        SDL_GL_MakeCurrent(sdl_window, graphics.root_context)
        glViewport(0, 0, window_ptr.width, window_ptr.height)

    @staticmethod
    cdef void c_unbind(GraphicsManager graphics, Handle window) nogil:
        SDL_GL_MakeCurrent(graphics.root_window, graphics.root_context)
        glViewport(0, 0, 1, 1)

    @staticmethod
    cdef void c_swap_buffers(GraphicsManager graphics, Handle window) nogil:
        cdef:
            WindowC *window_ptr
            SDL_Window *sdl_window

        window_ptr = Window.c_get_ptr(graphics, window)
        if window_ptr == NULL:
            return
        sdl_window = SDL_GetWindowFromID(window_ptr.id)
        SDL_GL_SetSwapInterval(0)
        SDL_GL_SwapWindow(sdl_window)