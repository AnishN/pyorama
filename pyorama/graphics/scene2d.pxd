from pyorama.core.handle cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.graphics.sprite cimport *

ctypedef struct Scene2DC:
    Handle handle
    VectorC sprites
    VectorC circles
    VectorC ellipses
    VectorC lines
    VectorC rectangles
    VectorC polygons

cdef Scene2DC *c_scene2d_get_ptr(Handle handle) except *
cdef Handle c_scene2d_create() except *
cdef void c_scene2d_delete(Handle handle) except *

cdef class Scene2D(HandleObject):
    @staticmethod
    cdef Scene2D c_from_handle(Handle handle)
    cdef Scene2DC *c_get_ptr(self) except *
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef void add_sprite(self, Sprite sprite) except *
    cpdef void remove_sprite(self, Sprite sprite) except *
    cpdef void add_sprites(self, list sprites) except *
    cpdef void remove_sprites(self, list sprites) except *
    cpdef void update(self) except *