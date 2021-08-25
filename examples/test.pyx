from pyorama.libs.c cimport *

def print_mv(const uint8_t[::1] data):
    cdef:
        size_t i
        size_t n = data.shape[0]

    for i in range(n):
        print(i, data[i])