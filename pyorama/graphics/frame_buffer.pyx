from pyorama.graphics.texture cimport *

ctypedef FrameBufferC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

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

cdef class FrameBuffer:
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

    cpdef void create(self) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        frame_buffer_ptr = self.c_get_ptr()
        glGenFramebuffers(1, &frame_buffer_ptr.gl_id); self.manager.c_check_gl()

    cpdef void delete(self) except *:
        cdef:
            FrameBufferC *frame_buffer_ptr
        frame_buffer_ptr = self.c_get_ptr()
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
        frame_buffer_ptr = self.c_get_ptr()
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
            texture_ptr = <TextureC *>self.manager.c_get_ptr(texture)
            glFramebufferTexture2D(GL_FRAMEBUFFER, gl_attachment, GL_TEXTURE_2D, texture_ptr.gl_id, 0); self.manager.c_check_gl()
            gl_status = glCheckFramebufferStatus(GL_FRAMEBUFFER); self.manager.c_check_gl()
            if gl_status != GL_FRAMEBUFFER_COMPLETE:
                raise ValueError("FrameBuffer: failed to attach textures (status: {0})".format(gl_status))
            i += 1
        glBindFramebuffer(GL_FRAMEBUFFER, 0); self.manager.c_check_gl()