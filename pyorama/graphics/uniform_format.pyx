cdef class UniformFormat:
    def __init__(self, GraphicsManager graphics):
        self.graphics = graphics

    def __dealloc__(self):
        self.graphics = None
    
    cdef UniformFormatC *get_ptr(self) except *:
        return self.graphics.uniform_format_get_ptr(self.handle)    

    cpdef void create(self, bytes name, UniformType type, size_t count=1) except *:
        cdef:
            size_t name_length
            Handle format
            UniformFormatC *format_ptr
        name_length = len(name)
        if name_length >= 256:
            raise ValueError("UniformFormat: name cannot exceed 255 characters")
        if count == 0:
            raise ValueError("UniformFormat: count must be non-zero value")
        self.handle = self.graphics.uniform_formats.c_create()
        format_ptr = self.get_ptr()
        memcpy(format_ptr.name, <char *>name, sizeof(char) * name_length)
        format_ptr.name_length = name_length
        format_ptr.type = type
        format_ptr.count = count
        format_ptr.size = count * c_uniform_type_get_size(type)

    cpdef void delete(self) except *:
        self.graphics.uniform_formats.c_delete(self.handle)
        self.handle = 0