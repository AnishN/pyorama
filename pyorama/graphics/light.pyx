ctypedef LightC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class Light:
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

    cpdef void create(self) except *:
        self.handle = self.manager.create(ITEM_TYPE)

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0