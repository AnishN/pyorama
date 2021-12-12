from pyorama.libs.c cimport *
from cpython.ref cimport *
import ctypes
import time

ctypedef void (* cy_func)(PyObject *obj_ptr)
proto_func = ctypes.CFUNCTYPE(None, ctypes.py_object)

def iter_call(func, dict params):
    cdef:
        size_t i
        size_t n = 100000
    
    start = time.time()
    for i in range(n):
        func(params)
    end = time.time()
    print(end - start)

def iter_call_2(func, dict params):
    cdef:
        size_t i
        size_t n = 100000
    
    ct_func = proto_func(func)
    func_ptr = ctypes.cast(ct_func, ctypes.c_void_p).value

    start = time.time()
    for i in range(n):
        ct_func(params)
    end = time.time()
    print(end - start)

def iter_call_3(func, dict params):
    cdef:
        size_t i
        size_t n = 100000
        uintptr_t ptr_val
        cy_func func_ptr
        PyObject *params_ptr
    
    ct_func = proto_func(func)
    ptr_val = ctypes.cast(ct_func, ctypes.c_void_p).value
    func_ptr = <cy_func>ptr_val
    params_ptr = <PyObject *>params

    start = time.time()
    for i in range(n):
        func_ptr(params_ptr)
    end = time.time()
    print(end - start)