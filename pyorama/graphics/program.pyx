cdef class Program:
    
    def __init__(self):
        raise NotImplementedError()

    def init(self, Shader vertex_shader, Shader fragment_shader):
        Program.c_init(self.graphics, self.handle, vertex_shader.handle, fragment_shader.handle)

    def clear(self):
        Program.c_clear(self.graphics, self.handle)
    
    def compile(self):
        cdef bint success
        success = Program.c_compile(self.graphics, self.handle)
        if not success:
            raise ValueError("Program: cannot compile")
    
    @property
    def vertex_shader(self):
        cdef:
            ProgramC *program_ptr
            Shader shader
        program_ptr = self.c_get_checked_ptr()
        shader = Shader.__new__(Shader)
        shader.graphics = self.graphics
        shader.handle = program_ptr.vertex_shader
        return shader
    
    @property
    def fragment_shader(self):
        cdef:
            ProgramC *program_ptr
            Shader shader
        program_ptr = self.c_get_checked_ptr()
        shader = Shader.__new__(Shader)
        shader.graphics = self.graphics
        shader.handle = program_ptr.fragment_shader
        return shader

    @staticmethod
    cdef ProgramC *c_get_ptr(GraphicsManager graphics, Handle program) nogil:
        cdef ProgramC *program_ptr
        item_slot_map_get_ptr(&graphics.programs, program, <void **>&program_ptr)
        return program_ptr

    cdef ProgramC *c_get_checked_ptr(self) except *:
        cdef ProgramC *program_ptr
        program_ptr = Program.c_get_ptr(self.graphics, self.handle)
        if program_ptr == NULL:
            raise MemoryError("Program: cannot get ptr from invalid handle")
        return program_ptr
    
    @staticmethod
    cdef void c_init(GraphicsManager graphics, Handle program, Handle vertex_shader, Handle fragment_shader) nogil:
        cdef ProgramC *program_ptr = Program.c_get_ptr(graphics, program)
        if program_ptr == NULL:
            return
        program_ptr.id = glCreateProgram()
        program_ptr.vertex_shader = vertex_shader
        program_ptr.fragment_shader = fragment_shader

    @staticmethod
    cdef void c_clear(GraphicsManager graphics, Handle program) nogil:
        cdef ProgramC *program_ptr = Program.c_get_ptr(graphics, program)
        if program_ptr == NULL:
            return
        glDeleteProgram(program_ptr.id)
        program_ptr.id = 0
        program_ptr.vertex_shader = 0
        program_ptr.fragment_shader = 0

    @staticmethod
    cdef bint c_compile(GraphicsManager graphics, Handle program) nogil:
        cdef:
            ProgramC *program_ptr
            ShaderC *vs_ptr
            ShaderC *fs_ptr
            bint success
        
        program_ptr = Program.c_get_ptr(graphics, program)
        if program_ptr == NULL:
            return False
        vs_ptr = Shader.c_get_ptr(graphics, program_ptr.vertex_shader)
        fs_ptr = Shader.c_get_ptr(graphics, program_ptr.fragment_shader)
        if vs_ptr == NULL or fs_ptr == NULL:
            return False
        glAttachShader(program_ptr.id, vs_ptr.id)
        glAttachShader(program_ptr.id, fs_ptr.id)
        glLinkProgram(program_ptr.id)
        glGetProgramiv(program_ptr.id, GL_LINK_STATUS, <GLint *>&success)
        return success