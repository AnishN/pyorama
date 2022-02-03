import os

cdef ShaderC *c_shader_get_ptr(Handle handle) except *:
    cdef:
        ShaderC *ptr
    CHECK_ERROR(slot_map_get_ptr(&graphics_system.shaders, handle, <void **>&ptr))
    return ptr

cdef Handle c_shader_create() except *:
    cdef:
        Handle handle
    CHECK_ERROR(slot_map_create(&graphics_system.shaders, &handle))
    return handle

cdef void c_shader_delete(Handle handle) except *:
    slot_map_delete(&graphics_system.shaders, handle)

cdef class Shader(HandleObject):

    @staticmethod
    cdef Shader c_from_handle(Handle handle):
        cdef Shader obj
        if handle == 0:
            raise ValueError("Shader: invalid handle")
        obj = Shader.__new__(Shader)
        obj.handle = handle
        return obj

    cdef ShaderC *c_get_ptr(self) except *:
        return c_shader_get_ptr(self.handle)

    @staticmethod
    def init_create_from_binary_file(ShaderType type_, bytes file_path):
        cdef:
            Shader shader

        shader = Shader.__new__(Shader)
        shader.create_from_binary_file(type_, file_path)
        return shader

    cpdef void create_from_binary_file(self, ShaderType type_, bytes file_path) except *:
        cdef:
            ShaderC *shader_ptr
            object in_file
            bytes file_data
            size_t file_size
            bgfx_memory_t *file_memory
        
        self.handle = c_shader_create()
        shader_ptr = self.c_get_ptr()
        shader_ptr.type_ = type_
        in_file = open(file_path, "rb")
        file_data = in_file.read()
        in_file.close()
        file_size = <size_t>len(file_data)
        file_memory = bgfx_copy(<char *>file_data, file_size)
        shader_ptr.bgfx_id = bgfx_create_shader(file_memory)

    @staticmethod
    def init_create_from_source_file(ShaderType type_, bytes file_path):
        cdef:
            Shader shader

        shader = Shader()
        shader.create_from_source_file(type_, file_path)
        return shader

    cpdef void create_from_source_file(self, ShaderType type_, bytes file_path) except *:
        cdef:
            ShaderC *shader_ptr
            object in_file
            bytes file_data
            size_t file_size
            bgfx_memory_t *file_memory
            bytes bin_file_path

        bin_file_path = os.path.splitext(file_path)[0] + b".bin"
        utils_runtime_compile_shader(file_path, bin_file_path, type_)
        self.handle = c_shader_create()
        shader_ptr = self.c_get_ptr()
        shader_ptr.type_ = type_
        in_file = open(bin_file_path, "rb")
        file_data = in_file.read()
        in_file.close()
        file_size = <size_t>len(file_data)
        file_memory = bgfx_copy(<char *>file_data, file_size)
        shader_ptr.bgfx_id = bgfx_create_shader(file_memory)

    cpdef void delete(self) except *:
        cdef:
            ShaderC *shader_ptr
        
        shader_ptr = self.c_get_ptr()
        #note: file_memory freed by bgfx internally
        bgfx_destroy_shader(shader_ptr.bgfx_id)
        c_shader_delete(self.handle)
        self.handle = 0

    cpdef ShaderType get_type(self) except *:
        return self.c_get_ptr().type_