cdef ShaderC *shader_get_ptr(Handle shader) except *:
    return <ShaderC *>graphics.slots.c_get_ptr(shader)

cpdef Handle shader_create(ShaderType type_) except *:
    cdef:
        Handle shader
        ShaderC *shader_ptr
    
    shader = graphics.slots.c_create(GRAPHICS_SLOT_SHADER)
    shader_ptr = shader_get_ptr(shader)
    shader_ptr.type_ = type_
    return shader

cpdef void shader_delete(Handle shader) except *:
    cdef:
        ShaderC *shader_ptr
    
    shader_ptr = shader_get_ptr(shader)
    graphics.slots.c_delete(GRAPHICS_SLOT_SHADER)

cpdef void shader_compile_from_file(Handle shader, bytes file_path) except *: pass
cpdef void shader_compile_from_bytes(Handle shader, bytes source) except *: pass
cpdef ShaderType shader_get_type(Handle shader) except *:
    return shader_get_ptr(shader).type_