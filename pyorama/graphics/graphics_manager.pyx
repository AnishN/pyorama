
cdef class GraphicsManager:

    def __cinit__(self):
        self.root_window = SDL_CreateWindow("", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1, 1, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN)
        self.root_context = SDL_GL_CreateContext(self.root_window)
        if self.root_context == NULL:
            raise ValueError("GraphicsManager: failed to create OpenGL context")
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
        
        #print(glGetString(GL_VERSION), glGetString(GL_SHADING_LANGUAGE_VERSION))
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
        self.sprite_batches = ItemSlotMap(sizeof(SpriteC), GRAPHICS_ITEM_TYPE_SPRITE_BATCH)

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

    cdef void c_create_predefined_uniform_formats(self) except *:
        self.u_fmt_rect = self.uniform_format_create(b"u_rect", UNIFORM_TYPE_VEC4)
        self.u_fmt_quad = self.uniform_format_create(b"u_quad", UNIFORM_TYPE_INT)
        self.u_fmt_view = self.uniform_format_create(b"u_view", UNIFORM_TYPE_MAT4)
        self.u_fmt_proj = self.uniform_format_create(b"u_proj", UNIFORM_TYPE_MAT4)
        self.u_fmt_texture_0 = self.uniform_format_create(b"u_texture_0", UNIFORM_TYPE_INT)
        self.u_fmt_texture_1 = self.uniform_format_create(b"u_texture_1", UNIFORM_TYPE_INT)
        self.u_fmt_texture_2 = self.uniform_format_create(b"u_texture_2", UNIFORM_TYPE_INT)
        self.u_fmt_texture_3 = self.uniform_format_create(b"u_texture_3", UNIFORM_TYPE_INT)
        self.u_fmt_texture_4 = self.uniform_format_create(b"u_texture_4", UNIFORM_TYPE_INT)
        self.u_fmt_texture_5 = self.uniform_format_create(b"u_texture_5", UNIFORM_TYPE_INT)
        self.u_fmt_texture_6 = self.uniform_format_create(b"u_texture_6", UNIFORM_TYPE_INT)
        self.u_fmt_texture_7 = self.uniform_format_create(b"u_texture_7", UNIFORM_TYPE_INT)

    cdef void c_delete_predefined_uniform_formats(self) except *:
        self.uniform_format_delete(self.u_fmt_quad)
        self.uniform_format_delete(self.u_fmt_view) 
        self.uniform_format_delete(self.u_fmt_proj) 
        self.uniform_format_delete(self.u_fmt_texture_0) 
        self.uniform_format_delete(self.u_fmt_texture_1) 
        self.uniform_format_delete(self.u_fmt_texture_2) 
        self.uniform_format_delete(self.u_fmt_texture_3) 
        self.uniform_format_delete(self.u_fmt_texture_4) 
        self.uniform_format_delete(self.u_fmt_texture_5) 
        self.uniform_format_delete(self.u_fmt_texture_6) 
        self.uniform_format_delete(self.u_fmt_texture_7) 

    cdef void c_create_predefined_vertex_index_formats(self) except *:
        self.v_fmt_quad = self.vertex_format_create([
            (b"a_quad", VERTEX_COMP_TYPE_F32, 4, False),
        ])
        self.v_fmt_mesh = self.vertex_format_create([
            (b"a_position", VERTEX_COMP_TYPE_F32, 3, False),
            (b"a_tex_coord_0", VERTEX_COMP_TYPE_F32, 2, False),
            (b"a_normal", VERTEX_COMP_TYPE_F32, 3, False),
        ])
        self.v_fmt_sprite = self.vertex_format_create([
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
        self.vertex_format_delete(self.v_fmt_quad)
        self.vertex_format_delete(self.v_fmt_mesh)
        self.i_fmt_quad = INDEX_FORMAT_U32
        self.i_fmt_mesh = INDEX_FORMAT_U32

    cdef void c_create_quad(self) except *:
        cdef:
            float[16] quad_vbo_data
            uint32_t[6] quad_ibo_data
            uint8_t[:] quad_vbo_mv
            uint8_t[:] quad_ibo_mv
        quad_vbo_data = [
            -1.0, -1.0, 0.0, 0.0,
            -1.0, 1.0, 0.0, 1.0,
            1.0, -1.0, 1.0, 0.0,
            1.0, 1.0, 1.0, 1.0,
        ]
        quad_vbo_mv = <uint8_t[:64]>(<uint8_t *>&quad_vbo_data)
        quad_ibo_data =  [0, 2, 1, 1, 2, 3]
        quad_ibo_mv = <uint8_t[:24]>(<uint8_t *>&quad_ibo_data)
        self.quad_vbo = self.vertex_buffer_create(self.v_fmt_quad)
        self.vertex_buffer_set_data(self.quad_vbo, quad_vbo_mv)
        self.quad_ibo = self.index_buffer_create(self.i_fmt_quad)
        self.index_buffer_set_data(self.quad_ibo, quad_ibo_mv)
        self.quad_vs = self.shader_create_from_file(SHADER_TYPE_VERTEX, b"./resources/shaders/quad.vert")
        self.quad_fs = self.shader_create_from_file(SHADER_TYPE_FRAGMENT, b"./resources/shaders/quad.frag")
        self.quad_program = self.program_create(self.quad_vs, self.quad_fs)
        self.u_quad = self.uniform_create(self.u_fmt_quad)
        self.uniform_set_data(self.u_quad, TEXTURE_UNIT_0)

    cdef void c_delete_quad(self) except *:
        self.vertex_buffer_delete(self.quad_vbo)
        self.index_buffer_delete(self.quad_ibo)
        self.shader_delete(self.quad_vs)
        self.shader_delete(self.quad_fs)
        self.program_delete(self.quad_program)
        self.uniform_delete(self.u_quad)

    cdef WindowC *window_get_ptr(self, Handle window) except *:
        return <WindowC *>self.windows.c_get_ptr(window)

    cpdef Handle window_create(self, uint16_t width, uint16_t height, bytes title) except *:
        cdef:
            Handle window
            WindowC *window_ptr
            size_t title_length
            #SDL_Renderer *renderer

        window = self.windows.c_create()
        window_ptr = self.window_get_ptr(window)
        window_ptr.sdl_ptr = SDL_CreateWindow(
            title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
            width, height, SDL_WINDOW_OPENGL,
        )
        window_ptr.width = width
        window_ptr.height = height
        title_length = len(title)
        if title_length >= 256:
            raise ValueError("Window: title cannot exceed 255 characters")
        memcpy(window_ptr.title, <char *>title, title_length)
        window_ptr.title_length = title_length
        self.window_clear(window)
        return window

    cpdef void window_delete(self, Handle window) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.window_get_ptr(window)
        SDL_DestroyWindow(window_ptr.sdl_ptr)
        self.windows.c_delete(window)

    cpdef void window_set_texture(self, Handle window, Handle texture) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.window_get_ptr(window)
        window_ptr.texture = texture

    cpdef void window_clear(self, Handle window) except *:
        cdef:
            WindowC *window_ptr
        window_ptr = self.window_get_ptr(window)
        SDL_GL_MakeCurrent(window_ptr.sdl_ptr, self.root_context)
        glViewport(0, 0, window_ptr.width, window_ptr.height); self.c_check_gl()
        glClearColor(0.0, 0.0, 0.0, 0.0); self.c_check_gl()
        glClearDepthf(1.0); self.c_check_gl()
        glClearStencil(0); self.c_check_gl()
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT); self.c_check_gl()
        SDL_GL_SetSwapInterval(0)
        SDL_GL_SwapWindow(window_ptr.sdl_ptr)
        SDL_GL_MakeCurrent(self.root_window, self.root_context)

    cpdef void window_render(self, Handle window) except *:
        cdef:
            WindowC *window_ptr
            TextureC *texture_ptr
            ProgramC *program_ptr
        window_ptr = self.window_get_ptr(window)
        SDL_GL_MakeCurrent(window_ptr.sdl_ptr, self.root_context)
        glViewport(0, 0, window_ptr.width, window_ptr.height); self.c_check_gl()
        glClearColor(0.0, 0.0, 0.0, 0.0); self.c_check_gl()
        glClearDepthf(1.0); self.c_check_gl()
        glClearStencil(0); self.c_check_gl()
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT); self.c_check_gl()
        if self.textures.c_is_handle_valid(window_ptr.texture):
            glActiveTexture(GL_TEXTURE0); self.c_check_gl()
            texture_ptr = self.texture_get_ptr(window_ptr.texture)
            program_ptr = self.program_get_ptr(self.quad_program)
            glUseProgram(program_ptr.gl_id); self.c_check_gl()
            glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id); self.c_check_gl()
            self._program_bind_uniform(self.quad_program, self.u_quad)
            self._program_bind_attributes(self.quad_program, self.quad_vbo)
            self._index_buffer_draw(self.quad_ibo)
            self._program_unbind_attributes(self.quad_program)
            glBindTexture(GL_TEXTURE_2D, 0); self.c_check_gl()
            SDL_GL_SetSwapInterval(0)
            SDL_GL_SwapWindow(window_ptr.sdl_ptr)
            glUseProgram(0); self.c_check_gl()
        SDL_GL_MakeCurrent(self.root_window, self.root_context)

    cdef VertexFormatC *vertex_format_get_ptr(self, Handle format) except *:
        return <VertexFormatC *>self.vertex_formats.c_get_ptr(format)

    cpdef Handle vertex_format_create(self, list comps) except *:
        cdef:
            Handle format
            VertexFormatC *format_ptr
            size_t num_comps
            size_t i
            tuple comp_tuple
            bytes name
            size_t name_length
            VertexCompC *comp
            size_t offset
            size_t comp_type_size
        num_comps = len(comps)
        if num_comps > 16:
            raise ValueError("VertexFormat: maximum number of vertex comps exceeded")
        format = self.vertex_formats.c_create()
        format_ptr = self.vertex_format_get_ptr(format)
        offset = 0
        for i in range(num_comps):
            comp_tuple = <tuple>comps[i]
            comp = &format_ptr.comps[i]
            name = <bytes>comp_tuple[0]
            name_length = len(name)
            if name_length >= 256:
                raise ValueError("VertexFormat: comp name cannot exceed 255 characters")
            memcpy(comp.name, <char *>name, sizeof(char) * name_length)
            comp.name_length = name_length
            comp.type = <VertexCompType>comp_tuple[1]
            comp.count = <size_t>comp_tuple[2]
            comp.normalized = <bint>comp_tuple[3]
            comp.offset = offset
            if comp.type == VERTEX_COMP_TYPE_F32: comp_type_size = 4
            elif comp.type == VERTEX_COMP_TYPE_I8: comp_type_size = 1
            elif comp.type == VERTEX_COMP_TYPE_U8: comp_type_size = 1
            elif comp.type == VERTEX_COMP_TYPE_I16: comp_type_size = 2
            elif comp.type == VERTEX_COMP_TYPE_U16: comp_type_size = 2
            offset += comp.count * comp_type_size
        format_ptr.count = num_comps
        format_ptr.stride = offset
        return format

    cpdef void vertex_format_delete(self, Handle format) except *:
        cdef VertexFormatC *format_ptr
        format_ptr = self.vertex_format_get_ptr(format)
        self.vertex_formats.c_delete(format)

    cdef VertexBufferC *vertex_buffer_get_ptr(self, Handle buffer) except *:
        return <VertexBufferC *>self.vertex_buffers.c_get_ptr(buffer)

    cpdef Handle vertex_buffer_create(self, Handle format, BufferUsage usage=BUFFER_USAGE_STATIC) except *:
        cdef:
            Handle buffer
            VertexBufferC *buffer_ptr
        buffer = self.vertex_buffers.c_create()
        buffer_ptr = self.vertex_buffer_get_ptr(buffer)
        glGenBuffers(1, &buffer_ptr.gl_id); self.c_check_gl()
        if buffer_ptr.gl_id == 0:
            raise ValueError("VertexBuffer: failed to generate buffer id")
        buffer_ptr.format = format
        buffer_ptr.usage = usage
        buffer_ptr.size = 0
        return buffer

    cpdef void vertex_buffer_delete(self, Handle buffer) except *:
        cdef:
            VertexBufferC *buffer_ptr
            uint32_t gl_usage
        buffer_ptr = self.vertex_buffer_get_ptr(buffer)
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id); self.c_check_gl()
        gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
        glBufferData(GL_ARRAY_BUFFER, buffer_ptr.size, NULL, gl_usage); self.c_check_gl()
        glBindBuffer(GL_ARRAY_BUFFER, 0); self.c_check_gl()
        glDeleteBuffers(1, &buffer_ptr.gl_id); self.c_check_gl()
        self.vertex_buffers.c_delete(buffer)

    cpdef void vertex_buffer_set_data(self, Handle buffer, uint8_t[:] data) except *:
        cdef:
            VertexBufferC *buffer_ptr
            size_t data_size
            uint8_t *data_ptr
            uint32_t gl_usage
        buffer_ptr = self.vertex_buffer_get_ptr(buffer)
        data_size = data.shape[0]
        data_ptr = &data[0]
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id); self.c_check_gl()
        if buffer_ptr.size == data_size:#use sub data instead
            glBufferSubData(GL_ARRAY_BUFFER, 0, data_size, data_ptr); self.c_check_gl()
        else:
            gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
            glBufferData(GL_ARRAY_BUFFER, data_size, data_ptr, gl_usage); self.c_check_gl()
            buffer_ptr.size = data_size
        glBindBuffer(GL_ARRAY_BUFFER, 0); self.c_check_gl()
    
    cpdef void vertex_buffer_set_data_from_mesh(self, Handle buffer, Handle mesh) except *:
        cdef:
            MeshC *mesh_ptr
            uint8_t[:] data
        mesh_ptr = self.mesh_get_ptr(mesh)
        data = <uint8_t[:mesh_ptr.vertex_data_size]>mesh_ptr.vertex_data
        self.vertex_buffer_set_data(buffer, data)

    cpdef void vertex_buffer_set_sub_data(self, Handle buffer, uint8_t[:] data, size_t offset) except *:
        cdef:
            VertexBufferC *buffer_ptr
            size_t data_size
            uint8_t *data_ptr
        buffer_ptr = self.vertex_buffer_get_ptr(buffer)
        data_size = data.shape[0]
        data_ptr = &data[0]
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id); self.c_check_gl()
        if offset + data_size > buffer_ptr.size:
            raise ValueError("VertexBuffer: attempting to write out of bounds")
        else:
            glBufferSubData(GL_ARRAY_BUFFER, 0, data_size, data_ptr); self.c_check_gl()
        glBindBuffer(GL_ARRAY_BUFFER, 0); self.c_check_gl()
    
    cpdef void vertex_buffer_set_sub_data_from_mesh(self, Handle buffer, Handle mesh, size_t offset) except *:
        cdef:
            MeshC *mesh_ptr
            uint8_t[:] data
        mesh_ptr = self.mesh_get_ptr(mesh)
        data = <uint8_t[:mesh_ptr.vertex_data_size]>mesh_ptr.vertex_data
        self.vertex_buffer_set_sub_data(buffer, data, offset)

    cdef IndexBufferC *index_buffer_get_ptr(self, Handle buffer) except *:
        return <IndexBufferC *>self.index_buffers.c_get_ptr(buffer)

    cpdef Handle index_buffer_create(self, IndexFormat format, BufferUsage usage=BUFFER_USAGE_STATIC) except *:
        cdef:
            Handle buffer
            IndexBufferC *buffer_ptr
        buffer = self.index_buffers.c_create()
        buffer_ptr = self.index_buffer_get_ptr(buffer)
        glGenBuffers(1, &buffer_ptr.gl_id); self.c_check_gl()
        if buffer_ptr.gl_id == 0:
            raise ValueError("IndexBuffer: failed to generate buffer id")
        buffer_ptr.format = format
        buffer_ptr.usage = usage
        buffer_ptr.size = 0
        return buffer

    cpdef void index_buffer_delete(self, Handle buffer) except *:
        cdef:
            IndexBufferC *buffer_ptr
            uint32_t gl_usage
        buffer_ptr = self.index_buffer_get_ptr(buffer)
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id); self.c_check_gl()
        gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.size, NULL, gl_usage); self.c_check_gl()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); self.c_check_gl()
        glDeleteBuffers(1, &buffer_ptr.gl_id); self.c_check_gl()
        self.index_buffers.c_delete(buffer)
    
    cpdef void index_buffer_set_data(self, Handle buffer, uint8_t[:] data) except *:
        cdef:
            IndexBufferC *buffer_ptr
            size_t data_size
            uint8_t *data_ptr
            uint32_t gl_usage
        buffer_ptr = self.index_buffer_get_ptr(buffer)
        data_size = data.shape[0]
        data_ptr = &data[0]
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id); self.c_check_gl()
        if buffer_ptr.size == data_size:#use sub data instead
            glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, data_size, data_ptr); self.c_check_gl()
        else:
            gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, data_size, data_ptr, gl_usage); self.c_check_gl()
            buffer_ptr.size = data_size
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); self.c_check_gl()
    
    cpdef void index_buffer_set_data_from_mesh(self, Handle buffer, Handle mesh) except *:
        cdef:
            MeshC *mesh_ptr
            uint8_t[:] data
        mesh_ptr = self.mesh_get_ptr(mesh)
        data = <uint8_t[:mesh_ptr.index_data_size]>mesh_ptr.index_data
        self.index_buffer_set_data(buffer, data)

    cpdef void index_buffer_set_sub_data(self, Handle buffer, uint8_t[:] data, size_t offset) except *:
        cdef:
            IndexBufferC *buffer_ptr
            size_t data_size
            uint8_t *data_ptr
        buffer_ptr = self.index_buffer_get_ptr(buffer)
        data_size = data.shape[0]
        data_ptr = &data[0]
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id); self.c_check_gl()
        if offset + data_size > buffer_ptr.size:
            raise ValueError("IndexBuffer: attempting to write out of bounds")
        else:
            glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, data_size, data_ptr); self.c_check_gl()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); self.c_check_gl()

    cpdef void index_buffer_set_sub_data_from_mesh(self, Handle buffer, Handle mesh, size_t offset) except *:
        cdef:
            MeshC *mesh_ptr
            uint8_t[:] data
        mesh_ptr = self.mesh_get_ptr(mesh)
        data = <uint8_t[:mesh_ptr.index_data_size]>mesh_ptr.index_data
        self.index_buffer_set_sub_data(buffer, data, offset)

    cdef void _index_buffer_draw(self, Handle buffer) except *:
        cdef:
            IndexBufferC *buffer_ptr
            size_t format_size
            uint32_t format_gl
        buffer_ptr = self.index_buffer_get_ptr(buffer)
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id); self.c_check_gl()
        format_size = c_index_format_get_size(buffer_ptr.format)    
        format_gl = c_index_format_to_gl(buffer_ptr.format)
        glDrawElements(GL_TRIANGLES, buffer_ptr.size / format_size, format_gl, NULL); self.c_check_gl()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); self.c_check_gl()
    
    cdef UniformFormatC *uniform_format_get_ptr(self, Handle format) except *:
        return <UniformFormatC *>self.uniform_formats.c_get_ptr(format)

    cpdef Handle uniform_format_create(self, bytes name, UniformType type, size_t count=1) except *:
        cdef:
            size_t name_length
            Handle format
            UniformFormatC *format_ptr
        name_length = len(name)
        if name_length >= 256:
            raise ValueError("UniformFormat: name cannot exceed 255 characters")
        if count == 0:
            raise ValueError("UniformFormat: count must be non-zero value")
        format = self.uniform_formats.c_create()
        format_ptr = self.uniform_format_get_ptr(format)
        memcpy(format_ptr.name, <char *>name, sizeof(char) * name_length)
        format_ptr.name_length = name_length
        format_ptr.type = type
        format_ptr.count = count
        format_ptr.size = count * c_uniform_type_get_size(type)
        return format

    cpdef void uniform_format_delete(self, Handle format) except *:
        self.uniform_formats.c_delete(format)

    cdef UniformC *uniform_get_ptr(self, Handle uniform) except *:
        return <UniformC *>self.uniforms.c_get_ptr(uniform)

    cpdef Handle uniform_create(self, Handle format) except *:
        cdef:
            Handle uniform
            UniformC *uniform_ptr
            UniformFormatC *format_ptr
            size_t type_size
            size_t data_size
            uint8_t *data_ptr
        uniform = self.uniforms.c_create()
        uniform_ptr = self.uniform_get_ptr(uniform)
        uniform_ptr.format = format
        format_ptr = self.uniform_format_get_ptr(format)
        type_size = c_uniform_type_get_size(format_ptr.type)
        data_size = format_ptr.count * type_size
        data_ptr = <uint8_t *>calloc(1, data_size)
        if data_ptr == NULL:
            raise MemoryError("Uniform: cannot allocate memory for data")
        uniform_ptr.data = data_ptr
        return uniform

    cpdef void uniform_delete(self, Handle uniform) except *:
        self.uniforms.c_delete(uniform)

    cpdef void uniform_set_data(self, Handle uniform, object data, size_t index=0) except *:
        cdef:
            UniformC *uniform_ptr
            UniformFormatC *format_ptr
            UniformType type
            size_t type_size
            int32_t int_data
            float float_data
            uint8_t *src_ptr
            uint8_t *dst_ptr
        uniform_ptr = self.uniform_get_ptr(uniform)
        format_ptr = self.uniform_format_get_ptr(uniform_ptr.format)
        if index >= format_ptr.count:
            raise ValueError("Uniform: attempting to set data outside of count boundaries")
        type = format_ptr.type
        type_size = c_uniform_type_get_size(type)
        if type == UNIFORM_TYPE_INT:
            int_data = <int32_t?>data
            src_ptr = <uint8_t *>&int_data
        elif type == UNIFORM_TYPE_FLOAT:
            float_data = <float?>data
            src_ptr = <uint8_t *>&float_data
        elif type == UNIFORM_TYPE_VEC2:
            src_ptr = <uint8_t *>&(<Vec2?>data).data
        elif type == UNIFORM_TYPE_VEC3:
            src_ptr = <uint8_t *>&(<Vec3?>data).data
        elif type == UNIFORM_TYPE_VEC4:
            src_ptr = <uint8_t *>&(<Vec4?>data).data
        elif type == UNIFORM_TYPE_MAT2:
            src_ptr = <uint8_t *>&(<Mat2?>data).data
        elif type == UNIFORM_TYPE_MAT3:
            src_ptr = <uint8_t *>&(<Mat3?>data).data
        elif type == UNIFORM_TYPE_MAT4:
            src_ptr = <uint8_t *>&(<Mat4?>data).data
        else:
            raise ValueError("Uniform: data is of an invalid type")
        dst_ptr = uniform_ptr.data + (index * type_size)
        memcpy(dst_ptr, src_ptr, type_size)

    cdef ShaderC *shader_get_ptr(self, Handle shader) except *:
        return <ShaderC *>self.shaders.c_get_ptr(shader)

    cpdef Handle shader_create(self, ShaderType type, bytes source) except *:
        cdef:
            Handle shader
            ShaderC *shader_ptr
            uint32_t gl_id
            char *source_ptr
            size_t source_length
            uint32_t compile_status
            char *log
            int log_length
            uint32_t gl_type
        shader = self.shaders.c_create()
        shader_ptr = self.shader_get_ptr(shader)
        gl_type = c_shader_type_to_gl(type)
        gl_id = glCreateShader(gl_type); self.c_check_gl()
        source_ptr = source
        source_length = len(source)
        glShaderSource(gl_id, 1, &source_ptr, <GLint*>&source_length); self.c_check_gl()
        glCompileShader(gl_id); self.c_check_gl()
        glGetShaderiv(gl_id, GL_COMPILE_STATUS, <GLint*>&compile_status); self.c_check_gl()
        glGetShaderiv(gl_id, GL_INFO_LOG_LENGTH, <GLint*>&log_length); self.c_check_gl()
        if not compile_status:
            log = <char*>malloc(log_length * sizeof(char))
            if log == NULL:
                raise MemoryError("Shader: could not allocate memory for compile error")
            glGetShaderInfoLog(gl_id, log_length, NULL, log); self.c_check_gl()
            raise ValueError("Shader: failed to compile (GL error message below)\n{0}".format(log.decode("utf-8")))
        shader_ptr.gl_id = gl_id
        shader_ptr.type = type
        return shader
    
    cpdef Handle shader_create_from_file(self, ShaderType type, bytes file_path) except *:
        cdef:
            Handle shader
            object in_file
            bytes source
        in_file = open(file_path, "rb")
        source = in_file.read()
        in_file.close()
        shader = self.shader_create(type, source)
        return shader

    cpdef void shader_delete(self, Handle shader) except *:
        cdef:
            ShaderC *shader_ptr
        shader_ptr = self.shader_get_ptr(shader)
        glDeleteShader(shader_ptr.gl_id); self.c_check_gl()
        self.shaders.c_delete(shader)

    cdef ProgramC *program_get_ptr(self, Handle program) except *:
        return <ProgramC *>self.programs.c_get_ptr(program)

    cpdef Handle program_create(self, Handle vertex, Handle fragment) except *:
        cdef:
            ProgramC *program_ptr
        program = self.programs.c_create()
        program_ptr = self.program_get_ptr(program)
        program_ptr.gl_id = glCreateProgram(); self.c_check_gl()
        program_ptr.vertex = vertex
        program_ptr.fragment = fragment
        self._program_compile(program)
        self._program_setup_attributes(program)
        self._program_setup_uniforms(program)
        return program

    cpdef void program_delete(self, Handle program) except *:
        cdef:
            ProgramC *program_ptr
        program_ptr = self.program_get_ptr(program)
        glDeleteProgram(program_ptr.gl_id); self.c_check_gl()
        self.programs.c_delete(program)

    cdef void _program_compile(self, Handle program) except *:
        cdef:
            ProgramC *program_ptr
            ShaderC *vertex_ptr
            ShaderC *fragment_ptr
            uint32_t gl_id
            uint32_t link_status
            char *log
            int log_length
        program_ptr = self.program_get_ptr(program)
        vertex_ptr = self.shader_get_ptr(program_ptr.vertex)
        fragment_ptr = self.shader_get_ptr(program_ptr.fragment)
        gl_id = program_ptr.gl_id
        glAttachShader(gl_id, vertex_ptr.gl_id); self.c_check_gl()
        glAttachShader(gl_id, fragment_ptr.gl_id); self.c_check_gl()
        glLinkProgram(gl_id); self.c_check_gl()
        glGetProgramiv(gl_id, GL_LINK_STATUS, <GLint*>&link_status); self.c_check_gl()
        glGetProgramiv(gl_id, GL_INFO_LOG_LENGTH, <GLint*>&log_length); self.c_check_gl()
        if not link_status:
            log = <char*>malloc(log_length * sizeof(char))
            glGetProgramInfoLog(gl_id, log_length, NULL, log); self.c_check_gl()
            raise ValueError("Program: failed to compile (GL error message below)\n{0}".format(log.decode("utf-8")))

    cdef void _program_setup_attributes(self, Handle program) except *:
        cdef:
            ProgramC *program_ptr
            uint32_t gl_id
            size_t i
            int count
            int name_max_length
            int name_length
            int size
            uint32_t type
            ProgramAttributeC *attribute
        program_ptr = self.program_get_ptr(program)
        gl_id = program_ptr.gl_id
        glGetProgramiv(gl_id, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &name_max_length); self.c_check_gl()
        if name_max_length >= 256:
            raise ValueError("Program: attribute names cannot exceed 255 characters")
        glGetProgramiv(gl_id, GL_ACTIVE_ATTRIBUTES, &count); self.c_check_gl()
        if count > PROGRAM_MAX_ATTRIBUTES:
            raise ValueError("Program: cannot exceed {0} attributes".format(PROGRAM_MAX_ATTRIBUTES))
        for i in range(count):
            attribute = &program_ptr.attributes[i]
            glGetActiveAttrib(gl_id, i, 255, &name_length, &size, &type, attribute.name); self.c_check_gl()
            attribute.name_length = name_length
            attribute.size = size
            attribute.type = c_attribute_type_from_gl(type)
            attribute.location = glGetAttribLocation(gl_id, attribute.name); self.c_check_gl()
        program_ptr.num_attributes = count
        
    cdef void _program_setup_uniforms(self, Handle program) except *:
        cdef:
            ProgramC *program_ptr
            uint32_t gl_id
            size_t i
            int count
            int name_max_length
            int name_length
            int size
            uint32_t type
            ProgramUniformC *uniform
        program_ptr = self.program_get_ptr(program)
        gl_id = program_ptr.gl_id
        glGetProgramiv(gl_id, GL_ACTIVE_UNIFORM_MAX_LENGTH, &name_max_length); self.c_check_gl()
        if name_max_length >= 256:
            raise ValueError("Program: uniform names cannot exceed 255 characters")
        glGetProgramiv(gl_id, GL_ACTIVE_UNIFORMS, &count); self.c_check_gl()
        if count > PROGRAM_MAX_UNIFORMS:
            raise ValueError("Program: cannot exceed {0} uniforms".format(PROGRAM_MAX_UNIFORMS))
        for i in range(count):
            uniform = &program_ptr.uniforms[i]
            glGetActiveUniform(gl_id, i, 255, &name_length, &size, &type, uniform.name); self.c_check_gl()
            uniform.name_length = name_length
            uniform.size = size
            uniform.type = c_uniform_type_from_gl(type)
            uniform.location = glGetUniformLocation(gl_id, uniform.name)
        program_ptr.num_uniforms = count

    cdef void _program_bind_attributes(self, Handle program, Handle buffer) except *:
        cdef:
            ProgramC *program_ptr
            VertexBufferC *buffer_ptr
            VertexFormatC *format_ptr
            VertexCompC *comp_ptr
            size_t i, j
            ProgramAttributeC *attribute
            uint32_t comp_type_gl
            size_t comp_type_size
            size_t comp_offset
            size_t location
        program_ptr = self.program_get_ptr(program)
        buffer_ptr = self.vertex_buffer_get_ptr(buffer)
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id); self.c_check_gl()
        format_ptr = self.vertex_format_get_ptr(buffer_ptr.format)
        for i in range(format_ptr.count):
            comp_ptr = &format_ptr.comps[i]
            for j in range(program_ptr.num_attributes):
                attribute = &program_ptr.attributes[j]
                if strcmp(comp_ptr.name, attribute.name) == 0:
                    location = attribute.location
                    comp_type_gl = c_vertex_comp_type_to_gl(comp_ptr.type)
                    comp_type_size = c_vertex_comp_type_get_size(comp_ptr.type)
                    comp_offset = comp_ptr.offset
                    glVertexAttribPointer(#TODO: validate buffer format against program's attribute info
                        location,
                        comp_ptr.count, 
                        comp_type_gl, 
                        comp_ptr.normalized, 
                        format_ptr.stride,
                        <void *>comp_offset,
                    ); self.c_check_gl()
                    glEnableVertexAttribArray(location); self.c_check_gl()
                    break
        glBindBuffer(GL_ARRAY_BUFFER, 0)

    cdef void _program_unbind_attributes(self, Handle program) except *:
        cdef:
            ProgramC *program_ptr
            size_t i
            ProgramAttributeC *attribute
        program_ptr = self.program_get_ptr(program)
        for i in range(program_ptr.num_attributes):
            attribute = &program_ptr.attributes[i]
            glDisableVertexAttribArray(attribute.location); self.c_check_gl()

    cdef void _program_bind_uniform(self, Handle program, Handle uniform) except *:
        cdef:
            ProgramC *program_ptr
            UniformC *uniform_ptr
            UniformFormatC *format_ptr
            size_t location
            size_t i
            ProgramUniformC *uniform_info
            UniformType type
            int32_t int_data
            float float_data
        program_ptr = self.program_get_ptr(program)
        uniform_ptr = self.uniform_get_ptr(uniform)
        format_ptr = self.uniform_format_get_ptr(uniform_ptr.format)
        for i in range(program_ptr.num_uniforms):
            uniform_info = &program_ptr.uniforms[i]
            if strcmp(format_ptr.name, uniform_info.name) == 0:#TODO: validate uniform against program's uniform info
                location = uniform_info.location
                type = uniform_info.type
                if type == UNIFORM_TYPE_INT:
                    int_data = (<int32_t *>(uniform_ptr.data))[0]
                    glUniform1i(location, <GLint>int_data); self.c_check_gl()
                elif type == UNIFORM_TYPE_FLOAT:
                    float_data = (<float *>uniform_ptr.data)[0]
                    glUniform1f(location, float_data); self.c_check_gl()
                elif type == UNIFORM_TYPE_VEC2:
                    glUniform2fv(location, 1, <float *>uniform_ptr.data); self.c_check_gl()
                elif type == UNIFORM_TYPE_VEC3:
                    glUniform3fv(location, 1, <float *>uniform_ptr.data); self.c_check_gl()
                elif type == UNIFORM_TYPE_VEC4:
                    glUniform4fv(location, 1, <float *>uniform_ptr.data); self.c_check_gl()
                elif type == UNIFORM_TYPE_MAT2:
                    glUniformMatrix2fv(location, 1, False, <float *>uniform_ptr.data); self.c_check_gl()
                elif type == UNIFORM_TYPE_MAT3:
                    glUniformMatrix3fv(location, 1, False, <float *>uniform_ptr.data); self.c_check_gl()
                elif type == UNIFORM_TYPE_MAT4:
                    glUniformMatrix4fv(location, 1, False, <float *>uniform_ptr.data); self.c_check_gl()

    cdef ImageC *image_get_ptr(self, Handle image) except *:
        return <ImageC *>self.images.c_get_ptr(image)

    cpdef Handle image_create(self, uint16_t width, uint16_t height, uint8_t[:] data=None, size_t bytes_per_channel=1, size_t num_channels=4) except *:
        cdef:
            Handle image
            ImageC *image_ptr
        if width == 0:
            raise ValueError("Image: width cannot be zero pixels")
        if height == 0:
            raise ValueError("Image: height cannot be zero pixels")
        image = self.images.c_create()
        image_ptr = self.image_get_ptr(image)
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.bytes_per_channel = bytes_per_channel
        image_ptr.num_channels = num_channels
        image_ptr.data_size = <uint64_t>width * <uint64_t>height * bytes_per_channel * num_channels
        image_ptr.data = <uint8_t *>calloc(image_ptr.data_size, sizeof(uint8_t))
        if image_ptr.data == NULL:
            raise MemoryError("Image: cannot allocate memory for data")
        self.image_set_data(image, data)
        return image

    cpdef Handle image_create_from_file(self, bytes file_path, bint flip_x=False, bint flip_y=False) except *:
        cdef:
            Handle image
            SDL_Surface *surface
            SDL_Surface *converted_surface
            uint16_t width
            uint16_t height
            size_t data_size
            size_t left, right, top, bottom
            size_t x, y, z
            size_t src, dst
            uint8_t *data_ptr
            uint8_t[:] data
        surface = IMG_Load(file_path)
        if surface == NULL:
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
        image = self.image_create(width, height, data)
        SDL_FreeSurface(surface)
        SDL_FreeSurface(converted_surface)
        return image
    
    cpdef void image_delete(self, Handle image) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.image_get_ptr(image)
        free(image_ptr.data)
        self.images.c_delete(image)

    cpdef void image_set_data(self, Handle image, uint8_t[:] data=None) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.image_get_ptr(image)
        if data != None:
            if data.shape[0] != image_ptr.data_size:
                raise ValueError("Image: invalid data size")
            memcpy(image_ptr.data, &data[0], image_ptr.data_size)
        else:
            memset(image_ptr.data, 0, image_ptr.data_size)

    cpdef uint16_t image_get_width(self, Handle image) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.image_get_ptr(image)
        return image_ptr.width

    cpdef uint16_t image_get_height(self, Handle image) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.image_get_ptr(image)
        return image_ptr.height

    cpdef uint8_t[:] image_get_data(self, Handle image) except *:
        cdef:
            ImageC *image_ptr
        image_ptr = self.image_get_ptr(image)
        return <uint8_t[:image_ptr.data_size]>image_ptr.data

    cdef TextureC *texture_get_ptr(self, Handle texture) except *:
        return <TextureC *>self.textures.c_get_ptr(texture)

    cpdef Handle texture_create(self, TextureFormat format=TEXTURE_FORMAT_RGBA_8U, bint mipmaps=True, 
            TextureFilter filter=TEXTURE_FILTER_LINEAR, TextureWrap wrap_s=TEXTURE_WRAP_REPEAT, 
            TextureWrap wrap_t=TEXTURE_WRAP_REPEAT, bint cubemap=False) except *:
        cdef:
            Handle texture
            TextureC *texture_ptr
        texture = self.textures.c_create()
        texture_ptr = self.texture_get_ptr(texture)
        texture_ptr.format = format
        texture_ptr.cubemap = cubemap
        glGenTextures(1, &texture_ptr.gl_id); self.c_check_gl()
        self.texture_set_parameters(texture, mipmaps, filter, wrap_s, wrap_t)
        return texture

    cpdef void texture_delete(self, Handle texture) except *:
        cdef:
            TextureC *texture_ptr
        texture_ptr = self.texture_get_ptr(texture)
        glDeleteTextures(1, &texture_ptr.gl_id); self.c_check_gl()
        self.textures.c_delete(texture)
    
    cpdef void texture_set_parameters(self, Handle texture, bint mipmaps=True, TextureFilter filter=TEXTURE_FILTER_LINEAR, TextureWrap wrap_s=TEXTURE_WRAP_REPEAT, TextureWrap wrap_t=TEXTURE_WRAP_REPEAT) except *:
        cdef:
            TextureC *texture_ptr
            uint32_t target
        texture_ptr = self.texture_get_ptr(texture)
        texture_ptr.mipmaps = mipmaps
        texture_ptr.filter = filter
        texture_ptr.wrap_s = wrap_s
        texture_ptr.wrap_t = wrap_t
        target = GL_TEXTURE_CUBE_MAP if texture_ptr.cubemap else GL_TEXTURE_2D
        glBindTexture(target, texture_ptr.gl_id); self.c_check_gl()
        glTexParameteri(target, GL_TEXTURE_WRAP_S, c_texture_wrap_to_gl(wrap_s)); self.c_check_gl()	
        glTexParameteri(target, GL_TEXTURE_WRAP_T, c_texture_wrap_to_gl(wrap_t)); self.c_check_gl()
        glTexParameteri(target, GL_TEXTURE_MIN_FILTER, c_texture_filter_to_gl(filter, mipmaps)); self.c_check_gl()
        glTexParameteri(target, GL_TEXTURE_MAG_FILTER, c_texture_filter_to_gl(filter, False)); self.c_check_gl()#mipmap does not matter for mag filter!
        glBindTexture(target, 0); self.c_check_gl()
    
    cpdef void texture_set_data_2d_from_image(self, Handle texture, Handle image) except *:
        cdef:
            TextureC *texture_ptr
            ImageC *image_ptr
            uint32_t gl_internal_format
            uint32_t gl_format
            uint32_t gl_type
        texture_ptr = self.texture_get_ptr(texture)
        if texture_ptr.cubemap:
            raise ValueError("Texture: cannot use 2D data setter for cubemap texture")
        gl_internal_format = c_texture_format_to_internal_format_gl(texture_ptr.format)
        gl_format = c_texture_format_to_format_gl(texture_ptr.format)
        gl_type = c_texture_format_to_type_gl(texture_ptr.format)
        image_ptr = self.image_get_ptr(image)
        glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id); self.c_check_gl()
        glTexImage2D(GL_TEXTURE_2D, 0, gl_internal_format, image_ptr.width, image_ptr.height, 0, gl_format, gl_type, image_ptr.data); self.c_check_gl()
        if texture_ptr.mipmaps:
            glGenerateMipmap(GL_TEXTURE_2D); self.c_check_gl()
        glBindTexture(GL_TEXTURE_2D, 0); self.c_check_gl()

    cpdef void texture_set_data_cubemap_from_images(self, Handle texture, 
            Handle image_pos_x, Handle image_neg_x, Handle image_pos_y,
            Handle image_neg_y, Handle image_pos_z, Handle image_neg_z) except *:
        cdef:
            TextureC *texture_ptr
            Handle[6] images
            size_t i
            ImageC *image_ptr
            uint32_t gl_internal_format
            uint32_t gl_format
            uint32_t gl_type
        images = [
            image_pos_x, image_neg_x, 
            image_pos_y, image_neg_y, 
            image_pos_z, image_neg_z,
        ]
        texture_ptr = self.texture_get_ptr(texture)
        if not texture_ptr.cubemap:
            raise ValueError("Texture: cannot use cubemap data setter for 2D texture")
        gl_internal_format = c_texture_format_to_internal_format_gl(texture_ptr.format)
        gl_format = c_texture_format_to_format_gl(texture_ptr.format)
        gl_type = c_texture_format_to_type_gl(texture_ptr.format)
        glBindTexture(GL_TEXTURE_CUBE_MAP, texture_ptr.gl_id)
        for i in range(6):
            image_ptr = self.image_get_ptr(images[i])
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, gl_internal_format, image_ptr.width, image_ptr.height, 0, gl_format, gl_type, image_ptr.data); self.c_check_gl()
        if texture_ptr.mipmaps:
            glGenerateMipmap(GL_TEXTURE_CUBE_MAP); self.c_check_gl()
        glBindTexture(GL_TEXTURE_CUBE_MAP, 0); self.c_check_gl()

    cpdef void texture_clear(self, Handle texture, uint16_t width, uint16_t height) except *:
        cdef:
            TextureC *texture_ptr
            uint32_t target
            size_t i
            uint32_t gl_internal_format
            uint32_t gl_format
            uint32_t gl_type
        texture_ptr = self.texture_get_ptr(texture)
        gl_internal_format = c_texture_format_to_internal_format_gl(texture_ptr.format)
        gl_format = c_texture_format_to_format_gl(texture_ptr.format)
        gl_type = c_texture_format_to_type_gl(texture_ptr.format)
        target = GL_TEXTURE_CUBE_MAP if texture_ptr.cubemap else GL_TEXTURE_2D
        glBindTexture(target, texture_ptr.gl_id); self.c_check_gl()
        if texture_ptr.cubemap:
            for i in range(6):
                glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, gl_internal_format, width, height, 0, gl_format, gl_type, NULL); self.c_check_gl()
        else:
            glTexImage2D(GL_TEXTURE_2D, 0, gl_internal_format, width, height, 0, gl_format, gl_type, NULL); self.c_check_gl()
        if texture_ptr.mipmaps:
            glGenerateMipmap(target); self.c_check_gl()
        glBindTexture(target, 0); self.c_check_gl()

    cdef FrameBufferC *frame_buffer_get_ptr(self, Handle frame_buffer) except *:
        return <FrameBufferC *>self.frame_buffers.c_get_ptr(frame_buffer)

    cpdef Handle frame_buffer_create(self) except *:
        cdef:
            Handle frame_buffer
            FrameBufferC *frame_buffer_ptr
        frame_buffer = self.frame_buffers.c_create()
        frame_buffer_ptr = self.frame_buffer_get_ptr(frame_buffer)
        glGenFramebuffers(1, &frame_buffer_ptr.gl_id); self.c_check_gl()
        return frame_buffer

    cpdef void frame_buffer_delete(self, Handle frame_buffer) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
        frame_buffer_ptr = self.frame_buffer_get_ptr(frame_buffer)
        glDeleteFramebuffers(1, &frame_buffer_ptr.gl_id); self.c_check_gl()
        self.frame_buffers.c_delete(frame_buffer)

    cpdef void frame_buffer_attach_textures(self, Handle frame_buffer, dict textures) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
            uint32_t gl_id
            size_t num_textures
            size_t i = 0
            Handle texture
            TextureC *texture_ptr
            FrameBufferAttachment attachment
            uint32_t gl_attachment
            uint32_t gl_status
        frame_buffer_ptr = self.frame_buffer_get_ptr(frame_buffer)
        num_textures = len(textures)
        if num_textures > MAX_FRAME_BUFFER_ATTACHMENTS:
            raise ValueError("FrameBuffer: cannot attach more than {0} textures".format(MAX_FRAME_BUFFER_ATTACHMENTS))
        memset(frame_buffer_ptr.textures, 0, MAX_FRAME_BUFFER_ATTACHMENTS * sizeof(Handle))
        memset(frame_buffer_ptr.attachments, 0, MAX_FRAME_BUFFER_ATTACHMENTS * sizeof(int32_t))
        gl_id = frame_buffer_ptr.gl_id
        glBindFramebuffer(GL_FRAMEBUFFER, gl_id); self.c_check_gl()
        for attachment in textures:
            texture = <Handle>textures[attachment]
            frame_buffer_ptr.attachments[i] = attachment
            frame_buffer_ptr.textures[<size_t>attachment] = texture
            gl_attachment = c_frame_buffer_attachment_to_gl(attachment)
            texture_ptr = self.texture_get_ptr(texture)
            glFramebufferTexture2D(GL_FRAMEBUFFER, gl_attachment, GL_TEXTURE_2D, texture_ptr.gl_id, 0); self.c_check_gl()
            gl_status = glCheckFramebufferStatus(GL_FRAMEBUFFER); self.c_check_gl()
            if gl_status != GL_FRAMEBUFFER_COMPLETE:
                raise ValueError("FrameBuffer: failed to attach textures (status: {0})".format(gl_status))
            i += 1
        glBindFramebuffer(GL_FRAMEBUFFER, 0); self.c_check_gl()

    cdef ViewC *view_get_ptr(self, Handle view) except *:
        return <ViewC *>self.views.c_get_ptr(view)

    cpdef Handle view_create(self) except *:
        cdef:
            Handle view
            ViewC *view_ptr
        view = self.views.c_create()
        view_ptr = self.view_get_ptr(view)
        return view

    cpdef void view_delete(self, Handle view) except *:
        self.views.c_delete(view)

    cpdef void view_set_clear_flags(self, Handle view, uint32_t clear_flags) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.clear_flags = clear_flags

    cpdef void view_set_clear_color(self, Handle view, Vec4 color) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.clear_color = color.data

    cpdef void view_set_clear_depth(self, Handle view, float depth) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.clear_depth = depth

    cpdef void view_set_clear_stencil(self, Handle view, uint32_t stencil) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.clear_stencil = stencil
    
    cpdef void view_set_rect(self, Handle view, uint16_t x, uint16_t y, uint16_t width, uint16_t height) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.rect[0] = x
        view_ptr.rect[1] = y
        view_ptr.rect[2] = width
        view_ptr.rect[3] = height

    cpdef void view_set_program(self, Handle view, Handle program) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.program = program

    cpdef void view_set_uniforms(self, Handle view, Handle[:] uniforms) except *:
        cdef:
            ViewC *view_ptr
            size_t num_uniforms
        view_ptr = self.view_get_ptr(view)
        num_uniforms = uniforms.shape[0]
        if num_uniforms > 16:
            raise ValueError("View: cannot set more than {0} uniforms".format(PROGRAM_MAX_UNIFORMS))
        view_ptr.num_uniforms = num_uniforms
        memcpy(view_ptr.uniforms, &uniforms[0], sizeof(Handle) * num_uniforms)

    cpdef void view_set_vertex_buffer(self, Handle view, Handle buffer) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.vertex_buffer = buffer

    cpdef void view_set_index_buffer(self, Handle view, Handle buffer) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.index_buffer = buffer

    cpdef void view_set_textures(self, Handle view, dict textures) except *:
        cdef:
            ViewC *view_ptr
            size_t num_textures
            size_t i = 0
            TextureUnit unit
            Handle texture
        view_ptr = self.view_get_ptr(view)
        num_textures = len(textures)
        if num_textures > MAX_TEXTURE_UNITS:
            raise ValueError("View: cannot set more than 16 textures")
        memset(view_ptr.texture_units, 0, MAX_TEXTURE_UNITS * sizeof(int32_t))
        memset(view_ptr.textures, 0, MAX_TEXTURE_UNITS * sizeof(Handle))
        for unit in textures:
            texture = <Handle>textures[unit]
            view_ptr.texture_units[i] = unit
            view_ptr.textures[<size_t>unit] = texture
            i += 1
        view_ptr.num_texture_units = num_textures

    cpdef void view_set_frame_buffer(self, Handle view, Handle frame_buffer) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.frame_buffer = frame_buffer
    
    cdef MeshC *mesh_get_ptr(self, Handle mesh) except *:
        return <MeshC *>self.meshes.c_get_ptr(mesh)

    cpdef Handle mesh_create(self, uint8_t[:] vertex_data, uint8_t[:] index_data) except *:
        cdef:
            Handle mesh
            MeshC *mesh_ptr
            size_t vertex_data_size
            size_t index_data_size
        mesh = self.meshes.c_create()
        mesh_ptr = self.mesh_get_ptr(mesh)
        vertex_data_size = vertex_data.shape[0]
        index_data_size = index_data.shape[0]
        mesh_ptr.vertex_data = <uint8_t *>calloc(vertex_data_size, sizeof(uint8_t))
        if mesh_ptr.vertex_data == NULL:
            raise MemoryError("Mesh: cannot allocate memory for vertex data")
        memcpy(mesh_ptr.vertex_data, &vertex_data[0], vertex_data_size)
        mesh_ptr.vertex_data_size = vertex_data_size
        mesh_ptr.index_data = <uint8_t *>calloc(index_data_size, sizeof(uint8_t))
        if mesh_ptr.index_data == NULL:
            raise MemoryError("Mesh: cannot allocate memory for index data")
        memcpy(mesh_ptr.index_data, &index_data[0], index_data_size)
        mesh_ptr.index_data_size = index_data_size
        return mesh
    
    cpdef Handle mesh_create_from_file(self, bytes file_path) except *:
        cdef:
            aiScene *ai_scene
            str error_str
            Handle mesh
            MeshC *mesh_ptr
            aiMesh *ai_mesh
            Vec3C *positions
            Vec3C *tex_coords#assimp uses Vec3 instead of Vec2
            Vec3C *normals
            Vec2C empty_tex_coord = Vec2C(0.0, 0.0)
            size_t num_vertices
            size_t vertex_data_size
            uint8_t *vertex_data
            size_t i
            uint8_t *dst_ptr
            size_t p_size = sizeof(Vec3C)
            size_t pt_size = p_size + sizeof(Vec2C)
            size_t ptn_size = pt_size + sizeof(Vec3C)
            size_t f_size = 3 * sizeof(uint32_t)
            size_t num_faces
            size_t num_indices
            size_t index_data_size
            uint8_t *index_data
            aiFace *ai_faces

        ai_scene = aiImportFile(file_path, 
            aiProcess_CalcTangentSpace | 
            aiProcess_GenNormals | #generates normals if not present in mesh file
            aiProcess_Triangulate |
            aiProcess_JoinIdenticalVertices |
            aiProcess_SortByPType,
        )
        if ai_scene == NULL:
            error_str = aiGetErrorString().decode("utf-8")
            raise ValueError("Mesh: assimp loader error message below:\n{0}".format(error_str))
        if ai_scene.mNumMeshes == 0:
            raise ValueError("Mesh: no meshes present in file")
        if ai_scene.mNumMeshes > 1:
            raise ValueError("Mesh: multiple mesh import not supported")
        mesh = self.meshes.c_create()
        mesh_ptr = self.mesh_get_ptr(mesh)
        ai_mesh = ai_scene.mMeshes[0]

        #get vertex data (interleaved)
        num_vertices = ai_mesh.mNumVertices
        vertex_data_size = num_vertices * ptn_size
        vertex_data = <uint8_t *>calloc(vertex_data_size, sizeof(uint8_t))
        if vertex_data == NULL:
            raise MemoryError("Mesh: cannot allocate memory for vertex data")

        positions = ai_mesh.mVertices
        tex_coords = ai_mesh.mTextureCoords[0]#takes only first channel of tex_coords
        normals = ai_mesh.mNormals
        
        if tex_coords == NULL:
            for i in range(num_vertices):
                dst_ptr = &vertex_data[i * ptn_size]
                memcpy(dst_ptr, &positions[i], sizeof(Vec3C))
                memcpy(dst_ptr + p_size, &empty_tex_coord, sizeof(Vec2C))
                memcpy(dst_ptr + pt_size, &normals[i], sizeof(Vec3C))
        else:
            for i in range(num_vertices):
                dst_ptr = &vertex_data[i * ptn_size]
                memcpy(dst_ptr, &positions[i], sizeof(Vec3C))
                memcpy(dst_ptr + p_size, &tex_coords[i], sizeof(Vec2C))
                memcpy(dst_ptr + pt_size, &normals[i], sizeof(Vec3C))
        mesh_ptr.vertex_data = vertex_data
        mesh_ptr.vertex_data_size = vertex_data_size

        #get index data
        ai_faces = ai_mesh.mFaces
        num_faces = ai_mesh.mNumFaces
        index_data_size = num_faces * f_size
        index_data = <uint8_t *>calloc(index_data_size, sizeof(uint8_t))
        if index_data == NULL:
            raise MemoryError("Mesh: cannot allocate memory for index data")
        for i in range(num_faces):
            memcpy(index_data + (i * f_size), ai_faces[i].mIndices, f_size)
        mesh_ptr.index_data = index_data
        mesh_ptr.index_data_size = index_data_size

        aiReleaseImport(ai_scene)
        return mesh

    cpdef void mesh_delete(self, Handle mesh) except *:
        cdef:
            MeshC *mesh_ptr
        mesh_ptr = self.mesh_get_ptr(mesh)
        free(mesh_ptr.vertex_data)
        free(mesh_ptr.index_data)
        self.meshes.c_delete(mesh)

    cdef MeshBatchC *mesh_batch_get_ptr(self, Handle batch) except *:
        return <MeshBatchC *>self.mesh_batches.c_get_ptr(batch)

    cpdef Handle mesh_batch_create(self) except *:
        cdef:
            Handle batch
            MeshBatchC *batch_ptr

        batch = self.mesh_batches.c_create()
        batch_ptr = self.mesh_batch_get_ptr(batch)
        batch_ptr.vertex_buffer = self.vertex_buffer_create(self.v_fmt_mesh)
        batch_ptr.index_buffer = self.index_buffer_create(self.i_fmt_mesh)
        return batch

    cpdef void mesh_batch_delete(self, Handle batch) except *:
        self.mesh_batches.c_delete(batch)

    cpdef void mesh_batch_set_meshes(self, Handle batch, uint64_t[:] meshes) except *:
        cdef:
            MeshBatchC *batch_ptr
            
        batch_ptr = self.mesh_batch_get_ptr(batch)
        if meshes.shape[0] > 65535:
            raise ValueError("MeshBatch: > 65535 meshes not supported")
        batch_ptr.num_meshes = meshes.shape[0]
        memcpy(batch_ptr.meshes, &meshes[0], sizeof(Handle) * batch_ptr.num_meshes)

    cpdef Handle mesh_batch_get_vertex_buffer(self, Handle batch) except *:
        cdef MeshBatchC *batch_ptr
        batch_ptr = self.mesh_batch_get_ptr(batch)
        return batch_ptr.vertex_buffer

    cpdef Handle mesh_batch_get_index_buffer(self, Handle batch) except *:
        cdef MeshBatchC *batch_ptr
        batch_ptr = self.mesh_batch_get_ptr(batch)
        return batch_ptr.index_buffer

    cdef void _mesh_batch_update(self, Handle batch) except *:
        pass
        """
        cdef:
            SpriteBatchC *batch_ptr
            SpriteC *sprite_ptr
            size_t i, j, index
            Vec4C[6] vertex_tex_coord
            VertexFormatC *v_fmt_ptr
            uint8_t *vbo
            uint8_t *ibo
            size_t vbo_size, ibo_size
            uint8_t *vbo_index
            uint8_t *ibo_index
            
        vertex_tex_coord = [
            Vec4C(0.0, 0.0, 0.0, 0.0),
            Vec4C(1.0, 0.0, 1.0, 0.0),
            Vec4C(0.0, 1.0, 0.0, 1.0),
            Vec4C(0.0, 1.0, 0.0, 1.0),
            Vec4C(1.0, 0.0, 1.0, 0.0),
            Vec4C(1.0, 1.0, 1.0, 1.0),
        ]
        v_fmt_ptr = self.vertex_format_get_ptr(self.v_fmt_sprite)
        batch_ptr = self.sprite_batch_get_ptr(batch)
        vbo_size = v_fmt_ptr.stride * 6 * batch_ptr.num_sprites
        ibo_size = 6 * batch_ptr.num_sprites * sizeof(uint32_t)
        vbo = <uint8_t *>calloc(1, vbo_size)
        if vbo == NULL:
            raise MemoryError("SpriteBatch: cannot allocate temporary vertex buffer memory")
        ibo = <uint8_t *>calloc(1, ibo_size)
        if ibo == NULL:
            raise MemoryError("SpriteBatch: cannot allocate temporary index buffer memory")
        for i in range(batch_ptr.num_sprites):
            sprite_ptr = self.sprite_get_ptr(batch_ptr.sprites[i])
            for j in range(6):
                index = 6 * i + j
                vbo_index = vbo + (index * v_fmt_ptr.stride)
                memcpy(vbo_index + 0, &vertex_tex_coord[j], sizeof(Vec4C))
                memcpy(vbo_index + sizeof(Vec4C), &sprite_ptr.position, sizeof(Vec2C))
                memcpy(vbo_index + sizeof(Vec4C) + sizeof(Vec2C), &sprite_ptr.z_index, sizeof(float))
                memcpy(vbo_index + sizeof(Vec4C) + sizeof(Vec3C), &sprite_ptr.rotation, sizeof(float))
                memcpy(vbo_index + (2 * sizeof(Vec4C)), &sprite_ptr.width, sizeof(float))
                memcpy(vbo_index + (2 * sizeof(Vec4C)) + sizeof(float), &sprite_ptr.height, sizeof(float))
                memcpy(vbo_index + (2 * sizeof(Vec4C)) + sizeof(Vec2C), &sprite_ptr.scale, sizeof(Vec2C))
                memcpy(vbo_index + (3 * sizeof(Vec4C)), &sprite_ptr.tint, sizeof(Vec3C))
                memcpy(vbo_index + (3 * sizeof(Vec4C)) + sizeof(Vec3C), &sprite_ptr.alpha, sizeof(float))
                memcpy(vbo_index + (4 * sizeof(Vec4C)), &sprite_ptr.anchor, sizeof(Vec2C))
                ibo_index = ibo + (index * sizeof(uint32_t))
                memcpy(ibo_index, &index, sizeof(uint32_t))
        self.vertex_buffer_set_data(batch_ptr.vertex_buffer, <uint8_t[:vbo_size]>vbo)
        self.index_buffer_set_data(batch_ptr.index_buffer, <uint8_t[:ibo_size]>ibo)
        #import numpy as np
        #print(np.array(<uint8_t[:vbo_size]>vbo))
        free(vbo)
        free(ibo)
        """

    cdef SpriteC *sprite_get_ptr(self, Handle sprite) except *:
        return <SpriteC *>self.sprites.c_get_ptr(sprite)

    cpdef Handle sprite_create(self, float width, float height) except *:
        cdef:
            Handle sprite
            SpriteC *sprite_ptr
            float[12] tex_coords

        tex_coords = [
            0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 
            0.0, 1.0, 1.0, 0.0, 1.0, 1.0,
        ]
        sprite = self.sprites.c_create()
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.width = width
        sprite_ptr.height = height
        sprite_ptr.tex_coords = tex_coords
        sprite_ptr.position = Vec2C(0.0, 0.0)
        sprite_ptr.rotation = 0.0
        sprite_ptr.scale = Vec2C(1.0, 1.0)
        sprite_ptr.z_index = 0.0
        sprite_ptr.visible = True
        sprite_ptr.tint = Vec3C(1.0, 1.0, 1.0)
        sprite_ptr.alpha = 1.0
        return sprite

    cpdef void sprite_delete(self, Handle sprite) except *:
        self.sprites.c_delete(sprite)

    cpdef void sprite_set_tex_coords(self, Handle sprite, float[:] tex_coords) except *:
        cdef:
            SpriteC *sprite_ptr
            float *tex_coords_ptr

        if tex_coords.shape[0] != 12:
            raise ValueError("Sprite: tex coords array is invalid length")    
        sprite_ptr = self.sprite_get_ptr(sprite)
        tex_coords_ptr = &tex_coords[0]
        memcpy(sprite_ptr.tex_coords, tex_coords_ptr, sizeof(float) * 12)

    cpdef void sprite_set_tex_coords_from_rect(self, Handle sprite, Vec4 rect) except *:
        cdef:
            SpriteC *sprite_ptr
            float *tex_coords_ptr
            Vec4C *rect_ptr

        rect_ptr = &rect.data  
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.tex_coords = [
            rect_ptr.x, rect_ptr.y,
            rect_ptr.z, rect_ptr.y,
            rect_ptr.x, rect_ptr.w,
            rect_ptr.x, rect_ptr.w,
            rect_ptr.z, rect_ptr.y,
            rect_ptr.z, rect_ptr.w,
        ]

    cpdef void sprite_set_position(self, Handle sprite, Vec2 position) except *:
        cdef SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.position = position.data

    cpdef void sprite_set_anchor(self, Handle sprite, Vec2 anchor) except *:
        cdef SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.anchor = anchor.data

    cpdef void sprite_set_rotation(self, Handle sprite, float rotation) except *:
        cdef SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.rotation = rotation

    cpdef void sprite_set_scale(self, Handle sprite, Vec2 scale) except *:
        cdef SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.scale = scale.data

    cpdef void sprite_set_z_index(self, Handle sprite, float z_index) except *:
        cdef SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.z_index = z_index

    cpdef void sprite_set_visible(self, Handle sprite, bint visible) except *:
        cdef SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.visible = visible

    cpdef void sprite_set_tint(self, Handle sprite, Vec3 tint) except *:
        cdef SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.tint = tint.data

    cpdef void sprite_set_alpha(self, Handle sprite, float alpha) except *:
        cdef SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        sprite_ptr.alpha = alpha

    cpdef float[:] sprite_get_tex_coords(self, Handle sprite) except *:
        cdef:
            float[:] tex_coords
            SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        tex_coords = <float[:12]>sprite_ptr.tex_coords
        return tex_coords
    
    cpdef Vec2 sprite_get_position(self, Handle sprite):
        cdef:
            Vec2 position = Vec2()
            SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        position.data = sprite_ptr.position
        return position

    cpdef Vec2 sprite_get_anchor(self, Handle sprite):
        cdef:
            Vec2 anchor = Vec2()
            SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        anchor.data = sprite_ptr.anchor
        return anchor

    cpdef float sprite_get_rotation(self, Handle sprite) except *:
        cdef:
            SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        return sprite_ptr.rotation

    cpdef Vec2 sprite_get_scale(self, Handle sprite):
        cdef:
            Vec2 scale = Vec2()
            SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        scale.data = sprite_ptr.scale
        return scale

    cpdef float sprite_get_z_index(self, Handle sprite) except *:
        cdef:
            SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        return sprite_ptr.z_index

    cpdef bint sprite_get_visible(self, Handle sprite) except *:
        cdef:
            SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        return sprite_ptr.visible

    cpdef Vec3 sprite_get_tint(self, Handle sprite):
        cdef:
            Vec3 tint = Vec3()
            SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        tint.data = sprite_ptr.tint
        return tint
    
    cpdef float sprite_get_alpha(self, Handle sprite) except *:
        cdef:
            SpriteC *sprite_ptr
        sprite_ptr = self.sprite_get_ptr(sprite)
        return sprite_ptr.alpha

    cdef SpriteBatchC *sprite_batch_get_ptr(self, Handle batch) except *:
        return <SpriteBatchC *>self.sprite_batches.c_get_ptr(batch)

    cpdef Handle sprite_batch_create(self) except *:
        cdef:
            Handle batch
            SpriteBatchC *batch_ptr

        batch = self.sprite_batches.c_create()
        batch_ptr = self.sprite_batch_get_ptr(batch)
        batch_ptr.vertex_buffer = self.vertex_buffer_create(self.v_fmt_sprite)
        batch_ptr.index_buffer = self.index_buffer_create(self.i_fmt_sprite)
        return batch

    cpdef void sprite_batch_delete(self, Handle batch) except *:
        self.sprite_batches.c_delete(batch)

    cpdef void sprite_batch_set_sprites(self, Handle batch, uint64_t[:] sprites) except *:
        cdef:
            SpriteBatchC *batch_ptr
            
        batch_ptr = self.sprite_batch_get_ptr(batch)
        if sprites.shape[0] > 65535:
            raise ValueError("SpriteBatch: > 65535 sprites not supported")
        batch_ptr.num_sprites = sprites.shape[0]
        memcpy(batch_ptr.sprites, &sprites[0], sizeof(Handle) * batch_ptr.num_sprites)

    cpdef Handle sprite_batch_get_vertex_buffer(self, Handle batch) except *:
        cdef SpriteBatchC *batch_ptr
        batch_ptr = self.sprite_batch_get_ptr(batch)
        return batch_ptr.vertex_buffer

    cpdef Handle sprite_batch_get_index_buffer(self, Handle batch) except *:
        cdef SpriteBatchC *batch_ptr
        batch_ptr = self.sprite_batch_get_ptr(batch)
        return batch_ptr.index_buffer

    cdef void _sprite_batch_update(self, Handle batch) except *:
        cdef:
            SpriteBatchC *batch_ptr
            SpriteC *sprite_ptr
            size_t i, j, index
            Vec4C[6] vertex_tex_coord
            VertexFormatC *v_fmt_ptr
            uint8_t *vbo
            uint8_t *ibo
            size_t vbo_size, ibo_size
            uint8_t *vbo_index
            uint8_t *ibo_index
            
        vertex_tex_coord = [
            Vec4C(0.0, 0.0, 0.0, 0.0),
            Vec4C(1.0, 0.0, 1.0, 0.0),
            Vec4C(0.0, 1.0, 0.0, 1.0),
            Vec4C(0.0, 1.0, 0.0, 1.0),
            Vec4C(1.0, 0.0, 1.0, 0.0),
            Vec4C(1.0, 1.0, 1.0, 1.0),
        ]
        v_fmt_ptr = self.vertex_format_get_ptr(self.v_fmt_sprite)
        batch_ptr = self.sprite_batch_get_ptr(batch)
        vbo_size = v_fmt_ptr.stride * 6 * batch_ptr.num_sprites
        ibo_size = 6 * batch_ptr.num_sprites * sizeof(uint32_t)
        vbo = <uint8_t *>calloc(1, vbo_size)
        if vbo == NULL:
            raise MemoryError("SpriteBatch: cannot allocate temporary vertex buffer memory")
        ibo = <uint8_t *>calloc(1, ibo_size)
        if ibo == NULL:
            raise MemoryError("SpriteBatch: cannot allocate temporary index buffer memory")
        for i in range(batch_ptr.num_sprites):
            sprite_ptr = self.sprite_get_ptr(batch_ptr.sprites[i])
            for j in range(6):
                index = 6 * i + j
                vbo_index = vbo + (index * v_fmt_ptr.stride)
                memcpy(vbo_index + 0, &vertex_tex_coord[j], sizeof(Vec4C))
                memcpy(vbo_index + sizeof(Vec4C), &sprite_ptr.position, sizeof(Vec2C))
                memcpy(vbo_index + sizeof(Vec4C) + sizeof(Vec2C), &sprite_ptr.z_index, sizeof(float))
                memcpy(vbo_index + sizeof(Vec4C) + sizeof(Vec3C), &sprite_ptr.rotation, sizeof(float))
                memcpy(vbo_index + (2 * sizeof(Vec4C)), &sprite_ptr.width, sizeof(float))
                memcpy(vbo_index + (2 * sizeof(Vec4C)) + sizeof(float), &sprite_ptr.height, sizeof(float))
                memcpy(vbo_index + (2 * sizeof(Vec4C)) + sizeof(Vec2C), &sprite_ptr.scale, sizeof(Vec2C))
                memcpy(vbo_index + (3 * sizeof(Vec4C)), &sprite_ptr.tint, sizeof(Vec3C))
                memcpy(vbo_index + (3 * sizeof(Vec4C)) + sizeof(Vec3C), &sprite_ptr.alpha, sizeof(float))
                memcpy(vbo_index + (4 * sizeof(Vec4C)), &sprite_ptr.anchor, sizeof(Vec2C))
                ibo_index = ibo + (index * sizeof(uint32_t))
                memcpy(ibo_index, &index, sizeof(uint32_t))
        self.vertex_buffer_set_data(batch_ptr.vertex_buffer, <uint8_t[:vbo_size]>vbo)
        self.index_buffer_set_data(batch_ptr.index_buffer, <uint8_t[:ibo_size]>ibo)
        #import numpy as np
        #print(np.array(<uint8_t[:vbo_size]>vbo))
        free(vbo)
        free(ibo)
    
    cdef void _swap_root_window(self) except *:
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
            ProgramC *program_ptr
            VertexBufferC *vbo_ptr
            IndexBufferC *ibo_ptr
            TextureC *texture_ptr
            UniformC *uniform_ptr
            WindowC *window_ptr
            SpriteBatchC *sprite_batch_ptr
            size_t i

        #update sprite batches
        for i in range(self.sprite_batches.items.num_items):
            sprite_batch_ptr = <SpriteBatchC *>self.sprite_batches.items.c_get_ptr(i)
            self._sprite_batch_update(sprite_batch_ptr.handle)

        #update mesh batches
        pass

        if self.views.items.num_items > 0:
            view_ptr = <ViewC *>self.views.items.c_get_ptr(0)
            program_ptr = self.program_get_ptr(view_ptr.program)
            vbo_ptr = self.vertex_buffer_get_ptr(view_ptr.vertex_buffer)
            ibo_ptr = self.index_buffer_get_ptr(view_ptr.index_buffer)
            
            glUseProgram(program_ptr.gl_id); self.c_check_gl()
            for i in range(view_ptr.num_uniforms):
                uniform_ptr = self.uniform_get_ptr(view_ptr.uniforms[i])
                self._program_bind_uniform(program_ptr.handle, uniform_ptr.handle)

            glEnable(GL_CULL_FACE); self.c_check_gl()
            glEnable(GL_DEPTH_TEST); self.c_check_gl()
            glDepthFunc(GL_LESS); self.c_check_gl()
            glDepthMask(True); self.c_check_gl()

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

            self._program_bind_attributes(program_ptr.handle, vbo_ptr.handle)
            self._index_buffer_draw(ibo_ptr.handle)
            self._program_unbind_attributes(program_ptr.handle)
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
            self.window_render(window_ptr.handle)
        self._swap_root_window()