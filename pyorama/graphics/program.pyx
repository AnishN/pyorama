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

    def bind(self):
        Program.c_bind(self.graphics, self.handle)
    
    def unbind(self):
        Program.c_unbind(self.graphics, self.handle)
    
    def setup_attributes(self):
        pass
        
        """
        GLint i;
        GLint count;
        GLint size; // size of the variable
        GLenum type; // type of the variable (float, vec3 or mat4, etc)

        const GLsizei bufSize = 16; // maximum name length
        GLchar name[bufSize]; // variable name in GLSL
        GLsizei length; // name length

        //Attributes
        glGetProgramiv(program, GL_ACTIVE_ATTRIBUTES, &count);
        printf("Active Attributes: %d\n", count);

        for (i = 0; i < count; i++)
        {
            glGetActiveAttrib(program, (GLuint)i, bufSize, &length, &size, &type, name);

            printf("Attribute #%d Type: %u Name: %s\n", i, type, name);
        }

        //Uniforms
        glGetProgramiv(program, GL_ACTIVE_UNIFORMS, &count);
        printf("Active Uniforms: %d\n", count);

        for (i = 0; i < count; i++)
        {
            glGetActiveUniform(program, (GLuint)i, bufSize, &length, &size, &type, name);

            printf("Uniform #%d Type: %u Name: %s\n", i, type, name);
        }
        """
    
    def setup_uniforms(self):
        pass

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
        cdef ProgramC *program_ptr
        program_ptr = Program.c_get_ptr(graphics, program)
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
        success = Program._c_compile_gl(program_ptr, vs_ptr, fs_ptr)
        if not success:
            return False
        success = Program._c_setup_attributes(program_ptr)
        return success

    @staticmethod
    cdef bint _c_compile_gl(ProgramC *program_ptr, ShaderC *vs_ptr, ShaderC *fs_ptr) nogil:
        cdef bint success
        glAttachShader(program_ptr.id, vs_ptr.id)
        glAttachShader(program_ptr.id, fs_ptr.id)
        glLinkProgram(program_ptr.id)
        glGetProgramiv(program_ptr.id, GL_LINK_STATUS, <GLint *>&success)
        return success
    
    @staticmethod
    cdef bint _c_setup_attributes(ProgramC *program_ptr) nogil:
        cdef:
            size_t i
            GLint count
            size_t size
            GLenum type_
            GLint max_name_len#includes NULL terminator
            GLint name_len#does not include NULL terminator
            char *names
            char *name

        glGetProgramiv(program_ptr.id, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &max_name_len)
        glGetProgramiv(program_ptr.id, GL_ACTIVE_ATTRIBUTES, &count)
        """
        names = <char *>calloc(count, max_name_len)
        if names == NULL:
            return False
        name = names
        for i in range(count):
            glGetActiveAttrib(program_ptr.id, i, 256, <GLsizei *>&name_len, <GLint *>&size, &type_, name)
            #print(i, count, name, name_len, size)
            name += max_name_len
        free(names)
        return True
        """
    
    @staticmethod
    cdef void c_bind(GraphicsManager graphics, Handle program) nogil:
        cdef ProgramC *program_ptr
        program_ptr = Program.c_get_ptr(graphics, program)
        if program_ptr == NULL:
            return
        glUseProgram(program_ptr.id)
        
    @staticmethod
    cdef void c_unbind(GraphicsManager graphics, Handle program) nogil:
        glUseProgram(0)