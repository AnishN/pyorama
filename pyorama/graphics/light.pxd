from pyorama.core.handle cimport *
from pyorama.math cimport *
from pyorama.graphics.graphics_system cimport *
from pyorama.libs.sdl2 cimport *
from pyorama.libs.c cimport *

cpdef enum LightType:
    LIGHT_TYPE_POINT
    LIGHT_TYPE_SPOT
    LIGHT_TYPE_DIRECTION
    #LIGHT_TYPE_AREA
    LIGHT_TYPE_AMBIENT

ctypedef struct PointLightC:
    Vec3C position
    float range_
    uint32_t color
    float intensity

ctypedef struct SpotLightC:
    Vec3C position
    Vec3C direction
    float outer_angle
    float inner_angle
    float range_
    uint32_t color
    float intensity

ctypedef struct DirectionLightC:
    Vec3C direction
    uint32_t color
    float intensity

ctypedef struct AmbientLightC:
    uint32_t color
    float intensity

ctypedef union LightDataC:
    PointLightC point
    SpotLightC spot
    DirectionLightC direction
    AmbientLightC ambient

ctypedef struct LightC:
    Handle handle
    LightType type_
    LightDataC data

cdef LightC *c_light_get_ptr(Handle handle) except *
cdef Handle c_light_create() except *
cdef void c_light_delete(Handle handle) except *

"""
cdef LightC *light_c_get_ptr(Handle light) except *
cpdef Handle light_create(LightType type_, dict params) except *
cpdef Handle light_create_point(Vec3 position, float range_, uint32_t color, float intensity) except *
cpdef Handle light_create_spot(Vec3 position, Vec3 direction, float outer_angle, float inner_angle, float range_, uint32_t color, float intensity) except *
cpdef Handle light_create_direction(Vec3 direction, uint32_t color, float intensity) except *
cpdef Handle light_create_ambient(uint32_t color, float intensity) except *
cpdef void light_delete(Handle light) except *
"""