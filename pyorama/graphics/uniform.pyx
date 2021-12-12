cdef class Uniform(HandleObject):

    cdef UniformC *get_ptr(self) except *:
        return <UniformC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(bytes name, UniformType type_):
        cdef:
            Uniform uniform

        uniform = Uniform.__new__(Uniform)
        uniform.create(name, type_)
        return uniform

    cpdef void create(self, bytes name, UniformType type_) except *:
        cdef:
            UniformC *uniform_ptr
        
        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_UNIFORM)
        uniform_ptr = self.get_ptr()
        uniform_ptr.bgfx_id = bgfx_create_uniform(
            _name=name, 
            _type=<bgfx_uniform_type_t>type_, 
            _num=1,
        )

    cpdef void delete(self) except *:
        cdef:
            UniformC *uniform_ptr
        
        uniform_ptr = self.get_ptr()
        bgfx_destroy_uniform(uniform_ptr.bgfx_id)
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void set_sampler(self, uint32_t value) except *:
        cdef UniformC *uniform_ptr = self.get_ptr()
        bgfx_set_uniform(uniform_ptr.bgfx_id, &value, 1)

    cpdef void set_vec4(self, Vec4 value) except *:
        cdef UniformC *uniform_ptr = self.get_ptr()
        bgfx_set_uniform(uniform_ptr.bgfx_id, &value.data, 1)

    cpdef void set_mat3(self, Mat3 value) except *:
        cdef UniformC *uniform_ptr = self.get_ptr()
        bgfx_set_uniform(uniform_ptr.bgfx_id, &value.data, 1)

    cpdef void set_mat4(self, Mat4 value) except *:
        cdef UniformC *uniform_ptr = self.get_ptr()
        bgfx_set_uniform(uniform_ptr.bgfx_id, &value.data, 1)

    cpdef void set_value(self, object value) except *:
        cdef:
            UniformType type_
            
        type_ = self.get_type()
        if type_ == UNIFORM_TYPE_SAMPLER: 
            self.set_sampler(<uint32_t>value)
        elif type_ == UNIFORM_TYPE_VEC4:
            self.set_vec4(<Vec4>value)
        elif type_ == UNIFORM_TYPE_MAT3:
            self.set_mat3(<Mat3>value)
        elif type_ == UNIFORM_TYPE_MAT4:
            self.set_mat4(<Mat4>value)

    cpdef bytes get_name(self):
        cdef:
            UniformC *uniform_ptr
            bgfx_uniform_info_t info
        
        uniform_ptr = self.get_ptr()
        bgfx_get_uniform_info(uniform_ptr.bgfx_id, &info)
        return info.name

    cpdef UniformType get_type(self) except *:
        cdef:
            UniformC *uniform_ptr
            bgfx_uniform_info_t info
        
        uniform_ptr = self.get_ptr()
        bgfx_get_uniform_info(uniform_ptr.bgfx_id, &info)
        return <UniformType>info.type
