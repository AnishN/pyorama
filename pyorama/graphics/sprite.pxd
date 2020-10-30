from pyorama.graphics.graphics_manager cimport *

cdef class Sprite:
    cdef:
        readonly Handle handle
        readonly GraphicsManager graphics
    
    cpdef void set_position(self, Vec2 position) except *
    cpdef Vec2 get_position(self)

    """
    cdef SpriteC *sprite_get_ptr(self, Handle sprite) except *
    cpdef Handle sprite_create(self, float width, float height) except *
    cpdef void sprite_delete(self, Handle sprite) except *
    cpdef void sprite_set_tex_coords(self, Handle sprite, float[::1] tex_coords) except *
    cpdef void sprite_set_tex_coords_as_rect(self, Handle sprite, Vec4 rect) except *
    cpdef void sprite_set_position(self, Handle sprite, Vec2 position) except *
    cpdef void sprite_set_anchor(self, Handle sprite, Vec2 anchor) except *
    cpdef void sprite_set_rotation(self, Handle sprite, float rotation) except *
    cpdef void sprite_set_scale(self, Handle sprite, Vec2 scale) except *
    cpdef void sprite_set_z_index(self, Handle sprite, float z_index) except *
    cpdef void sprite_set_visible(self, Handle sprite, bint visible) except *
    cpdef void sprite_set_tint(self, Handle sprite, Vec3 tint) except *
    cpdef void sprite_set_alpha(self, Handle sprite, float alpha) except *

    cpdef float[::1] sprite_get_tex_coords(self, Handle sprite) except *
    cpdef Vec4 sprite_get_tex_coords_as_rect(self, Handle sprite)
    cpdef Vec2 sprite_get_position(self, Handle sprite)
    cpdef Vec2 sprite_get_anchor(self, Handle sprite)
    cpdef float sprite_get_rotation(self, Handle sprite) except *
    cpdef Vec2 sprite_get_scale(self, Handle sprite)
    cpdef float sprite_get_z_index(self, Handle sprite) except *
    cpdef bint sprite_get_visible(self, Handle sprite) except *
    cpdef Vec3 sprite_get_tint(self, Handle sprite)
    cpdef float sprite_get_alpha(self, Handle sprite) except *
    """