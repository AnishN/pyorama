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

    def init(self, dict config=None):
        self.renderer_type = config.get("renderer_type", GRAPHICS_RENDERER_TYPE_DEFAULT)
        print(self.renderer_type)

        self.c_init_sdl2()
        self.c_init_bgfx()
        self.slots.c_init(self.slot_sizes)
        memset(&self.used_views, False, sizeof(GRAPHICS_MAX_VIEWS * sizeof(bint)))
        memset(&self.free_views, 0, sizeof(GRAPHICS_MAX_VIEWS * sizeof(uint16_t)))
        self.free_view_index = 0
        self.window_ids.c_init()
    
    def quit(self):
        self.window_ids.c_free()
        memset(&self.used_views, False, sizeof(GRAPHICS_MAX_VIEWS * sizeof(bint)))
        memset(&self.free_views, 0, sizeof(GRAPHICS_MAX_VIEWS * sizeof(uint16_t)))
        self.free_view_index = 0
        self.slots.c_free()
        self.c_quit_bgfx()
        self.c_quit_sdl2()

    def update(self):
        cdef:
            SlotMap views
            size_t num_views
            size_t i
            ViewC *view_ptr

        views = self.slots.get_slot_map(GRAPHICS_SLOT_VIEW)
        num_views = views.items.num_items
        for i in range(num_views):
            view_ptr = <ViewC *>views.c_get_ptr_unsafe(i)
            view_touch(view_ptr.handle)
        bgfx_frame(False)

    cdef void c_init_sdl2(self) except *:
        SDL_InitSubSystem(SDL_INIT_VIDEO)
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
        if self.renderer_type == GRAPHICS_RENDERER_TYPE_OPENGLES:
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2)
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 0)
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES)
            SDL_GL_SetAttribute(SDL_GL_SHARE_WITH_CURRENT_CONTEXT, True)
            SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, True)
            SDL_GL_SetAttribute(SDL_GL_DEPTH_SIZE, 24)

    cdef void c_quit_sdl2(self) except *:
        if self.renderer_type == GRAPHICS_RENDERER_TYPE_OPENGLES:
            SDL_GL_ResetAttributes()

        IMG_Quit()
        SDL_QuitSubSystem(SDL_INIT_VIDEO)
    
    cdef void c_init_bgfx(self) except *:
        cdef:
            bgfx_init_t init
        
        self.wmi = bgfx_fetch_wmi()
        bgfx_init_ctor(&init)
        init.type = <bgfx_renderer_type_t>self.renderer_type
        init.resolution.reset = BGFX_RESET_VSYNC
        bgfx_init(&init)
    
    cdef void c_quit_bgfx(self) except *:
        bgfx_shutdown()
        free(self.wmi)
        self.wmi = NULL

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