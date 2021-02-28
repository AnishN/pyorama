ctypedef TextureGridAtlasC ItemTypeC
cdef uint8_t ITEM_TYPE = handle_create_item_type()
cdef size_t ITEM_SIZE = sizeof(ItemTypeC)

cdef class TextureGridAtlas:
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
        return TextureGridAtlas.get_ptr_by_handle(self.manager, self.handle)
    
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

    cpdef void create(self, Texture texture, size_t num_rows, size_t num_columns) except *:
        cdef:
            TextureGridAtlasC *atlas_ptr
        if num_rows == 0:
            raise ValueError("TextureGridAtlas: num_rows cannot be zero")
        elif num_columns == 0:
            raise ValueError("TextureGridAtlas: num_columns cannot be zero")
        self.handle = self.manager.create(ITEM_TYPE)
        atlas_ptr = self.get_ptr()
        atlas_ptr.texture = texture.handle
        atlas_ptr.num_rows = num_rows
        atlas_ptr.num_columns = num_columns

    cpdef void delete(self) except *:
        self.manager.delete(self.handle)
        self.handle = 0

    cpdef size_t get_num_rows(self) except *:
        return self.get_ptr().num_rows

    cpdef size_t get_num_columns(self) except *:
        return self.get_ptr().num_columns

    cpdef size_t get_row_from_index(self, size_t index) except *:
        cdef:
            TextureGridAtlasC *atlas_ptr
            size_t row
        atlas_ptr = self.get_ptr()
        row = index / atlas_ptr.num_columns
        if row > atlas_ptr.num_rows:
            raise ValueError("TextureGridAtlas: invalid index")
        return row

    cpdef size_t get_column_from_index(self, size_t index) except *:
        cdef:
            TextureGridAtlasC *atlas_ptr
            size_t column
        atlas_ptr = self.get_ptr()
        column = index % atlas_ptr.num_columns
        if column > atlas_ptr.num_columns:
            raise ValueError("TextureGridAtlas: invalid index")
        return column

    cpdef size_t get_index_from_row_column(self, size_t row, size_t column) except *:
        cdef:
            TextureGridAtlasC *atlas_ptr
            size_t index
        atlas_ptr = self.get_ptr()
        if row >= atlas_ptr.num_rows:
            raise ValueError("TextureGridAtlas: invalid row")
        if column >= atlas_ptr.num_columns:
            raise ValueError("TextureGridAtlas: invalid column")
        index = row * atlas_ptr.num_columns + column
        return index