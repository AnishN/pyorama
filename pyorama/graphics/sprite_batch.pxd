from cpython.object cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.sprite cimport *
from pyorama.graphics.vertex_buffer cimport *

ctypedef struct SpriteBatchC:
    Handle handle
    size_t num_sprites
    Handle *sprites
    Handle vertex_buffer
    uint8_t *vertex_data_ptr
    Handle index_buffer
    uint8_t *index_data_ptr
    Handle texture

cdef class SpriteBatch:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    @staticmethod
    cdef SpriteBatchC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef SpriteBatchC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef SpriteBatchC *get_ptr(self) except *

    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void set_sprites(self, list sprites) except *
    cpdef VertexBuffer get_vertex_buffer(self)
    cpdef IndexBuffer get_index_buffer(self)
    cdef void _update(self) except *