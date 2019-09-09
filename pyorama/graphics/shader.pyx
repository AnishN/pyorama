cdef class Shader:

    def __init__(self):
        raise NotImplementedError()

    def init(self, ShaderType type_, bytes source):
        cdef:
            ShaderC *shader_ptr
        shader_ptr = self.c_get_checked_ptr()
        Shader.c_init(shader_ptr, type_, source, len(source))

    def clear(self):
        cdef ShaderC *shader_ptr
        shader_ptr = self.c_get_checked_ptr()
        Shader.c_clear(shader_ptr)

    def compile(self):
        cdef ShaderC *shader_ptr
        shader_ptr = self.c_get_checked_ptr()
        Shader.c_compile(shader_ptr)

    cdef ShaderC *c_get_checked_ptr(self) except *:
        cdef ShaderC *shader_ptr
        item_slot_map_get_ptr(&self.graphics.shaders, self.handle, <void **>&shader_ptr)
        if shader_ptr == NULL:
            raise MemoryError("Shader: cannot get ptr from invalid handle")
        return shader_ptr

    @staticmethod
    cdef void c_init(ShaderC *shader_ptr, ShaderType type_, char *source, size_t source_len) nogil:
        if type_ == SHADER_TYPE_VERTEX:
            shader_ptr.id = glCreateShader(GL_VERTEX_SHADER)
        else:
            shader_ptr.id = glCreateShader(GL_FRAGMENT_SHADER)
        shader_ptr.type = type_
        shader_ptr.source = source
        shader_ptr.source_len = source_len
    
    @staticmethod
    cdef void c_clear(ShaderC *shader_ptr):
        glDeleteShader(shader_ptr.id)
        shader_ptr.id = 0
        shader_ptr.type = SHADER_TYPE_VERTEX
        shader_ptr.source = NULL
        shader_ptr.source_len = 0

    @staticmethod
    cdef bint c_compile(ShaderC *shader_ptr) nogil:
        cdef bint success
        glCompileShader(shader_ptr.id)
        glGetShaderiv(shader_ptr.id, GL_COMPILE_STATUS, <GLint *>&success)
        return success