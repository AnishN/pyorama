ctypedef TextureC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

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

cdef class Texture:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    cdef ItemTypeC *c_get_ptr(self) except *:
        return <ItemTypeC *>self.manager.c_get_ptr(self.handle)

    @staticmethod
    cdef uint8_t c_get_type() nogil:
        return ITEM_TYPE

    @staticmethod
    def get_type():
        return ITEM_TYPE

    @staticmethod
    cdef size_t c_get_size() nogil:
        return ITEM_SIZE

    @staticmethod
    def get_size():
        return ITEM_SIZE

    cpdef void create(self, TextureFormat format=TEXTURE_FORMAT_RGBA_8U, bint mipmaps=True, 
            TextureFilter filter=TEXTURE_FILTER_LINEAR, TextureWrap wrap_s=TEXTURE_WRAP_REPEAT, 
            TextureWrap wrap_t=TEXTURE_WRAP_REPEAT, bint cubemap=False) except *:
        cdef:
            TextureC *texture_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        texture_ptr = self.c_get_ptr()
        texture_ptr.format = format
        texture_ptr.cubemap = cubemap
        glGenTextures(1, &texture_ptr.gl_id); self.manager.c_check_gl()
        self.set_parameters(mipmaps, filter, wrap_s, wrap_t)
    
    cpdef void delete(self) except *:
        cdef:
            TextureC *texture_ptr
        texture_ptr = self.c_get_ptr()
        glDeleteTextures(1, &texture_ptr.gl_id); self.manager.c_check_gl()
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef void set_parameters(self, bint mipmaps=True, TextureFilter filter=TEXTURE_FILTER_LINEAR, TextureWrap wrap_s=TEXTURE_WRAP_REPEAT, TextureWrap wrap_t=TEXTURE_WRAP_REPEAT) except *:
        cdef:
            TextureC *texture_ptr
            uint32_t target
        texture_ptr = self.c_get_ptr()
        texture_ptr.mipmaps = mipmaps
        texture_ptr.filter = filter
        texture_ptr.wrap_s = wrap_s
        texture_ptr.wrap_t = wrap_t
        target = GL_TEXTURE_CUBE_MAP if texture_ptr.cubemap else GL_TEXTURE_2D
        glBindTexture(target, texture_ptr.gl_id); self.manager.c_check_gl()
        glTexParameteri(target, GL_TEXTURE_WRAP_S, c_texture_wrap_to_gl(wrap_s)); self.manager.c_check_gl()	
        glTexParameteri(target, GL_TEXTURE_WRAP_T, c_texture_wrap_to_gl(wrap_t)); self.manager.c_check_gl()
        glTexParameteri(target, GL_TEXTURE_MIN_FILTER, c_texture_filter_to_gl(filter, mipmaps)); self.manager.c_check_gl()
        glTexParameteri(target, GL_TEXTURE_MAG_FILTER, c_texture_filter_to_gl(filter, False)); self.manager.c_check_gl()#mipmap does not matter for mag filter!
        glBindTexture(target, 0); self.manager.c_check_gl()
    
    cpdef void set_data_2d_from_image(self, Image image) except *:
        cdef:
            TextureC *texture_ptr
            ImageC *image_ptr
            uint32_t gl_internal_format
            uint32_t gl_format
            uint32_t gl_type
        texture_ptr = self.c_get_ptr()
        if texture_ptr.cubemap:
            raise ValueError("Texture: cannot use 2D data setter for cubemap texture")
        gl_internal_format = c_texture_format_to_internal_format_gl(texture_ptr.format)
        gl_format = c_texture_format_to_format_gl(texture_ptr.format)
        gl_type = c_texture_format_to_type_gl(texture_ptr.format)
        image_ptr = image.c_get_ptr()
        glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id); self.manager.c_check_gl()
        glTexImage2D(GL_TEXTURE_2D, 0, gl_internal_format, image_ptr.width, image_ptr.height, 0, gl_format, gl_type, image_ptr.data); self.manager.c_check_gl()
        if texture_ptr.mipmaps:
            glGenerateMipmap(GL_TEXTURE_2D); self.manager.c_check_gl()
        glBindTexture(GL_TEXTURE_2D, 0); self.manager.c_check_gl()

    cpdef void set_data_cubemap_from_images(self, 
            Image pos_x, Image neg_x, Image pos_y,
            Image neg_y, Image pos_z, Image neg_z) except *:
        cdef:
            TextureC *texture_ptr
            Handle[6] images
            size_t i
            ImageC *image_ptr
            uint32_t gl_internal_format
            uint32_t gl_format
            uint32_t gl_type
        images = [
            pos_x.handle, neg_x.handle, 
            pos_y.handle, neg_y.handle, 
            pos_z.handle, neg_z.handle,
        ]
        texture_ptr = self.c_get_ptr()
        if not texture_ptr.cubemap:
            raise ValueError("Texture: cannot use cubemap data setter for 2D texture")
        gl_internal_format = c_texture_format_to_internal_format_gl(texture_ptr.format)
        gl_format = c_texture_format_to_format_gl(texture_ptr.format)
        gl_type = c_texture_format_to_type_gl(texture_ptr.format)
        glBindTexture(GL_TEXTURE_CUBE_MAP, texture_ptr.gl_id)
        for i in range(6):
            image_ptr = <ImageC *>self.manager.c_get_ptr(images[i])
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, gl_internal_format, image_ptr.width, image_ptr.height, 0, gl_format, gl_type, image_ptr.data); self.manager.c_check_gl()
        if texture_ptr.mipmaps:
            glGenerateMipmap(GL_TEXTURE_CUBE_MAP); self.manager.c_check_gl()
        glBindTexture(GL_TEXTURE_CUBE_MAP, 0); self.manager.c_check_gl()

    cpdef void clear(self, uint16_t width, uint16_t height) except *:
        cdef:
            TextureC *texture_ptr
            uint32_t target
            size_t i
            uint32_t gl_internal_format
            uint32_t gl_format
            uint32_t gl_type
        texture_ptr = self.c_get_ptr()
        gl_internal_format = c_texture_format_to_internal_format_gl(texture_ptr.format)
        gl_format = c_texture_format_to_format_gl(texture_ptr.format)
        gl_type = c_texture_format_to_type_gl(texture_ptr.format)
        target = GL_TEXTURE_CUBE_MAP if texture_ptr.cubemap else GL_TEXTURE_2D
        glBindTexture(target, texture_ptr.gl_id); self.manager.c_check_gl()
        if texture_ptr.cubemap:
            for i in range(6):
                glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, gl_internal_format, width, height, 0, gl_format, gl_type, NULL); self.manager.c_check_gl()
        else:
            glTexImage2D(GL_TEXTURE_2D, 0, gl_internal_format, width, height, 0, gl_format, gl_type, NULL); self.manager.c_check_gl()
        if texture_ptr.mipmaps:
            glGenerateMipmap(target); self.manager.c_check_gl()
        glBindTexture(target, 0); self.manager.c_check_gl()