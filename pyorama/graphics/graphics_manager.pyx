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

cdef size_t c_uniform_type_get_size(UniformType type) nogil:
    if type == UNIFORM_TYPE_INT:
        return sizeof(int32_t)
    elif type == UNIFORM_TYPE_FLOAT:
        return sizeof(float)
    elif type == UNIFORM_TYPE_VEC2:
        return sizeof(Vec2C)
    elif type == UNIFORM_TYPE_VEC3:
        return sizeof(Vec3C)
    elif type == UNIFORM_TYPE_VEC4:
        return sizeof(Vec4C)
    elif type == UNIFORM_TYPE_MAT2:
        return sizeof(Mat2C)
    elif type == UNIFORM_TYPE_MAT3:
        return sizeof(Mat3C)
    elif type == UNIFORM_TYPE_MAT4:
        return sizeof(Mat4C)

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



cdef AttributeType c_attribute_type_from_gl(uint32_t gl_type) except *:
    if gl_type == GL_INT:
        return ATTRIBUTE_TYPE_INT
    elif gl_type == GL_FLOAT:
        return ATTRIBUTE_TYPE_FLOAT
    elif gl_type == GL_FLOAT_VEC2:
        return ATTRIBUTE_TYPE_VEC2
    elif gl_type == GL_FLOAT_VEC3:
        return ATTRIBUTE_TYPE_VEC3
    elif gl_type == GL_FLOAT_VEC4:
        return ATTRIBUTE_TYPE_VEC4
    elif gl_type == GL_FLOAT_MAT2:
        return ATTRIBUTE_TYPE_MAT2
    elif gl_type == GL_FLOAT_MAT3:
        return ATTRIBUTE_TYPE_MAT3
    elif gl_type == GL_FLOAT_MAT4:
        return ATTRIBUTE_TYPE_MAT4
    else:
        raise ValueError("Program: unsupported OpenGL attribute data type {0}".format(gl_type))

cdef UniformType c_uniform_type_from_gl(uint32_t gl_type) except *:
    if gl_type == GL_INT or gl_type == GL_SAMPLER_1D or gl_type == GL_SAMPLER_2D or gl_type == GL_SAMPLER_3D:
        return UNIFORM_TYPE_INT
    elif gl_type == GL_FLOAT:
        return UNIFORM_TYPE_FLOAT
    elif gl_type == GL_FLOAT_VEC2:
        return UNIFORM_TYPE_VEC2
    elif gl_type == GL_FLOAT_VEC3:
        return UNIFORM_TYPE_VEC3
    elif gl_type == GL_FLOAT_VEC4:
        return UNIFORM_TYPE_VEC4
    elif gl_type == GL_FLOAT_MAT2:
        return UNIFORM_TYPE_MAT2
    elif gl_type == GL_FLOAT_MAT3:
        return UNIFORM_TYPE_MAT3
    elif gl_type == GL_FLOAT_MAT4:
        return UNIFORM_TYPE_MAT4
    else:
        raise ValueError("Program: unsupported OpenGL uniform data type {0}".format(gl_type))

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

cdef uint32_t c_clear_flags_to_gl(uint32_t flags) nogil:
    cdef uint32_t gl_flags = 0
    if flags & VIEW_CLEAR_COLOR:
        gl_flags |= GL_COLOR_BUFFER_BIT
    if flags & VIEW_CLEAR_DEPTH:
        gl_flags |= GL_DEPTH_BUFFER_BIT
    if flags & VIEW_CLEAR_STENCIL:
        gl_flags |= GL_STENCIL_BUFFER_BIT
    return gl_flags

cdef uint32_t c_texture_unit_to_gl(TextureUnit unit) nogil:
    return GL_TEXTURE0 + (unit - TEXTURE_UNIT_0)

cdef uint32_t c_frame_buffer_attachment_to_gl(FrameBufferAttachment attachment) nogil:
    return GL_COLOR_ATTACHMENT0 + (attachment - FRAME_BUFFER_ATTACHMENT_COLOR_0)

