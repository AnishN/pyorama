from pyorama.app cimport *
from pyorama.core.handle cimport *
from pyorama.math cimport *

cpdef enum CameraProjType:
    CAMERA_PROJ_TYPE_ORTHOGRAPHIC
    CAMERA_PROJ_TYPE_PERSPECTIVE

ctypedef struct CameraProjInfoOrthographicC:
    float x_mag
    float y_mag
    float z_near
    float z_far

ctypedef struct CameraProjInfoPerspectiveC:
    float aspect_ratio
    float y_fov
    float z_near
    float z_far

ctypedef union CameraProjInfoC:
    CameraProjInfoOrthographicC orthographic
    CameraProjInfoPerspectiveC perspective

ctypedef struct CameraC:
    Handle handle
    CameraProjType proj_type
    CameraProjInfoC proj_info
    Mat4C proj_mat

cdef class Camera(HandleObject):
    @staticmethod
    cdef Camera c_from_handle(Handle handle)
    cdef CameraC *c_get_ptr(self) except *
    cpdef void create_orthographic(self, float x_mag, float y_mag, float z_near, float z_far) except *
    cpdef void create_perspective(self, float aspect_ratio, float y_fov, float z_near, float z_far) except *
    cpdef void delete(self) except *
    cpdef void get_proj_mat(self, Mat4 proj_mat) except *