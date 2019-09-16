cdef class Shader:

    def __init__(self):
        raise NotImplementedError()

    def init(self, ShaderType type_, bytes source):
        Shader.c_init(self.graphics, self.handle, type_, source, len(source))

    def clear(self):
        Shader.c_clear(self.graphics, self.handle)

    def compile(self):
        cdef:
            Error check
            char *error
            size_t error_len

        self.c_get_checked_ptr()#avoid ERROR_INVALID_HANDLE error checking later
        check = Shader.c_compile(self.graphics, self.handle)
        if check == ERROR_SHADER_COMPILE:
            check = Shader.c_get_compile_error(self.graphics, self.handle, &error, &error_len)
            if check == ERROR_OUT_OF_MEMORY:
                raise MemoryError("Shader: cannot allocate memory for compile error")
            raise ValueError("Shader: cannot compile; {0}".format(error))

    @property
    def source(self):
        cdef ShaderC *shader_ptr
        shader_ptr = self.c_get_checked_ptr()
        return shader_ptr.source

    @staticmethod
    cdef ShaderC *c_get_ptr(GraphicsManager graphics, Handle shader) nogil:
        cdef ShaderC *shader_ptr
        ItemSlotMap.c_get_ptr(&graphics.shaders, shader, <void **>&shader_ptr)
        return shader_ptr

    cdef ShaderC *c_get_checked_ptr(self) except *:
        cdef:
            ShaderC *shader_ptr
            Error check
        check = ItemSlotMap.c_get_ptr(&self.graphics.shaders, self.handle, <void **>&shader_ptr)
        if check == ERROR_INVALID_HANDLE:
            raise MemoryError("Shader: invalid handle")
        return shader_ptr
    
    @staticmethod
    cdef void c_init(GraphicsManager graphics, Handle shader, ShaderType type_, char *source, size_t source_len) nogil:
        cdef ShaderC *shader_ptr
        shader_ptr = Shader.c_get_ptr(graphics, shader)
        if shader_ptr == NULL:
            return
        if type_ == SHADER_TYPE_VERTEX:
            shader_ptr.id = glCreateShader(GL_VERTEX_SHADER)
        else:
            shader_ptr.id = glCreateShader(GL_FRAGMENT_SHADER)
        shader_ptr.type = type_
        shader_ptr.source = source
        shader_ptr.source_len = source_len

    @staticmethod
    cdef void c_clear(GraphicsManager graphics, Handle shader):
        cdef ShaderC *shader_ptr
        shader_ptr = Shader.c_get_ptr(graphics, shader)
        if shader_ptr == NULL:
            return
        glDeleteShader(shader_ptr.id)
        shader_ptr.id = 0
        shader_ptr.type = SHADER_TYPE_VERTEX
        shader_ptr.source = NULL
        shader_ptr.source_len = 0

    @staticmethod
    cdef Error c_compile(GraphicsManager graphics, Handle shader) nogil:
        cdef:
            bint success
            ShaderC *shader_ptr
        shader_ptr = Shader.c_get_ptr(graphics, shader)
        if shader_ptr == NULL:
            return ERROR_INVALID_HANDLE
        glShaderSource(shader_ptr.id, 1, &shader_ptr.source, <GLint *>&shader_ptr.source_len)
        glCompileShader(shader_ptr.id)
        glGetShaderiv(shader_ptr.id, GL_COMPILE_STATUS, <GLint *>&success)
        if not success:
            return ERROR_SHADER_COMPILE
        return ERROR_NONE

    @staticmethod
    cdef Error c_get_compile_error(GraphicsManager graphics, Handle shader, char **error, size_t *error_len) nogil:
        cdef ShaderC *shader_ptr
        shader_ptr = Shader.c_get_ptr(graphics, shader)
        if shader_ptr == NULL:
            return ERROR_INVALID_HANDLE
        glGetShaderiv(shader_ptr.id, GL_INFO_LOG_LENGTH, <GLint *>error_len)
        error[0] = <char *>calloc(error_len[0], sizeof(char))
        if error[0] == NULL:
            return ERROR_OUT_OF_MEMORY
        glGetShaderInfoLog(shader_ptr.id, error_len[0], <GLsizei *>error_len, error[0])
        return ERROR_NONE