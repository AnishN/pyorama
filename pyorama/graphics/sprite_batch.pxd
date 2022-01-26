from pyorama.data.handle cimport *
from pyorama.data.vector cimport *
from pyorama.math cimport *
from pyorama.graphics.vertex_buffer cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct SpriteBatchC:
    Handle handle
    VectorC sprites
    Handle vertex_buffer
    Handle index_buffer
    VectorC indices

ctypedef struct SpriteVertexC:
    Vec3C position
    float rotation
    Vec2C scale
    Vec2C size
    Vec2C texcoord
    Vec2C offset
    uint8_t[3] tint
    uint8_t alpha

cdef class SpriteBatch(HandleObject):

    cdef SpriteBatchC *get_ptr(self) except *
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void set_sprites(self, list sprites) except *
    cpdef void get_vertex_buffer(self, VertexBuffer buffer) except *
    cpdef void get_index_buffer(self, IndexBuffer buffer) except *
    cpdef void update(self) except *