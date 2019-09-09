from pyorama.core.handle cimport *
from pyorama.graphics.graphics_manager cimport *

cdef class Sampler:
    cdef readonly GraphicsManager graphics
    cdef readonly Handle handle
    
    cdef SamplerC *c_get_checked_ptr(self) except *

    @staticmethod
    cdef void c_init(SamplerC *sampler_ptr, 
            SamplerFilter mag_filter=*,
            SamplerFilter min_filter=*,
            SamplerWrap wrap_s=*,
            SamplerWrap wrap_t=*,
    ) nogil

    @staticmethod
    cdef void c_clear(SamplerC *sampler_ptr) nogil