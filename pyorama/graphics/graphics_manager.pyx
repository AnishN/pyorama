from cython.parallel import parallel, prange

cdef class GraphicsManager:

    def __cinit__(self):
        self.root_window = SDL_CreateWindow("", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1, 1, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN)
        self.root_context = SDL_GL_CreateContext(self.root_window)
        if self.root_context == NULL:
            raise ValueError("GraphicsManager: failed to create OpenGL context")
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF | IMG_INIT_WEBP)
        
        self.c_check_gl_extensions()
        self.c_create_slot_maps()
        self.c_create_predefined_uniform_formats()
        self.c_create_predefined_vertex_index_formats()
        self.c_create_quad()

    def __dealloc__(self):
        self.c_delete_quad()
        self.c_delete_predefined_vertex_index_formats()
        self.c_delete_predefined_uniform_formats()
        self.c_delete_slot_maps()
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

    cdef void c_create_slot_maps(self) except *:
        self.windows = ItemSlotMap(sizeof(WindowC), GRAPHICS_ITEM_TYPE_WINDOW)
        self.vertex_formats = ItemSlotMap(sizeof(VertexFormatC), GRAPHICS_ITEM_TYPE_VERTEX_FORMAT)
        self.vertex_buffers = ItemSlotMap(sizeof(VertexBufferC), GRAPHICS_ITEM_TYPE_VERTEX_BUFFER)
        self.index_buffers = ItemSlotMap(sizeof(IndexBufferC), GRAPHICS_ITEM_TYPE_INDEX_BUFFER)
        self.uniform_formats = ItemSlotMap(sizeof(UniformFormatC), GRAPHICS_ITEM_TYPE_UNIFORM_FORMAT)
        self.uniforms = ItemSlotMap(sizeof(UniformC), GRAPHICS_ITEM_TYPE_UNIFORM)
        self.shaders = ItemSlotMap(sizeof(ShaderC), GRAPHICS_ITEM_TYPE_SHADER)
        self.programs = ItemSlotMap(sizeof(ProgramC), GRAPHICS_ITEM_TYPE_PROGRAM)
        self.images = ItemSlotMap(sizeof(ImageC), GRAPHICS_ITEM_TYPE_IMAGE)
        self.textures = ItemSlotMap(sizeof(TextureC), GRAPHICS_ITEM_TYPE_TEXTURE)
        self.frame_buffers = ItemSlotMap(sizeof(FrameBufferC), GRAPHICS_ITEM_TYPE_FRAME_BUFFER)
        self.views = ItemSlotMap(sizeof(ViewC), GRAPHICS_ITEM_TYPE_VIEW)
        self.meshes = ItemSlotMap(sizeof(MeshC), GRAPHICS_ITEM_TYPE_MESH)
        self.mesh_batches = ItemSlotMap(sizeof(MeshBatchC), GRAPHICS_ITEM_TYPE_MESH_BATCH)
        self.sprites = ItemSlotMap(sizeof(SpriteC), GRAPHICS_ITEM_TYPE_SPRITE)
        self.sprite_batches = ItemSlotMap(sizeof(SpriteBatchC), GRAPHICS_ITEM_TYPE_SPRITE_BATCH)
        self.bitmap_fonts = ItemSlotMap(sizeof(BitmapFontC), GRAPHICS_ITEM_TYPE_BITMAP_FONT)
        self.texts = ItemSlotMap(sizeof(TextC), GRAPHICS_ITEM_TYPE_TEXT)

    cdef void c_delete_slot_maps(self) except *:
        self.windows = None
        self.vertex_formats = None
        self.vertex_buffers = None
        self.index_buffers = None
        self.uniform_formats = None
        self.uniforms = None
        self.shaders = None
        self.programs = None
        self.images = None
        self.textures = None
        self.frame_buffers = None
        self.views = None
        self.meshes = None
        self.mesh_batches = None
        self.sprites = None
        self.sprite_batches = None
        self.bitmap_fonts = None
        self.texts = None

    cdef void c_create_predefined_uniform_formats(self) except *: 
        self.u_fmt_rect = UniformFormat(self); self.u_fmt_rect.create(b"u_rect", UNIFORM_TYPE_VEC4)
        self.u_fmt_quad = UniformFormat(self); self.u_fmt_quad.create(b"u_quad", UNIFORM_TYPE_INT)
        self.u_fmt_view = UniformFormat(self); self.u_fmt_view.create(b"u_view", UNIFORM_TYPE_MAT4)
        self.u_fmt_proj = UniformFormat(self); self.u_fmt_proj.create(b"u_proj", UNIFORM_TYPE_MAT4)
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
        self.i_fmt_quad = INDEX_FORMAT_U32
        self.i_fmt_mesh = INDEX_FORMAT_U32
        self.i_fmt_sprite = INDEX_FORMAT_U32

    cdef void c_delete_predefined_vertex_index_formats(self) except *:
        self.v_fmt_quad.delete(); self.v_fmt_quad = None
        self.v_fmt_mesh.delete(); self.v_fmt_mesh = None
        self.v_fmt_sprite.delete(); self.v_fmt_sprite = None
        self.i_fmt_quad = INDEX_FORMAT_U32
        self.i_fmt_mesh = INDEX_FORMAT_U32
        self.i_fmt_sprite = INDEX_FORMAT_U32

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

    cdef WindowC *window_get_ptr(self, Handle window) except *:
        return <WindowC *>self.windows.c_get_ptr(window)

    cdef VertexFormatC *vertex_format_get_ptr(self, Handle format) except *:
        return <VertexFormatC *>self.vertex_formats.c_get_ptr(format)
    
    cdef VertexBufferC *vertex_buffer_get_ptr(self, Handle buffer) except *:
        return <VertexBufferC *>self.vertex_buffers.c_get_ptr(buffer)

    cdef IndexBufferC *index_buffer_get_ptr(self, Handle buffer) except *:
        return <IndexBufferC *>self.index_buffers.c_get_ptr(buffer)
    
    cdef UniformFormatC *uniform_format_get_ptr(self, Handle format) except *:
        return <UniformFormatC *>self.uniform_formats.c_get_ptr(format)

    cdef UniformC *uniform_get_ptr(self, Handle uniform) except *:
        return <UniformC *>self.uniforms.c_get_ptr(uniform)

    cdef ShaderC *shader_get_ptr(self, Handle shader) except *:
        return <ShaderC *>self.shaders.c_get_ptr(shader)

    cdef ProgramC *program_get_ptr(self, Handle program) except *:
        return <ProgramC *>self.programs.c_get_ptr(program)

    cdef ImageC *image_get_ptr(self, Handle image) except *:
        return <ImageC *>self.images.c_get_ptr(image)

    cdef TextureC *texture_get_ptr(self, Handle texture) except *:
        return <TextureC *>self.textures.c_get_ptr(texture)

    cdef FrameBufferC *frame_buffer_get_ptr(self, Handle frame_buffer) except *:
        return <FrameBufferC *>self.frame_buffers.c_get_ptr(frame_buffer)

    cdef ViewC *view_get_ptr(self, Handle view) except *:
        return <ViewC *>self.views.c_get_ptr(view)
    
    cdef MeshC *mesh_get_ptr(self, Handle mesh) except *:
        return <MeshC *>self.meshes.c_get_ptr(mesh)

    cdef MeshBatchC *mesh_batch_get_ptr(self, Handle batch) except *:
        return <MeshBatchC *>self.mesh_batches.c_get_ptr(batch)

    cdef SpriteC *sprite_get_ptr(self, Handle sprite) except *:
        return <SpriteC *>self.sprites.c_get_ptr(sprite)

    cdef SpriteBatchC *sprite_batch_get_ptr(self, Handle batch) except *:
        return <SpriteBatchC *>self.sprite_batches.c_get_ptr(batch)
    
    cdef BitmapFontC *bitmap_font_get_ptr(self, Handle font) except *:
        return <BitmapFontC *>self.bitmap_fonts.c_get_ptr(font)

    cdef TextC *text_get_ptr(self, Handle text) except *:
        return <TextC *>self.texts.c_get_ptr(text)
    
    cdef void c_swap_root_window(self) except *:
        SDL_GL_MakeCurrent(self.root_window, self.root_context)
        SDL_GL_SetSwapInterval(0)
        SDL_GL_SwapWindow(self.root_window)

    cpdef void update(self) except *:
        cdef:
            ViewC *view_ptr
            Vec4C *color
            uint32_t gl_clear_flags
            Handle texture
            TextureUnit texture_unit
            uint32_t gl_texture_unit
            Handle fbo
            FrameBufferC *fbo_ptr
            SpriteBatch sprite_batch = SpriteBatch(self)
            Program program = Program(self)
            ProgramC *program_ptr
            VertexBufferC *vbo_ptr
            IndexBuffer ibo = IndexBuffer(self)
            IndexBufferC *ibo_ptr
            TextureC *texture_ptr
            UniformC *uniform_ptr
            WindowC *window_ptr
            SpriteBatchC *sprite_batch_ptr
            size_t i
        
        #update sprite batches
        for i in range(self.sprite_batches.items.num_items):
            sprite_batch_ptr = <SpriteBatchC *>self.sprite_batches.items.c_get_ptr(i)
            sprite_batch.handle = sprite_batch_ptr.handle
            sprite_batch._update()

        #update mesh batches
        pass

        for i in range(self.views.items.num_items):
            view_ptr = <ViewC *>self.views.items.c_get_ptr(i)
            program_ptr = self.program_get_ptr(view_ptr.program)
            program.handle = view_ptr.program
            vbo_ptr = self.vertex_buffer_get_ptr(view_ptr.vertex_buffer)
            ibo_ptr = self.index_buffer_get_ptr(view_ptr.index_buffer)
            
            glUseProgram(program_ptr.gl_id); self.c_check_gl()
            for i in range(view_ptr.num_uniforms):
                uniform_ptr = self.uniform_get_ptr(view_ptr.uniforms[i])
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
                fbo_ptr = self.frame_buffer_get_ptr(fbo)
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
                texture_ptr = self.texture_get_ptr(texture)
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
        
        for i in range(self.windows.items.num_items):
            window_ptr = <WindowC *>self.windows.items.c_get_ptr(i)
            window = Window(self)
            window.handle = window_ptr.handle
            window.render()