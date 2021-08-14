cdef ProgramC *program_get_ptr(Handle program) except *:
    return <ProgramC *>graphics.slots.c_get_ptr(program)

cpdef Handle program_create(Handle vertex_shader, Handle fragment_shader) except *:
    cdef:
        Handle program
        ProgramC *program_ptr
        ShaderC *vertex_shader_ptr
        ShaderC *fragment_shader_ptr
    
    program = graphics.slots.c_create(GRAPHICS_SLOT_PROGRAM)
    program_ptr = program_get_ptr(program)
    program_ptr.vertex_shader = vertex_shader
    program_ptr.fragment_shader = fragment_shader
    vertex_shader_ptr = shader_get_ptr(vertex_shader)
    fragment_shader_ptr = shader_get_ptr(fragment_shader)
    program_ptr.bgfx_id = bgfx_create_program(
        vertex_shader_ptr.bgfx_id, 
        fragment_shader_ptr.bgfx_id,
        False,
    )
    return program

cpdef void program_delete(Handle program) except *:
    cdef:
        ProgramC *program_ptr
    
    program_ptr = program_get_ptr(program)
    program_ptr.vertex_shader = 0
    program_ptr.fragment_shader = 0
    program_ptr.compute_shader = 0
    bgfx_destroy_program(program_ptr.bgfx_id)
    graphics.slots.c_delete(program)