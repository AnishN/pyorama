cdef uint8_t ITEM_TYPE = GRAPHICS_ITEM_TYPE_SHADER
ctypedef ShaderC ItemTypeC

cdef class Shader:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    @staticmethod
    cdef ItemTypeC *get_ptr_by_index(GraphicsManager manager, size_t index) except *:
        cdef:
            PyObject *slot_map_ptr
        slot_map_ptr = manager.slot_maps[<uint8_t>ITEM_TYPE]
        return <ItemTypeC *>(<ItemSlotMap>slot_map_ptr).items.c_get_ptr(index)

    @staticmethod
    cdef ItemTypeC *get_ptr_by_handle(GraphicsManager manager, Handle handle) except *:
        return <ItemTypeC *>manager.get_ptr(handle)

    cdef ItemTypeC *get_ptr(self) except *:
        return Shader.get_ptr_by_handle(self.manager, self.handle)

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

        self.handle = self.manager.create(ITEM_TYPE)
        shader_ptr = self.get_ptr()
        gl_type = c_shader_type_to_gl(type)
        gl_id = glCreateShader(gl_type); self.manager.c_check_gl()
        source_ptr = source
        source_length = len(source)
        glShaderSource(gl_id, 1, &source_ptr, <GLint*>&source_length); self.manager.c_check_gl()
        glCompileShader(gl_id); self.manager.c_check_gl()
        glGetShaderiv(gl_id, GL_COMPILE_STATUS, <GLint*>&compile_status); self.manager.c_check_gl()
        glGetShaderiv(gl_id, GL_INFO_LOG_LENGTH, <GLint*>&log_length); self.manager.c_check_gl()
        if not compile_status:
            log = <char*>malloc(log_length * sizeof(char))
            if log == NULL:
                raise MemoryError("Shader: could not allocate memory for compile error")
            glGetShaderInfoLog(gl_id, log_length, NULL, log); self.manager.c_check_gl()
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
        glDeleteShader(shader_ptr.gl_id); self.manager.c_check_gl()
        self.manager.delete(self.handle)
        self.handle = 0