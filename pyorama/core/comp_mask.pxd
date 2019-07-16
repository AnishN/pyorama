from pyorama.core.ecs_types cimport *
from pyorama.libs.c cimport *

cdef bint comp_mask_get_bit(CompMask *mask, uint8_t n) nogil
cdef void comp_mask_set_bit(CompMask *mask, uint8_t n, bint value) nogil
cdef void comp_mask_set_bit_on(CompMask *mask, uint8_t n) nogil
cdef void comp_mask_set_bit_off(CompMask *mask, uint8_t n) nogil
cdef void comp_mask_toggle_bit(CompMask *mask, uint8_t n) nogil