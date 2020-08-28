cimport cython
from pyorama.core.handle cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.libs.c cimport *
from pyorama.libs.chipmunk cimport *
from pyorama.math3d cimport *
from pyorama.physics.physics_enums cimport *
from pyorama.physics.physics_structs cimport *
from pyorama.physics.physics_utils cimport *

@cython.final
cdef class PhysicsManager:
    cdef:
        ItemSlotMap spaces
        ItemSlotMap bodies
        ItemSlotMap shapes

    cdef void c_create_slot_maps(self) except *
    cdef void c_delete_slot_maps(self) except *

    cdef SpaceC *space_get_ptr(self, Handle space) except *
    cpdef Handle space_create(self) except *
    cpdef void space_delete(self, Handle space) except *
    cpdef Vec2 space_get_gravity(self, Handle space)
    cpdef void space_set_gravity(self, Handle space, Vec2 gravity) except *
    cpdef void space_add_body(self, Handle space, Handle body) except *
    cpdef void space_remove_body(self, Handle space, Handle body) except *
    cpdef void space_add_shape(self, Handle space, Handle shape) except *
    cpdef void space_remove_shape(self, Handle space, Handle shape) except *
    cpdef void space_step(self, Handle space, float delta) except *
    
    cdef BodyC *body_get_ptr(self, Handle body) except *
    cpdef Handle body_create(self, float mass=*, float moment=*, BodyType type=*) except *
    cpdef void body_delete(self, Handle body) except *
    cpdef Vec2 body_get_position(self, Handle body)
    cpdef void body_set_position(self, Handle body, Vec2 position) except *
    cpdef Vec2 body_get_velocity(self, Handle body)

    
    cdef ShapeC *shape_get_ptr(self, Handle shape) except *
    cpdef Handle shape_create_circle(self, Handle body, float radius, Vec2 offset) except *
    cpdef Handle shape_create_segment(self, Handle body, Vec2 a, Vec2 b, float radius) except *
    #cpdef Handle shape_create_poly_line(self) except *
    #cpdef Handle shape_create_poly_shape(self) except *
    #cpdef Handle shape_create_poly_box(self) except *
    cpdef void shape_delete(self, Handle shape) except *
    cpdef void shape_set_friction(self, Handle shape, float friction) except *