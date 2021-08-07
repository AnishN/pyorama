DEF MAX_ITEM_TYPES = 256

cdef class SlotManager:
    
    def __cinit__(self):
        cdef:
            size_t i
            SlotMap slot_map
            PyObject *slot_map_ptr
        for i in range(MAX_ITEM_TYPES):
            slot_map = SlotMap()
            slot_map_ptr = <PyObject *>slot_map
            Py_XINCREF(slot_map_ptr)
            self.slot_maps[i] = slot_map_ptr

    def __dealloc__(self):
        cdef:
            size_t i
            PyObject *slot_map_ptr
        for i in range(MAX_ITEM_TYPES):
            slot_map_ptr = self.slot_maps[i]
            Py_XDECREF(slot_map_ptr)
            self.slot_maps[i] = NULL
    
    cdef void c_init(self, dict slot_type_sizes) except *:
        cdef:
            uint8_t slot_type
            size_t slot_size
            PyObject *slot_map_ptr
        self.num_slot_types = 0
        for slot_type, slot_size in slot_type_sizes.items():
            if 0 <= slot_type < MAX_ITEM_TYPES:
                self.register_map[slot_type] = True
                slot_map_ptr = self.slot_maps[slot_type]
                (<SlotMap>slot_map_ptr).c_init(slot_type, slot_size)
            else:
                print(slot_type)
                raise ValueError("SlotManager: invalid slot type")

    cdef void c_free(self) except *:
        cdef:
            size_t i
            PyObject *slot_map_ptr
        for i in range(MAX_ITEM_TYPES):
            if self.register_map[i]:
                slot_map_ptr = self.slot_maps[i]
                (<SlotMap>slot_map_ptr).c_free()
    
    cdef void c_check_slot_type(self, uint8_t slot_type) except *:
        if not self.register_map[slot_type]:
            print(slot_type)
            raise ValueError("SlotManager: invalid slot type")
    
    cdef Handle c_create(self, uint8_t slot_type) except *:
        cdef:
            PyObject *slot_map_ptr
        self.c_check_slot_type(slot_type)
        slot_map_ptr = self.slot_maps[slot_type]
        return (<SlotMap>slot_map_ptr).c_create()

    cdef void c_delete(self, Handle handle) except *:
        cdef:
            uint8_t slot_type
            PyObject *slot_map_ptr
        slot_type = handle_get_type(&handle)
        self.c_check_slot_type(slot_type)
        slot_map_ptr = self.slot_maps[slot_type]
        (<SlotMap>slot_map_ptr).c_delete(handle)

    cdef void *c_get_ptr(self, Handle handle) except *:
        cdef:
            uint8_t slot_type
            PyObject *slot_map_ptr
            void *item_ptr
        slot_type = handle_get_type(&handle)
        self.c_check_slot_type(slot_type)
        slot_map_ptr = self.slot_maps[slot_type]
        item_ptr = (<SlotMap>slot_map_ptr).c_get_ptr(handle)
        return item_ptr

    cdef void *c_get_ptr_by_index(self, uint8_t slot_type, size_t index) except *:
        cdef:
            PyObject *slot_map_ptr
        slot_map_ptr = self.slot_maps[slot_type]
        return (<SlotMap>slot_map_ptr).items.c_get_ptr(index)

    cdef void *c_get_ptr_unsafe(self, Handle handle) nogil:
        cdef:
            uint8_t slot_type
            PyObject *slot_map_ptr
            void *item_ptr
        slot_type = handle_get_type(&handle)
        slot_map_ptr = self.slot_maps[slot_type]
        item_ptr = (<SlotMap>slot_map_ptr).c_get_ptr_unsafe(handle)
        return item_ptr

    cdef SlotMap get_slot_map(self, uint8_t slot_type):
        self.c_check_slot_type(slot_type)
        return <SlotMap>self.slot_maps[slot_type]