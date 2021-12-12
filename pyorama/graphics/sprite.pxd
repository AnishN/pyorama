from pyorama.data.handle cimport *
from pyorama.math cimport *
from pyorama.graphics.graphics_system cimport *

ctypedef struct SpriteC:
    Handle handle
    Handle color_texture
    Handle normal_texture
    Handle transform
    Vec2C[4] texcoords
    Vec3C tint
    float alpha

cdef SpriteC *sprite_get_ptr(Handle sprite) except *
cpdef Handle sprite_create(Handle color_texture, Handle normal_texture=*, Handle transform=*, list texcoords=*, Vec3 tint=*, float alpha=*) except *
cpdef void sprite_delete(Handle sprite) except *