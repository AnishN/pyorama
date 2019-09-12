cdef class Sampler:
    
    def __init__(self):
        raise NotImplementedError()

    def init(self, 
            SamplerFilter mag_filter=SAMPLER_FILTER_LINEAR,
            SamplerFilter min_filter=SAMPLER_FILTER_LINEAR,
            SamplerWrap wrap_s=SAMPLER_WRAP_REPEAT,
            SamplerWrap wrap_t=SAMPLER_WRAP_REPEAT,
    ):
        cdef SamplerC *sampler_ptr
        sampler_ptr = self.c_get_checked_ptr()
        Sampler.c_init(sampler_ptr, mag_filter, min_filter, wrap_s, wrap_t)

    def clear(self):
        cdef SamplerC *sampler_ptr
        sampler_ptr = self.c_get_checked_ptr()
        Sampler.c_clear(sampler_ptr)
    
    @property
    def mag_filter(self):
        cdef SamplerC *sampler_ptr
        sampler_ptr = self.c_get_checked_ptr()
        return sampler_ptr.mag_filter
    
    @property
    def min_filter(self):
        cdef SamplerC *sampler_ptr
        sampler_ptr = self.c_get_checked_ptr()
        return sampler_ptr.min_filter

    @property
    def wrap_s(self):
        cdef SamplerC *sampler_ptr
        sampler_ptr = self.c_get_checked_ptr()
        return sampler_ptr.wrap_s

    @property
    def wrap_s(self):
        cdef SamplerC *sampler_ptr
        sampler_ptr = self.c_get_checked_ptr()
        return sampler_ptr.wrap_t

    cdef SamplerC *c_get_checked_ptr(self) except *:
        cdef SamplerC *sampler_ptr
        ItemSlotMap.c_get_ptr(&self.graphics.samplers, self.handle, <void **>&sampler_ptr)
        if sampler_ptr == NULL:
            raise MemoryError("Sampler: cannot get ptr from invalid handle")
        return sampler_ptr
    
    @staticmethod
    cdef void c_init(SamplerC *sampler_ptr, 
            SamplerFilter mag_filter=SAMPLER_FILTER_LINEAR,
            SamplerFilter min_filter=SAMPLER_FILTER_LINEAR,
            SamplerWrap wrap_s=SAMPLER_WRAP_REPEAT,
            SamplerWrap wrap_t=SAMPLER_WRAP_REPEAT,
    ) nogil:
        sampler_ptr.mag_filter = mag_filter
        sampler_ptr.min_filter = min_filter
        sampler_ptr.wrap_s = wrap_s
        sampler_ptr.wrap_t = wrap_t

    @staticmethod
    cdef void c_clear(SamplerC *sampler_ptr) nogil:
        sampler_ptr.mag_filter = SAMPLER_FILTER_LINEAR
        sampler_ptr.min_filter = SAMPLER_FILTER_LINEAR
        sampler_ptr.wrap_s = SAMPLER_WRAP_REPEAT
        sampler_ptr.wrap_t = SAMPLER_WRAP_REPEAT