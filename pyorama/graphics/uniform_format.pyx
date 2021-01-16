cdef uint8_t ITEM_TYPE = GRAPHICS_ITEM_TYPE_UNIFORM_FORMAT
ctypedef UniformFormatC ItemTypeC

cdef class UniformFormat:
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
        return UniformFormat.get_ptr_by_handle(self.manager, self.handle)

    cpdef void create(self, bytes name, UniformType type, size_t count=1) except *:
        cdef:
            size_t name_length
            UniformFormatC *format_ptr
        name_length = len(name)
        if name_length >= 256:
            raise ValueError("UniformFormat: name cannot exceed 255 characters")
        if count == 0:
            raise ValueError("UniformFormat: count must be non-zero value")
        self.handle = self.manager.create(ITEM_TYPE)
        format_ptr = self.get_ptr()
        memcpy(format_ptr.name, <char *>name, sizeof(char) * name_length)
        format_ptr.name_length = name_length
        format_ptr.type = type
        format_ptr.count = count
        format_ptr.size = count * c_uniform_type_get_size(type)

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0