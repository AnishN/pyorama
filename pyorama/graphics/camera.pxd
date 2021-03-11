from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.math3d cimport *

cdef extern from "camera_projection.h":
    cpdef enum ProjectionMode:
        PROJECTION_MODE_2D
        PROJECTION_MODE_3D

    ctypedef struct Projection2DC:
        float left
        float right
        float bottom
        float top
        float near
        float far

    ctypedef struct Projection3DC:
        float fovy
        float aspect
        float near
        float far

    ctypedef struct ProjectionC:
        ProjectionMode mode
        Projection2DC two_d
        Projection3DC three_d

ctypedef struct CameraC:
    Handle handle
    ProjectionC projection
    Vec3C position
    Vec3C forward
    Vec3C up
    Vec3C right
    float yaw
    float pitch
    float zoom

cdef class Camera:
    cdef:
        readonly GraphicsManager manager
        readonly Handle handle
    
    @staticmethod
    cdef CameraC *get_ptr_by_index(GraphicsManager manager, size_t index) except *
    @staticmethod
    cdef CameraC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *
    cdef CameraC *get_ptr(self) except *
    
    @staticmethod
    cdef uint8_t c_get_type() nogil
    @staticmethod
    cdef size_t c_get_size() nogil
    cpdef void create(self) except *
    cpdef void delete(self) except *
    
    cpdef void get_projection_matrix(self, Mat4 matrix) except *
    cpdef void set_projection_2d(self, float left, float right, float bottom, float top, float near, float far) except *
    cpdef void set_projection_3d(self, float fovy, float aspect, float near, float far) except *