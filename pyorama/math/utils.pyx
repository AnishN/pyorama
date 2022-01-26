cdef void random_set_seed_from_time() nogil:
    srand(c_time(NULL))

cdef void random_set_seed(uint64_t seed) nogil:
    srand(seed)

cdef float random_get_float() nogil:
    return <double>rand()/<double>(RAND_MAX)

cdef float random_get_range_float(float min_, float max_) nogil:
    return min_ + ((max_ - min_) * rand())