from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.vertex_buffer cimport *

cdef class Mesh:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef MeshC *get_ptr(self) except *
    cpdef void create(self, uint8_t[::1] vertex_data, uint8_t[::1] index_data) except *
    cpdef void create_from_file(self, bytes file_path) except *
    cpdef void delete(self) except *