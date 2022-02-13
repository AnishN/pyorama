from pyorama.libs.c cimport *

cpdef enum RadixSortType:
    RADIX_SORT_TYPE_U8
    RADIX_SORT_TYPE_I8
    RADIX_SORT_TYPE_U16
    RADIX_SORT_TYPE_I16
    RADIX_SORT_TYPE_U32
    RADIX_SORT_TYPE_I32
    RADIX_SORT_TYPE_U64
    RADIX_SORT_TYPE_I64
    RADIX_SORT_TYPE_F32
    RADIX_SORT_TYPE_F64
    RADIX_SORT_TYPE_STR

#ctypedef void (* RadixKeyFuncC)(void *item, void *key_item) except *
ctypedef cmp_func_t BackupCmpFuncC
ctypedef uint8_t (* RadixKeyFuncC)(void *item, size_t byte_offset) except *
cdef void c_radix_sort(void *items, size_t item_size, size_t start, size_t end, size_t start_offset, RadixSortType type_, RadixKeyFuncC key_func=*) except *

"""
cdef void c_radix_sort_u8
cdef void c_radix_sort_u16
cdef void c_radix_sort_u32
cdef void c_radix_sort_u64
cdef void c_radix_sort_i8
cdef void c_radix_sort_i16
cdef void c_radix_sort_i32
cdef void c_radix_sort_i64
cdef void c_radix_sort_f32
cdef void c_radix_sort_f64
cdef void c_radix_sort_str
cdef void c_radix_sort_custom
"""