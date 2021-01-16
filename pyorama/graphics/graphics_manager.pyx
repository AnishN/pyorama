from cython.parallel import parallel, prange

cdef class GraphicsManager:

    def __cinit__(self):
        cdef:
            dict item_types_info
        self.root_window = SDL_CreateWindow("", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1, 1, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN)
        self.root_context = SDL_GL_CreateContext(self.root_window)
        if self.root_context == NULL:
            raise ValueError("GraphicsManager: failed to create OpenGL context")
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF | IMG_INIT_WEBP)
        item_types_info = {
            GRAPHICS_ITEM_TYPE_WINDOW: sizeof(WindowC),
            GRAPHICS_ITEM_TYPE_VERTEX_FORMAT: sizeof(VertexFormatC),
            GRAPHICS_ITEM_TYPE_VERTEX_BUFFER: sizeof(VertexBufferC),
            GRAPHICS_ITEM_TYPE_INDEX_BUFFER: sizeof(IndexBufferC),
            GRAPHICS_ITEM_TYPE_UNIFORM_FORMAT: sizeof(UniformFormatC),
            GRAPHICS_ITEM_TYPE_UNIFORM: sizeof(UniformC),
            GRAPHICS_ITEM_TYPE_SHADER: sizeof(ShaderC),
            GRAPHICS_ITEM_TYPE_PROGRAM: sizeof(ProgramC),
            GRAPHICS_ITEM_TYPE_IMAGE: sizeof(ImageC),
            GRAPHICS_ITEM_TYPE_TEXTURE: sizeof(TextureC),
            GRAPHICS_ITEM_TYPE_FRAME_BUFFER: sizeof(FrameBufferC),
            GRAPHICS_ITEM_TYPE_VIEW: sizeof(ViewC),
            GRAPHICS_ITEM_TYPE_MESH: sizeof(MeshC),
            GRAPHICS_ITEM_TYPE_MESH_BATCH: sizeof(MeshBatchC),
            GRAPHICS_ITEM_TYPE_SPRITE: sizeof(SpriteC),
            GRAPHICS_ITEM_TYPE_SPRITE_BATCH: sizeof(SpriteBatchC),
            GRAPHICS_ITEM_TYPE_BITMAP_FONT: sizeof(BitmapFontC),
            GRAPHICS_ITEM_TYPE_TEXT: sizeof(TextC),
            GRAPHICS_ITEM_TYPE_TEXTURE_GRID_ATLAS: sizeof(TextureGridAtlasC),
            GRAPHICS_ITEM_TYPE_TILE_MAP: sizeof(TileMapC),
        }
        self.register_item_types(item_types_info)
        self.c_check_gl_extensions()
        self.c_create_predefined_uniform_formats()
        self.c_create_predefined_vertex_index_formats()
        self.c_create_quad()

    def __dealloc__(self):
        self.c_delete_quad()
        self.c_delete_predefined_vertex_index_formats()
        self.c_delete_predefined_uniform_formats()
        IMG_Quit()
        #no equivalent like glewQuit()
        SDL_GL_DeleteContext(self.root_context)
        SDL_DestroyWindow(self.root_window)

    cdef void c_check_gl(self) except *:
        cdef:
            uint32_t gl_error
            #str gl_error_str
        gl_error = glGetError()
        if gl_error != GL_NO_ERROR:
            #gl_error_str = gluErrorString(gl_error).decode("utf-8")
            #raise ValueError("GraphicsManager: OpenGL error (code: {0}; message: {1})".format(gl_error, gl_error_str))
            raise ValueError("GraphicsManager: OpenGL error (code: {0})".format(gl_error))

    cdef void c_check_gl_extensions(self) except *:
        cdef:
            str extentions_str
            set extensions
            list required
            str r
        extentions_str = glGetString(GL_EXTENSIONS).decode("utf-8"); self.c_check_gl()
        extensions = set(extentions_str.split())
        required = [
            "GL_OES_texture_float",
            "GL_OES_texture_float_linear",
            "GL_OES_texture_half_float",
            "GL_OES_texture_half_float_linear",
            "GL_OES_depth_texture",
        ]
        for r in required:
            if r not in extensions:
                raise ValueError("GraphicsManager: required OpenGL extension {0} not supported.".format(r))

    cdef void c_create_predefined_uniform_formats(self) except *: 
        self.u_fmt_rect = UniformFormat(self); self.u_fmt_rect.create(b"u_rect", UNIFORM_TYPE_VEC4)
        self.u_fmt_quad = UniformFormat(self); self.u_fmt_quad.create(b"u_quad", UNIFORM_TYPE_INT)
        self.u_fmt_view = UniformFormat(self); self.u_fmt_view.create(b"u_view", UNIFORM_TYPE_MAT4)
        self.u_fmt_proj = UniformFormat(self); self.u_fmt_proj.create(b"u_proj", UNIFORM_TYPE_MAT4)
        self.u_fmt_tile_map_size = UniformFormat(self); self.u_fmt_tile_map_size.create(b"u_tile_map_size", UNIFORM_TYPE_VEC2)
        self.u_fmt_tile_size = UniformFormat(self); self.u_fmt_tile_size.create(b"u_tile_size", UNIFORM_TYPE_VEC2)
        self.u_fmt_atlas_size = UniformFormat(self); self.u_fmt_atlas_size.create(b"u_atlas_size", UNIFORM_TYPE_VEC2)
        self.u_fmt_texture_0 = UniformFormat(self); self.u_fmt_texture_0.create(b"u_texture_0", UNIFORM_TYPE_INT)
        self.u_fmt_texture_1 = UniformFormat(self); self.u_fmt_texture_1.create(b"u_texture_1", UNIFORM_TYPE_INT)
        self.u_fmt_texture_2 = UniformFormat(self); self.u_fmt_texture_2.create(b"u_texture_2", UNIFORM_TYPE_INT)
        self.u_fmt_texture_3 = UniformFormat(self); self.u_fmt_texture_3.create(b"u_texture_3", UNIFORM_TYPE_INT)
        self.u_fmt_texture_4 = UniformFormat(self); self.u_fmt_texture_4.create(b"u_texture_4", UNIFORM_TYPE_INT)
        self.u_fmt_texture_5 = UniformFormat(self); self.u_fmt_texture_5.create(b"u_texture_5", UNIFORM_TYPE_INT)
        self.u_fmt_texture_6 = UniformFormat(self); self.u_fmt_texture_6.create(b"u_texture_6", UNIFORM_TYPE_INT)
        self.u_fmt_texture_7 = UniformFormat(self); self.u_fmt_texture_7.create(b"u_texture_7", UNIFORM_TYPE_INT)

    cdef void c_delete_predefined_uniform_formats(self) except *:
        self.u_fmt_rect.delete(); self.u_fmt_rect = None
        self.u_fmt_quad.delete(); self.u_fmt_quad = None
        self.u_fmt_view.delete(); self.u_fmt_view = None
        self.u_fmt_proj.delete(); self.u_fmt_proj = None
        self.u_fmt_tile_map_size.delete(); self.u_fmt_tile_map_size = None
        self.u_fmt_tile_size.delete(); self.u_fmt_tile_size = None
        self.u_fmt_atlas_size.delete(); self.u_fmt_atlas_size = None
        self.u_fmt_texture_0.delete(); self.u_fmt_texture_0 = None
        self.u_fmt_texture_1.delete(); self.u_fmt_texture_1 = None
        self.u_fmt_texture_2.delete(); self.u_fmt_texture_2 = None
        self.u_fmt_texture_3.delete(); self.u_fmt_texture_3 = None
        self.u_fmt_texture_4.delete(); self.u_fmt_texture_4 = None
        self.u_fmt_texture_5.delete(); self.u_fmt_texture_5 = None
        self.u_fmt_texture_6.delete(); self.u_fmt_texture_6 = None
        self.u_fmt_texture_7.delete(); self.u_fmt_texture_7 = None

    cdef void c_create_predefined_vertex_index_formats(self) except *:
        self.v_fmt_quad = VertexFormat(self)
        self.v_fmt_quad.create([
            (b"a_quad", VERTEX_COMP_TYPE_F32, 4, False),
        ])

        self.v_fmt_mesh = VertexFormat(self)
        self.v_fmt_mesh.create([
            (b"a_position", VERTEX_COMP_TYPE_F32, 3, False),
            (b"a_tex_coord_0", VERTEX_COMP_TYPE_F32, 2, False),
            (b"a_normal", VERTEX_COMP_TYPE_F32, 3, False),
        ])

        self.v_fmt_sprite = VertexFormat(self)
        self.v_fmt_sprite.create([
            (b"a_vertex_tex_coord", VERTEX_COMP_TYPE_F32, 4, False),#base vertex (vec2), tex coord (vec2)
            (b"a_pos_z_rot", VERTEX_COMP_TYPE_F32, 4, False),#position (vec2), z_index (float), rotation (float)
            (b"a_size_scale", VERTEX_COMP_TYPE_F32, 4, False),#width (float), height (float), scale (vec2)
            (b"a_tint_alpha", VERTEX_COMP_TYPE_F32, 4, False),#tint (vec3), alpha (float)
            (b"a_anchor", VERTEX_COMP_TYPE_F32, 2, False),#anchor (vec2)
        ])

        self.v_fmt_tile = VertexFormat(self)
        self.v_fmt_tile.create([
            (b"a_vertex_index_type", VERTEX_COMP_TYPE_F32, 4, False),#base vertex (vec2), tile_index (float), tile_type (float)
        ])
        
        self.i_fmt_quad = INDEX_FORMAT_U32
        self.i_fmt_mesh = INDEX_FORMAT_U32
        self.i_fmt_sprite = INDEX_FORMAT_U32
        self.i_fmt_tile = INDEX_FORMAT_U32

    cdef void c_delete_predefined_vertex_index_formats(self) except *:
        self.v_fmt_quad.delete(); self.v_fmt_quad = None
        self.v_fmt_mesh.delete(); self.v_fmt_mesh = None
        self.v_fmt_sprite.delete(); self.v_fmt_sprite = None
        self.v_fmt_tile.delete(); self.v_fmt_tile = None
        self.i_fmt_quad = INDEX_FORMAT_U32
        self.i_fmt_mesh = INDEX_FORMAT_U32
        self.i_fmt_sprite = INDEX_FORMAT_U32
        self.i_fmt_tile = INDEX_FORMAT_U32

    cdef void c_create_quad(self) except *:
        cdef:
            float[16] quad_vbo_data
            uint32_t[6] quad_ibo_data
            uint8_t[::1] quad_vbo_mv
            uint8_t[::1] quad_ibo_mv
        quad_vbo_data = [
            -1.0, -1.0, 0.0, 0.0,
            -1.0, 1.0, 0.0, 1.0,
            1.0, -1.0, 1.0, 0.0,
            1.0, 1.0, 1.0, 1.0,
        ]
        quad_vbo_mv = <uint8_t[:64]>(<uint8_t *>&quad_vbo_data)
        quad_ibo_data =  [0, 2, 1, 1, 2, 3]
        quad_ibo_mv = <uint8_t[:24]>(<uint8_t *>&quad_ibo_data)
        self.quad_vbo = VertexBuffer(self)
        self.quad_vbo.create(self.v_fmt_quad)
        self.quad_vbo.set_data(quad_vbo_mv)
        self.quad_ibo = IndexBuffer(self)
        self.quad_ibo.create(self.i_fmt_quad)
        self.quad_ibo.set_data(quad_ibo_mv)

        self.quad_vs = Shader(self); self.quad_vs.create_from_file(SHADER_TYPE_VERTEX, b"./resources/shaders/quad.vert")
        self.quad_fs = Shader(self); self.quad_fs.create_from_file(SHADER_TYPE_FRAGMENT, b"./resources/shaders/quad.frag")
        self.quad_program = Program(self)
        self.quad_program.create(self.quad_vs, self.quad_fs)
        self.u_quad = Uniform(self)
        self.u_quad.create(self.u_fmt_quad)
        self.u_quad.set_data(TEXTURE_UNIT_0)

    cdef void c_delete_quad(self) except *:
        self.quad_vbo.delete(); self.quad_vbo = None
        self.index_buffer_delete(self.quad_ibo)
        self.shader_delete(self.quad_vs)
        self.shader_delete(self.quad_fs)
        self.program_delete(self.quad_program)
        self.u_quad.delete(); self.u_quad = None
    
    cdef void c_swap_root_window(self) except *:
        SDL_GL_MakeCurrent(self.root_window, self.root_context)
        SDL_GL_SetSwapInterval(0)
        SDL_GL_SwapWindow(self.root_window)

    cpdef void update(self) except *:
        cdef:
            ItemSlotMap slot_map
            ViewC *view_ptr
            Vec4C *color
            uint32_t gl_clear_flags
            Handle texture
            TextureUnit texture_unit
            uint32_t gl_texture_unit
            Handle fbo
            FrameBufferC *fbo_ptr
            SpriteBatch sprite_batch = SpriteBatch(self)
            TileMap tile_map = TileMap(self)
            Program program = Program(self)
            ProgramC *program_ptr
            VertexBufferC *vbo_ptr
            IndexBuffer ibo = IndexBuffer(self)
            IndexBufferC *ibo_ptr
            TextureC *texture_ptr
            UniformC *uniform_ptr
            WindowC *window_ptr
            SpriteBatchC *sprite_batch_ptr
            TileMapC *tile_map_ptr
            size_t i
        
        #update sprite batches
        slot_map = self.get_slot_map(GRAPHICS_ITEM_TYPE_SPRITE_BATCH)
        for i in range(slot_map.items.num_items):
            sprite_batch_ptr = SpriteBatch.get_ptr_by_index(self, i)
            sprite_batch.handle = sprite_batch_ptr.handle
            sprite_batch._update()

        #update tile maps
        slot_map = self.get_slot_map(GRAPHICS_ITEM_TYPE_TILE_MAP)
        for i in range(slot_map.items.num_items):
            tile_map_ptr = TileMap.get_ptr_by_index(self, i)
            tile_map.handle = tile_map_ptr.handle
            tile_map._update()

        #update mesh batches
        pass

        slot_map = self.get_slot_map(GRAPHICS_ITEM_TYPE_VIEW)
        for i in range(slot_map.items.num_items):
            view_ptr = View.get_ptr_by_index(self, i)
            program_ptr = Program.get_ptr_by_handle(self, view_ptr.program)
            program.handle = view_ptr.program
            vbo_ptr = VertexBuffer.get_ptr_by_handle(self, view_ptr.vertex_buffer)
            ibo_ptr = IndexBuffer.get_ptr_by_handle(self, view_ptr.index_buffer)
            
            glUseProgram(program_ptr.gl_id); self.c_check_gl()
            for i in range(view_ptr.num_uniforms):
                uniform_ptr = Uniform.get_ptr_by_index(self, i)
                program._bind_uniform(uniform_ptr.handle)

            glEnable(GL_BLEND); self.c_check_gl()
            #glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); self.c_check_gl()#unmultiplied alpha
            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA); self.c_check_gl()#pre-multiplied alpha
            #glEnable(GL_CULL_FACE); self.c_check_gl()
            glEnable(GL_DEPTH_TEST); self.c_check_gl()
            glDepthFunc(GL_LESS); self.c_check_gl()
            glDepthMask(False); self.c_check_gl()
            
            fbo = view_ptr.frame_buffer
            if fbo != 0:
                fbo_ptr = FrameBuffer.get_ptr_by_handle(self, fbo)
                glBindFramebuffer(GL_FRAMEBUFFER, fbo_ptr.gl_id); self.c_check_gl()

            color = &view_ptr.clear_color
            gl_clear_flags = c_clear_flags_to_gl(view_ptr.clear_flags)
            glViewport(view_ptr.rect[0], view_ptr.rect[1], view_ptr.rect[2], view_ptr.rect[3]); self.c_check_gl()
            glClearColor(color.x, color.y, color.z, color.w); self.c_check_gl()
            glClearDepthf(view_ptr.clear_depth); self.c_check_gl()
            glClearStencil(view_ptr.clear_stencil); self.c_check_gl()
            glClear(gl_clear_flags); self.c_check_gl()
            
            for i in range(view_ptr.num_texture_units):
                texture_unit = view_ptr.texture_units[i]
                gl_texture_unit = c_texture_unit_to_gl(texture_unit)
                texture = view_ptr.textures[<size_t>texture_unit]
                texture_ptr = Texture.get_ptr_by_handle(self, texture)
                glActiveTexture(gl_texture_unit); self.c_check_gl()
                glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id); self.c_check_gl()

            program._bind_attributes(vbo_ptr.handle)
            ibo.handle = ibo_ptr.handle
            ibo._draw()
            program._unbind_attributes()
            for i in range(view_ptr.num_texture_units):
                texture_unit = view_ptr.texture_units[i]
                gl_texture_unit = c_texture_unit_to_gl(texture_unit)
                glActiveTexture(gl_texture_unit); self.c_check_gl()
                glBindTexture(GL_TEXTURE_2D, 0); self.c_check_gl()
            if fbo != 0:
                glBindFramebuffer(GL_FRAMEBUFFER, 0); self.c_check_gl()
            glUseProgram(0); self.c_check_gl()
        
        slot_map = self.get_slot_map(GRAPHICS_ITEM_TYPE_WINDOW)
        for i in range(slot_map.items.num_items):
            window_ptr = Window.get_ptr_by_index(self, i)
            window = Window(self)
            window.handle = window_ptr.handle
            window.render()