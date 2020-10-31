cdef class Texture:
    def __init__(self, GraphicsManager graphics):
        self.graphics = graphics

    def __dealloc__(self):
        self.graphics = None
    
    cdef TextureC *get_ptr(self) except *:
        return self.graphics.texture_get_ptr(self.handle)

    cpdef void create(self, TextureFormat format=TEXTURE_FORMAT_RGBA_8U, bint mipmaps=True, 
            TextureFilter filter=TEXTURE_FILTER_LINEAR, TextureWrap wrap_s=TEXTURE_WRAP_REPEAT, 
            TextureWrap wrap_t=TEXTURE_WRAP_REPEAT, bint cubemap=False) except *:
        cdef:
            TextureC *texture_ptr
        self.handle = self.graphics.textures.c_create()
        texture_ptr = self.get_ptr()
        texture_ptr.format = format
        texture_ptr.cubemap = cubemap
        glGenTextures(1, &texture_ptr.gl_id); self.graphics.c_check_gl()
        self.set_parameters(mipmaps, filter, wrap_s, wrap_t)
    
    cpdef void delete(self) except *:
        cdef:
            TextureC *texture_ptr
        texture_ptr = self.get_ptr()
        glDeleteTextures(1, &texture_ptr.gl_id); self.graphics.c_check_gl()
        self.graphics.textures.c_delete(self.handle)
        self.handle = 0

    cpdef void set_parameters(self, bint mipmaps=True, TextureFilter filter=TEXTURE_FILTER_LINEAR, TextureWrap wrap_s=TEXTURE_WRAP_REPEAT, TextureWrap wrap_t=TEXTURE_WRAP_REPEAT) except *:
        cdef:
            TextureC *texture_ptr
            uint32_t target
        texture_ptr = self.get_ptr()
        texture_ptr.mipmaps = mipmaps
        texture_ptr.filter = filter
        texture_ptr.wrap_s = wrap_s
        texture_ptr.wrap_t = wrap_t
        target = GL_TEXTURE_CUBE_MAP if texture_ptr.cubemap else GL_TEXTURE_2D
        glBindTexture(target, texture_ptr.gl_id); self.graphics.c_check_gl()
        glTexParameteri(target, GL_TEXTURE_WRAP_S, c_texture_wrap_to_gl(wrap_s)); self.graphics.c_check_gl()	
        glTexParameteri(target, GL_TEXTURE_WRAP_T, c_texture_wrap_to_gl(wrap_t)); self.graphics.c_check_gl()
        glTexParameteri(target, GL_TEXTURE_MIN_FILTER, c_texture_filter_to_gl(filter, mipmaps)); self.graphics.c_check_gl()
        glTexParameteri(target, GL_TEXTURE_MAG_FILTER, c_texture_filter_to_gl(filter, False)); self.graphics.c_check_gl()#mipmap does not matter for mag filter!
        glBindTexture(target, 0); self.graphics.c_check_gl()
    
    cpdef void set_data_2d_from_image(self, Image image) except *:
        cdef:
            TextureC *texture_ptr
            ImageC *image_ptr
            uint32_t gl_internal_format
            uint32_t gl_format
            uint32_t gl_type
        texture_ptr = self.get_ptr()
        if texture_ptr.cubemap:
            raise ValueError("Texture: cannot use 2D data setter for cubemap texture")
        gl_internal_format = c_texture_format_to_internal_format_gl(texture_ptr.format)
        gl_format = c_texture_format_to_format_gl(texture_ptr.format)
        gl_type = c_texture_format_to_type_gl(texture_ptr.format)
        image_ptr = image.get_ptr()
        glBindTexture(GL_TEXTURE_2D, texture_ptr.gl_id); self.graphics.c_check_gl()
        glTexImage2D(GL_TEXTURE_2D, 0, gl_internal_format, image_ptr.width, image_ptr.height, 0, gl_format, gl_type, image_ptr.data); self.graphics.c_check_gl()
        if texture_ptr.mipmaps:
            glGenerateMipmap(GL_TEXTURE_2D); self.graphics.c_check_gl()
        glBindTexture(GL_TEXTURE_2D, 0); self.graphics.c_check_gl()

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
        texture_ptr = self.get_ptr()
        if not texture_ptr.cubemap:
            raise ValueError("Texture: cannot use cubemap data setter for 2D texture")
        gl_internal_format = c_texture_format_to_internal_format_gl(texture_ptr.format)
        gl_format = c_texture_format_to_format_gl(texture_ptr.format)
        gl_type = c_texture_format_to_type_gl(texture_ptr.format)
        glBindTexture(GL_TEXTURE_CUBE_MAP, texture_ptr.gl_id)
        for i in range(6):
            image_ptr = self.graphics.image_get_ptr(images[i])
            glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, gl_internal_format, image_ptr.width, image_ptr.height, 0, gl_format, gl_type, image_ptr.data); self.graphics.c_check_gl()
        if texture_ptr.mipmaps:
            glGenerateMipmap(GL_TEXTURE_CUBE_MAP); self.graphics.c_check_gl()
        glBindTexture(GL_TEXTURE_CUBE_MAP, 0); self.graphics.c_check_gl()

    cpdef void clear(self, uint16_t width, uint16_t height) except *:
        cdef:
            TextureC *texture_ptr
            uint32_t target
            size_t i
            uint32_t gl_internal_format
            uint32_t gl_format
            uint32_t gl_type
        texture_ptr = self.get_ptr()
        gl_internal_format = c_texture_format_to_internal_format_gl(texture_ptr.format)
        gl_format = c_texture_format_to_format_gl(texture_ptr.format)
        gl_type = c_texture_format_to_type_gl(texture_ptr.format)
        target = GL_TEXTURE_CUBE_MAP if texture_ptr.cubemap else GL_TEXTURE_2D
        glBindTexture(target, texture_ptr.gl_id); self.graphics.c_check_gl()
        if texture_ptr.cubemap:
            for i in range(6):
                glTexImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X + i, 0, gl_internal_format, width, height, 0, gl_format, gl_type, NULL); self.graphics.c_check_gl()
        else:
            glTexImage2D(GL_TEXTURE_2D, 0, gl_internal_format, width, height, 0, gl_format, gl_type, NULL); self.graphics.c_check_gl()
        if texture_ptr.mipmaps:
            glGenerateMipmap(target); self.graphics.c_check_gl()
        glBindTexture(target, 0); self.graphics.c_check_gl()