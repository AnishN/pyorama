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
    if gl_type == GL_INT or gl_type == GL_SAMPLER_2D or gl_type == GL_SAMPLER_CUBE:
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

cdef uint32_t c_texture_unit_to_gl(TextureUnit unit):
    if unit == TEXTURE_UNIT_0:
        return GL_TEXTURE0
    elif unit == TEXTURE_UNIT_1:
        return GL_TEXTURE1
    elif unit == TEXTURE_UNIT_2:
        return GL_TEXTURE2
    elif unit == TEXTURE_UNIT_3:
        return GL_TEXTURE3
    elif unit == TEXTURE_UNIT_4:
        return GL_TEXTURE4
    elif unit == TEXTURE_UNIT_5:
        return GL_TEXTURE5
    elif unit == TEXTURE_UNIT_6:
        return GL_TEXTURE6
    elif unit == TEXTURE_UNIT_7:
        return GL_TEXTURE7
    elif unit == TEXTURE_UNIT_8:
        return GL_TEXTURE8
    elif unit == TEXTURE_UNIT_9:
        return GL_TEXTURE9
    elif unit == TEXTURE_UNIT_10:
        return GL_TEXTURE10
    elif unit == TEXTURE_UNIT_11:
        return GL_TEXTURE11
    elif unit == TEXTURE_UNIT_12:
        return GL_TEXTURE12
    elif unit == TEXTURE_UNIT_13:
        return GL_TEXTURE13
    elif unit == TEXTURE_UNIT_14:
        return GL_TEXTURE14
    elif unit == TEXTURE_UNIT_15:
        return GL_TEXTURE15

cdef uint32_t c_frame_buffer_attachment_to_gl(FrameBufferAttachment attachment) nogil:
    if attachment == FRAME_BUFFER_ATTACHMENT_COLOR_0:
        return GL_COLOR_ATTACHMENT0
    elif attachment == FRAME_BUFFER_ATTACHMENT_DEPTH:
        return GL_DEPTH_ATTACHMENT
    elif attachment == FRAME_BUFFER_ATTACHMENT_STENCIL:
        return GL_STENCIL_ATTACHMENT
    """
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_1:
        return GL_COLOR_ATTACHMENT1
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_2:
        return GL_COLOR_ATTACHMENT2
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_3:
        return GL_COLOR_ATTACHMENT3
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_4:
        return GL_COLOR_ATTACHMENT4
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_5:
        return GL_COLOR_ATTACHMENT5
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_6:
        return GL_COLOR_ATTACHMENT6
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_7:
        return GL_COLOR_ATTACHMENT7
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_8:
        return GL_COLOR_ATTACHMENT8
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_9:
        return GL_COLOR_ATTACHMENT9
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_10:
        return GL_COLOR_ATTACHMENT10
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_11:
        return GL_COLOR_ATTACHMENT11
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_12:
        return GL_COLOR_ATTACHMENT12
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_13:
        return GL_COLOR_ATTACHMENT13
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_14:
        return GL_COLOR_ATTACHMENT14
    elif attachment == FRAME_BUFFER_ATTACHMENT_COLOR_15:
        return GL_COLOR_ATTACHMENT15
    """

cdef uint32_t c_texture_format_to_internal_format_gl(TextureFormat format) nogil:
    if format == TEXTURE_FORMAT_RGBA_8U:
        return GL_RGBA
    elif format == TEXTURE_FORMAT_RGBA_32F:
        return GL_RGBA
    elif format == TEXTURE_FORMAT_DEPTH_16U:
        return GL_DEPTH_COMPONENT
    elif format == TEXTURE_FORMAT_DEPTH_32U:
        return GL_DEPTH_COMPONENT
    #elif format == TEXTURE_FORMAT_DEPTH_STENCIL_24_8U:
    #    return GL_DEPTH_STENCIL

cdef uint32_t c_texture_format_to_format_gl(TextureFormat format) nogil:
    if format == TEXTURE_FORMAT_RGBA_8U:
        return GL_RGBA
    elif format == TEXTURE_FORMAT_RGBA_32F:
        return GL_RGBA
    elif format == TEXTURE_FORMAT_DEPTH_16U:
        return GL_DEPTH_COMPONENT
    elif format == TEXTURE_FORMAT_DEPTH_32U:
        return GL_DEPTH_COMPONENT
    #elif format == TEXTURE_FORMAT_DEPTH_STENCIL_24_8U:
    #    return GL_DEPTH_STENCIL

cdef uint32_t c_texture_format_to_type_gl(TextureFormat format) nogil:
    if format == TEXTURE_FORMAT_RGBA_8U:
        return GL_UNSIGNED_BYTE
    elif format == TEXTURE_FORMAT_RGBA_32F:
        return GL_FLOAT
    elif format == TEXTURE_FORMAT_DEPTH_16U:
        return GL_UNSIGNED_SHORT
    elif format == TEXTURE_FORMAT_DEPTH_32U:
        return GL_UNSIGNED_INT
    #elif format == TEXTURE_FORMAT_DEPTH_STENCIL_24_8U:
    #    return GL_UNSIGNED_INT_24_8
