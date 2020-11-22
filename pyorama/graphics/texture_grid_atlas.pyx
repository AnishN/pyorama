cdef class TextureGridAtlas:
    def __cinit__(self, GraphicsManager graphics):
        self.graphics = graphics

    def __dealloc__(self):
        self.graphics = None
    
    cdef TextureGridAtlasC *get_ptr(self) except *:
        return self.graphics.texture_grid_atlas_get_ptr(self.handle)
    
    cpdef void create(self, Texture texture, size_t num_rows, size_t num_columns) except *:
        cdef:
            TextureGridAtlasC *atlas_ptr
        if num_rows == 0:
            raise ValueError("TextureGridAtlas: num_rows cannot be zero")
        elif num_columns == 0:
            raise ValueError("TextureGridAtlas: num_columns cannot be zero")
        self.handle = self.graphics.texture_grid_atlases.c_create()
        atlas_ptr = self.get_ptr()
        atlas_ptr.texture = texture.handle
        atlas_ptr.num_rows = num_rows
        atlas_ptr.num_columns = num_columns

    cpdef void delete(self) except *:
        self.graphics.texture_grid_atlases.c_delete(self.handle)
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