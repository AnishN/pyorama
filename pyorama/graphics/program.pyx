ctypedef ProgramC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef AttributeType c_attribute_type_from_gl(uint32_t gl_type) except *:
    if gl_type == GL_INT:
        return ATTRIBUTE_TYPE_INT
    elif gl_type == GL_FLOAT:
        return ATTRIBUTE_TYPE_FLOAT
    elif gl_type == GL_FLOAT_VEC2:
        return ATTRIBUTE_TYPE_VEC2
    elif gl_type == GL_FLOAT_VEC3:
        return ATTRIBUTE_TYPE_VEC3
    elif gl_type == GL_FLOAT_VEC4:
        return ATTRIBUTE_TYPE_VEC4
    elif gl_type == GL_FLOAT_MAT2:
        return ATTRIBUTE_TYPE_MAT2
    elif gl_type == GL_FLOAT_MAT3:
        return ATTRIBUTE_TYPE_MAT3
    elif gl_type == GL_FLOAT_MAT4:
        return ATTRIBUTE_TYPE_MAT4
    else:
        raise ValueError("Program: unsupported OpenGL attribute data type {0}".format(gl_type))

cdef UniformType c_uniform_type_from_gl(uint32_t gl_type) except *:
    if gl_type == GL_INT or gl_type == GL_SAMPLER_2D or gl_type == GL_SAMPLER_CUBE:
        return UNIFORM_TYPE_INT
    elif gl_type == GL_FLOAT:
        return UNIFORM_TYPE_FLOAT
    elif gl_type == GL_FLOAT_VEC2:
        return UNIFORM_TYPE_VEC2
    elif gl_type == GL_FLOAT_VEC3:
        return UNIFORM_TYPE_VEC3
    elif gl_type == GL_FLOAT_VEC4:
        return UNIFORM_TYPE_VEC4
    elif gl_type == GL_FLOAT_MAT2:
        return UNIFORM_TYPE_MAT2
    elif gl_type == GL_FLOAT_MAT3:
        return UNIFORM_TYPE_MAT3
    elif gl_type == GL_FLOAT_MAT4:
        return UNIFORM_TYPE_MAT4
    else:
        raise ValueError("Program: unsupported OpenGL uniform data type {0}".format(gl_type))

