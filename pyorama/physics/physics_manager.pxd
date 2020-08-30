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

    cpdef float moment_for_circle(self, float mass, float inner_radius, float outer_radius, Vec2 offset) except *
    cpdef float area_for_circle(self, float inner_radius, float outer_radius) except *
    cpdef float moment_for_segment(self, float mass, Vec2 a, Vec2 b, float radius) except *
    cpdef float area_for_segment(self, Vec2 a, Vec2 b, float radius) except *
    cpdef float moment_for_poly(self, float mass, float[:, :] vertices, Vec2 offset, float radius) except *
    cpdef float area_for_poly(self, float[:, :] vertices, float radius) except *
    cpdef float centroid_for_poly(self, float[:, :] vertices) except *
    cpdef float moment_for_box(self, float mass, float width, float height) except *
    cpdef float moment_for_box_2(self, float mass, float left, float bottom, float right, float top) except *

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
    cpdef Handle body_get_space(self, Handle body) except *
    cpdef float body_get_mass(self, Handle body) except *
    cpdef void body_set_mass(self, Handle body, float mass) except *
    cpdef float body_get_moment(self, Handle body) except *
    cpdef void body_set_moment(self, Handle body, float moment) except *
    cpdef Vec2 body_get_position(self, Handle body)
    cpdef void body_set_position(self, Handle body, Vec2 position) except *
    cpdef Vec2 body_get_center_of_gravity(self, Handle body)
    cpdef void body_set_center_of_gravity(self, Handle body, Vec2 center_of_gravity) except *
    cpdef Vec2 body_get_velocity(self, Handle body)
    cpdef void body_set_velocity(self, Handle body, Vec2 velocity) except *
    cpdef Vec2 body_get_force(self, Handle body)
    cpdef void body_set_force(self, Handle body, Vec2 force) except *
    cpdef float body_get_angle(self, Handle body) except *
    cpdef void body_set_angle(self, Handle body, float angle) except *
    cpdef float body_get_angular_velocity(self, Handle body) except *
    cpdef void body_set_angular_velocity(self, Handle body, float angular_velocity) except *
    cpdef float body_get_torque(self, Handle body) except *
    cpdef void body_set_torque(self, Handle body, float torque) except *
    cpdef Vec2 body_get_rotation(self, Handle body)
    
    cdef ShapeC *shape_get_ptr(self, Handle shape) except *
    cpdef Handle shape_create_circle(self, Handle body, float radius, Vec2 offset) except *
    cpdef Handle shape_create_segment(self, Handle body, Vec2 a, Vec2 b, float radius) except *
    #cpdef Handle shape_create_poly_line(self) except *
    #cpdef Handle shape_create_poly_shape(self) except *
    #cpdef Handle shape_create_poly_box(self) except *
    cpdef void shape_delete(self, Handle shape) except *
    cpdef void shape_set_friction(self, Handle shape, float friction) except *

    cpdef void update(self, float delta) except *