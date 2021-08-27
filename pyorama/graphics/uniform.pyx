"""
bgfx_uniform_handle_t bgfx_create_uniform(const char* _name, bgfx_uniform_type_t _type, uint16_t _num)
void bgfx_get_uniform_info(bgfx_uniform_handle_t _handle, bgfx_uniform_info_t * _info)
void bgfx_set_uniform(bgfx_uniform_handle_t _handle, const void* _value, uint16_t _num)
void bgfx_destroy_uniform(bgfx_uniform_handle_t _handle)

char name[256]
bgfx_uniform_type_t type
uint16_t num
"""

cdef UniformC *uniform_get_ptr(Handle uniform) except *:
    return <UniformC *>graphics.slots.c_get_ptr(uniform)

cpdef Handle uniform_create(bytes name, UniformType type_) except *:
    cdef:
        Handle uniform
        UniformC *uniform_ptr
    
    uniform = graphics.slots.c_create(GRAPHICS_SLOT_UNIFORM)
    uniform_ptr = uniform_get_ptr(uniform)
    uniform_ptr.bgfx_id = bgfx_create_uniform(
        _name=name, 
        _type=<bgfx_uniform_type_t>type_, 
        _num=1,
    )
    return uniform

cpdef void uniform_delete(Handle uniform) except *:
    cdef:
        UniformC *uniform_ptr
    
    uniform_ptr = uniform_get_ptr(uniform)
    bgfx_destroy_uniform(uniform_ptr.bgfx_id)
    graphics.slots.c_delete(uniform)

cpdef void uniform_set_sampler(Handle uniform, uint32_t value) except *:
    cdef UniformC *uniform_ptr = uniform_get_ptr(uniform)
    bgfx_set_uniform(uniform_ptr.bgfx_id, &value, 1)

cpdef void uniform_set_vec4(Handle uniform, Vec4 value) except *:
    cdef UniformC *uniform_ptr = uniform_get_ptr(uniform)
    bgfx_set_uniform(uniform_ptr.bgfx_id, &value.data, 1)

cpdef void uniform_set_mat3(Handle uniform, Mat3 value) except *:
    cdef UniformC *uniform_ptr = uniform_get_ptr(uniform)
    bgfx_set_uniform(uniform_ptr.bgfx_id, &value.data, 1)

cpdef void uniform_set_mat4(Handle uniform, Mat4 value) except *:
    cdef UniformC *uniform_ptr = uniform_get_ptr(uniform)
    bgfx_set_uniform(uniform_ptr.bgfx_id, &value.data, 1)

cpdef void uniform_set(Handle uniform, object value) except *:
    cdef UniformType type_ = uniform_get_type(uniform)
    if type_ == UNIFORM_TYPE_SAMPLER: 
        uniform_set_sampler(uniform, <uint32_t>value)
    elif type_ == UNIFORM_TYPE_VEC4:
        uniform_set_vec4(uniform, <Vec4>value)
    elif type_ == UNIFORM_TYPE_MAT3:
        uniform_set_mat3(uniform, <Mat3>value)
    elif type_ == UNIFORM_TYPE_MAT4:
        uniform_set_mat4(uniform, <Mat4>value)

cpdef bytes uniform_get_name(Handle uniform):
    cdef:
        UniformC *uniform_ptr
        bgfx_uniform_info_t info
    
    uniform_ptr = uniform_get_ptr(uniform)
    bgfx_get_uniform_info(uniform_ptr.bgfx_id, &info)
    return info.name

cpdef UniformType uniform_get_type(Handle uniform) except *:
    cdef:
        UniformC *uniform_ptr
        bgfx_uniform_info_t info
    
    uniform_ptr = uniform_get_ptr(uniform)
    bgfx_get_uniform_info(uniform_ptr.bgfx_id, &info)
    return <UniformType>info.type
