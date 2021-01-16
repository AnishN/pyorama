from pyorama.physics.physics_manager cimport *
from pyorama.physics.body cimport *

cdef class Shape:
    cdef:
        readonly PhysicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef ShapeC *get_ptr_by_index(PhysicsManager manager, size_t index) except *
    @staticmethod
    cdef ShapeC *get_ptr_by_handle(PhysicsManager manager, Handle handle) except *
    cdef ShapeC *get_ptr(self) except *
    @staticmethod
    cdef float c_moment_for_circle(float mass, float inner_radius, float outer_radius, Vec2 offset) except *
    @staticmethod
    cdef float c_area_for_circle(float inner_radius, float outer_radius) except *
    @staticmethod
    cdef float c_moment_for_segment(float mass, Vec2 a, Vec2 b, float radius) except *
    @staticmethod
    cdef float c_area_for_segment(Vec2 a, Vec2 b, float radius) except *
    @staticmethod
    cdef float c_moment_for_poly(float mass, float[:, :] vertices, Vec2 offset, float radius) except *
    @staticmethod
    cdef float c_area_for_poly(float[:, :] vertices, float radius) except *
    @staticmethod
    cdef float c_centroid_for_poly(float[:, :] vertices) except *
    @staticmethod
    cdef float c_moment_for_box(float mass, float width, float height) except *
    @staticmethod
    cdef float c_moment_for_box_2(float mass, float left, float bottom, float right, float top) except *

    cpdef void create_circle(self, Body body, float radius, Vec2 offset) except *
    cpdef void create_segment(self, Body body, Vec2 a, Vec2 b, float radius) except *
    #cpdef void create_poly_line(self) except *
    #cpdef void create_poly_shape(self) except *
    #cpdef void create_poly_box(self) except *
    cpdef void delete(self) except *
    cpdef void set_elasticity(self, float elasticity) except *
    cpdef void set_friction(self, float friction) except *