from pyorama.data.handle cimport *
from pyorama.math cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct SpriteBatchC:
    Handle handle
    Handle *sprites
    size_t num_sprites
    Handle vertex_buffer
    Handle index_buffer

cdef SpriteBatchC *sprite_batch_get_ptr(Handle sprite_batch) except *
cpdef Handle sprite_batch_create(Handle[::1] sprites) except *
cpdef void sprite_batch_delete(Handle sprite_batch) except *
cpdef void sprite_batch_update(Handle sprite_batch) except *