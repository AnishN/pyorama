from pyorama.libs.c cimport *

ctypedef uint64_t Handle

cdef uint32_t c_handle_get_index(Handle *handle) nogil
cdef uint32_t c_handle_get_version(Handle *handle) nogil
cdef uint8_t c_handle_get_type(Handle *handle) nogil
cdef bint c_handle_get_free(Handle *handle) nogil

cdef void c_handle_set(Handle *handle, uint32_t index, uint32_t version, uint8_t type, bint free) nogil
cdef void c_handle_set_index(Handle *handle, uint32_t index) nogil
cdef void c_handle_set_version(Handle *handle, uint32_t version) nogil
cdef void c_handle_set_type(Handle *handle, uint8_t type) nogil
cdef void c_handle_set_free(Handle *handle, bint free) nogil