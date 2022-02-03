from cython cimport view
from pyorama.core.handle cimport *
from pyorama.core.vector cimport *
from pyorama.math cimport *
from pyorama.graphics.sprite cimport *
from pyorama.graphics.vertex_buffer cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct SpriteBatchC:
    Handle handle
    VectorC sprites
    VectorC sorted_sprites
    size_t first_alpha_index
    Handle vertex_buffer
    Handle index_buffer
    VectorC indices

ctypedef packed struct SpriteVertexC:
    Vec3C position
    float rotation
    Vec2C scale
    Vec2C size
    Vec2C texcoord
    Vec2C offset
    float tint_alpha#packing 4x uint8
    Vec3C padding

cdef SpriteBatchC *c_sprite_batch_get_ptr(Handle handle) except *
cdef Handle c_sprite_batch_create() except *
cdef void c_sprite_batch_delete(Handle handle) except *

cdef class SpriteBatch(HandleObject):
    @staticmethod
    cdef SpriteBatch c_from_handle(Handle handle)
    cdef SpriteBatchC *c_get_ptr(self) except *
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void set_sprites(self, list sprites) except *
    cpdef void get_vertex_buffer(self, VertexBuffer buffer) except *
    cpdef void get_index_buffer(self, IndexBuffer buffer) except *
    cpdef void update(self) except *
    cdef void c_sort_back_to_front(self) except *