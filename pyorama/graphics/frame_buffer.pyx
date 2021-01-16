cdef uint8_t ITEM_TYPE = GRAPHICS_ITEM_TYPE_FRAME_BUFFER
ctypedef FrameBufferC ItemTypeC

cdef class FrameBuffer:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    @staticmethod
    cdef ItemTypeC *get_ptr_by_index(GraphicsManager manager, size_t index) except *:
        cdef:
            PyObject *slot_map_ptr
        slot_map_ptr = manager.slot_maps[<uint8_t>ITEM_TYPE]
        return <ItemTypeC *>(<ItemSlotMap>slot_map_ptr).items.c_get_ptr(index)

    @staticmethod
    cdef ItemTypeC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *:
        return <ItemTypeC *>manager.get_ptr(handle)

    cdef ItemTypeC *get_ptr(self) except *:
        return FrameBuffer.get_ptr_by_handle(self.manager, self.handle)

    cpdef void create(self) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        frame_buffer_ptr = self.get_ptr()
        glGenFramebuffers(1, &frame_buffer_ptr.gl_id); self.manager.c_check_gl()

    cpdef void delete(self) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
        frame_buffer_ptr = self.get_ptr()
        glDeleteFramebuffers(1, &frame_buffer_ptr.gl_id); self.manager.c_check_gl()
        self.manager.delete(self.handle)
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
        glBindFramebuffer(GL_FRAMEBUFFER, gl_id); self.manager.c_check_gl()
        for attachment in textures:
            texture = <Handle>(textures[attachment].handle)
            frame_buffer_ptr.attachments[i] = attachment
            frame_buffer_ptr.textures[<size_t>attachment] = texture
            gl_attachment = c_frame_buffer_attachment_to_gl(attachment)
            texture_ptr = Texture.get_ptr_by_handle(self.manager, texture)
            glFramebufferTexture2D(GL_FRAMEBUFFER, gl_attachment, GL_TEXTURE_2D, texture_ptr.gl_id, 0); self.manager.c_check_gl()
            gl_status = glCheckFramebufferStatus(GL_FRAMEBUFFER); self.manager.c_check_gl()
            if gl_status != GL_FRAMEBUFFER_COMPLETE:
                raise ValueError("FrameBuffer: failed to attach textures (status: {0})".format(gl_status))
            i += 1
        glBindFramebuffer(GL_FRAMEBUFFER, 0); self.manager.c_check_gl()