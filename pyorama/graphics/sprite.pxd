from pyorama.data.handle cimport *
from pyorama.math cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.graphics.texture cimport *
from pyorama.graphics.transform cimport *

ctypedef struct SpriteC:
    Handle handle
    Handle color_texture
    Handle normal_texture
    Vec3C position
    float rotation
    Vec2C scale
    Vec2C size
    Vec2C[4] texcoords
    Vec2C offset
    Vec3C tint
    float alpha

cdef class Sprite(HandleObject):
    cdef SpriteC *get_ptr(self) except *
    cpdef void create(self, 
            Texture color_texture, Texture normal_texture=*, 
            Vec3 position=*, float rotation=*, Vec2 scale=*, 
            Vec2 size=*, list texcoords=*, Vec2 offset=*,
            Vec3 tint=*, float alpha=*,
    ) except *
    cpdef void delete(self) except *