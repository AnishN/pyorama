from pyorama.app cimport *

cdef size_t GRAPHICS_MAX_VIEWS = 2**16

cdef class GraphicsSystem:
    
    def __cinit__(self):
        slot_map_init(&self.windows, GRAPHICS_SLOT_WINDOW, sizeof(WindowC))
        slot_map_init(&self.frame_buffers, GRAPHICS_SLOT_FRAME_BUFFER, sizeof(FrameBufferC))
        slot_map_init(&self.views, GRAPHICS_SLOT_VIEW, sizeof(ViewC))
        slot_map_init(&self.shaders, GRAPHICS_SLOT_SHADER, sizeof(ShaderC))
        slot_map_init(&self.programs, GRAPHICS_SLOT_PROGRAM, sizeof(ProgramC))
        slot_map_init(&self.vertex_layouts, GRAPHICS_SLOT_VERTEX_LAYOUT, sizeof(VertexLayoutC))
        slot_map_init(&self.vertex_buffers, GRAPHICS_SLOT_VERTEX_BUFFER, sizeof(VertexBufferC))
        slot_map_init(&self.index_buffers, GRAPHICS_SLOT_INDEX_BUFFER, sizeof(IndexBufferC))
        slot_map_init(&self.meshes, GRAPHICS_SLOT_MESH, sizeof(MeshC))
        slot_map_init(&self.images, GRAPHICS_SLOT_IMAGE, sizeof(ImageC))
        slot_map_init(&self.textures, GRAPHICS_SLOT_TEXTURE, sizeof(TextureC))
        slot_map_init(&self.uniforms, GRAPHICS_SLOT_UNIFORM, sizeof(UniformC))
        slot_map_init(&self.lights, GRAPHICS_SLOT_LIGHT, sizeof(LightC))
        slot_map_init(&self.transforms, GRAPHICS_SLOT_TRANSFORM, sizeof(TransformC))
        slot_map_init(&self.sprites, GRAPHICS_SLOT_SPRITE, sizeof(SpriteC))
        slot_map_init(&self.sprite_batches, GRAPHICS_SLOT_SPRITE_BATCH, sizeof(SpriteBatchC))
        slot_map_init(&self.cameras, GRAPHICS_SLOT_CAMERA, sizeof(CameraC))
        slot_map_init(&self.scene2ds, GRAPHICS_SLOT_SCENE2D, sizeof(Scene2DC))

    def __dealloc__(self):
        slot_map_free(&self.windows)
        slot_map_free(&self.frame_buffers)
        slot_map_free(&self.views)
        slot_map_free(&self.shaders)
        slot_map_free(&self.programs)
        slot_map_free(&self.vertex_layouts)
        slot_map_free(&self.vertex_buffers)
        slot_map_free(&self.index_buffers)
        slot_map_free(&self.meshes)
        slot_map_free(&self.images)
        slot_map_free(&self.textures)
        slot_map_free(&self.uniforms)
        slot_map_free(&self.lights)
        slot_map_free(&self.transforms)
        slot_map_free(&self.sprites)
        slot_map_free(&self.sprite_batches)
        slot_map_free(&self.cameras)
        slot_map_free(&self.scene2ds)

    def init(self, dict config=None):
        if config == None:
            config = {}
        self.renderer_type = config.get("renderer_type", GRAPHICS_RENDERER_TYPE_DEFAULT)
        self.c_init_sdl2()
        self.c_init_bgfx()
        memset(&self.used_views, False, sizeof(GRAPHICS_MAX_VIEWS * sizeof(bint)))
        memset(&self.free_views, 0, sizeof(GRAPHICS_MAX_VIEWS * sizeof(uint16_t)))
        self.free_view_index = 0
        int_hash_map_init(&self.window_ids)
        """
        self.sprite_vertex_layout = VertexLayout.init_create([
            (ATTRIBUTE_POSITION, ATTRIBUTE_TYPE_F32, 4, False, False),#Vec3 position + float rotation
            (ATTRIBUTE_NORMAL, ATTRIBUTE_TYPE_F32, 4, False, False),#Vec2 scale + Vec2 size
            (ATTRIBUTE_TEXCOORD0, ATTRIBUTE_TYPE_F32, 4, False, False),#Vec2 texcoord + Vec2 offset
            (ATTRIBUTE_COLOR0, ATTRIBUTE_TYPE_F32, 1, False, False),#tint + alpha crammed in uint32_t, then Vec2 vertex, then extra
        ])
        """
    
    def quit(self):
        #self.sprite_vertex_layout.delete()
        int_hash_map_free(&self.window_ids)
        memset(&self.used_views, False, sizeof(GRAPHICS_MAX_VIEWS * sizeof(bint)))
        memset(&self.free_views, 0, sizeof(GRAPHICS_MAX_VIEWS * sizeof(uint16_t)))
        self.free_view_index = 0
        self.c_quit_bgfx()
        self.c_quit_sdl2()
        self.renderer_type = GRAPHICS_RENDERER_TYPE_DEFAULT

    def update(self):
        pass
        bgfx_frame(False)

    def bind_events(self):
        event_system.event_type_register(b"window", SDL_WINDOWEVENT)
        event_system.event_type_register(b"enter_frame")
        event_system.c_event_type_bind(b"window", <EventFuncC>c_window_event)
        event_system.c_event_type_bind(b"enter_frame", <EventFuncC>c_enter_frame_event)

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
                used = graphics_system.used_views[i]
                if not used:
                    graphics_system.used_views[i] = True
                    return i
        raise ValueError("GraphicsSystem: no free views available")