cdef class Program:
    def __cinit__(self, GraphicsManager manager):
        self.handle = 0
        self.manager = manager

    def __dealloc__(self):
        self.handle = 0
        self.manager = None
    
    cdef ItemTypeC *c_get_ptr(self) except *:
        return <ItemTypeC *>self.manager.c_get_ptr(self.handle)

    @staticmethod
    cdef uint8_t c_get_type() nogil:
        return ITEM_TYPE

    @staticmethod
    def get_type():
        return ITEM_TYPE

    @staticmethod
    cdef size_t c_get_size() nogil:
        return ITEM_SIZE

    @staticmethod
    def get_size():
        return ITEM_SIZE

    cpdef void create(self, Shader vertex, Shader fragment) except *:
        cdef:
            ProgramC *program_ptr
        self.handle = self.manager.create(ITEM_TYPE)
        program_ptr = self.c_get_ptr()
        program_ptr.gl_id = glCreateProgram(); self.manager.c_check_gl()
        program_ptr.vertex = vertex.handle
        program_ptr.fragment = fragment.handle
        self.c_compile()
        self.c_setup_attributes()
        self.c_setup_uniforms()

    cpdef void delete(self) except *:
        cdef:
            ProgramC *program_ptr
        program_ptr = self.c_get_ptr()
        glDeleteProgram(program_ptr.gl_id); self.manager.c_check_gl()
        self.manager.delete(self.handle)
        self.handle = 0

    cdef void c_compile(self) except *:
        cdef:
            ProgramC *program_ptr
            ShaderC *vertex_ptr
            ShaderC *fragment_ptr
            uint32_t gl_id
            uint32_t link_status
            char *log
            int log_length
        program_ptr = self.c_get_ptr()
        vertex_ptr = <ShaderC *>self.manager.c_get_ptr(program_ptr.vertex)
        fragment_ptr = <ShaderC *>self.manager.c_get_ptr(program_ptr.fragment)
        gl_id = program_ptr.gl_id
        glAttachShader(gl_id, vertex_ptr.gl_id); self.manager.c_check_gl()
        glAttachShader(gl_id, fragment_ptr.gl_id); self.manager.c_check_gl()
        glLinkProgram(gl_id); self.manager.c_check_gl()
        glGetProgramiv(gl_id, GL_LINK_STATUS, <GLint*>&link_status); self.manager.c_check_gl()
        glGetProgramiv(gl_id, GL_INFO_LOG_LENGTH, <GLint*>&log_length); self.manager.c_check_gl()
        if not link_status:
            log = <char*>malloc(log_length * sizeof(char))
            glGetProgramInfoLog(gl_id, log_length, NULL, log); self.manager.c_check_gl()
            raise ValueError("Program: failed to compile (GL error message below)\n{0}".format(log.decode("utf-8")))

    cdef void c_setup_attributes(self) except *:
        cdef:
            ProgramC *program_ptr
            uint32_t gl_id
            size_t i
            int count
            int name_max_length
            int name_length
            int size
            uint32_t type
            ProgramAttributeC *attribute
        program_ptr = self.c_get_ptr()
        gl_id = program_ptr.gl_id
        glGetProgramiv(gl_id, GL_ACTIVE_ATTRIBUTE_MAX_LENGTH, &name_max_length); self.manager.c_check_gl()
        if name_max_length >= 256:
            raise ValueError("Program: attribute names cannot exceed 255 characters")
        glGetProgramiv(gl_id, GL_ACTIVE_ATTRIBUTES, &count); self.manager.c_check_gl()
        if count > PROGRAM_MAX_ATTRIBUTES:
            raise ValueError("Program: cannot exceed {0} attributes".format(PROGRAM_MAX_ATTRIBUTES))
        for i in range(count):
            attribute = &program_ptr.attributes[i]
            glGetActiveAttrib(gl_id, i, 255, &name_length, &size, &type, attribute.name); self.manager.c_check_gl()
            attribute.name_length = name_length
            attribute.size = size
            attribute.type = c_attribute_type_from_gl(type)
            attribute.location = glGetAttribLocation(gl_id, attribute.name); self.manager.c_check_gl()
        program_ptr.num_attributes = count

    cdef void c_setup_uniforms(self) except *:
        cdef:
            ProgramC *program_ptr
            uint32_t gl_id
            size_t i
            int count
            int name_max_length
            int name_length
            int size
            uint32_t type
            ProgramUniformC *uniform
        program_ptr = self.c_get_ptr()
        gl_id = program_ptr.gl_id
        glGetProgramiv(gl_id, GL_ACTIVE_UNIFORM_MAX_LENGTH, &name_max_length); self.manager.c_check_gl()
        if name_max_length >= 256:
            raise ValueError("Program: uniform names cannot exceed 255 characters")
        glGetProgramiv(gl_id, GL_ACTIVE_UNIFORMS, &count); self.manager.c_check_gl()
        if count > PROGRAM_MAX_UNIFORMS:
            raise ValueError("Program: cannot exceed {0} uniforms".format(PROGRAM_MAX_UNIFORMS))
        for i in range(count):
            uniform = &program_ptr.uniforms[i]
            glGetActiveUniform(gl_id, i, 255, &name_length, &size, &type, uniform.name); self.manager.c_check_gl()
            uniform.name_length = name_length
            uniform.size = size
            uniform.type = c_uniform_type_from_gl(type)
            uniform.location = glGetUniformLocation(gl_id, uniform.name)
        program_ptr.num_uniforms = count

    cdef void c_bind_attributes(self, Handle buffer) except *:
        cdef:
            ProgramC *program_ptr
            VertexBufferC *buffer_ptr
            VertexFormatC *format_ptr
            VertexCompC *comp_ptr
            size_t i, j
            ProgramAttributeC *attribute
            uint32_t comp_type_gl
            size_t comp_type_size
            size_t comp_offset
            size_t location
        program_ptr = self.c_get_ptr()
        buffer_ptr = <VertexBufferC *>self.manager.c_get_ptr(buffer)
        glBindBuffer(GL_ARRAY_BUFFER, buffer_ptr.gl_id); self.manager.c_check_gl()
        format_ptr = <VertexFormatC *>self.manager.c_get_ptr(buffer_ptr.format)
        for i in range(format_ptr.count):
            comp_ptr = &format_ptr.comps[i]
            for j in range(program_ptr.num_attributes):
                attribute = &program_ptr.attributes[j]
                if strcmp(comp_ptr.name, attribute.name) == 0:
                    location = attribute.location
                    comp_type_gl = c_vertex_comp_type_to_gl(comp_ptr.type)
                    comp_type_size = c_vertex_comp_type_get_size(comp_ptr.type)
                    comp_offset = comp_ptr.offset
                    glVertexAttribPointer(#TODO: validate buffer format against program's attribute info
                        location,
                        comp_ptr.count, 
                        comp_type_gl, 
                        comp_ptr.normalized, 
                        format_ptr.stride,
                        <void *>comp_offset,
                    ); self.manager.c_check_gl()
                    glEnableVertexAttribArray(location); self.manager.c_check_gl()
                    break
        glBindBuffer(GL_ARRAY_BUFFER, 0)

    cdef void c_unbind_attributes(self) except *:
        cdef:
            ProgramC *program_ptr
            size_t i
            ProgramAttributeC *attribute
        program_ptr = self.c_get_ptr()
        for i in range(program_ptr.num_attributes):
            attribute = &program_ptr.attributes[i]
            glDisableVertexAttribArray(attribute.location); self.manager.c_check_gl()

    cdef void c_bind_uniform(self, Handle uniform) except *:
        cdef:
            ProgramC *program_ptr
            UniformC *uniform_ptr
            UniformFormatC *format_ptr
            size_t location
            size_t i
            ProgramUniformC *uniform_info
            UniformType u_type
            int32_t int_data
            float float_data
        program_ptr = self.c_get_ptr()
        uniform_ptr = <UniformC *>self.manager.c_get_ptr(uniform)
        format_ptr = <UniformFormatC *>self.manager.c_get_ptr(uniform_ptr.format)
        for i in range(program_ptr.num_uniforms):
            uniform_info = &program_ptr.uniforms[i]
            if strcmp(format_ptr.name, uniform_info.name) == 0:#TODO: validate uniform against program's uniform info
                location = uniform_info.location
                u_type = uniform_info.type
                if u_type == UNIFORM_TYPE_INT:
                    int_data = (<int32_t *>(uniform_ptr.data))[0]
                    glUniform1i(location, <GLint>int_data); self.manager.c_check_gl()
                elif u_type == UNIFORM_TYPE_FLOAT:
                    float_data = (<float *>uniform_ptr.data)[0]
                    glUniform1f(location, float_data); self.manager.c_check_gl()
                elif u_type == UNIFORM_TYPE_VEC2:
                    glUniform2fv(location, 1, <float *>uniform_ptr.data); self.manager.c_check_gl()
                elif u_type == UNIFORM_TYPE_VEC3:
                    glUniform3fv(location, 1, <float *>uniform_ptr.data); self.manager.c_check_gl()
                elif u_type == UNIFORM_TYPE_VEC4:
                    glUniform4fv(location, 1, <float *>uniform_ptr.data); self.manager.c_check_gl()
                elif u_type == UNIFORM_TYPE_MAT2:
                    glUniformMatrix2fv(location, 1, False, <float *>uniform_ptr.data); self.manager.c_check_gl()
                elif u_type == UNIFORM_TYPE_MAT3:
                    glUniformMatrix3fv(location, 1, False, <float *>uniform_ptr.data); self.manager.c_check_gl()
                elif u_type == UNIFORM_TYPE_MAT4:
                    glUniformMatrix4fv(location, 1, False, <float *>uniform_ptr.data); self.manager.c_check_gl()