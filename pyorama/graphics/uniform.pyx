cdef class Uniform:
    def __cinit__(self, GraphicsManager graphics):
        self.graphics = graphics

    def __dealloc__(self):
        self.graphics = None
    
    cdef UniformC *get_ptr(self) except *:
        return self.graphics.uniform_get_ptr(self.handle)    
    
    cpdef void create(self, UniformFormat format) except *:
        cdef:
            UniformC *uniform_ptr
            size_t type_size
            size_t data_size
            uint8_t *data_ptr
        self.handle = self.graphics.uniforms.c_create()
        uniform_ptr = self.get_ptr()
        uniform_ptr.format = format.handle
        format_ptr = format.get_ptr()
        type_size = c_uniform_type_get_size(format_ptr.type)
        data_size = format_ptr.count * type_size
        data_ptr = <uint8_t *>calloc(1, data_size)
        if data_ptr == NULL:
            raise MemoryError("Uniform: cannot allocate memory for data")
        uniform_ptr.data = data_ptr

    cpdef void delete(self) except *:
        self.graphics.uniforms.c_delete(self.handle)
        self.handle = 0

    cpdef void set_data(self, object data, size_t index=0) except *:
        cdef:
            UniformC *uniform_ptr
            UniformFormat format = UniformFormat(self.graphics)
            UniformType type
            size_t type_size
            int32_t int_data
            float float_data
            uint8_t *src_ptr
            uint8_t *dst_ptr
        uniform_ptr = self.get_ptr()
        format.handle = uniform_ptr.format
        format_ptr = format.get_ptr()
        if index >= format_ptr.count:
            raise ValueError("Uniform: attempting to set data outside of count boundaries")
        type = format_ptr.type
        type_size = c_uniform_type_get_size(type)
        
        if type == UNIFORM_TYPE_INT:
            int_data = <int32_t?>data
            src_ptr = <uint8_t *>&int_data
        elif type == UNIFORM_TYPE_FLOAT:
            float_data = <float?>data
            src_ptr = <uint8_t *>&float_data
        elif type == UNIFORM_TYPE_VEC2:
            src_ptr = <uint8_t *>&(<Vec2?>data).data
        elif type == UNIFORM_TYPE_VEC3:
            src_ptr = <uint8_t *>&(<Vec3?>data).data
        elif type == UNIFORM_TYPE_VEC4:
            src_ptr = <uint8_t *>&(<Vec4?>data).data
        elif type == UNIFORM_TYPE_MAT2:
            src_ptr = <uint8_t *>&(<Mat2?>data).data
        elif type == UNIFORM_TYPE_MAT3:
            src_ptr = <uint8_t *>&(<Mat3?>data).data
        elif type == UNIFORM_TYPE_MAT4:
            src_ptr = <uint8_t *>&(<Mat4?>data).data
        else:
            raise ValueError("Uniform: data is of an invalid type")
        dst_ptr = uniform_ptr.data + (index * type_size)
        memcpy(dst_ptr, src_ptr, type_size)