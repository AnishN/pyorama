cdef void color_set(ColorC *color,  uint8_t r, uint8_t g, uint8_t b, uint8_t a) nogil:
    color.r = r
    color.g = g
    color.b = b
    color.a = a

cdef void float_color_set(FloatColorC *color, float r, float g, float b, float a) nogil:
    color.r = r
    color.g = g
    color.b = b
    color.a = a

cdef void color_to_float(FloatColorC *out, ColorC *a) nogil:
    out.r = a.r / 255.0
    out.g = a.g / 255.0
    out.b = a.b / 255.0
    out.a = a.a / 255.0

cdef void color_from_float(ColorC *out, FloatColorC *a) nogil:
    out.r = <uint8_t>c_math.round(a.r * 255)
    out.g = <uint8_t>c_math.round(a.g * 255)
    out.b = <uint8_t>c_math.round(a.b * 255)
    out.a = <uint8_t>c_math.round(a.a * 255)

cdef class Color:

    def __cinit__(self, uint8_t r, uint8_t g, uint8_t b, uint8_t a):
        color_set(&self.data, r, g, b, a)

    def __dealloc__(self):
        color_set(&self.data, 0, 0, 0, 0)

    def set_data(self, uint8_t r, uint8_t g, uint8_t b, uint8_t a):
        color_set(&self.data, r, g, b, a)