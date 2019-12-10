cdef class GraphicsManager:
    
    def __cinit__(self):
        self.root_window = SDL_CreateWindow("", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1, 1, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN)
        self.root_context = SDL_GL_CreateContext(self.root_window)
        glewInit()
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)
        glEnable(GL_TEXTURE_2D)

        self.windows = ItemSlotMap(sizeof(WindowC), ITEM_TYPE_WINDOW)
        self.images = ItemSlotMap(sizeof(ImageC), ITEM_TYPE_IMAGE)
        self.samplers = ItemSlotMap(sizeof(SamplerC), ITEM_TYPE_SAMPLER)
        self.textures = ItemSlotMap(sizeof(TextureC), ITEM_TYPE_TEXTURE)
        self.mesh_formats = ItemSlotMap(sizeof(MeshFormatC), ITEM_TYPE_MESH_FORMAT)
        self.meshes = ItemSlotMap(sizeof(MeshC), ITEM_TYPE_MESH)
        self.mesh_batches = ItemSlotMap(sizeof(MeshBatchC), ITEM_TYPE_MESH_BATCH)
        self.shaders = ItemSlotMap(sizeof(ShaderC), ITEM_TYPE_SHADER)
        self.programs = ItemSlotMap(sizeof(ProgramC), ITEM_TYPE_PROGRAM)

    def __dealloc__(self):
        SDL_GL_DeleteContext(self.root_context)
        SDL_DestroyWindow(self.root_window)

    #Window
    def window_create(self):
        return self.windows.c_create()
    
    def window_delete(self, Handle window):
        self.windows.c_delete(window)
    
    cdef WindowC *c_window_get_ptr(self, Handle window) except *:
        return <WindowC *>self.windows.c_get_ptr(window)

    def window_init(self, Handle window, int width, int height, bytes title):
        cdef:
            WindowC *window_ptr
            SDL_Window *sdl_window
            int center = SDL_WINDOWPOS_CENTERED
            int flags = SDL_WINDOW_SHOWN | SDL_WINDOW_OPENGL
        
        window_ptr = self.c_window_get_ptr(window)
        sdl_window = SDL_CreateWindow(title, center, center, width, height, flags)
        window_ptr.id = SDL_GetWindowID(sdl_window)
        window_ptr.width = width
        window_ptr.height = height
        window_ptr.title = title
        window_ptr.title_len = len(title)

    def window_free(self, Handle window):
        cdef:
            WindowC *window_ptr
            SDL_Window *sdl_window

        window_ptr = self.c_window_get_ptr(window)
        sdl_window = SDL_GetWindowFromID(window_ptr.id)
        SDL_DestroyWindow(sdl_window)
        window_ptr.id = 0
        window_ptr.width = 0
        window_ptr.height = 0
        window_ptr.title = NULL
        window_ptr.title_len = 0

    def window_clear(self):
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT)

    def window_bind(self, Handle window):
        cdef:
            WindowC *window_ptr
            SDL_Window *sdl_window

        window_ptr = self.c_window_get_ptr(window)
        sdl_window = SDL_GetWindowFromID(window_ptr.id)
        SDL_GL_MakeCurrent(sdl_window, self.root_context)
        glViewport(0, 0, window_ptr.width, window_ptr.height)
    
    def window_unbind(self):
        SDL_GL_MakeCurrent(self.root_window, self.root_context)
        glViewport(0, 0, 1, 1)
    
    def window_swap_buffers(self, Handle window):
        cdef:
            WindowC *window_ptr
            SDL_Window *sdl_window

        window_ptr = self.c_window_get_ptr(window)
        sdl_window = SDL_GetWindowFromID(window_ptr.id)
        SDL_GL_SetSwapInterval(0)
        SDL_GL_SwapWindow(sdl_window)

    #Image
    def image_create(self):
        return self.images.c_create()
    
    def image_delete(self, Handle image):
        self.images.c_delete(image)
    
    cdef ImageC *c_image_get_ptr(self, Handle image) except *:
        return <ImageC *>self.images.c_get_ptr(image)
    
    def image_init(self, Handle image, int width, int height):
        cdef ImageC *image_ptr
        image_ptr = self.c_image_get_ptr(image)
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.pixels = <uint8_t *>calloc(height * width * 4, sizeof(uint8_t))

    def image_init_from_file(self, Handle image, bytes file_path):
        cdef ImageC *image_ptr
        image_ptr = self.c_image_get_ptr(image)
        surface = IMG_Load(file_path)
        if surface == NULL:
            raise ValueError("Image: cannot load file")
        converted_surface = SDL_ConvertSurfaceFormat(surface, SDL_PIXELFORMAT_ABGR8888, 0)
        if converted_surface == NULL:
            SDL_FreeSurface(surface)#free the surface at this exit point
            raise ValueError("Image: cannot load file")
        image_ptr.pixels = <uint8_t *>converted_surface.pixels
        image_ptr.width = converted_surface.w
        image_ptr.height = converted_surface.h
        SDL_FreeSurface(surface)
        free(converted_surface)#free the struct, not the void *pixels data!

    def image_init_from_array(self, Handle image, uint8_t[:, :, :] pixels):
        cdef ImageC *image_ptr
        image_ptr = self.c_image_get_ptr(image)
        image_ptr.width = pixels.shape[1]
        image_ptr.height = pixels.shape[0]
        image_ptr.pixels = &pixels[0, 0, 0]

    def image_free(self, Handle image):
        cdef ImageC *image_ptr
        image_ptr = self.c_image_get_ptr(image)
        image_ptr.width = 0
        image_ptr.height = 0
        free(image_ptr.pixels)
        image_ptr.pixels = NULL

    def image_get_width(self, Handle image):
        cdef ImageC *image_ptr
        image_ptr = self.c_image_get_ptr(image)
        return image_ptr.width

    def image_get_height(self, Handle image):
        cdef ImageC *image_ptr
        image_ptr = self.c_image_get_ptr(image)
        return image_ptr.height

    def image_get_pixels(self, Handle image):
        cdef:
            ImageC *image_ptr
            uint8_t[:, :, :] pixels
            int w
            int h

        image_ptr = self.c_image_get_ptr(image)
        w = image_ptr.width
        h = image_ptr.height
        pixels = <uint8_t[:h, :w, :4]>image_ptr.pixels
        return pixels

    def image_set_pixels(self, Handle image, uint8_t[:, :, :] pixels):
        cdef:
            ImageC *image_ptr
            int w
            int h

        image_ptr = self.c_image_get_ptr(image)
        w = image_ptr.width
        h = image_ptr.height
        if pixels.shape[0] != h or pixels.shape[1] != w or pixels.shape[2] != 4:
            raise ValueError("Image: invalid pixel array dimensions")
        image_ptr.pixels = &pixels[0, 0, 0]

    #Sampler
    def sampler_create(self):
        return self.samplers.c_create()
    
    def sampler_delete(self, Handle sampler):
        self.samplers.c_delete(sampler)
    
    cdef SamplerC *c_sampler_get_ptr(self, Handle sampler) except *:
        return <SamplerC *>self.samplers.c_get_ptr(sampler)

    def sampler_init(self, Handle sampler, 
            SamplerFilter mag_filter=SAMPLER_FILTER_LINEAR,
            SamplerFilter min_filter=SAMPLER_FILTER_LINEAR,
            SamplerWrap wrap_s=SAMPLER_WRAP_REPEAT,
            SamplerWrap wrap_t=SAMPLER_WRAP_REPEAT,
    ):
        cdef SamplerC *sampler_ptr
        sampler_ptr = self.c_sampler_get_ptr(sampler)
        sampler_ptr.mag_filter = mag_filter
        sampler_ptr.min_filter = min_filter
        sampler_ptr.wrap_s = wrap_s
        sampler_ptr.wrap_t = wrap_t

    def sampler_free(self, Handle sampler):
        cdef SamplerC *sampler_ptr
        sampler_ptr = self.c_sampler_get_ptr(sampler)
        sampler_ptr.mag_filter = SAMPLER_FILTER_LINEAR
        sampler_ptr.min_filter = SAMPLER_FILTER_LINEAR
        sampler_ptr.wrap_s = SAMPLER_WRAP_REPEAT
        sampler_ptr.wrap_t = SAMPLER_WRAP_REPEAT
    
    #Texture
    def texture_create(self):
        return self.textures.c_create()
    
    def texture_delete(self, Handle texture):
        self.textures.c_delete(texture)
    
    cdef TextureC *c_texture_get_ptr(self, Handle texture) except *:
        return <TextureC *>self.textures.c_get_ptr(texture)

    def texture_init(self, Handle texture, Handle sampler, Handle image):
        cdef TextureC *texture_ptr
        texture_ptr = self.c_texture_get_ptr(texture)
        glGenTextures(1, &texture_ptr.id)
        texture_ptr.sampler = sampler
        texture_ptr.image = image

    def texture_free(self, Handle texture):
        cdef TextureC *texture_ptr
        texture_ptr = self.c_texture_get_ptr(texture)
        glDeleteTextures(1, &texture_ptr.id)
        texture_ptr.id = 0
        texture_ptr.sampler = 0
        texture_ptr.image = 0
    
    def texture_bind(self, Handle texture, bint upload_sampler=False, bint upload_image=False):
        cdef:
            TextureC *texture_ptr
            SamplerC *sampler_ptr
            ImageC *image_ptr

        texture_ptr = self.c_texture_get_ptr(texture)
        sampler_ptr = self.c_sampler_get_ptr(texture_ptr.sampler)
        image_ptr = self.c_image_get_ptr(texture_ptr.image)

        glBindTexture(GL_TEXTURE_2D, texture_ptr.id)
        if upload_sampler:
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, sampler_ptr.mag_filter)
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, sampler_ptr.min_filter)
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, sampler_ptr.wrap_s)
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, sampler_ptr.wrap_t)
        if upload_image:
            glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image_ptr.width, image_ptr.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_ptr.pixels)
    
    def texture_unbind(self):
        glBindTexture(GL_TEXTURE_2D, 0)

    #MeshFormat
    def mesh_format_create(self):
        return self.mesh_formats.c_create()
    
    def mesh_format_delete(self, Handle mesh_format):
        self.mesh_formats.c_delete(mesh_format)
    
    cdef MeshFormatC *c_mesh_format_get_ptr(self, Handle mesh_format) except *:
        return <MeshFormatC *>self.mesh_formats.c_get_ptr(mesh_format)

    def mesh_format_init(self, Handle mesh_format, list mesh_format_info):
        cdef:
            MeshFormatC *mesh_format_ptr
            size_t i
            size_t index
            bytes name
            MathType type
            AttributeC *info
            size_t num_attributes
            ItemHashMap attribute_map
            size_t offset = 0

        attribute_map = ItemHashMap()
        mesh_format_ptr = self.c_mesh_format_get_ptr(mesh_format)
        mesh_format_ptr.stride = 0
        num_attributes = len(mesh_format_info)
        if num_attributes > 16:
            raise ValueError("MeshFormat: Only up to 16 attribute are supported")
        for i in range(num_attributes):
            index, name, type = mesh_format_info[i]
            info = &mesh_format_ptr.attribute_info[i]
            info.index = index
            info.type = type
            if info.type == MATH_TYPE_FLOAT: info.size = 1 * sizeof(float)
            elif info.type == MATH_TYPE_VEC2: info.size = 2 * sizeof(float)
            elif info.type == MATH_TYPE_VEC3: info.size = 3 * sizeof(float)
            elif info.type == MATH_TYPE_VEC4: info.size = 4 * sizeof(float)
            elif info.type == MATH_TYPE_MAT2: info.size = 4 * sizeof(float)
            elif info.type == MATH_TYPE_MAT3: info.size = 9 * sizeof(float)
            elif info.type == MATH_TYPE_MAT4: info.size = 16 * sizeof(float)
            else: raise ValueError("MeshFormat: invalid attribute type")
            info.offset = offset
            offset += info.size
            attribute_map.c_append(name, i)
        mesh_format_ptr.stride = offset
        mesh_format_ptr.attribute_map = <PyObject *>attribute_map
        Py_XINCREF(mesh_format_ptr.attribute_map)
        mesh_format_ptr.num_attributes = num_attributes
    
    def mesh_format_free(self, Handle mesh_format):
        cdef MeshFormatC *mesh_format_ptr
        mesh_format_ptr = self.c_mesh_format_get_ptr(mesh_format)
        Py_XDECREF(mesh_format_ptr.attribute_map)
        mesh_format_ptr.attribute_map = NULL

    #Mesh
    def mesh_create(self):
        return self.meshes.c_create()
    
    def mesh_delete(self, Handle mesh):
        self.meshes.c_delete(mesh)
    
    cdef MeshC *c_mesh_get_ptr(self, Handle mesh) except *:
        return <MeshC *>self.meshes.c_get_ptr(mesh)

    def mesh_init(self, Handle mesh, Handle format):
        cdef:
            MeshC *mesh_ptr

        mesh_ptr = self.c_mesh_get_ptr(mesh)
        mesh_ptr.format = format
    
    def mesh_free(self, Handle mesh):
        cdef:
            MeshC *mesh_ptr
        
        mesh_ptr = self.c_mesh_get_ptr(mesh)
        mesh_ptr.format = 0

    def mesh_set_data(self, Handle mesh, float[:] data):
        cdef MeshC *mesh_ptr
        mesh_ptr = self.c_mesh_get_ptr(mesh)
        mesh_ptr.data = &data[0]
        mesh_ptr.length = data.shape[0]

    #MeshBatch
    def mesh_batch_create(self):
        return self.mesh_batches.c_create()
    
    def mesh_batch_delete(self, Handle mesh_batch):
        self.mesh_batches.c_delete(mesh_batch)
    
    cdef MeshBatchC *c_mesh_batch_get_ptr(self, Handle mesh_batch) except *:
        return <MeshBatchC *>self.mesh_batches.c_get_ptr(mesh_batch)

    def mesh_batch_init(self, Handle mesh_batch, Handle mesh_format, Handle[:] meshes):
        cdef:
            MeshBatchC *mesh_batch_ptr
            MeshFormatC *mesh_format_ptr
            MeshC *mesh_ptr
            AttributeC *info
            size_t i, j, k
            size_t stride
            size_t offset

        mesh_batch_ptr = self.c_mesh_batch_get_ptr(mesh_batch)
        glGenVertexArrays(1, &mesh_batch_ptr.vao_id)
        glGenBuffers(1, &mesh_batch_ptr.vbo_id)
        mesh_batch_ptr.format = mesh_format
        mesh_batch_ptr.meshes = &meshes[0]
        mesh_batch_ptr.num_meshes = meshes.shape[0]
        mesh_format_ptr = self.c_mesh_format_get_ptr(mesh_format)

        #Reset cumulative lengths per MeshBatch attribute data
        for i in range(16):
            mesh_batch_ptr.length = 0

        #Accumulate meshes together into single array of data
        #Also validate that each mesh's format matches the batch's format
        for i in range(mesh_batch_ptr.num_meshes):
            mesh_ptr = self.c_mesh_get_ptr(meshes[i])
            if mesh_ptr.format != mesh_format:
                raise ValueError("MeshBatch: Mesh has wrong MeshFormat")
            mesh_batch_ptr.length += mesh_ptr.length
        
        #Allocate contiguous memory storing all attibutes
        #Fill this buffer with interleaved attribute data (since mesh data is already interleaved)
        mesh_batch_ptr.data = <float *>malloc(mesh_batch_ptr.length * sizeof(float))
        j = 0
        for i in range(mesh_batch_ptr.num_meshes):
            mesh_ptr = self.c_mesh_get_ptr(meshes[i])
            memcpy(
                &mesh_batch_ptr.data[j],
                mesh_ptr.data, 
                mesh_ptr.length * sizeof(float),
            )
            j += mesh_ptr.length

        #Fill the batch's single vbo with the interleaved data
        #Bind each attribute for the corresponding vao (matching format)
        glBindVertexArray(mesh_batch_ptr.vao_id)
        glBindBuffer(GL_ARRAY_BUFFER, mesh_batch_ptr.vbo_id)
        glBufferData(
            GL_ARRAY_BUFFER, 
            mesh_batch_ptr.length * sizeof(float), 
            mesh_batch_ptr.data, 
            GL_STATIC_DRAW,
        )
        stride = mesh_format_ptr.stride
        for i in range(mesh_format_ptr.num_attributes):
            info = &mesh_format_ptr.attribute_info[i]
            offset = info.offset
            if info.type == MATH_TYPE_VEC2:
                glVertexAttribPointer(info.index, 2, GL_FLOAT, False, stride, <void *>offset)
            elif info.type == MATH_TYPE_VEC3:
                glVertexAttribPointer(info.index, 3, GL_FLOAT, False, stride, <void *>offset)
            elif info.type == MATH_TYPE_VEC4:
                glVertexAttribPointer(info.index, 4, GL_FLOAT, False, stride, <void *>offset)
            glEnableVertexAttribArray(info.index)
        glBindBuffer(GL_ARRAY_BUFFER, 0)
        glBindVertexArray(0)

    def mesh_batch_free(self, Handle mesh_batch):
        cdef MeshBatchC *mesh_batch_ptr
        mesh_batch_ptr = self.c_mesh_batch_get_ptr(mesh_batch)
        glDeleteVertexArrays(1, &mesh_batch_ptr.vao_id)
        mesh_batch_ptr.vao_id = 0
        glDeleteBuffers(1, &mesh_batch_ptr.vbo_id)
        mesh_batch_ptr.vbo_id = 0

    def mesh_batch_render(self, Handle mesh_batch):
        cdef MeshBatchC *mesh_batch_ptr
        mesh_batch_ptr = self.c_mesh_batch_get_ptr(mesh_batch)
        glBindVertexArray(mesh_batch_ptr.vao_id)
        glDrawArrays(GL_TRIANGLES, 0, mesh_batch_ptr.length / 5)
        glBindVertexArray(0)

    #Shader
    def shader_create(self):
        return self.shaders.c_create()
    
    def shader_delete(self, Handle shader):
        self.shaders.c_delete(shader)
    
    cdef ShaderC *c_shader_get_ptr(self, Handle shader) except *:
        return <ShaderC *>self.shaders.c_get_ptr(shader)

    def shader_init(self, Handle shader, ShaderType type, bytes source):
        cdef ShaderC *shader_ptr
        shader_ptr = self.c_shader_get_ptr(shader)

        if type == SHADER_TYPE_VERTEX:
            shader_ptr.id = glCreateShader(GL_VERTEX_SHADER)
        elif type == SHADER_TYPE_FRAGMENT:
            shader_ptr.id = glCreateShader(GL_FRAGMENT_SHADER)
        else:
            raise ValueError("Shader: invalid type")
        shader_ptr.type = type
        shader_ptr.source = source
        shader_ptr.source_length = len(source)
    
    def shader_free(self, Handle shader):
        cdef ShaderC *shader_ptr
        shader_ptr = self.c_shader_get_ptr(shader)
        glDeleteShader(shader_ptr.id)
        shader_ptr.id = 0

    def shader_compile(self, Handle shader):
        cdef:
            ShaderC *shader_ptr
            uint32_t gl_id
            uint32_t compile_status
            char *log
            int log_length

        shader_ptr = self.c_shader_get_ptr(shader)
        gl_id = shader_ptr.id
        glShaderSource(gl_id, 1, &shader_ptr.source, <GLint*>&shader_ptr.source_length)
        glCompileShader(gl_id)
        glGetShaderiv(gl_id, GL_COMPILE_STATUS, <GLint*>&compile_status)
        glGetShaderiv(gl_id, GL_INFO_LOG_LENGTH, <GLint*>&log_length)
        if not compile_status:
            log = <char*>malloc(log_length * sizeof(char))
            if log == NULL:
                raise MemoryError("Shader: could not allocate memory for compile error")
            glGetShaderInfoLog(gl_id, log_length, NULL, log)
            raise ValueError("Shader: failed to compile:\n{0}".format(log))

    #Program
    def program_create(self):
        return self.programs.c_create()
    
    def program_delete(self, Handle program):
        self.programs.c_delete(program)
    
    cdef ProgramC *c_program_get_ptr(self, Handle program) except *:
        return <ProgramC *>self.programs.c_get_ptr(program)

    def program_init(self, Handle program, Handle vs, Handle fs):
        cdef ProgramC *program_ptr
        program_ptr = self.c_program_get_ptr(program)
        program_ptr.id = glCreateProgram()
        program_ptr.vs = vs
        program_ptr.fs = fs
    
    def program_free(self, Handle program):
        cdef ProgramC *program_ptr
        program_ptr = self.c_program_get_ptr(program)
        glDeleteProgram(program_ptr.id)
        program_ptr.id = 0

    def program_bind(self, Handle program):
        cdef ProgramC *program_ptr
        program_ptr = self.c_program_get_ptr(program)
        glUseProgram(program_ptr.id)

    def program_unbind(self):
        glUseProgram(0)
    
    def program_compile(self, Handle program):
        cdef:
            ProgramC *program_ptr
            ShaderC *vs
            ShaderC *fs
            uint32_t gl_id
            uint32_t link_status
            char *log
            int log_length

            int max_u_name_length
            int u_name_length
            int u_size
            size_t i
            GLenum u_type
            char *u_name
            UniformC *info
            ItemHashMap uniform_map

        #Compile OpenGL program object
        program_ptr = self.c_program_get_ptr(program)
        gl_id = program_ptr.id
        vs = self.c_shader_get_ptr(program_ptr.vs)
        fs = self.c_shader_get_ptr(program_ptr.fs)
        glAttachShader(gl_id, vs.id)
        glAttachShader(gl_id, fs.id)
        glLinkProgram(gl_id)
        glGetProgramiv(gl_id, GL_LINK_STATUS, <GLint*>&link_status)
        glGetProgramiv(gl_id, GL_INFO_LOG_LENGTH, <GLint*>&log_length)
        if not link_status:
            log = <char*>malloc(log_length * sizeof(char))
            glGetProgramInfoLog(gl_id, log_length, NULL, log)
            raise ValueError("Program: failed to compile:\n{0}".format(log))

        #Setup uniform dict mapping
        uniform_map = ItemHashMap()
        glGetProgramiv(program_ptr.id, GL_ACTIVE_UNIFORMS, <int *>&program_ptr.num_uniforms)
        glGetProgramiv(program_ptr.id, GL_ACTIVE_UNIFORM_MAX_LENGTH, &max_u_name_length)
        #print("max_len", max_u_name_length)
        if program_ptr.num_uniforms > 16:
            raise ValueError("Program: > 16 uniforms is not supported")
        for i in range(program_ptr.num_uniforms):
            u_name = <char *>calloc(max_u_name_length, sizeof(char))
            if u_name == NULL:
                raise MemoryError("Program: cannot allocate uniform name")
            glGetActiveUniform(program_ptr.id, i, max_u_name_length, &u_name_length, &u_size, &u_type, u_name);
            info = &program_ptr.uniform_info[i]
            info.index = glGetUniformLocation(program_ptr.id, u_name)
            info.type = <MathType>u_type
            info.size = u_size
            uniform_map.c_append(u_name, i)
        program_ptr.uniform_map = <PyObject *>uniform_map
        Py_XINCREF(program_ptr.uniform_map)#TODO: need decompile decref equivalent
    
    def program_set_uniform(self, Handle program, bytes name, value):
        cdef:
            ProgramC *program_ptr
            size_t i
            UniformC *info
            uint32_t type
            PairC *pair
        
        program_ptr = self.c_program_get_ptr(program)
        i = (<ItemHashMap>program_ptr.uniform_map).c_get(name)
        info = &program_ptr.uniform_info[i]
        if info.type == MATH_TYPE_FLOAT:
            glUniform1f(info.index, <float>value)
        elif info.type == MATH_TYPE_VEC2:
            glUniform2fv(info.index, 1, <float *>(<Vec2>value).ptr)
        elif info.type == MATH_TYPE_VEC3:
            glUniform3fv(info.index, 1, <float *>(<Vec3>value).ptr)
        elif info.type == MATH_TYPE_VEC4:
            glUniform4fv(info.index, 1, <float *>(<Vec4>value).ptr)
        elif info.type == MATH_TYPE_MAT2:
            glUniformMatrix2fv(info.index, 1, False, <float *>(<Mat2>value).ptr)
        elif info.type == MATH_TYPE_MAT3:
            glUniformMatrix3fv(info.index, 1, False, <float *>(<Mat3>value).ptr)
        elif info.type == MATH_TYPE_MAT4:
            glUniformMatrix4fv(info.index, 1, False, <float *>(<Mat4>value).ptr)