from pyorama.graphics.graphics_manager cimport *

cdef class Sprite:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
        
    @staticmethod
    cdef SpriteC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef SpriteC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef SpriteC *get_ptr(self) except *

    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self, float width, float height) except *
    cpdef void delete(self) except *
    
    cpdef void set_tex_coords(self, float[::1] tex_coords) except *
    cpdef void set_tex_coords_as_rect(self, Vec4 rect) except *
    cpdef void set_position(self, Vec2 position) except *
    cpdef void set_anchor(self, Vec2 anchor) except *
    cpdef void set_rotation(self, float rotation) except *
    cpdef void set_scale(self, Vec2 scale) except *
    cpdef void set_z_index(self, float z_index) except *
    cpdef void set_visible(self, bint visible) except *
    cpdef void set_tint(self, Vec3 tint) except *
    cpdef void set_alpha(self, float alpha) except *

    cpdef float[::1] get_tex_coords(self) except *
    cpdef Vec4 get_tex_coords_as_rect(self)
    cpdef Vec2 get_position(self)
    cpdef Vec2 get_anchor(self)
    cpdef float get_rotation(self) except *
    cpdef Vec2 get_scale(self)
    cpdef float get_z_index(self) except *
    cpdef bint get_visible(self) except *
    cpdef Vec3 get_tint(self)
    cpdef float get_alpha(self) except *