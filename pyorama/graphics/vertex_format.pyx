cdef uint8_t ITEM_TYPE = GRAPHICS_ITEM_TYPE_VERTEX_FORMAT
ctypedef VertexFormatC ItemTypeC

cdef class VertexFormat:
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
        return VertexFormat.get_ptr_by_handle(self.manager, self.handle)

    cpdef void create(self, list comps) except *:
        cdef:
            VertexFormatC *format_ptr
            size_t num_comps
            size_t i
            tuple comp_tuple
            bytes name
            size_t name_length
            VertexCompC *comp
            size_t offset
            size_t comp_type_size
        num_comps = len(comps)
        if num_comps > 16:
            raise ValueError("VertexFormat: maximum number of vertex comps exceeded")
        self.handle = self.manager.create(ITEM_TYPE)
        format_ptr = self.get_ptr()
        offset = 0
        for i in range(num_comps):
            comp_tuple = <tuple>comps[i]
            comp = &format_ptr.comps[i]
            name = <bytes>comp_tuple[0]
            name_length = len(name)
            if name_length >= 256:
                raise ValueError("VertexFormat: comp name cannot exceed 255 characters")
            memcpy(comp.name, <char *>name, sizeof(char) * name_length)
            comp.name_length = name_length
            comp.type = <VertexCompType>comp_tuple[1]
            comp.count = <size_t>comp_tuple[2]
            comp.normalized = <bint>comp_tuple[3]
            comp.offset = offset
            if comp.type == VERTEX_COMP_TYPE_F32: comp_type_size = 4
            elif comp.type == VERTEX_COMP_TYPE_I8: comp_type_size = 1
            elif comp.type == VERTEX_COMP_TYPE_U8: comp_type_size = 1
            elif comp.type == VERTEX_COMP_TYPE_I16: comp_type_size = 2
            elif comp.type == VERTEX_COMP_TYPE_U16: comp_type_size = 2
            offset += comp.count * comp_type_size
        format_ptr.count = num_comps
        format_ptr.stride = offset

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0


    