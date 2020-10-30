cdef class IndexBuffer:
    def __init__(self, GraphicsManager graphics):
        self.graphics = graphics

    def __dealloc__(self):
        self.graphics = None
    
    cdef IndexBufferC *get_ptr(self) except *:
        return self.graphics.index_buffer_get_ptr(self.handle)    
    
    cpdef void create(self, IndexFormat format, BufferUsage usage=BUFFER_USAGE_STATIC) except *:
        cdef:
            Handle buffer
            IndexBufferC *buffer_ptr
        self.handle = self.graphics.index_buffers.c_create()
        buffer_ptr = self.get_ptr()
        glGenBuffers(1, &buffer_ptr.gl_id); self.graphics.c_check_gl()
        if buffer_ptr.gl_id == 0:
            raise ValueError("IndexBuffer: failed to generate buffer id")
        buffer_ptr.format = format
        buffer_ptr.usage = usage
        buffer_ptr.size = 0

    cpdef void delete(self) except *:
        cdef:
            IndexBufferC *buffer_ptr
            uint32_t gl_usage
        buffer_ptr = self.get_ptr()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id); self.graphics.c_check_gl()
        gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.size, NULL, gl_usage); self.graphics.c_check_gl()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); self.graphics.c_check_gl()
        glDeleteBuffers(1, &buffer_ptr.gl_id); self.graphics.c_check_gl()
        self.graphics.index_buffers.c_delete(self.handle)
        self.handle = 0
    
    cpdef void set_data(self, uint8_t[::1] data) except *:
        cdef:
            IndexBufferC *buffer_ptr
            size_t data_size
            uint8_t *data_ptr
            uint32_t gl_usage
        buffer_ptr = self.get_ptr()
        data_size = data.shape[0]
        data_ptr = &data[0]
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id); self.graphics.c_check_gl()
        if buffer_ptr.size == data_size:#use sub data instead
            glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, data_size, data_ptr); self.graphics.c_check_gl()
        else:
            gl_usage = c_buffer_usage_to_gl(buffer_ptr.usage)
            glBufferData(GL_ELEMENT_ARRAY_BUFFER, data_size, data_ptr, gl_usage); self.graphics.c_check_gl()
            buffer_ptr.size = data_size
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); self.graphics.c_check_gl()
    
    cpdef void set_data_from_mesh(self, Handle mesh) except *:
        cdef:
            MeshC *mesh_ptr
            uint8_t[::1] data
        mesh_ptr = self.graphics.mesh_get_ptr(mesh)
        data = <uint8_t[:mesh_ptr.index_data_size]>mesh_ptr.index_data
        self.set_data(data)

    cpdef void set_sub_data(self, uint8_t[::1] data, size_t offset) except *:
        cdef:
            IndexBufferC *buffer_ptr
            size_t data_size
            uint8_t *data_ptr
        buffer_ptr = self.get_ptr()
        data_size = data.shape[0]
        data_ptr = &data[0]
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id); self.graphics.c_check_gl()
        if offset + data_size > buffer_ptr.size:
            raise ValueError("IndexBuffer: attempting to write out of bounds")
        else:
            glBufferSubData(GL_ELEMENT_ARRAY_BUFFER, 0, data_size, data_ptr); self.graphics.c_check_gl()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); self.graphics.c_check_gl()

    cpdef void set_sub_data_from_mesh(self, Handle mesh, size_t offset) except *:
        cdef:
            MeshC *mesh_ptr
            uint8_t[::1] data
        mesh_ptr = self.graphics.mesh_get_ptr(mesh)
        data = <uint8_t[:mesh_ptr.index_data_size]>mesh_ptr.index_data
        self.set_sub_data(data, offset)

    cdef void _draw(self) except *:
        cdef:
            IndexBufferC *buffer_ptr
            size_t format_size
            uint32_t format_gl
        buffer_ptr = self.get_ptr()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, buffer_ptr.gl_id); self.graphics.c_check_gl()
        format_size = c_index_format_get_size(buffer_ptr.format)    
        format_gl = c_index_format_to_gl(buffer_ptr.format)
        glDrawElements(GL_TRIANGLES, buffer_ptr.size / format_size, format_gl, NULL); self.graphics.c_check_gl()
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0); self.graphics.c_check_gl()