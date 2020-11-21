from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.sprite cimport *
from pyorama.graphics.vertex_buffer cimport *

cdef class SpriteBatch:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics

    cdef SpriteBatchC *get_ptr(self) except *
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void set_sprites(self, list sprites) except *
    cpdef VertexBuffer get_vertex_buffer(self)
    cpdef IndexBuffer get_index_buffer(self)
    cdef void _update(self) except *