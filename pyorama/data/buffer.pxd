from pyorama.libs.c cimport *

ctypedef union BufferFieldValue:
    uint8_t u8
    uint16_t u16
    uint32_t u32
    uint64_t u64
    int8_t i8
    int16_t i16
    int32_t i32
    int64_t i64
    float f32
    double f64

cpdef enum BufferFieldType:
    BUFFER_FIELD_TYPE_U8
    BUFFER_FIELD_TYPE_U16
    BUFFER_FIELD_TYPE_U32
    BUFFER_FIELD_TYPE_U64
    BUFFER_FIELD_TYPE_I8
    BUFFER_FIELD_TYPE_I16
    BUFFER_FIELD_TYPE_I32
    BUFFER_FIELD_TYPE_I64
    BUFFER_FIELD_TYPE_F32
    BUFFER_FIELD_TYPE_F64

ctypedef struct BufferFieldC:
    char[256] name
    size_t name_length
    size_t count
    BufferFieldType type_
    size_t type_size
    size_t field_size

cdef class BufferFormat:
    cdef:
        size_t size
        size_t count
        size_t num_fields
        BufferFieldC *fields
        char *format_str

    @staticmethod
    cdef size_t c_get_field_type_size(BufferFieldType field_type) nogil
    @staticmethod
    cdef char c_get_field_type_char(BufferFieldType field_type) nogil
    @staticmethod
    cdef BufferFieldValue c_convert_value(object value, BufferFieldType field_type) except *

cdef class Buffer:
    cdef:
        BufferFormat item_format
        uint8_t *items
        size_t item_size
        size_t num_items
        bint is_owner
    
    cpdef void init_empty(self, size_t num_items) except *
    cpdef void init_from_bytes(self, bytes items, bint copy=*) except *
    cpdef void init_from_list(self, list items, bint is_flat=*) except *
    cdef void c_init_from_ptr(self, uint8_t *items, size_t num_items, bint copy=*) except *
    cpdef void free(self) except *