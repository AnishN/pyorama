cdef uint64_t NUM_INDEX_BITS = 32
cdef uint64_t NUM_VERSION_BITS = 23
cdef uint64_t NUM_TYPE_BITS = 8
cdef uint64_t NUM_FREE_BITS = 1

cdef uint64_t INDEX_BIT = 0
cdef uint64_t VERSION_BIT = NUM_INDEX_BITS
cdef uint64_t TYPE_BIT = NUM_INDEX_BITS + NUM_VERSION_BITS
cdef uint64_t FREE_BIT = NUM_INDEX_BITS + NUM_VERSION_BITS + NUM_TYPE_BITS

cdef uint64_t INDEX_MASK = mask_range(INDEX_BIT, NUM_INDEX_BITS)
cdef uint64_t VERSION_MASK = mask_range(VERSION_BIT, NUM_VERSION_BITS)
cdef uint64_t TYPE_MASK = mask_range(TYPE_BIT, NUM_TYPE_BITS)
cdef uint64_t FREE_MASK = mask_range(FREE_BIT, NUM_FREE_BITS)
#print("{0:X}, {1:X}, {2:X}, {3:X}".format(INDEX_MASK, VERSION_MASK, TYPE_MASK, FREE_MASK))

cdef uint64_t mask_range(uint64_t n, uint64_t r) nogil:
    cdef:
        uint64_t a
        uint64_t b
        uint64_t one
        uint64_t mask

    one = 1
    a = (one << n) - one
    b = (one << (n + r)) - one
    mask = a ^ b
    return mask

cdef uint32_t handle_get_index(Handle *handle) nogil:
    return <uint32_t>((handle[0] & INDEX_MASK) >> INDEX_BIT)
    
cdef uint32_t handle_get_version(Handle *handle) nogil:
    return <uint32_t>((handle[0] & VERSION_MASK) >> VERSION_BIT)

cdef uint8_t handle_get_type(Handle *handle) nogil:
    return <uint8_t>((handle[0] & TYPE_MASK) >> TYPE_BIT)

cdef bint handle_get_free(Handle *handle) nogil:
    return <bint>((handle[0] & FREE_MASK) >> FREE_BIT)

cdef void handle_set(Handle *handle, uint32_t index, uint32_t version, uint8_t type, bint free) nogil:
    handle_set_index(handle, index)
    handle_set_version(handle, version)
    handle_set_type(handle, type)
    handle_set_free(handle, free)

cdef void handle_set_index(Handle *handle, uint32_t index) nogil:    
    handle[0] = (handle[0] & (~INDEX_MASK)) | (<uint64_t>index << INDEX_BIT & INDEX_MASK)
    
cdef void handle_set_version(Handle *handle, uint32_t version) nogil:
    handle[0] = (handle[0] & (~VERSION_MASK)) | (<uint64_t>version << VERSION_BIT & VERSION_MASK)
    
cdef void handle_set_type(Handle *handle, uint8_t type) nogil:
    handle[0] = (handle[0] & (~TYPE_MASK)) | ((<uint64_t>type) << TYPE_BIT & TYPE_MASK)
    
cdef void handle_set_free(Handle *handle, bint free) nogil:
    handle[0] = (handle[0] & (~FREE_MASK)) | (<uint64_t>free << FREE_BIT & FREE_MASK)