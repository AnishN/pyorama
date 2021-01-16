DEF MAX_ITEM_TYPES = 256

cdef class ItemManager:
    
    def __cinit__(self):
        self.num_item_types = 0
    
    def __dealloc__(self):
        cdef:
            PyObject *slot_map_ptr
        for i in range(MAX_ITEM_TYPES):
            slot_map_ptr = self.slot_maps[i]
            if slot_map_ptr != NULL:
                Py_XDECREF(slot_map_ptr)
                self.slot_maps[i] = NULL
                self.registered_item_types[i] = False
        self.num_item_types = 0
    
    cpdef uint8_t register_item_types(self, dict item_types_info) except *:
        cdef:
            uint8_t item_type
            size_t item_size
            ItemSlotMap slot_map
            PyObject *slot_map_ptr
        
        self.num_item_types = <size_t>len(item_types_info)
        for item_type, item_size in item_types_info.items():
            if 0 <= item_type < MAX_ITEM_TYPES:
                self.registered_item_types[item_type] = True
                slot_map = ItemSlotMap(item_size, item_type)
                slot_map_ptr = <PyObject *>slot_map
                self.slot_maps[item_type] = slot_map_ptr
                Py_XINCREF(slot_map_ptr)
    
    cpdef void check_item_type(self, uint8_t item_type) except *:
        if not self.registered_item_types[item_type]:
            raise ValueError("ItemManager: invalid item type")

    cpdef Handle create(self, uint8_t item_type) except *:
        cdef:
            PyObject *slot_map_ptr
        self.check_item_type(item_type)
        slot_map_ptr = self.slot_maps[item_type]
        return (<ItemSlotMap>slot_map_ptr).c_create()

    cpdef void delete(self, Handle handle):
        cdef:
            uint8_t item_type
        item_type = handle_get_type(&handle)
        self.check_item_type(item_type)
        (<ItemSlotMap>self.slot_maps[item_type]).c_delete(handle)

    cdef void *get_ptr(self, Handle handle) except *:
        cdef:
            uint8_t item_type
            PyObject *slot_map_ptr
            void *item_ptr
        item_type = handle_get_type(&handle)
        self.check_item_type(item_type)
        slot_map_ptr = self.slot_maps[item_type]
        item_ptr = (<ItemSlotMap>slot_map_ptr).c_get_ptr(handle)
        return item_ptr

    cdef void *get_ptr_unsafe(self, Handle handle) nogil:
        cdef:
            uint8_t item_type
            PyObject *slot_map_ptr
            void *item_ptr
        item_type = handle_get_type(&handle)
        slot_map_ptr = self.slot_maps[item_type]
        item_ptr = (<ItemSlotMap>slot_map_ptr).c_get_ptr_unsafe(handle)
        return item_ptr

    cdef ItemSlotMap get_slot_map(self, uint8_t item_type):
        self.check_item_type(item_type)
        return <ItemSlotMap>self.slot_maps[item_type]