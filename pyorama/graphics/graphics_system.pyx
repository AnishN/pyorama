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
            GRAPHICS_SLOT_MESH: sizeof(MeshC),
            GRAPHICS_SLOT_IMAGE: sizeof(ImageC),
            GRAPHICS_SLOT_TEXTURE: sizeof(TextureC),
            GRAPHICS_SLOT_UNIFORM: sizeof(UniformC),
            GRAPHICS_SLOT_LIGHT: sizeof(LightC),
            GRAPHICS_SLOT_TRANSFORM: sizeof(TransformC),
            GRAPHICS_SLOT_SPRITE: sizeof(SpriteC),
            GRAPHICS_SLOT_SPRITE_BATCH: sizeof(SpriteBatchC),
            GRAPHICS_SLOT_CAMERA: sizeof(CameraC),
        }
    
    def __dealloc__(self):
        self.slot_sizes = None
        self.slots = None
        self.name = None

    def init(self, dict config=None):
        if config == None:
            config = {}
        self.renderer_type = config.get("renderer_type", GRAPHICS_RENDERER_TYPE_DEFAULT)
        self.c_init_sdl2()
        self.c_init_bgfx()
        self.slots.c_init(self.slot_sizes)
        memset(&self.used_views, False, sizeof(GRAPHICS_MAX_VIEWS * sizeof(bint)))
        memset(&self.free_views, 0, sizeof(GRAPHICS_MAX_VIEWS * sizeof(uint16_t)))
        self.free_view_index = 0
        int_hash_map_init(&self.window_ids)
    
    def quit(self):
        int_hash_map_free(&self.window_ids)
        memset(&self.used_views, False, sizeof(GRAPHICS_MAX_VIEWS * sizeof(bint)))
        memset(&self.free_views, 0, sizeof(GRAPHICS_MAX_VIEWS * sizeof(uint16_t)))
        self.free_view_index = 0
        self.slots.c_free()
        self.c_quit_bgfx()
        self.c_quit_sdl2()
        self.renderer_type = GRAPHICS_RENDERER_TYPE_DEFAULT

    def update(self):
        pass
        bgfx_frame(False)

    cdef void c_init_sdl2(self) except *:
        SDL_InitSubSystem(SDL_INIT_VIDEO)
        self.wmi = bgfx_fetch_wmi()
        self.root_window = SDL_CreateWindow(
            b"", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
            1, 1, SDL_WINDOW_HIDDEN | SDL_WINDOW_RESIZABLE,
        )

    cdef void c_quit_sdl2(self) except *:
        SDL_DestroyWindow(self.root_window); self.root_window = NULL
        free(self.wmi); self.wmi = NULL
        SDL_QuitSubSystem(SDL_INIT_VIDEO)
    
    cdef void c_init_bgfx(self) except *:
        bgfx_get_platform_data_from_window(&self.pd, self.wmi, self.root_window)
        bgfx_set_platform_data(&self.pd)
        bgfx_init_ctor(&self.bgfx_init)
        self.bgfx_init.type = BGFX_RENDERER_TYPE_COUNT
        #self.bgfx_init.type = BGFX_RENDERER_TYPE_OPENGL
        self.bgfx_init.resolution.reset = BGFX_RESET_VSYNC
        bgfx_init(&self.bgfx_init)
    
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