from pyorama.libs.c cimport *
from pyorama.math3d.common cimport *

cdef void color_set(ColorC *color,  uint8_t r, uint8_t g, uint8_t b, uint8_t a) nogil
cdef void float_color_set(FloatColorC *color, float r, float g, float b, float a) nogil
cdef void color_to_float(FloatColorC *out, ColorC *a) nogil
cdef void color_from_float(ColorC *out, FloatColorC *a) nogil

cdef class Color:
    cdef ColorC data
    
    