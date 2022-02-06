from pyorama.libs.c cimport *

cdef void c_radix_sort_u8(uint8_t *items, size_t num_items) nogil
"""
cdef void c_radix_sort_bool
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