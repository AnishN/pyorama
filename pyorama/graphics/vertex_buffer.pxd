from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.vertex_format cimport *

cdef class VertexBuffer:
    cdef:
        public Handle handle#TODO: switch back to readonly
        readonly GraphicsManager graphics

    cdef VertexBufferC *get_ptr(self) except *
    cpdef void create(self, VertexFormat format, BufferUsage usage=*) except *
    cpdef void delete(self) except *
    cpdef void set_data(self, uint8_t[::1] data) except *
    cpdef void set_data_from_mesh(self, Handle mesh) except *
    cpdef void set_sub_data(self, uint8_t[::1] data, size_t offset) except *
    cpdef void set_sub_data_from_mesh(self, Handle mesh, size_t offset) except *