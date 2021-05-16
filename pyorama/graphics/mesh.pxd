from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.vertex_buffer cimport *

ctypedef struct MeshC:
    Handle handle
    uint8_t *vertex_data
    size_t vertex_data_size
    uint8_t *index_data
    size_t index_data_size

cdef class Mesh:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    cdef MeshC *c_get_ptr(self) except *
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, uint8_t[::1] vertex_data, uint8_t[::1] index_data) except *
    cpdef void create_from_file(self, bytes file_path) except *
    cpdef void delete(self) except *