cimport libc.math as c_math
from libc.stdint cimport *
from libc.stdlib cimport *
from libc.string cimport *
from libc.stdio cimport *

cdef extern from "stdarg.h":
    ctypedef struct va_list:
        pass
    ctypedef struct fake_type:
        pass
    void va_start(va_list, void* arg)
    void* va_arg(va_list, fake_type)
    void va_end(va_list)
    fake_type int_type "int"

ctypedef int (* cmp_func_t)(void *, void *) nogil

cdef extern from "stdlib.h" nogil:
    char *itoa(int value, char *str_, int base)
    #void qsort(void *ptr, size_t count, size_t size, int (*cmp_func)(const void *, const void *))
    void qsort(void *ptr, size_t count, size_t size, cmp_func_t cmp_func)

cdef extern from "math.h" nogil:
    double d_round "round" (double x)
    float f_round "roundf" (float x)
    long double l_round "roundl" (long double x)

cdef extern from "time.h" nogil:
    ctypedef int64_t time_t
    time_t c_time "time" (time_t *timer)