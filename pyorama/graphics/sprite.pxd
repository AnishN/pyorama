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

    cpdef void get_color_texture(self, Texture color_texture) except *
    cpdef void get_normal_texture(self, Texture normal_texture) except *
    cpdef void get_position(self, Vec3 position) except *
    cpdef float get_rotation(self) except *
    cpdef void get_scale(self, Vec2 scale) except *
    cpdef void get_size(self, Vec2 size) except *
    cpdef list get_texcoords(self)
    cpdef void get_offset(self, Vec2 offset) except *
    cpdef void get_tint(self, Vec3 tint) except *
    cpdef float get_alpha(self) except *

    cpdef void set_color_texture(self, Texture color_texture) except *
    cpdef void set_normal_texture(self, Texture normal_texture) except *
    cpdef void set_position(self, Vec3 position) except *
    cpdef void set_rotation(self, float rotation) except *
    cpdef void set_scale(self, Vec2 scale) except *
    cpdef void set_size(self, Vec2 size) except *
    cpdef void set_texcoords(self, list texcoords) except *
    cpdef void set_offset(self, Vec2 offset) except *
    cpdef void set_tint(self, Vec3 tint) except *
    cpdef void set_alpha(self, float alpha) except *