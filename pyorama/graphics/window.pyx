cdef WindowC *c_window_get_ptr(Handle handle) except *:
    cdef:
        WindowC *ptr
    CHECK_ERROR(slot_map_get_ptr(&graphics_system.windows, handle, <void **>&ptr))
    return ptr

cdef Handle c_window_create() except *:
    cdef:
        Handle handle
    CHECK_ERROR(slot_map_create(&graphics_system.windows, &handle))
    return handle

cdef void c_window_delete(Handle handle) except *:
    slot_map_delete(&graphics_system.windows, handle)

cdef class Window(HandleObject):

    @staticmethod
    cdef Window c_from_handle(Handle handle):
        cdef Window obj
        if handle == 0:
            raise ValueError("Window: invalid handle")
        obj = Window.__new__(Window)
        obj.handle = handle
        return obj

    cdef WindowC *c_get_ptr(self) except *:
        return c_window_get_ptr(self.handle)
    
    @staticmethod
    def init_create(uint16_t width, uint16_t height, bytes title, uint32_t flags=WINDOW_FLAGS_SHOWN | WINDOW_FLAGS_RESIZABLE):
        cdef:
            Window window
        
        window = Window.__new__(Window)
        window.create(width, height, title, flags)
        return window

    cpdef void create(self, uint16_t width, uint16_t height, bytes title, uint32_t flags=WINDOW_FLAGS_SHOWN | WINDOW_FLAGS_RESIZABLE) except *:
        cdef:
            WindowC *window_ptr
            uint64_t window_id
            size_t title_length
            uint32_t clear_flags = BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH | BGFX_CLEAR_STENCIL
            uint32_t debug = BGFX_DEBUG_TEXT
            uint32_t reset = BGFX_RESET_VSYNC
            
        self.handle = c_window_create()
        window_ptr = self.c_get_ptr()
        window_ptr.sdl_ptr = SDL_CreateWindow(
            title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
            width, height, flags,
        )
        window_ptr.sdl_id = SDL_GetWindowID(window_ptr.sdl_ptr)
        int_hash_map_insert(&graphics_system.window_ids, window_ptr.sdl_id, self.handle)
        window_ptr.width = width
        window_ptr.height = height
        window_ptr.title = <char *>title
        window_ptr.title_length = len(title)

    cpdef void load_from_id(self, uint32_t id_) except *:
        CHECK_ERROR(int_hash_map_get(&graphics_system.window_ids, id_, &self.handle))

    cpdef void delete(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        int_hash_map_remove(&graphics_system.window_ids, window_ptr.sdl_id)
        SDL_DestroyWindow(window_ptr.sdl_ptr)
        c_window_delete(self.handle)
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
        return SDL_GetWindowFlags(self.c_get_ptr().sdl_ptr)

    cpdef uint64_t get_id(self) except *:
        return self.c_get_ptr().sdl_id

    cpdef bint is_fullscreen(self) except *:
        return self.get_flags() & WINDOW_FLAGS_FULLSCREEN

    cpdef bint is_fullscreen_desktop(self) except *:
        return self.get_flags() & WINDOW_FLAGS_FULLSCREEN_DESKTOP

    cpdef bint is_shown(self) except *:
        return self.get_flags() & WINDOW_FLAGS_SHOWN

    cpdef bint is_hidden(self) except *:
        return self.get_flags() & WINDOW_FLAGS_HIDDEN

    cpdef bint is_borderless(self) except *:
        return self.get_flags() & WINDOW_FLAGS_BORDERLESS

    cpdef bint is_resizable(self) except *:
        return self.get_flags() & WINDOW_FLAGS_RESIZABLE

    cpdef bint is_minimized(self) except *:
        return self.get_flags() & WINDOW_FLAGS_MINIMIZED

    cpdef bint is_maximized(self) except *:
        return self.get_flags() & WINDOW_FLAGS_MAXIMIZED

    cpdef bint is_input_grabbed(self) except *:
        return self.get_flags() & WINDOW_FLAGS_INPUT_GRABBED

    cpdef bint is_mouse_captured(self) except *:
        return self.get_flags() & WINDOW_FLAGS_MOUSE_CAPTURED

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
        window_ptr.title = title
        window_ptr.title_length = len(title)

    cpdef void set_flags(self, uint32_t flags) except *:
        cdef:
            WindowC *window_ptr
            bint full_screen
        window_ptr = self.c_get_ptr()
        
        #full_screen
        full_screen = flags & WINDOW_FLAGS_FULLSCREEN or flags & WINDOW_FLAGS_FULLSCREEN_DESKTOP
        if full_screen:
            if flags & WINDOW_FLAGS_FULLSCREEN:
                SDL_SetWindowFullscreen(window_ptr.sdl_ptr, WINDOW_FLAGS_FULLSCREEN)
            else:
                SDL_SetWindowFullscreen(window_ptr.sdl_ptr, WINDOW_FLAGS_FULLSCREEN_DESKTOP)
        else:
            SDL_SetWindowFullscreen(window_ptr.sdl_ptr, 0)
        
        #show_or_hide
        if flags & WINDOW_FLAGS_SHOWN:
            SDL_ShowWindow(window_ptr.sdl_ptr)
        if flags & WINDOW_FLAGS_HIDDEN:
            SDL_HideWindow(window_ptr.sdl_ptr)

        #borderless
        if flags & WINDOW_FLAGS_BORDERLESS:
            SDL_SetWindowBordered(window_ptr.sdl_ptr, False)
        else:
            SDL_SetWindowBordered(window_ptr.sdl_ptr, True)

        #resizable
        if flags & WINDOW_FLAGS_RESIZABLE:
            SDL_SetWindowResizable(window_ptr.sdl_ptr, True)
        else:
            SDL_SetWindowResizable(window_ptr.sdl_ptr, False)

        #min_max_restore
        if flags & WINDOW_FLAGS_MINIMIZED:
            SDL_MinimizeWindow(window_ptr.sdl_ptr)
        elif flags & WINDOW_FLAGS_MAXIMIZED:
            SDL_MaximizeWindow(window_ptr.sdl_ptr)
        else:
            SDL_RestoreWindow(window_ptr.sdl_ptr)
        
        if flags & WINDOW_FLAGS_INPUT_GRABBED:
            SDL_SetWindowGrab(window_ptr.sdl_ptr, True)
        else:
            SDL_SetWindowGrab(window_ptr.sdl_ptr, False)
        
        #mouse_capture
        if flags & WINDOW_FLAGS_MOUSE_CAPTURED:
            SDL_CaptureMouse(True)
        else:
            SDL_CaptureMouse(False)

    cpdef void set_fullscreen(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_SetWindowFullscreen(window_ptr.sdl_ptr, WINDOW_FLAGS_FULLSCREEN)
        
    cpdef void set_fullscreen_desktop(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_SetWindowFullscreen(window_ptr.sdl_ptr, WINDOW_FLAGS_FULLSCREEN_DESKTOP)

    cpdef void set_shown(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_ShowWindow(window_ptr.sdl_ptr)

    cpdef void set_hidden(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_HideWindow(window_ptr.sdl_ptr)

    cpdef void set_borderless(self, bint borderless) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_SetWindowBordered(window_ptr.sdl_ptr, not borderless)

    cpdef void set_resizable(self, bint resizable) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_SetWindowResizable(window_ptr.sdl_ptr, resizable)
        
    cpdef void set_minimized(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_MinimizeWindow(window_ptr.sdl_ptr)

    cpdef void set_maximized(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_MaximizeWindow(window_ptr.sdl_ptr)

    cpdef void set_restored(self) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.c_get_ptr()
        SDL_RestoreWindow(window_ptr.sdl_ptr)

    cpdef void toggle_fullscreen(self) except *:
        cdef:
            bint is_fullscreen
        is_fullscreen = self.is_fullscreen()
        if is_fullscreen: self.set_restored()
        else: self.set_fullscreen()

    cpdef void toggle_fullscreen_desktop(self) except *:
        cdef:
            bint is_fullscreen_desktop
        is_fullscreen_desktop = self.is_fullscreen_desktop()
        if is_fullscreen_desktop: self.set_restored()
        else: self.set_fullscreen_desktop()

    cpdef void toggle_shown(self) except *:
        cdef:
            bint is_shown
        is_shown = self.is_shown()
        if is_shown: self.set_hidden()
        else: self.set_shown()

    cpdef void toggle_hidden(self) except *:
        cdef:
            bint is_hidden
        is_hidden = self.is_hidden()
        if is_hidden: self.set_shown()
        else: self.set_hidden()
        
    cpdef void toggle_borderless(self) except *:
        cdef:
            bint is_borderless
        is_borderless = self.is_borderless()
        self.set_borderless(not is_borderless)
        
    cpdef void toggle_resizable(self) except *:
        cdef:
            bint is_resizable
        is_resizable = self.is_resizable()
        self.set_resizable(not is_resizable)

    cpdef void toggle_minimized(self) except *:
        cdef:
            bint is_minimized
        is_minimized = self.is_minimized()
        if is_minimized: self.set_restored()
        else: self.set_minimized()
        
    cpdef void toggle_maximized(self) except *:
        cdef:
            bint is_maximized
        is_maximized = self.is_maximized()
        if is_maximized: self.set_restored()
        else: self.set_maximized()