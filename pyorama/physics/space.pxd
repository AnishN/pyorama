from pyorama.physics.physics_manager cimport *
from pyorama.physics.body cimport *
from pyorama.physics.shape cimport *

cdef class Space:
    cdef:
        readonly PhysicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef SpaceC *c_get_ptr_by_index(PhysicsManager manager, size_t index) except *
    @staticmethod
    cdef SpaceC *c_get_ptr_by_handle(PhysicsManager manager, Handle handle) except *
    cdef SpaceC *c_get_ptr(self) except *
    cpdef void create(self) except *
    cpdef void delete(self) except *
    cpdef Vec2 get_gravity(self)
    cpdef void set_gravity(self, Vec2 gravity) except *
    cpdef float get_damping(self) except *
    cpdef void set_damping(self, float damping) except *
    cpdef void add_body(self, Body body) except *
    cpdef void remove_body(self, Body body) except *
    cpdef void add_shape(self, Shape shape) except *
    cpdef void remove_shape(self, Shape shape) except *
    cpdef void step(self, float delta) except *