cdef class GraphicsManager:

    def __cinit__(self):
        self.root_window = SDL_CreateWindow("", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1, 1, SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN)
        self.root_context = SDL_GL_CreateContext(self.root_window)
        glewInit()
        IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG | IMG_INIT_TIF)

        self.windows = ItemSlotMap(sizeof(WindowC), RENDERER_ITEM_TYPE_WINDOW)
        self.vertex_formats = ItemSlotMap(sizeof(VertexFormatC), RENDERER_ITEM_TYPE_VERTEX_FORMAT)
        self.vertex_buffers = ItemSlotMap(sizeof(VertexBufferC), RENDERER_ITEM_TYPE_VERTEX_BUFFER)
        self.index_buffers = ItemSlotMap(sizeof(IndexBufferC), RENDERER_ITEM_TYPE_INDEX_BUFFER)
        self.uniform_formats = ItemSlotMap(sizeof(UniformFormatC), RENDERER_ITEM_TYPE_UNIFORM_FORMAT)
        self.uniforms = ItemSlotMap(sizeof(UniformC), RENDERER_ITEM_TYPE_UNIFORM)
        self.shaders = ItemSlotMap(sizeof(ShaderC), RENDERER_ITEM_TYPE_SHADER)
        self.programs = ItemSlotMap(sizeof(ProgramC), RENDERER_ITEM_TYPE_PROGRAM)
        self.images = ItemSlotMap(sizeof(ImageC), RENDERER_ITEM_TYPE_IMAGE)
        self.textures = ItemSlotMap(sizeof(TextureC), RENDERER_ITEM_TYPE_TEXTURE)
        self.frame_buffers = ItemSlotMap(sizeof(FrameBufferC), RENDERER_ITEM_TYPE_FRAME_BUFFER)
        self.views = ItemSlotMap(sizeof(ViewC), RENDERER_ITEM_TYPE_VIEW)

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
        quad_ibo_data =  [0, 1, 2, 1, 2, 3]
        quad_ibo_mv = <uint8_t[:24]>(<uint8_t *>&quad_ibo_data)
        self.quad_v_fmt = self.vertex_format_create([
            (b"a_quad", VERTEX_COMP_TYPE_F32, 4, False),
        ])
        self.quad_vbo = self.vertex_buffer_create(self.quad_v_fmt, BUFFER_USAGE_STATIC)
        self.vertex_buffer_set_data(self.quad_vbo, quad_vbo_mv)
        self.quad_ibo = self.index_buffer_create(INDEX_FORMAT_U32, BUFFER_USAGE_STATIC)
        self.index_buffer_set_data(self.quad_ibo, quad_ibo_mv)
        self.quad_vs = self.shader_create_from_file(SHADER_TYPE_VERTEX, b"./resources/shaders/quad.vert")
        self.quad_fs = self.shader_create_from_file(SHADER_TYPE_FRAGMENT, b"./resources/shaders/quad.frag")
        self.quad_program = self.program_create(self.quad_vs, self.quad_fs)
        self.u_fmt_quad = self.uniform_format_create(b"u_quad", UNIFORM_TYPE_INT)
        self.u_quad = self.uniform_create(self.u_fmt_quad)
        self.uniform_set_data(self.u_quad, TEXTURE_UNIT_0)

    def __dealloc__(self):
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
        SDL_GL_DeleteContext(self.root_context)
        SDL_DestroyWindow(self.root_window)

    cdef WindowC *window_get_ptr(self, Handle window) except *:
        return <WindowC *>self.windows.c_get_ptr(window)

    cpdef Handle window_create(self, uint16_t width, uint16_t height, bytes title) except *:
        cdef:
            Handle window
            WindowC *window_ptr
            size_t title_length
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
        glGetProgramiv(gl_id, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &name_max_length)
        if name_max_length >= 256:
            raise ValueError("Program: attribute names cannot exceed 255 characters")
        glGetProgramiv(gl_id, GL_ACTIVE_ATTRIBUTES, &count)
        if count > PROGRAM_MAX_ATTRIBUTES:
            raise ValueError("Program: cannot exceed {0} attributes".format(PROGRAM_MAX_ATTRIBUTES))
        for i in range(count):
            attribute = &program_ptr.attributes[i]
            glGetActiveAttrib(gl_id, i, 255, &name_length, &size, &type, attribute.name)
            attribute.name_length = name_length
            attribute.size = size
            attribute.type = c_attribute_type_from_gl(type)
            attribute.location = glGetAttribLocation(gl_id, attribute.name)
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
        glGetProgramiv(gl_id, GL_ACTIVE_UNIFORM_MAX_LENGTH, &name_max_length)
        if name_max_length >= 256:
            raise ValueError("Program: uniform names cannot exceed 255 characters")
        glGetProgramiv(gl_id, GL_ACTIVE_UNIFORMS, &count)
        if count > PROGRAM_MAX_UNIFORMS:
            raise ValueError("Program: cannot exceed {0} uniforms".format(PROGRAM_MAX_UNIFORMS))
        for i in range(count):
            uniform = &program_ptr.uniforms[i]
            glGetActiveUniform(gl_id, i, 255, &name_length, &size, &type, uniform.name)
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
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id)
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
                    )
                    glEnableVertexAttribArray(location)
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
            glDisableVertexAttribArray(attribute.location)

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
                    glUniform1i(location, <GLint>int_data)
                elif type == UNIFORM_TYPE_FLOAT:
                    float_data = (<float *>uniform_ptr.data)[0]
                    glUniform1f(location, float_data)
                elif type == UNIFORM_TYPE_VEC2:
                    glUniform2fv(location, 1, <float *>uniform_ptr.data)
                elif type == UNIFORM_TYPE_VEC3:
                    glUniform3fv(location, 1, <float *>uniform_ptr.data)
                elif type == UNIFORM_TYPE_VEC4:
                    glUniform4fv(location, 1, <float *>uniform_ptr.data)
                elif type == UNIFORM_TYPE_MAT2:
                    glUniformMatrix2fv(location, 1, False, <float *>uniform_ptr.data)
                elif type == UNIFORM_TYPE_MAT3:
                    glUniformMatrix3fv(location, 1, False, <float *>uniform_ptr.data)
                elif type == UNIFORM_TYPE_MAT4:
                    glUniformMatrix4fv(location, 1, False, <float *>uniform_ptr.data)

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
    
    cpdef void texture_set_data_from_image(self, Handle texture, Handle image) except *:
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

    cpdef void texture_set_data(self, Handle texture, uint8_t[:] data, uint16_t width, uint16_t height) except *:
        cdef:
            TextureC *texture_ptr
            size_t data_size 
        texture_ptr = self.texture_get_ptr(texture)
        data_size = width * height * 4 * sizeof(uint8_t)
        if data_size != data.shape[0]:
            raise ValueError("Texture: data shape does not match dimensions")
        glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id)
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, &data[0])
        if texture_ptr.mipmaps:
            glGenerateMipmap(GL_TEXTURE_2D)
        glBindTexture(GL_TEXTURE_2D, 0)

    cpdef void texture_clear(self, Handle texture, uint16_t width, uint16_t height) except *:
        cdef:
            TextureC *texture_ptr
        texture_ptr = self.texture_get_ptr(texture)
        glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id)
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL)
        if texture_ptr.mipmaps:
            glGenerateMipmap(GL_TEXTURE_2D)
        glBindTexture(GL_TEXTURE_2D, 0)

    cdef FrameBufferC *frame_buffer_get_ptr(self, Handle frame_buffer) except *:
        return <FrameBufferC *>self.frame_buffers.c_get_ptr(frame_buffer)

    cpdef Handle frame_buffer_create(self) except *:
        cdef:
            Handle frame_buffer
            FrameBufferC *frame_buffer_ptr
        frame_buffer = self.frame_buffers.c_create()
        frame_buffer_ptr = self.frame_buffer_get_ptr(frame_buffer)
        glGenFramebuffers(1, &frame_buffer_ptr.gl_id)
        return frame_buffer

    cpdef void frame_buffer_delete(self, Handle frame_buffer) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
        frame_buffer_ptr = self.frame_buffer_get_ptr(frame_buffer)
        glDeleteFramebuffers(1, &frame_buffer_ptr.gl_id)
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
        frame_buffer_ptr = self.frame_buffer_get_ptr(frame_buffer)
        num_textures = len(textures)
        if num_textures > MAX_FRAME_BUFFER_ATTACHMENTS:
            raise ValueError("FrameBuffer: cannot attach more than {0} textures".format(MAX_FRAME_BUFFER_ATTACHMENTS))
        memset(frame_buffer_ptr.textures, 0, MAX_FRAME_BUFFER_ATTACHMENTS * sizeof(Handle))
        memset(frame_buffer_ptr.attachments, 0, MAX_FRAME_BUFFER_ATTACHMENTS * sizeof(int32_t))
        gl_id = frame_buffer_ptr.gl_id
        glBindFramebuffer(GL_FRAMEBUFFER, gl_id)
        for attachment in textures:
            texture = <Handle>textures[attachment]
            frame_buffer_ptr.attachments[i] = attachment
            frame_buffer_ptr.textures[<size_t>attachment] = texture
            gl_attachment = c_frame_buffer_attachment_to_gl(attachment)
            print(gl_attachment)
            texture_ptr = self.texture_get_ptr(texture)
            glFramebufferTexture2D(GL_FRAMEBUFFER, gl_attachment, GL_TEXTURE_2D, texture_ptr.gl_id, 0)
            i += 1
        glBindFramebuffer(GL_FRAMEBUFFER, 0)

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

    cpdef void view_set_transform(self, Handle view, Mat4 view_mat, Mat4 proj_mat) except *:
        cdef:
            ViewC *view_ptr
        view_ptr = self.view_get_ptr(view)
        memcpy(&view_ptr.view_mat, &view_mat.data, sizeof(Mat4C))
        memcpy(&view_ptr.proj_mat, &proj_mat.data, sizeof(Mat4C))

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
            size_t i

        view_ptr = <ViewC *>self.views.items.c_get_ptr(0)
        color = &view_ptr.clear_color
        gl_clear_flags = c_clear_flags_to_gl(view_ptr.clear_flags)

        program_ptr = self.program_get_ptr(view_ptr.program)
        vbo_ptr = self.vertex_buffer_get_ptr(view_ptr.vertex_buffer)
        ibo_ptr = self.index_buffer_get_ptr(view_ptr.index_buffer)

        glUseProgram(program_ptr.gl_id)
        for i in range(view_ptr.num_uniforms):
            uniform_ptr = self.uniform_get_ptr(view_ptr.uniforms[i])
            self._program_bind_uniform(program_ptr.handle, uniform_ptr.handle)
        fbo = view_ptr.frame_buffer
        if fbo != 0:
            fbo_ptr = self.frame_buffer_get_ptr(fbo)
            glBindFramebuffer(GL_FRAMEBUFFER, fbo_ptr.gl_id)
        glClearColor(color.x, color.y, color.z, color.w)
        glClear(gl_clear_flags)
        glViewport(0, 0, 800, 600)
        for i in range(view_ptr.num_texture_units):
            texture_unit = view_ptr.texture_units[i]
            gl_texture_unit = c_texture_unit_to_gl(texture_unit)
            texture = view_ptr.textures[<size_t>texture_unit]
            texture_ptr = self.texture_get_ptr(texture)
            glActiveTexture(gl_texture_unit)
            glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id)
        self._program_bind_attributes(program_ptr.handle, vbo_ptr.handle)
        self._index_buffer_draw(ibo_ptr.handle)
        self._program_unbind_attributes(program_ptr.handle)
        for i in range(view_ptr.num_texture_units):
            texture_unit = view_ptr.texture_units[i]
            gl_texture_unit = c_texture_unit_to_gl(texture_unit)
            glActiveTexture(gl_texture_unit)
            glBindTexture(GL_TEXTURE_2D, 0)
        if fbo != 0:
            glBindFramebuffer(GL_FRAMEBUFFER, 0)
        glUseProgram(0)
        
        for i in range(self.windows.items.num_items):
            window_ptr = <WindowC *>self.windows.items.c_get_ptr(i)
            SDL_GL_MakeCurrent(window_ptr.sdl_ptr, self.root_context)
            glViewport(0, 0, 800, 600)
            glClearColor(1.0, 0.0, 0.0, 1.0)
            glClear(GL_COLOR_BUFFER_BIT)
            glActiveTexture(GL_TEXTURE0)
            texture_ptr = self.texture_get_ptr(window_ptr.texture)
            program_ptr = self.program_get_ptr(self.quad_program)
            glUseProgram(program_ptr.gl_id)
            glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id)
            self._program_bind_uniform(self.quad_program, self.u_quad)
            self._program_bind_attributes(self.quad_program, self.quad_vbo)
            self._index_buffer_draw(self.quad_ibo)
            self._program_unbind_attributes(self.quad_program)
            glBindTexture(GL_TEXTURE_2D, 0)
            SDL_GL_SetSwapInterval(0)
            SDL_GL_SwapWindow(window_ptr.sdl_ptr)
            glUseProgram(0)
        SDL_GL_MakeCurrent(self.root_window, self.root_context)
        SDL_GL_SetSwapInterval(0)
        SDL_GL_SwapWindow(self.root_window)