from pyorama.data.handle cimport *
from pyorama.data.vector cimport *
from pyorama.math cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct SpriteBatchC:
    Handle handle
    VectorC sprites
    Handle vertex_buffer
    Handle index_buffer
    VectorC vertices
    VectorC indices

ctypedef struct SpriteVertexC:
    Vec3C position
    float rotation
    Vec2C scale
    Vec2C size
    Vec2C texcoord
    Vec2C offset
    Vec3C tint
    float alpha

cdef class SpriteBatch(HandleObject):

    cdef SpriteBatchC *get_ptr(self) except *
    cpdef void create(self, list sprites) except *
    cpdef void delete(self) except *
    cpdef void update(self) except *