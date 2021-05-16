from pyorama.core.handle cimport *
from pyorama.libs.chipmunk cimport *
from pyorama.math3d.vec2 cimport *
from pyorama.physics.physics_enums cimport *
from pyorama.physics.physics_manager cimport *
from pyorama.physics.physics_structs cimport *
from pyorama.physics.space cimport *

cdef class Body:
    cdef:
        readonly PhysicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef BodyC *c_get_ptr_by_index(PhysicsManager manager, size_t index) except *
    @staticmethod
    cdef BodyC *c_get_ptr_by_handle(PhysicsManager manager, Handle handle) except *
    cdef BodyC *c_get_ptr(self) except *
    cpdef void create(self, float mass=*, float moment=*, BodyType type=*) except *
    cpdef void delete(self) except *
    cpdef Space get_space(self)
    cpdef float get_mass(self) except *
    cpdef void set_mass(self, float mass) except *
    cpdef float get_moment(self) except *
    cpdef void set_moment(self, float moment) except *
    cpdef Vec2 get_position(self)
    cpdef void set_position(self, Vec2 position) except *
    cpdef Vec2 get_center_of_gravity(self)
    cpdef void set_center_of_gravity(self, Vec2 center_of_gravity) except *
    cpdef Vec2 get_velocity(self)
    cpdef void set_velocity(self, Vec2 velocity) except *
    cpdef Vec2 get_force(self)
    cpdef void set_force(self, Vec2 force) except *
    cpdef float get_angle(self) except *
    cpdef void set_angle(self, float angle) except *
    cpdef float get_angular_velocity(self) except *
    cpdef void set_angular_velocity(self, float angular_velocity) except *
    cpdef float get_torque(self) except *
    cpdef void set_torque(self, float torque) except *
    cpdef Vec2 get_rotation(self)