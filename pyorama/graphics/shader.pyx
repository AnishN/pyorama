cdef ShaderC *shader_get_ptr(Handle shader) except *:
    return <ShaderC *>graphics.slots.c_get_ptr(shader)

cpdef Handle shader_create_from_file(ShaderType type_, bytes file_path) except *:
    cdef:
        Handle shader
        ShaderC *shader_ptr
        object in_file
        bytes file_data
        size_t file_size
        bgfx_memory_t *file_memory
    
    shader = graphics.slots.c_create(GRAPHICS_SLOT_SHADER)
    shader_ptr = shader_get_ptr(shader)
    shader_ptr.type_ = type_
    in_file = open(file_path, "rb")
    file_data = in_file.read()
    in_file.close()
    file_size = <size_t>len(file_data)
    file_memory = bgfx_copy(<char *>file_data, file_size)
    shader_ptr.bgfx_id = bgfx_create_shader(file_memory)
    return shader

cpdef void shader_delete(Handle shader) except *:
    cdef:
        ShaderC *shader_ptr
    
    shader_ptr = shader_get_ptr(shader)
    #note: file_memory freed by bgfx internally
    bgfx_destroy_shader(shader_ptr.bgfx_id)
    graphics.slots.c_delete(shader)

cpdef ShaderType shader_get_type(Handle shader) except *:
    return shader_get_ptr(shader).type_