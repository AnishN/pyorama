cdef size_t GRAPHICS_MAX_VIEWS = 2**16

cdef class GraphicsSystem:
    
    def __cinit__(self, str name):
        self.name = name
        self.slots = SlotManager()
        self.slot_sizes = {
            GRAPHICS_SLOT_WINDOW: sizeof(WindowC),
            GRAPHICS_SLOT_FRAME_BUFFER: sizeof(FrameBufferC),
            GRAPHICS_SLOT_VIEW: sizeof(ViewC),
            GRAPHICS_SLOT_SHADER: sizeof(ShaderC),
            GRAPHICS_SLOT_PROGRAM: sizeof(ProgramC),
            GRAPHICS_SLOT_VERTEX_LAYOUT: sizeof(VertexLayoutC),
            GRAPHICS_SLOT_VERTEX_BUFFER: sizeof(VertexBufferC),
            GRAPHICS_SLOT_INDEX_BUFFER: sizeof(IndexBufferC),
        }
        self.window_ids = HashMap()
    
    def __dealloc__(self):
        self.window_ids = None
        self.slot_sizes = None
        self.slots = None
        self.name = None

    def init(self):
        print(self.name, "init")
        self.c_init_sdl2()
        self.c_init_bgfx()
        self.slots.c_init(self.slot_sizes)
        memset(&self.used_views, False, sizeof(GRAPHICS_MAX_VIEWS * sizeof(bint)))
        memset(&self.free_views, 0, sizeof(GRAPHICS_MAX_VIEWS * sizeof(uint16_t)))
        self.used_views[0] = True#reserve as global view
        self.used_views[1] = True#view count starts from 1
        self.free_view_index = 0
        self.window_ids.c_init()
    
    def quit(self):
        print(self.name, "quit")
        self.window_ids.c_free()
        memset(&self.used_views, False, sizeof(GRAPHICS_MAX_VIEWS * sizeof(bint)))
        memset(&self.free_views, 0, sizeof(GRAPHICS_MAX_VIEWS * sizeof(uint16_t)))
        self.free_view_index = 0
        print("cleared windows and views")
        self.slots.c_free()
        print("cleared slots")
        self.c_quit_bgfx()
        print("quit bgfx")
        self.c_quit_sdl2()
        print("quit sdl2")

    def update(self):
        cdef:
            size_t i
            SlotMap views
            ViewC *view_ptr 
        print(self.name, "update")
        views = self.slots.get_slot_map(GRAPHICS_SLOT_VIEW)
        for i in range(views.items.num_items):
            view_ptr = <ViewC *>views.items.c_get_ptr_unsafe(i)
            bgfx_touch(view_ptr.index)
        bgfx_frame(False)

    cdef void c_init_sdl2(self) except *:
        SDL_InitSubSystem(SDL_INIT_VIDEO)
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0)
        SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES)
        SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, True)
        SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, True)
        SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)
        SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1")
        #SDL_SetHint(SDL_HINT_VIDEO_EXTERNAL_CONTEXT, "1")
        self.root_window = SDL_CreateWindow("", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 1, 1, SDL_WINDOW_HIDDEN | SDL_WINDOW_RESIZABLE)
        #self.root_window = SDL_CreateWindow("ROOT", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 800, 600, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE)
        self.wmi = bgfx_fetch_wmi()

    cdef void c_quit_sdl2(self) except *:
        SDL_DestroyWindow(self.root_window)
        self.root_window = NULL
        free(self.wmi)
        self.wmi = NULL
        #SDL_SetHint(SDL_HINT_VIDEO_EXTERNAL_CONTEXT, "0")
        SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "0")
        SDL_GL_ResetAttributes()
        IMG_Quit()
        SDL_QuitSubSystem(SDL_INIT_VIDEO)
    
    cdef void c_init_bgfx(self) except *:
        cdef:
            uint16_t width = 1
            uint16_t height = 1
            uint32_t clear_flags = BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH | BGFX_CLEAR_STENCIL
            uint32_t debug = BGFX_DEBUG_TEXT
            uint32_t reset = BGFX_RESET_VSYNC
            bgfx_init_t init
        
        bgfx_get_platform_data_from_window(self.wmi, self.root_window)
        bgfx_init_ctor(&init)
        bgfx_init(&init)
    
    cdef void c_quit_bgfx(self) except *:
        bgfx_shutdown()

    cdef uint16_t c_get_next_view_index(self) except *:
        cdef:
            size_t i
            uint16_t index
            bint used
        index = self.free_views[self.free_view_index]
        if index != 0:
            self.free_view_index += 1
            self.free_view_index %= GRAPHICS_MAX_VIEWS
            return index
        else:
            for i in range(GRAPHICS_MAX_VIEWS):
                used = graphics.used_views[i]
                if not used:
                    graphics.used_views[i] = True
                    return i
        raise ValueError("GraphicsSystem: no free views available")