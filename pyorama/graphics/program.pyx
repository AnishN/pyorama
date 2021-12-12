cdef class Program(HandleObject):

    cdef ProgramC *get_ptr(self) except *:
        return <ProgramC *>graphics.slots.c_get_ptr(self.handle)

    cpdef void create(self, Shader vertex_shader, Shader fragment_shader) except *:
        cdef:
            Handle program
            ProgramC *program_ptr
            ShaderC *vertex_shader_ptr
            ShaderC *fragment_shader_ptr
        
        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_PROGRAM)
        program_ptr = self.get_ptr()
        program_ptr.vertex_shader = vertex_shader.handle
        program_ptr.fragment_shader = fragment_shader.handle
        vertex_shader_ptr = vertex_shader.get_ptr()
        fragment_shader_ptr = fragment_shader.get_ptr()
        program_ptr.bgfx_id = bgfx_create_program(
            vertex_shader_ptr.bgfx_id, 
            fragment_shader_ptr.bgfx_id,
            False,
        )

    cpdef void delete(self) except *:
        cdef:
            ProgramC *program_ptr
        
        program_ptr = self.get_ptr()
        program_ptr.vertex_shader = 0
        program_ptr.fragment_shader = 0
        program_ptr.compute_shader = 0
        bgfx_destroy_program(program_ptr.bgfx_id)
        graphics.slots.c_delete(self.handle)
        self.handle = 0