cdef uint32_t c_buffer_usage_to_gl(BufferUsage usage) nogil:
    if usage == BUFFER_USAGE_STATIC:
        return GL_STATIC_DRAW
    elif usage == BUFFER_USAGE_DYNAMIC:
        return GL_DYNAMIC_DRAW
    elif usage == BUFFER_USAGE_STREAM:
        return GL_STREAM_DRAW

cdef size_t c_index_format_get_size(IndexFormat format) nogil:
    if format == INDEX_FORMAT_U8: 
        return sizeof(uint8_t)
    elif format == INDEX_FORMAT_U16: 
        return sizeof(uint16_t)
    elif format == INDEX_FORMAT_U32: 
        return sizeof(uint32_t)

cdef uint32_t c_index_format_to_gl(IndexFormat format) nogil:
    if format == INDEX_FORMAT_U8:
        return GL_UNSIGNED_BYTE
    elif format == INDEX_FORMAT_U16:
        return GL_UNSIGNED_SHORT
    elif format == INDEX_FORMAT_U32:
        return GL_UNSIGNED_INT

cdef uint32_t c_shader_type_to_gl(ShaderType type) nogil:
    if type == SHADER_TYPE_VERTEX:
        return GL_VERTEX_SHADER
    elif type == SHADER_TYPE_FRAGMENT:
        return GL_FRAGMENT_SHADER

cdef uint32_t c_vertex_comp_type_to_gl(VertexCompType type) nogil:
    if type == VERTEX_COMP_TYPE_F32:
        return GL_FLOAT
    elif type == VERTEX_COMP_TYPE_I8:
        return GL_BYTE
    elif type == VERTEX_COMP_TYPE_U8:
        return GL_UNSIGNED_BYTE
    elif type == VERTEX_COMP_TYPE_I16:
        return GL_SHORT
    elif type == VERTEX_COMP_TYPE_U16:
        return GL_UNSIGNED_SHORT

cdef size_t c_vertex_comp_type_get_size(VertexCompType type) nogil:
    if type == VERTEX_COMP_TYPE_F32:
        return sizeof(float)
    elif type == VERTEX_COMP_TYPE_I8:
        return sizeof(int8_t)
    elif type == VERTEX_COMP_TYPE_U8:
        return sizeof(uint8_t)
    elif type == VERTEX_COMP_TYPE_I16:
        return sizeof(int16_t)
    elif type == VERTEX_COMP_TYPE_U16:
        return sizeof(uint16_t)

cdef uint32_t c_texture_filter_to_gl(TextureFilter filter, bint mipmaps) nogil:
    if mipmaps:
        if filter == TEXTURE_FILTER_NEAREST:
            return GL_NEAREST_MIPMAP_NEAREST
        elif filter == TEXTURE_FILTER_LINEAR:
            return GL_LINEAR_MIPMAP_LINEAR
    else:
        if filter == TEXTURE_FILTER_NEAREST:
            return GL_NEAREST
        elif filter == TEXTURE_FILTER_LINEAR:
            return GL_LINEAR

cdef uint32_t c_texture_wrap_to_gl(TextureWrap wrap) nogil:
    if wrap == TEXTURE_WRAP_REPEAT:
        return GL_REPEAT
    elif wrap == TEXTURE_WRAP_MIRRORED_REPEAT:
        return GL_MIRRORED_REPEAT
    elif wrap == TEXTURE_WRAP_CLAMP_TO_EDGE:
        return GL_CLAMP_TO_EDGE

cdef void c_image_data_flip_x(uint16_t width, uint16_t height, uint8_t *data) nogil:
    cdef:
        uint32_t *data_ptr
        size_t y
        size_t src, dst
        uint16_t left, right
    data_ptr = <uint32_t *>data
    for y in range(height):
        left = 0
        right = width - 1
        while left < right:
            src = y * width + left
            dst = y * width + right
            data_ptr[src], data_ptr[dst] = data_ptr[dst], data_ptr[src]
            left += 1
            right -= 1

cdef void c_image_data_flip_y(uint16_t width, uint16_t height, uint8_t *data) nogil:
    cdef:
        uint32_t *data_ptr
        size_t x
        size_t src, dst
        uint16_t top, bottom
    data_ptr = <uint32_t *>data
    for x in range(width):
        top = 0
        bottom = height - 1
        while top < bottom:
            src = top * width + x
            dst = bottom * width + x
            data_ptr[src], data_ptr[dst] = data_ptr[dst], data_ptr[src]
            top += 1
            bottom -= 1

