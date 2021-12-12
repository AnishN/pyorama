from pyorama.libs.c cimport *

ctypedef uint64_t Handle

cdef uint8_t handle_create_slot_type() nogil

cdef uint32_t handle_get_index(Handle *handle) nogil
cdef uint32_t handle_get_version(Handle *handle) nogil
cdef uint8_t handle_get_type(Handle *handle) nogil
cdef bint handle_get_free(Handle *handle) nogil

cdef void handle_set(Handle *handle, uint32_t index, uint32_t version, uint8_t type, bint free) nogil
cdef void handle_set_index(Handle *handle, uint32_t index) nogil
cdef void handle_set_version(Handle *handle, uint32_t version) nogil
cdef void handle_set_type(Handle *handle, uint8_t type) nogil
cdef void handle_set_free(Handle *handle, bint free) nogil

cdef class HandleObject:
    cdef Handle handle