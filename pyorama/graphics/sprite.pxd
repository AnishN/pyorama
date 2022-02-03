from pyorama.core.handle cimport *
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
    Vec4C texcoord_xywh
    Vec2C offset
    Vec3C tint
    float alpha

cdef SpriteC *c_sprite_get_ptr(Handle handle) except *
cdef Handle c_sprite_create() except *
cdef void c_sprite_delete(Handle handle) except *

cdef class Sprite(HandleObject):
    @staticmethod
    cdef Sprite c_from_handle(Handle handle)
    cdef SpriteC *c_get_ptr(self) except *
    cpdef void create(self, 
            Texture color_texture, Texture normal_texture=*, 
            Vec3 position=*, float rotation=*, Vec2 scale=*, 
            Vec2 size=*, Vec4 texcoord_xywh=*, Vec2 offset=*,
            Vec3 tint=*, float alpha=*,
    ) except *
    cpdef void delete(self) except *