from pyorama.libs.c cimport *

cdef void random_set_seed_from_time() nogil
cdef void random_set_seed(uint64_t seed) nogil
cdef float random_get_float() nogil
cdef float random_get_range_float(float min_, float max_) nogil