cdef class Shader:

    def __init__(self):
        raise NotImplementedError()

    def init(self, ShaderType type_, bytes source):
        Shader.c_init(self.graphics, self.handle, type_, source, len(source))

    def clear(self):
        Shader.c_clear(self.graphics, self.handle)

    def compile(self):
        cdef:
            bint success
            ShaderC *shader_ptr
            char *info_log
            size_t info_len

        success = Shader.c_compile(self.graphics, self.handle)
        if not success:
            shader_ptr = self.c_get_checked_ptr()
            glGetShaderiv(shader_ptr.id, GL_INFO_LOG_LENGTH, <GLint *>&info_len)
            info_log = <char *>calloc(info_len, sizeof(char))
            if info_log == NULL:
                raise MemoryError("Shader: cannot alloc memory for compile error")
            glGetShaderInfoLog(shader_ptr.id, info_len, <GLsizei *>&info_len, info_log)
            raise ValueError("Shader: cannot compile\n{0}".format(info_log))

    @staticmethod
    cdef ShaderC *c_get_ptr(GraphicsManager graphics, Handle shader) nogil:
        cdef ShaderC *shader_ptr
        item_slot_map_get_ptr(&graphics.shaders, shader, <void **>&shader_ptr)
        return shader_ptr

    cdef ShaderC *c_get_checked_ptr(self) except *:
        cdef ShaderC *shader_ptr
        shader_ptr = Shader.c_get_ptr(self.graphics, self.handle)
        if shader_ptr == NULL:
            raise MemoryError("Shader: cannot get ptr from invalid handle")
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
    cdef bint c_compile(GraphicsManager graphics, Handle shader) nogil:
        cdef:
            bint success
            ShaderC *shader_ptr
        
        shader_ptr = Shader.c_get_ptr(graphics, shader)
        if shader_ptr == NULL:
            return False
        glShaderSource(shader_ptr.id, 1, &shader_ptr.source, <GLint *>&shader_ptr.source_len)
        glCompileShader(shader_ptr.id)
        glGetShaderiv(shader_ptr.id, GL_COMPILE_STATUS, <GLint *>&success)
        return success