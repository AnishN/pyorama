cdef class Shader:
    def __cinit__(self, GraphicsManager graphics):
        self.graphics = graphics

    def __dealloc__(self):
        self.graphics = None
    
    cdef ShaderC *get_ptr(self) except *:
        return self.graphics.shader_get_ptr(self.handle)

    cpdef void create(self, ShaderType type, bytes source) except *:
        cdef:
            ShaderC *shader_ptr
            uint32_t gl_id
            char *source_ptr
            size_t source_length
            uint32_t compile_status
            char *log
            int log_length
            uint32_t gl_type

        self.handle = self.graphics.shaders.c_create()
        shader_ptr = self.get_ptr()
        gl_type = c_shader_type_to_gl(type)
        gl_id = glCreateShader(gl_type); self.graphics.c_check_gl()
        source_ptr = source
        source_length = len(source)
        glShaderSource(gl_id, 1, &source_ptr, <GLint*>&source_length); self.graphics.c_check_gl()
        glCompileShader(gl_id); self.graphics.c_check_gl()
        glGetShaderiv(gl_id, GL_COMPILE_STATUS, <GLint*>&compile_status); self.graphics.c_check_gl()
        glGetShaderiv(gl_id, GL_INFO_LOG_LENGTH, <GLint*>&log_length); self.graphics.c_check_gl()
        if not compile_status:
            log = <char*>malloc(log_length * sizeof(char))
            if log == NULL:
                raise MemoryError("Shader: could not allocate memory for compile error")
            glGetShaderInfoLog(gl_id, log_length, NULL, log); self.graphics.c_check_gl()
            raise ValueError("Shader: failed to compile (GL error message below)\n{0}".format(log.decode("utf-8")))
        shader_ptr.gl_id = gl_id
        shader_ptr.type = type
    
    cpdef void create_from_file(self, ShaderType type, bytes file_path) except *:
        cdef:
            object in_file
            bytes source
        in_file = open(file_path, "rb")
        source = in_file.read()
        in_file.close()
        self.create(type, source)

    cpdef void delete(self) except *:
        cdef:
            ShaderC *shader_ptr
        shader_ptr = self.get_ptr()
        glDeleteShader(shader_ptr.gl_id); self.graphics.c_check_gl()
        self.graphics.shaders.c_delete(self.handle)
        self.handle = 0