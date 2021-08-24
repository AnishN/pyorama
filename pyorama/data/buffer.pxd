from pyorama.libs.c cimport *

cdef class Buffer:
    cdef:
        readonly uint8_t[::1] items
        bytes item_format
        size_t item_size
        size_t num_items
        bint is_owner
    
    cpdef void init(self, bytes item_format, size_t num_items) except *
    cpdef void init_and_set_items(self, bytes item_format, list items, bint is_flat=*, size_t num_row_items=*) except *
    cpdef void free(self) except *
    cpdef void set_items(self, list items, size_t start_index=*, bint is_flat=*, size_t num_row_items=*) except *
    cdef void c_init_from_ptr(self, bytes item_format, uint8_t *items_ptr, size_t num_items) except *