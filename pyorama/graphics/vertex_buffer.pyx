ctypedef VertexBufferC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class VertexBuffer:
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

    cpdef void create(self, VertexFormat format, BufferUsage usage=BUFFER_USAGE_STATIC) except *:
        cdef:
            VertexBufferC *buffer_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        buffer_ptr = self.c_get_ptr()
        glGenBuffers(1, &buffer_ptr.gl_id); self.manager.c_check_gl()
        if buffer_ptr.gl_id == 0:
            raise ValueError("VertexBuffer: failed to generate buffer id")
        buffer_ptr.format = format.handle
        buffer_ptr.usage = usage
        buffer_ptr.size = 0

    cpdef void delete(self) except *:
        cdef:
            VertexBufferC *buffer_ptr
            uint32_t gl_usage
        buffer_ptr = self.c_get_ptr()
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id); self.manager.c_check_gl()
        gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
        glBufferData(GL_ARRAY_BUFFER, buffer_ptr.size, NULL, gl_usage); self.manager.c_check_gl()
        glBindBuffer(GL_ARRAY_BUFFER, 0); self.manager.c_check_gl()
        glDeleteBuffers(1, &buffer_ptr.gl_id); self.manager.c_check_gl()
        self.manager.delete(self.handle)
        self.handle = 0

    cdef void c_set_data(self, uint8_t *data_ptr, size_t data_size) except *:
        cdef:
            VertexBufferC *buffer_ptr
            uint32_t gl_usage
        buffer_ptr = self.c_get_ptr()
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id); self.manager.c_check_gl()
        if buffer_ptr.size == data_size:#use sub data instead
            glBufferSubData(GL_ARRAY_BUFFER, 0, data_size, data_ptr); self.manager.c_check_gl()
        else:
            gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
            glBufferData(GL_ARRAY_BUFFER, data_size, data_ptr, gl_usage); self.manager.c_check_gl()
            buffer_ptr.size = data_size
        glBindBuffer(GL_ARRAY_BUFFER, 0); self.manager.c_check_gl()

    cpdef void set_data(self, uint8_t[::1] data) except *:
        cdef:
            uint8_t *data_ptr = &data[0]
            size_t data_size = data.shape[0]
        self.c_set_data(data_ptr, data_size)
    
    cpdef void set_data_from_mesh(self, Mesh mesh) except *:
        cdef:
            MeshC *mesh_ptr = mesh.c_get_ptr()
            uint8_t *data_ptr = mesh_ptr.vertex_data
            size_t data_size = mesh_ptr.vertex_data_size
        self.c_set_data(data_ptr, data_size)
    
    cdef void c_set_sub_data(self, uint8_t *data_ptr, size_t data_size, size_t offset) except *:
        cdef:
            VertexBufferC *buffer_ptr
        buffer_ptr = self.c_get_ptr()
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id); self.manager.c_check_gl()
        if offset + data_size > buffer_ptr.size:
            raise ValueError("VertexBuffer: attempting to write out of bounds")
        else:
            glBufferSubData(GL_ARRAY_BUFFER, 0, data_size, data_ptr); self.manager.c_check_gl()
        glBindBuffer(GL_ARRAY_BUFFER, 0); self.manager.c_check_gl()

    cpdef void set_sub_data(self, uint8_t[::1] data, size_t offset) except *:
        cdef:
            uint8_t *data_ptr = &data[0]
            size_t data_size = data.shape[0]
        self.c_set_sub_data(data_ptr, data_size, offset)
    
    cpdef void set_sub_data_from_mesh(self, Mesh mesh, size_t offset) except *:
        cdef:
            MeshC *mesh_ptr = mesh.c_get_ptr()
            uint8_t *data_ptr = mesh_ptr.vertex_data
            size_t data_size = mesh_ptr.vertex_data_size
        self.c_set_sub_data(data_ptr, data_size, offset)