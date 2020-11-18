cdef class FrameBuffer:
    def __cinit__(self, GraphicsManager graphics):
        self.graphics = graphics

    def __dealloc__(self):
        self.graphics = None
    
    cdef FrameBufferC *get_ptr(self) except *:
        return self.graphics.frame_buffer_get_ptr(self.handle)

    cpdef void create(self) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
        self.handle = self.graphics.frame_buffers.c_create()
        frame_buffer_ptr = self.get_ptr()
        glGenFramebuffers(1, &frame_buffer_ptr.gl_id); self.graphics.c_check_gl()

    cpdef void delete(self) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
        frame_buffer_ptr = self.get_ptr()
        glDeleteFramebuffers(1, &frame_buffer_ptr.gl_id); self.graphics.c_check_gl()
        self.graphics.frame_buffers.c_delete(self.handle)
        self.handle = 0

    cpdef void attach_textures(self, dict textures) except *:
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
        frame_buffer_ptr = self.get_ptr()
        num_textures = len(textures)
        if num_textures > MAX_FRAME_BUFFER_ATTACHMENTS:
            raise ValueError("FrameBuffer: cannot attach more than {0} textures".format(MAX_FRAME_BUFFER_ATTACHMENTS))
        memset(frame_buffer_ptr.textures, 0, MAX_FRAME_BUFFER_ATTACHMENTS * sizeof(Handle))
        memset(frame_buffer_ptr.attachments, 0, MAX_FRAME_BUFFER_ATTACHMENTS * sizeof(int32_t))
        gl_id = frame_buffer_ptr.gl_id
        glBindFramebuffer(GL_FRAMEBUFFER, gl_id); self.graphics.c_check_gl()
        for attachment in textures:
            texture = <Handle>(textures[attachment].handle)
            frame_buffer_ptr.attachments[i] = attachment
            frame_buffer_ptr.textures[<size_t>attachment] = texture
            gl_attachment = c_frame_buffer_attachment_to_gl(attachment)
            texture_ptr = self.graphics.texture_get_ptr(texture)
            glFramebufferTexture2D(GL_FRAMEBUFFER, gl_attachment, GL_TEXTURE_2D, texture_ptr.gl_id, 0); self.graphics.c_check_gl()
            gl_status = glCheckFramebufferStatus(GL_FRAMEBUFFER); self.graphics.c_check_gl()
            if gl_status != GL_FRAMEBUFFER_COMPLETE:
                raise ValueError("FrameBuffer: failed to attach textures (status: {0})".format(gl_status))
            i += 1
        glBindFramebuffer(GL_FRAMEBUFFER, 0); self.graphics.c_check_gl()