cdef class GraphicsManager:

    def __cinit__(self):
        #self.root_window = SDL_CreateWindow("", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1, 1, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN)
        self.root_window = SDL_CreateWindow(
            "", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 
            800, 600, SDL_WINDOW_OPENGL,
        )
        self.root_context = SDL_GL_CreateContext(self.root_window)
        glewInit()
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)

        self.vertex_formats = ItemSlotMap(sizeof(VertexFormatC), RENDERER_ITEM_TYPE_VERTEX_FORMAT)
        self.vertex_buffers = ItemSlotMap(sizeof(VertexBufferC), RENDERER_ITEM_TYPE_VERTEX_BUFFER)
        self.index_buffers = ItemSlotMap(sizeof(IndexBufferC), RENDERER_ITEM_TYPE_INDEX_BUFFER)
        self.shaders = ItemSlotMap(sizeof(ShaderC), RENDERER_ITEM_TYPE_SHADER)
        self.programs = ItemSlotMap(sizeof(ProgramC), RENDERER_ITEM_TYPE_PROGRAM)
        self.images = ItemSlotMap(sizeof(ImageC), RENDERER_ITEM_TYPE_IMAGE)
        self.textures = ItemSlotMap(sizeof(TextureC), RENDERER_ITEM_TYPE_TEXTURE)
        self.views = ItemSlotMap(sizeof(ViewC), RENDERER_ITEM_TYPE_VIEW)

    def __dealloc__(self):
        self.vertex_formats = None
        self.vertex_buffers = None
        self.index_buffers = None
        self.shaders = None
        self.programs = None
        self.images = None
        self.textures = None
        self.views = None
        SDL_GL_DeleteContext(self.root_context)
        SDL_DestroyWindow(self.root_window)

    cdef VertexFormatC *vertex_format_get_ptr(self, Handle format) except *:
        return <VertexFormatC *>self.vertex_formats.c_get_ptr(format)

    cpdef Handle vertex_format_create(self, list comps) except *:
        cdef:
            Handle format
            VertexFormatC *format_ptr
            size_t num_comps
            size_t i
            tuple comp_tuple
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
            comp.attribute = <Attribute>comp_tuple[0]
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

    cpdef Handle vertex_buffer_create(self, Handle format, BufferUsage usage) except *:
        cdef:
            Handle buffer
            VertexBufferC *buffer_ptr
        buffer = self.vertex_buffers.c_create()
        buffer_ptr = self.vertex_buffer_get_ptr(buffer)
        glGenBuffers(1, &buffer_ptr.gl_id)
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
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id)
        gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
        glBufferData(GL_ARRAY_BUFFER, buffer_ptr.size, NULL, gl_usage)
        glBindBuffer(GL_ARRAY_BUFFER, 0)
        glDeleteBuffers(1, &buffer_ptr.gl_id)
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
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id)
        if buffer_ptr.size == data_size:#use sub data instead
            glBufferSubData(GL_ARRAY_BUFFER, 0, data_size, data_ptr)
        else:
            gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
            glBufferData(GL_ARRAY_BUFFER, data_size, data_ptr, gl_usage)
            buffer_ptr.size = data_size
        glBindBuffer(GL_ARRAY_BUFFER, 0)
        
    cpdef void vertex_buffer_set_sub_data(self, Handle buffer, uint8_t[:] data, size_t offset) except *:
        cdef:
            VertexBufferC *buffer_ptr
            size_t data_size
            uint8_t *data_ptr
        buffer_ptr = self.vertex_buffer_get_ptr(buffer)
        data_size = data.shape[0]
        data_ptr = &data[0]
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id)
        if offset + data_size > buffer_ptr.size:
            raise ValueError("VertexBuffer: attempting to write out of bounds")
        else:
            glBufferSubData(GL_ARRAY_BUFFER, 0, data_size, data_ptr)
        glBindBuffer(GL_ARRAY_BUFFER, 0)
    
    cdef IndexBufferC *index_buffer_get_ptr(self, Handle buffer) except *:
        return <IndexBufferC *>self.index_buffers.c_get_ptr(buffer)

    cpdef Handle index_buffer_create(self, IndexFormat format, BufferUsage usage) except *:
        cdef:
            Handle buffer
            IndexBufferC *buffer_ptr
        buffer = self.index_buffers.c_create()
        buffer_ptr = self.index_buffer_get_ptr(buffer)
        glGenBuffers(1, &buffer_ptr.gl_id)
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
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id)
        gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.size, NULL, gl_usage)
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
        glDeleteBuffers(1, &buffer_ptr.gl_id)
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
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id)
        if buffer_ptr.size == data_size:#use sub data instead
            glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, data_size, data_ptr)
        else:
            gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, data_size, data_ptr, gl_usage)
            buffer_ptr.size = data_size
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
        
    cpdef void index_buffer_set_sub_data(self, Handle buffer, uint8_t[:] data, size_t offset) except *:
        cdef:
            IndexBufferC *buffer_ptr
            size_t data_size
            uint8_t *data_ptr
        buffer_ptr = self.index_buffer_get_ptr(buffer)
        data_size = data.shape[0]
        data_ptr = &data[0]
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id)
        if offset + data_size > buffer_ptr.size:
            raise ValueError("IndexBuffer: attempting to write out of bounds")
        else:
            glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, data_size, data_ptr)
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)

    cdef void _index_buffer_draw(self, Handle buffer) except *:
        cdef:
            IndexBufferC *buffer_ptr
            size_t format_size
            uint32_t format_gl
        buffer_ptr = self.index_buffer_get_ptr(buffer)
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id)
        format_size = c_index_format_get_size(buffer_ptr.format)    
        format_gl = c_index_format_to_gl(buffer_ptr.format)
        glDrawElements(GL_TRIANGLES, buffer_ptr.size / format_size, format_gl, NULL)
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)

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
        gl_id = glCreateShader(gl_type)
        source_ptr = source
        source_length = len(source)
        glShaderSource(gl_id, 1, &source_ptr, <GLint*>&source_length)
        glCompileShader(gl_id)
        glGetShaderiv(gl_id, GL_COMPILE_STATUS, <GLint*>&compile_status)
        glGetShaderiv(gl_id, GL_INFO_LOG_LENGTH, <GLint*>&log_length)
        if not compile_status:
            log = <char*>malloc(log_length * sizeof(char))
            if log == NULL:
                raise MemoryError("Shader: could not allocate memory for compile error")
            glGetShaderInfoLog(gl_id, log_length, NULL, log)
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
        glDeleteShader(shader_ptr.gl_id)
        self.shaders.c_delete(shader)

    cdef ProgramC *program_get_ptr(self, Handle program) except *:
        return <ProgramC *>self.programs.c_get_ptr(program)

    cpdef Handle program_create(self, Handle vertex, Handle fragment) except *:
        cdef:
            ProgramC *program_ptr
        program = self.programs.c_create()
        program_ptr = self.program_get_ptr(program)
        program_ptr.gl_id = glCreateProgram()
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
        glDeleteProgram(program_ptr.gl_id)
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
        glAttachShader(gl_id, vertex_ptr.gl_id)
        glAttachShader(gl_id, fragment_ptr.gl_id)
        glLinkProgram(gl_id)
        glGetProgramiv(gl_id, GL_LINK_STATUS, <GLint*>&link_status)
        glGetProgramiv(gl_id, GL_INFO_LOG_LENGTH, <GLint*>&log_length)
        if not link_status:
            log = <char*>malloc(log_length * sizeof(char))
            glGetProgramInfoLog(gl_id, log_length, NULL, log)
            raise ValueError("Program: failed to compile (GL error message below)\n{0}".format(log.decode("utf-8")))

    cdef void _program_setup_attributes(self, Handle program) except *:
        print("setup attributes")
        cdef:
            ProgramC *program_ptr
            uint32_t gl_id
            size_t i
            char *a_name
            int a_loc
            int num_attributes = 0
        program_ptr = self.program_get_ptr(program)
        gl_id = program_ptr.gl_id
        program_ptr.num_attributes = 0
        for i in range(ATTRIBUTE_COUNT):
            a_name = attribute_names[i]
            a_loc = glGetAttribLocation(gl_id, a_name)
            if a_loc != -1:
                program_ptr.attributes[program_ptr.num_attributes] = <Attribute>i
                program_ptr.num_attributes += 1
                program_ptr.attribute_locations[i] = a_loc
        glGetProgramiv(gl_id, GL_ACTIVE_ATTRIBUTES, &num_attributes)
        if num_attributes != program_ptr.num_attributes:
            raise ValueError("Program: non-standard attribute names present in shader code")
        
    cdef void _program_setup_uniforms(self, Handle program) except *:
        print("setup uniforms")

    cdef void _program_bind_attributes(self, Handle program, Handle buffer) except *:
        cdef:
            ProgramC *program_ptr
            VertexBufferC *buffer_ptr
            VertexFormatC *format_ptr
            VertexCompC *comp_ptr
            size_t i
            uint32_t comp_type_gl
            size_t comp_type_size
            size_t comp_offset
            size_t a_loc
            Attribute attrib
        program_ptr = self.program_get_ptr(program)
        buffer_ptr = self.vertex_buffer_get_ptr(buffer)
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id)
        format_ptr = self.vertex_format_get_ptr(buffer_ptr.format)
        for i in range(format_ptr.count):
            comp_ptr = &format_ptr.comps[i]
            attrib = comp_ptr.attribute
            a_loc = program_ptr.attribute_locations[<size_t>attrib]
            comp_type_gl = c_vertex_comp_type_to_gl(comp_ptr.type)
            comp_type_size = c_vertex_comp_type_get_size(comp_ptr.type)
            comp_offset = comp_ptr.offset
            glVertexAttribPointer(
                a_loc,
                comp_ptr.count, 
                comp_type_gl, 
                comp_ptr.normalized, 
                format_ptr.stride,
                <void *>comp_offset,
            )
            glEnableVertexAttribArray(a_loc)
        glBindBuffer(GL_ARRAY_BUFFER, 0)

    cdef void _program_unbind_attributes(self, Handle program) except *:
        cdef:
            ProgramC *program_ptr
            size_t i
            size_t a_loc
            Attribute attrib
        program_ptr = self.program_get_ptr(program)
        for i in range(program_ptr.num_attributes):
            attrib = program_ptr.attributes[i]
            a_loc = program_ptr.attribute_locations[<size_t>attrib]
            glDisableVertexAttribArray(a_loc)

    cdef ImageC *image_get_ptr(self, Handle image) except *:
        return <ImageC *>self.images.c_get_ptr(image)

    cpdef Handle image_create(self, uint16_t width, uint16_t height, uint8_t[:] data=None) except *:
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
        image_ptr.data_size = <uint64_t>width * <uint64_t>height * 4
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

    cpdef Handle texture_create(self, bint mipmaps=True, TextureFilter filter=TEXTURE_FILTER_LINEAR, TextureWrap wrap_s=TEXTURE_WRAP_REPEAT, TextureWrap wrap_t=TEXTURE_WRAP_REPEAT) except *:
        cdef:
            Handle texture
            TextureC *texture_ptr
        texture = self.textures.c_create()
        texture_ptr = self.texture_get_ptr(texture)
        glGenTextures(1, &texture_ptr.gl_id)
        self.texture_set_parameters(texture, mipmaps, filter, wrap_s, wrap_t)
        return texture

    cpdef void texture_delete(self, Handle texture) except *:
        cdef:
            TextureC *texture_ptr
        texture_ptr = self.texture_get_ptr(texture)
        glDeleteTextures(1, &texture_ptr.gl_id)
        self.textures.c_delete(texture)
    
    cpdef void texture_set_parameters(self, Handle texture, bint mipmaps=True, TextureFilter filter=TEXTURE_FILTER_LINEAR, TextureWrap wrap_s=TEXTURE_WRAP_REPEAT, TextureWrap wrap_t=TEXTURE_WRAP_REPEAT) except *:
        cdef:
            TextureC *texture_ptr
        texture_ptr = self.texture_get_ptr(texture)
        texture_ptr.mipmaps = mipmaps
        texture_ptr.filter = filter
        texture_ptr.wrap_s = wrap_s
        texture_ptr.wrap_t = wrap_t
        glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id)
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, c_texture_wrap_to_gl(wrap_s))	
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, c_texture_wrap_to_gl(wrap_t))
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, c_texture_filter_to_gl(filter, mipmaps))
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, c_texture_filter_to_gl(filter, mipmaps))
        glBindTexture(GL_TEXTURE_2D, 0)
    
    cpdef void texture_set_image(self, Handle texture, Handle image) except *:
        cdef:
            TextureC *texture_ptr
            ImageC *image_ptr
        texture_ptr = self.texture_get_ptr(texture)
        image_ptr = self.image_get_ptr(image)
        glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id)
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, image_ptr.width, image_ptr.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_ptr.data)
        if texture_ptr.mipmaps:
            glGenerateMipmap(GL_TEXTURE_2D)
        glBindTexture(GL_TEXTURE_2D, 0)

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

    cpdef void view_set_clear_color(self, Handle view, Color color) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        view_ptr.clear_color = color.data

    cpdef void view_set_clear_depth(self, Handle view, float depth) except *: pass
    cpdef void view_set_clear_stencil(self, Handle view, uint32_t stencil) except *: pass

    cpdef void update(self) except *:
        cdef:
            ProgramC *program_ptr
            VertexBufferC *vbo_ptr
            IndexBufferC *ibo_ptr
            TextureC *texture_ptr

        program_ptr = <ProgramC *>self.programs.items.c_get_ptr(0)
        vbo_ptr = <VertexBufferC *>self.vertex_buffers.items.c_get_ptr(0)
        ibo_ptr = <IndexBufferC *>self.index_buffers.items.c_get_ptr(0)
        texture_ptr = <TextureC *>self.textures.items.c_get_ptr(0)

        glClearColor(0.2, 0.2, 0.2, 1.0)
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glViewport(0, 0, 800, 600)

        glUseProgram(program_ptr.gl_id)

        glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id)
        self._program_bind_attributes(program_ptr.handle, vbo_ptr.handle)
        self._index_buffer_draw(ibo_ptr.handle)
        self._program_unbind_attributes(program_ptr.handle)
        glBindTexture(GL_TEXTURE_2D, 0)
        glUseProgram(0)
        
        SDL_GL_SetSwapInterval(0)
        SDL_GL_SwapWindow(self.root_window)