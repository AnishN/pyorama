"""
cdef class IndexBuffer(HandleObject):

    cdef IndexBufferC *get_ptr(self) except *:
        return <IndexBufferC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(IndexLayout layout, Buffer data, IndexBufferType type_=INDEX_BUFFER_TYPE_STATIC):
        cdef:
            IndexBuffer index_buffer

        index_buffer = IndexBuffer.__new__(IndexBuffer)
        index_buffer.create(layout, data, type_)
        return index_buffer

    cpdef void create(self, IndexLayout layout, Buffer data, IndexBufferType type_=INDEX_BUFFER_TYPE_STATIC) except *:
        cdef:
            Handle index_buffer
            IndexBufferC *index_buffer_ptr
            bgfx_memory_t *memory_ptr

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_INDEX_BUFFER)
        index_buffer_ptr = self.get_ptr()
        index_buffer_ptr.layout = layout
        index_buffer_ptr.type_ = type_
        memory_ptr = bgfx_copy(data.items, data.num_items * data.item_size)
        if index_buffer_ptr.layout == INDEX_LAYOUT_U16:
            index_buffer_ptr.bgfx_id = bgfx_create_index_buffer(memory_ptr, BGFX_BUFFER_NONE)
            index_buffer_ptr.num_indices = data.num_items * data.item_size / sizeof(uint16_t)
        elif index_buffer_ptr.layout == INDEX_LAYOUT_U32:
            index_buffer_ptr.bgfx_id = bgfx_create_index_buffer(memory_ptr, BGFX_BUFFER_NONE | BGFX_BUFFER_INDEX32)
            index_buffer_ptr.num_indices = data.num_items * data.item_size / sizeof(uint32_t)

    cpdef void delete(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
        index_buffer_ptr = self.get_ptr()
        bgfx_destroy_index_buffer(index_buffer_ptr.bgfx_id)
        graphics.slots.c_delete(self.handle)
        self.handle = 0
"""

cdef class IndexBuffer(HandleObject):

    cdef IndexBufferC *get_ptr(self) except *:
        return <IndexBufferC *>graphics.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create_static(IndexLayout layout, list indices):
        cdef:
            IndexBuffer index_buffer
        
        index_buffer = IndexBuffer.__new__(IndexBuffer)
        index_buffer.create_static(layout, indices)
        return index_buffer

    cpdef void create_static(self, IndexLayout layout, list indices) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
            bgfx_memory_t *memory_ptr
            size_t num_indices
            size_t index_size
            size_t i
            uint16_t index_u16
            uint32_t index_u32
            uint16_t flags

        self.handle = graphics.slots.c_create(GRAPHICS_SLOT_INDEX_BUFFER)
        index_buffer_ptr = self.get_ptr()
        num_indices = len(indices)
        
        if index_buffer_ptr.layout == INDEX_LAYOUT_U16:
            index_size = sizeof(uint16_t)
            data = <uint8_t *>calloc(num_indices, index_size)
            flags = BGFX_BUFFER_NONE
            if data == NULL:
                raise MemoryError("IndexBuffer: unable to allocate index data")
            for i in range(num_indices):
                index_u16 = <uint16_t>indices[i]
                memcpy(&data[i * index_size], &index_u16, index_size)
        elif index_buffer_ptr.layout == INDEX_LAYOUT_U32:
            index_size = sizeof(uint32_t)
            data = <uint8_t *>calloc(num_indices, index_size)
            flags = BGFX_BUFFER_NONE | BGFX_BUFFER_INDEX32
            if data == NULL:
                raise MemoryError("IndexBuffer: unable to allocate index data")
            for i in range(num_indices):
                index_u32 = <uint32_t>indices[i]
                memcpy(&data[i * index_size], &index_u32, index_size)

        memory_ptr = bgfx_copy(data, num_indices * index_size)
        index_buffer_ptr.bgfx_id.static = bgfx_create_index_buffer(memory_ptr, flags)
        index_buffer_ptr.layout = layout
        index_buffer_ptr.data = data
        index_buffer_ptr.num_indices = num_indices
        index_buffer_ptr.type_ = INDEX_BUFFER_TYPE_STATIC

    cpdef void delete(self) except *:
        cdef:
            IndexBufferC *index_buffer_ptr
        index_buffer_ptr = self.get_ptr()
        if index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_STATIC:
            bgfx_destroy_index_buffer(index_buffer_ptr.bgfx_id.static)
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_DYNAMIC:
            bgfx_destroy_dynamic_index_buffer(index_buffer_ptr.bgfx_id.dynamic)
        elif index_buffer_ptr.type_ == INDEX_BUFFER_TYPE_TRANSIENT:
            pass
        graphics.slots.c_delete(self.handle)
        self.handle = 0

    cpdef void update(self) except *:
        pass