cdef class Program:
    
    def __init__(self):
        raise NotImplementedError()

    def init(self, Shader vertex_shader, Shader fragment_shader):
        Program.c_init(self.graphics, self.handle, vertex_shader.handle, fragment_shader.handle)

    def clear(self):
        Program.c_clear(self.graphics, self.handle)
    
    def link(self):
        cdef:
            Error check
            char *error
            size_t error_len

        self.c_get_checked_ptr()#partially avoid ERROR_INVALID_HANDLE error checking later
        check = Program.c_link(self.graphics, self.handle)
        if check == ERROR_PROGRAM_LINK:
            check = Program.c_get_link_error(self.graphics, self.handle, &error, &error_len)
            if check == ERROR_OUT_OF_MEMORY:
                raise MemoryError("Program: cannot allocate memory for link error")
            raise ValueError("Program: cannot link; {0}".format(error))
        elif check == ERROR_INVALID_HANDLE:#one of the shaders must be invalid
            raise MemoryError("Program: invalid associated shader handle(s)")

    def bind(self):
        Program.c_bind(self.graphics, self.handle)
    
    def unbind(self):
        Program.c_unbind(self.graphics, self.handle)
    
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
        ItemSlotMap.c_get_ptr(&graphics.programs, program, <void **>&program_ptr)
        return program_ptr

    cdef ProgramC *c_get_checked_ptr(self) except *:
        cdef:
            ProgramC *program_ptr
            Error check
        check = ItemSlotMap.c_get_ptr(&self.graphics.programs, self.handle, <void **>&program_ptr)
        if check == ERROR_INVALID_HANDLE:
            raise MemoryError("Program: invalid handle")
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
    cdef Error c_link(GraphicsManager graphics, Handle program) nogil:
        cdef:
            ProgramC *program_ptr
            ShaderC *vs_ptr
            ShaderC *fs_ptr
            bint success
        
        program_ptr = Program.c_get_ptr(graphics, program)
        if program_ptr == NULL:
            return ERROR_INVALID_HANDLE
        vs_ptr = Shader.c_get_ptr(graphics, program_ptr.vertex_shader)
        fs_ptr = Shader.c_get_ptr(graphics, program_ptr.fragment_shader)
        if vs_ptr == NULL or fs_ptr == NULL:
            return ERROR_INVALID_HANDLE
        glAttachShader(program_ptr.id, vs_ptr.id)
        glAttachShader(program_ptr.id, fs_ptr.id)
        glLinkProgram(program_ptr.id)
        glGetProgramiv(program_ptr.id, GL_LINK_STATUS, <GLint *>&success)
        if not success:
            return ERROR_PROGRAM_LINK
        return ERROR_NONE

    @staticmethod
    cdef Error c_get_link_error(GraphicsManager graphics, Handle program, char **error, size_t *error_len) nogil:
        cdef ProgramC *program_ptr
        program_ptr = Program.c_get_ptr(graphics, program)
        if program_ptr == NULL:
            return ERROR_INVALID_HANDLE
        glGetProgramiv(program_ptr.id, GL_INFO_LOG_LENGTH, <GLint *>error_len)
        error[0] = <char *>calloc(error_len[0], sizeof(char))
        if error[0] == NULL:
            return ERROR_OUT_OF_MEMORY
        glGetProgramInfoLog(program_ptr.id, error_len[0], <GLsizei *>error_len, error[0])
        return ERROR_NONE

    """
    @staticmethod
    cdef bint c_setup_attributes(GraphicsManager graphics, Handle program) nogil:
        cdef:
            ProgramC *program_ptr
            size_t i
            GLint count
            size_t size
            GLenum type_
            GLint max_name_len#includes NULL terminator
            GLint name_len#does not include NULL terminator
            char *names
            char *name
            AttributeC attribute

        program_ptr = Program.c_get_ptr(graphics, program)
        if program_ptr == NULL:
            return False
        glGetProgramiv(program_ptr.id, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &max_name_len)
        glGetProgramiv(program_ptr.id, GL_ACTIVE_ATTRIBUTES, &count)
        ItemVector.c_init(&program_ptr.attributes, sizeof(AttributeC))
        names = <char *>calloc(count, max_name_len)
        if names == NULL:
            return False
        name = names
        for i in range(count):
            glGetActiveAttrib(program_ptr.id, i, 256, <GLsizei *>&name_len, <GLint *>&size, &type_, name)
            attribute.name = name
            attribute.name_len = name_len
            attribute.size = size
            attribute.type = <AttributeType>type_#wrong
            printf("%d\n", type_)
            attribute.location = i
            name += max_name_len
        free(names)
        return True

    @staticmethod
    cdef bint c_setup_uniforms(GraphicsManager graphics, Handle program) nogil:
        cdef:
            ProgramC *program_ptr
            size_t i
            GLint count
            size_t size
            GLenum type_
            GLint max_name_len#includes NULL terminator
            GLint name_len#does not include NULL terminator
            char *names
            char *name
            UniformC uniform

        program_ptr = Program.c_get_ptr(graphics, program)
        if program_ptr == NULL:
            return False
        glGetProgramiv(program_ptr.id, GL_ACTIVE_UNIFORM_MAX_LENGTH, &max_name_len)
        glGetProgramiv(program_ptr.id, GL_ACTIVE_UNIFORMS, &count)
        ItemVector.c_init(&program_ptr.uniforms, sizeof(UniformC))
        names = <char *>calloc(count, max_name_len)
        if names == NULL:
            return False
        name = names
        for i in range(count):
            glGetActiveUniform(program_ptr.id, i, 256, <GLsizei *>&name_len, <GLint *>&size, &type_, name)
            uniform.name = name
            uniform.name_len = name_len
            uniform.size = size
            uniform.type = <UniformType>type_#wrong
            printf("%d\n", type_)
            uniform.location = i
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