cdef LightC *light_c_get_ptr(Handle light) except *:
    return <LightC *>graphics.slots.c_get_ptr(light)

"""
DEFAULTS:
color = 1, 1, 1
intensity = 1.0
range = 0? means infinite (per gltf, must be > 0)
inner_angle = 0 [0, pi/2)
outer_angle = pi/4 [0, pi/2)

attenuation = max( min( 1.0 - ( current_distance / range )4, 1 ), 0 ) / current_distance2
"""

cpdef Handle light_create(LightType type_, dict params) except *:
    cdef:
        Handle light

    if type_ == LIGHT_TYPE_POINT:
        light = light_create_point(
            <Vec3>params["position"],
            <float>params["range"],
            <uint32_t>params["color"],
            <float>params["intensity"],
        )
    elif type_ == LIGHT_TYPE_SPOT:
        light = light_create_spot(
            <Vec3>params["position"],
            <Vec3>params["direction"],
            <float>params["outer_angle"],
            <float>params["inner_angle"],
            <float>params["range"],
            <uint32_t>params["color"],
            <float>params["intensity"],
        )
    elif type_ == LIGHT_TYPE_DIRECTION:
        light = light_create_direction(
            <Vec3>params["direction"],
            <uint32_t>params["color"],
            <float>params["intensity"],
        )
    elif type_ == LIGHT_TYPE_AMBIENT:
        light = light_create_ambient(
            <uint32_t>params["color"],
            <float>params["intensity"],
        )
    return light

cpdef Handle light_create_point(Vec3 position, float range_, uint32_t color, float intensity) except *:
    cdef:
        Handle light
        LightC *light_ptr
    
    light = graphics.slots.c_create(GRAPHICS_SLOT_LIGHT)
    light_ptr = light_c_get_ptr(light)
    light_ptr.type_ = LIGHT_TYPE_POINT
    light_ptr.data.point.position = position.data
    light_ptr.data.point.range_ = range_
    light_ptr.data.point.color = color
    light_ptr.data.point.intensity = intensity
    return light

cpdef Handle light_create_spot(Vec3 position, Vec3 direction, float outer_angle, float inner_angle, float range_, uint32_t color, float intensity) except *:
    cdef:
        Handle light
        LightC *light_ptr
    
    light = graphics.slots.c_create(GRAPHICS_SLOT_LIGHT)
    light_ptr = light_c_get_ptr(light)
    light_ptr.type_ = LIGHT_TYPE_SPOT
    light_ptr.data.spot.position = position.data
    light_ptr.data.spot.direction = direction.data
    light_ptr.data.spot.outer_angle = outer_angle
    light_ptr.data.spot.inner_angle = inner_angle
    light_ptr.data.spot.range_ = range_
    light_ptr.data.spot.color = color
    light_ptr.data.spot.intensity = intensity
    return light

cpdef Handle light_create_direction(Vec3 direction, uint32_t color, float intensity) except *:
    cdef:
        Handle light
        LightC *light_ptr
    
    light = graphics.slots.c_create(GRAPHICS_SLOT_LIGHT)
    light_ptr = light_c_get_ptr(light)
    light_ptr.type_ = LIGHT_TYPE_DIRECTION
    light_ptr.data.direction.direction = direction.data
    light_ptr.data.direction.color = color
    light_ptr.data.direction.intensity = intensity
    return light

cpdef Handle light_create_ambient(uint32_t color, float intensity) except *:
    cdef:
        Handle light
        LightC *light_ptr
    
    light = graphics.slots.c_create(GRAPHICS_SLOT_LIGHT)
    light_ptr = light_c_get_ptr(light)
    light_ptr.type_ = LIGHT_TYPE_AMBIENT
    light_ptr.data.ambient.color = color
    light_ptr.data.ambient.intensity = intensity
    return light

cpdef void light_delete(Handle light) except *:
    cdef:
        LightC *light_ptr
    
    light_ptr = light_c_get_ptr(light)
    graphics.slots.c_delete(light)