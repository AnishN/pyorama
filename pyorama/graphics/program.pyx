cdef class Program(HandleObject):

    @staticmethod
    cdef Program c_from_handle(Handle handle):
        cdef Program obj
        if handle == 0:
            raise ValueError("Program: invalid handle")
        obj = Program.__new__(Program)
        obj.handle = handle
        return obj

    cdef ProgramC *c_get_ptr(self) except *:
        return <ProgramC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(Shader vertex_shader, Shader fragment_shader):
        cdef:
            Program program

        program = Program.__new__(Program)
        program.create(vertex_shader, fragment_shader)
        return program

    cpdef void create(self, Shader vertex_shader, Shader fragment_shader) except *:
        cdef:
            Handle program
            ProgramC *program_ptr
            ShaderC *vertex_shader_ptr
            ShaderC *fragment_shader_ptr
        
        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_PROGRAM)
        program_ptr = self.c_get_ptr()
        program_ptr.vertex_shader = vertex_shader.handle
        program_ptr.fragment_shader = fragment_shader.handle
        vertex_shader_ptr = vertex_shader.c_get_ptr()
        fragment_shader_ptr = fragment_shader.c_get_ptr()
        program_ptr.bgfx_id = bgfx_create_program(
            vertex_shader_ptr.bgfx_id, 
            fragment_shader_ptr.bgfx_id,
            False,
        )

    cpdef void delete(self) except *:
        cdef:
            ProgramC *program_ptr
        
        program_ptr = self.c_get_ptr()
        program_ptr.vertex_shader = 0
        program_ptr.fragment_shader = 0
        program_ptr.compute_shader = 0
        bgfx_destroy_program(program_ptr.bgfx_id)
        graphics.slots.c_delete(self.handle)
        self.handle = 0