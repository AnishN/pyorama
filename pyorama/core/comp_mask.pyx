cdef bint comp_mask_get_bit(CompMask *mask, uint8_t n) nogil:
    cdef:
        uint8_t byte_index
        uint8_t bit_index
        bint test
    
    byte_index = n / 8
    bit_index = n % 8
    test = (mask.bits[byte_index] >> bit_index) & 1
    return test

cdef void comp_mask_set_bit(CompMask *mask, uint8_t n, bint value) nogil:
    cdef:
        uint8_t byte_index
        uint8_t bit_index
        bint test
    
    byte_index = n / 8
    bit_index = n % 8
    mask.bits[byte_index] ^= (-value ^ mask.bits[byte_index]) & (1 << bit_index)

cdef void comp_mask_set_bit_on(CompMask *mask, uint8_t n) nogil:
    cdef:
        uint8_t byte_index
        uint8_t bit_index
    
    byte_index = n / 8
    bit_index = n % 8
    mask.bits[byte_index] |= (1 << bit_index)

cdef void comp_mask_set_bit_off(CompMask *mask, uint8_t n) nogil:
    cdef:
        uint8_t byte_index
        uint8_t bit_index
    
    byte_index = n / 8
    bit_index = n % 8
    mask.bits[byte_index] &= ~(1 << bit_index)

cdef void comp_mask_toggle_bit(CompMask *mask, uint8_t n) nogil:
    cdef:
        uint8_t byte_index
        uint8_t bit_index
    
    byte_index = n / 8
    bit_index = n % 8
    mask.bits[byte_index] ^= 1 << bit_index