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
        self.quad_vs = self.shader_create_from_file(SHADER_TYPE_VERTEX, b"./resources/shaders/quad.vert")
        self.quad_fs = self.shader_create_from_file(SHADER_TYPE_FRAGMENT, b"./resources/shaders/quad.frag")
        self.quad_program = self.program_create(self.quad_vs, self.quad_fs)
        self.u_quad = self.uniform_create(self.u_fmt_quad)
        self.uniform_set_data(self.u_quad, TEXTURE_UNIT_0)

    cdef void c_delete_quad(self) except *:
        self.quad_vbo.delete(); self.quad_vbo = None
        self.index_buffer_delete(self.quad_ibo)
        self.shader_delete(self.quad_vs)
        self.shader_delete(self.quad_fs)
        self.program_delete(self.quad_program)
        self.uniform_delete(self.u_quad)

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

    cpdef Handle image_create(self, uint16_t width, uint16_t height, uint8_t[::1] data=None, size_t bytes_per_channel=1, size_t num_channels=4) except *:
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
            uint8_t[::1] data
        surface = IMG_Load(file_path)
        if surface == NULL:
            print(IMG_GetError())
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

    cpdef void image_set_data(self, Handle image, uint8_t[::1] data=None) except *:
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

    cpdef uint8_t[::1] image_get_data(self, Handle image) except *:
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
        view_ptr.clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH | VIEW_CLEAR_STENCIL
        view_ptr.clear_color = Vec4C(0.0, 0.0, 0.0, 1.0)
        view_ptr.clear_depth = 1.0
        view_ptr.clear_stencil = 0
        view_ptr.rect = (0, 0, 1, 1)
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

    cpdef void view_set_uniforms(self, Handle view, Handle[::1] uniforms) except *:
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

    cpdef Handle mesh_create(self, uint8_t[::1] vertex_data, uint8_t[::1] index_data) except *:
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
            VertexBuffer vbo = VertexBuffer(self)
            IndexBuffer ibo = IndexBuffer(self)
            Handle batch
            MeshBatchC *batch_ptr

        batch = self.mesh_batches.c_create()
        batch_ptr = self.mesh_batch_get_ptr(batch)
        vbo.create(self.v_fmt_mesh)
        batch_ptr.vertex_buffer = vbo.handle
        ibo.create(self.i_fmt_mesh)
        batch_ptr.index_buffer = ibo.handle
        return batch

    cpdef void mesh_batch_delete(self, Handle batch) except *:
        self.mesh_batches.c_delete(batch)

    cpdef void mesh_batch_set_meshes(self, Handle batch, Handle[::1] meshes) except *:
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
        free(vbo)
        free(ibo)
        """

    cdef SpriteC *sprite_get_ptr(self, Handle sprite) except *:
        return <SpriteC *>self.sprites.c_get_ptr(sprite)

    cdef SpriteBatchC *sprite_batch_get_ptr(self, Handle batch) except *:
        return <SpriteBatchC *>self.sprite_batches.c_get_ptr(batch)

    cpdef Handle sprite_batch_create(self) except *:
        cdef Handle batch = self.sprite_batches.c_create()
        return batch

    cpdef void sprite_batch_delete(self, Handle batch) except *:
        cdef:
            SpriteBatchC *batch_ptr
        batch_ptr = self.sprite_batch_get_ptr(batch)
        free(batch_ptr.sprites)
        free(batch_ptr.vertex_data_ptr)
        free(batch_ptr.index_data_ptr)
        self.sprite_batches.c_delete(batch)

    cpdef void sprite_batch_set_sprites(self, Handle batch, Handle[::1] sprites) except *:
        cdef:
            SpriteBatchC *batch_ptr
            VertexBuffer vbo = VertexBuffer(self)
            IndexBuffer ibo = IndexBuffer(self)
            size_t num_sprites = sprites.shape[0]
            
        batch_ptr = self.sprite_batch_get_ptr(batch)
        if num_sprites != batch_ptr.num_sprites:
            #recreate sprite handles buffer
            free(batch_ptr.sprites)
            batch_ptr.sprites = <Handle *>calloc(num_sprites, sizeof(Handle))
            if batch_ptr.sprites == NULL:
                raise MemoryError("SpriteBatch: cannot allocate sprite handles")

            #recreate vertex buffer
            free(batch_ptr.vertex_data_ptr)
            vbo.create(self.v_fmt_sprite, usage=BUFFER_USAGE_DYNAMIC)
            batch_ptr.vertex_buffer = vbo.handle
            v_fmt_ptr = self.vertex_format_get_ptr(self.v_fmt_sprite.handle)
            vbo_size = v_fmt_ptr.stride * 6 * num_sprites
            batch_ptr.vertex_data_ptr = <uint8_t *>calloc(1, vbo_size)
            if batch_ptr.vertex_data_ptr == NULL:
                raise MemoryError("SpriteBatch: cannot allocate vertex data")

            #recreate index buffer
            free(batch_ptr.index_data_ptr)
            ibo.create(self.i_fmt_sprite, usage=BUFFER_USAGE_DYNAMIC)
            batch_ptr.index_buffer = ibo.handle
            ibo_size = sizeof(uint32_t) * 6 * num_sprites
            batch_ptr.index_data_ptr = <uint8_t *>calloc(1, ibo_size)
            if batch_ptr.index_data_ptr == NULL:
                raise MemoryError("SpriteBatch: cannot allocate index data")

        batch_ptr.num_sprites = num_sprites
        memcpy(batch_ptr.sprites, &sprites[0], sizeof(Handle) * num_sprites)

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
            VertexBuffer v_buffer = VertexBuffer(self)
            IndexBuffer i_buffer = IndexBuffer(self)
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
        v_fmt_ptr = self.vertex_format_get_ptr(self.v_fmt_sprite.handle)
        batch_ptr = self.sprite_batch_get_ptr(batch)
        vbo_size = v_fmt_ptr.stride * 6 * batch_ptr.num_sprites
        ibo_size = sizeof(uint32_t) * 6 * batch_ptr.num_sprites
        vbo = batch_ptr.vertex_data_ptr
        ibo = batch_ptr.index_data_ptr
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
        v_buffer.handle = batch_ptr.vertex_buffer
        v_buffer.set_data(<uint8_t[:vbo_size]>vbo)
        i_buffer.handle = batch_ptr.index_buffer
        i_buffer.set_data(<uint8_t[:ibo_size]>ibo)
    
    cdef BitmapFontC *bitmap_font_get_ptr(self, Handle font) except *:
        return <BitmapFontC *>self.bitmap_fonts.c_get_ptr(font)

    cpdef Handle bitmap_font_create_from_file(self, bytes file_path):
        cdef:
            Handle font
            BitmapFontC *font_ptr
            size_t num_pages
            size_t i
        font = self.bitmap_fonts.c_create()
        font_ptr = self.bitmap_font_get_ptr(font)
        self._bitmap_font_parse_file(font, file_path)
        num_pages = font_ptr.common.num_pages
        for i in range(num_pages):
            font_ptr.pages[i].texture = self.texture_create()
        return font

    cpdef void bitmap_font_delete(self, Handle font) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        free(font_ptr.pages)
        free(font_ptr.chars)
        free(font_ptr.kernings)
        self.bitmap_fonts.c_delete(font)

    cdef void _bitmap_font_parse_file(self, Handle font, bytes file_path) except *:
        cdef:
            BitmapFontC *font_ptr
            object in_file
            list lines
            bytes line
            list line_items
            bytes first
            bytes rest
            dict pairs
            size_t i_c = 0
            size_t i_k = 0
        
        font_ptr = self.bitmap_font_get_ptr(font)
        in_file = open(file_path, "rb")
        lines = in_file.readlines()
        for line in lines:
            line_items = line.split()
            first = line_items[0]
            rest = b" ".join(line_items[1:] + [b" "])
            pairs = self._bitmap_font_parse_pairs(rest)
            if first == b"info":
                self._bitmap_font_parse_info(font, pairs)
            elif first == b"common":
                self._bitmap_font_parse_common(font, pairs)
            elif first == b"page":
                self._bitmap_font_parse_page(font, pairs)
            elif first == b"chars":
                font_ptr.num_chars = int(pairs[b"count"])
            elif first == b"char":
                self._bitmap_font_parse_char(font, i_c, pairs)
                i_c += 1
            elif first == b"kernings":
                font_ptr.num_kernings = int(pairs[b"count"])
            elif first == b"kerning":
                self._bitmap_font_parse_kerning(font, i_k, pairs)
                i_k += 1
            else:
                raise ValueError("BitmapFont: invalid line tokens in .fnt file")

    cdef dict _bitmap_font_parse_pairs(self, bytes line):
        cdef:
            size_t i
            size_t start = 0
            size_t end = 0
            char c
            char *line_ptr = &(<char *>line)[0]
            size_t line_len = len(line)
            bint in_quotes = False
            bytes key
            bytes value
            dict out = {}

        for i in range(line_len - 1):
            c = line_ptr[i]
            if c == b" " and not in_quotes:
                end = i
                key, value = line[start:end].replace(b"\"", b"").split(b"=")
                out[key] = value
                start = end + 1
            elif c == b"\"":
                in_quotes = not in_quotes
        return out

    cdef void _bitmap_font_parse_info(self, Handle font, dict pairs) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        str_len = len(pairs[b"face"])
        if str_len > 255:
            raise ValueError("BitmapFont: face names > 255 characters are not supported")
        memcpy(font_ptr.info.face, <char *>pairs[b"face"], str_len)
        font_ptr.info.size = int(pairs[b"size"])
        font_ptr.info.bold = int(pairs[b"bold"])
        font_ptr.info.italic = int(pairs[b"italic"])
        str_len = len(pairs[b"charset"])
        if str_len > 255:
            raise ValueError("BitmapFont: charset names > 255 characters are not supported")
        memcpy(font_ptr.info.charset, <char *>pairs[b"charset"], str_len)
        font_ptr.info.unicode = int(pairs[b"unicode"])
        font_ptr.info.stretch_h = int(pairs[b"stretchH"])
        font_ptr.info.smooth = int(pairs[b"smooth"])
        font_ptr.info.aa = int(pairs[b"aa"])
        font_ptr.info.padding = [int(v) for v in pairs[b"padding"].split(b",")]
        font_ptr.info.spacing = [int(v) for v in pairs[b"spacing"].split(b",")]
        font_ptr.info.outline = int(pairs[b"outline"])

    cdef void _bitmap_font_parse_common(self, Handle font, dict pairs) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        font_ptr.common.line_height = int(pairs[b"lineHeight"])
        font_ptr.common.base = int(pairs[b"base"])
        font_ptr.common.scale_w = int(pairs[b"scaleW"])
        font_ptr.common.scale_h = int(pairs[b"scaleH"])
        font_ptr.common.num_pages = int(pairs[b"pages"])
        font_ptr.common.packed = int(pairs[b"packed"])
        font_ptr.common.alpha = int(pairs[b"alphaChnl"])
        font_ptr.common.red = int(pairs[b"redChnl"])
        font_ptr.common.green = int(pairs[b"greenChnl"])
        font_ptr.common.blue = int(pairs[b"blueChnl"])

    cdef void _bitmap_font_parse_page(self, Handle font, dict pairs) except *:
        cdef:
            BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
            size_t page_num
            size_t str_len
        
        if font_ptr.pages == NULL:
            font_ptr.pages = <BitmapFontPageC *>calloc(font_ptr.common.num_pages, sizeof(BitmapFontPageC))
            if font_ptr.pages == NULL:
                raise MemoryError("BitmapFont: cannot allocate pages")
        page_num = int(pairs[b"id"])
        font_ptr.pages[page_num].id = page_num
        str_len = len(pairs[b"file"])
        if str_len > 255:
            raise ValueError("BitmapFont: page file names > 255 characters are not supported")
        memcpy(font_ptr.pages[page_num].file_name, <char *>pairs[b"file"], str_len)

    cdef void _bitmap_font_parse_char(self, Handle font, size_t i, dict pairs) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        if font_ptr.chars == NULL:
            font_ptr.chars = <BitmapFontCharC *>calloc(font_ptr.num_chars, sizeof(BitmapFontCharC))
            if font_ptr.chars == NULL:
                raise MemoryError("BitmapFont: cannot allocate chars")
        if i >= font_ptr.num_chars:
            raise ValueError("BitmapFont: invalid char index")
        font_ptr.chars[i].id = int(pairs[b"id"])
        font_ptr.chars[i].x = int(pairs[b"x"])
        font_ptr.chars[i].y = int(pairs[b"y"])
        font_ptr.chars[i].width = int(pairs[b"width"])
        font_ptr.chars[i].height = int(pairs[b"height"])
        font_ptr.chars[i].offset_x = int(pairs[b"xoffset"])
        font_ptr.chars[i].offset_y = int(pairs[b"yoffset"])
        font_ptr.chars[i].advance_x = int(pairs[b"xadvance"])
        font_ptr.chars[i].page = int(pairs[b"page"])
        font_ptr.chars[i].channel = int(pairs[b"chnl"])

    cdef void _bitmap_font_parse_kerning(self, Handle font, size_t i, dict pairs) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        if font_ptr.kernings == NULL:
            font_ptr.kernings = <BitmapFontKerningC *>calloc(font_ptr.num_kernings, sizeof(BitmapFontKerningC))
            if font_ptr.kernings == NULL:
                raise MemoryError("BitmapFont: cannot allocate kernings")
        if i >= font_ptr.num_kernings:
            raise ValueError("BitmapFont: invalid kerning index")
        font_ptr.kernings[i].first = int(pairs[b"first"])
        font_ptr.kernings[i].second = int(pairs[b"second"])
        font_ptr.kernings[i].amount = int(pairs[b"amount"])

    cpdef Handle bitmap_font_get_page_texture(self, Handle font, size_t page_num) except *:
        cdef BitmapFontC *font_ptr = self.bitmap_font_get_ptr(font)
        if page_num >= font_ptr.common.num_pages:
            raise ValueError("BitmapFont: invalid page number")
        return font_ptr.pages[page_num].texture

    cdef TextC *text_get_ptr(self, Handle text) except *:
        return <TextC *>self.texts.c_get_ptr(text)

    cpdef Handle text_create(self, Handle font, bytes data, Vec2 position, Vec4 color) except *:
        cdef:
            Handle text
            TextC *text_ptr
        text = self.texts.c_create()
        text_ptr = self.text_get_ptr(text)
        text_ptr.font = font
        text_ptr.data_length = len(data)
        text_ptr.data = <char *>calloc(text_ptr.data_length, sizeof(char))
        if text_ptr.data == NULL:
            raise MemoryError("Text: cannot allocate character data")
        memcpy(text_ptr.data, <char *>data, text_ptr.data_length * sizeof(char))
        text_ptr.position = position.data
        text_ptr.color = color.data
        self._text_update(text)
        return text

    cpdef void text_delete(self, Handle text) except *:
        cdef TextC *text_ptr = self.text_get_ptr(text)
        free(text_ptr.data)
        self.texts.c_delete(text)

    cdef void _text_update(self, Handle text) except *:
        cdef:
            TextC *text_ptr
            BitmapFontC *font_ptr
            size_t i, j
            char *c
            BitmapFontCharC *char_ptr
            Vec2C cursor
        pass
        """
        text_ptr = self.text_get_ptr(text)
        font_ptr = self.bitmap_font_get_ptr(text_ptr.font)
        cursor = text_ptr.position
        for i in range(text_ptr.data_length):
            c = &text_ptr.data[i]
            for j in range(font_ptr.num_chars):
                char_ptr = &font_ptr.chars[j]
                if <char>char_ptr.id == c[0]:
                    print(i, chr(c[0]), char_ptr[0])
                    cursor.x += char_ptr.advance
        """
    
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
            self._sprite_batch_update(sprite_batch_ptr.handle)

        #update mesh batches
        pass

        for i in range(self.views.items.num_items):
            view_ptr = <ViewC *>self.views.items.c_get_ptr(i)
            program_ptr = self.program_get_ptr(view_ptr.program)
            vbo_ptr = self.vertex_buffer_get_ptr(view_ptr.vertex_buffer)
            ibo_ptr = self.index_buffer_get_ptr(view_ptr.index_buffer)
            
            glUseProgram(program_ptr.gl_id); self.c_check_gl()
            for i in range(view_ptr.num_uniforms):
                uniform_ptr = self.uniform_get_ptr(view_ptr.uniforms[i])
                self._program_bind_uniform(program_ptr.handle, uniform_ptr.handle)

            glEnable(GL_BLEND); self.c_check_gl()
            #glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); self.c_check_gl()#unmultiplied alpha
            glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA); self.c_check_gl()#pre-multiplied alpha
            #glEnable(GL_CULL_FACE); self.c_check_gl()
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
            ibo.handle = ibo_ptr.handle
            ibo._draw()
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
            window = Window(self)
            window.handle = window_ptr.handle
            window.render()
            #self.window_render(window_ptr.handle)
        
        self._swap_root_window()