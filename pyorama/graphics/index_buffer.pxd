from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.mesh cimport *

cdef class IndexBuffer:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef IndexBufferC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef IndexBufferC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef IndexBufferC *get_ptr(self) except *
    
    cdef IndexBufferC *get_ptr(self) except *
    cpdef void create(self, IndexFormat format, BufferUsage usage=*) except *
    cpdef void delete(self) except *
    cpdef void set_data(self, uint8_t[::1] data) except *
    cpdef void set_data_from_mesh(self, Mesh mesh) except *
    cpdef void set_sub_data_from_mesh(self, Mesh mesh, size_t offset) except *
    cpdef void set_sub_data(self, uint8_t[::1] data, size_t offset) except *
    cdef void _draw(self) except *