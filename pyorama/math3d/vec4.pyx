cdef class Vec4:
    
    def __init__(self, float x=0.0, float y=0.0, float z=0.0, float w=0.0):
        Vec4.c_set_data(&self.data, x, y, z, w)
    
    def __dealloc__(self):
        memset(&self.data, 0, sizeof(Vec4C))
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = &self.data
        buffer.len = 4
        buffer.readonly = 0
        buffer.format = "f"
        buffer.ndim = 1
        buffer.shape = <Py_ssize_t *>&buffer.len
        buffer.strides = NULL
        buffer.suboffsets = NULL
        buffer.itemsize = sizeof(float)
        buffer.internal = NULL

    def __releasebuffer__(self, Py_buffer *buffer):
        pass
    
    """
    def __getitem__(self, size_t i):
        cdef size_t size = 4
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        return (<float *>self.data)[i]
        
    def __setitem__(self, size_t i, float value):
        cdef size_t size = 4
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        (<float *>self.data)[i] = value
    """
    
    property x:
        def __get__(self): return self.data.x
        def __set__(self, float new_x): self.data.x = new_x
    
    property y:
        def __get__(self): return self.data.y
        def __set__(self, float new_y): self.data.y = new_y
        
    property z:
        def __get__(self): return self.data.z
        def __set__(self, float new_z): self.data.z = new_z
        
    property w:
        def __get__(self): return self.data.w
        def __set__(self, float new_w): self.data.w = new_w
        
    @staticmethod
    def add(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_add(&out.data, &a.data, &b.data)
    
    @staticmethod
    def ceil(Vec4 out, Vec4 a):
        Vec4.c_ceil(&out.data, &a.data)

    @staticmethod
    def copy(Vec4 out, Vec4 a):
        Vec4.c_copy(&out.data, &a.data)

    @staticmethod
    def dist(Vec4 a, Vec4 b):
        return Vec4.c_dist(&a.data, &b.data)

    @staticmethod
    def div(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_div(&out.data, &a.data, &b.data)

    @staticmethod
    def dot(Vec4 a, Vec4 b):
        return Vec4.c_dot(&a.data, &b.data)

    @staticmethod
    def equals(Vec4 a, Vec4 b):
        return Vec4.c_equals(&a.data, &b.data)

    @staticmethod
    def floor(Vec4 out, Vec4 a):
        Vec4.c_floor(&out.data, &a.data)

    @staticmethod
    def inv(Vec4 out, Vec4 a):
        Vec4.c_inv(&out.data, &a.data)

    @staticmethod
    def length(Vec4 a):
        Vec4.c_length(&a.data)

    @staticmethod
    def lerp(Vec4 out, Vec4 a, Vec4 b, float t):
        Vec4.c_lerp(&out.data, &a.data, &b.data, t)

    @staticmethod
    def max_comps(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_max_comps(&out.data, &a.data, &b.data)

    @staticmethod
    def min_comps(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_min_comps(&out.data, &a.data, &b.data)

    @staticmethod
    def mul(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    def nearly_equals(Vec4 a, Vec4 b, float epsilon=0.000001):
        Vec4.c_nearly_equals(&a.data, &b.data, epsilon)

    @staticmethod
    def negate(Vec4 out, Vec4 a):
        Vec4.c_negate(&out.data, &a.data)

    @staticmethod
    def norm(Vec4 out, Vec4 a):
        Vec4.c_norm(&out.data, &a.data)

    @staticmethod
    def random(Vec4 out):
        Vec4.c_random(&out.data)

    @staticmethod
    def round(Vec4 out, Vec4 a):
        Vec4.c_round(&out.data, &a.data)

    @staticmethod
    def scale_add(Vec4 out, Vec4 a, float scale=1.0, float add=0.0):
        Vec4.c_scale_add(&out.data, &a.data, scale, add)

    @staticmethod
    def set_data(Vec4 out, float x=0.0, float y=0.0, float z=0.0, float w=0.0):
        Vec4.c_set_data(&out.data, x, y, z, w)

    @staticmethod
    def sqr_dist(Vec4 a, Vec4 b):
        return Vec4.c_sqr_dist(&a.data, &b.data)

    @staticmethod
    def sqr_length(Vec4 a):
        return Vec4.c_sqr_length(&a.data)

    @staticmethod
    def sub(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_sub(&out.data, &a.data, &b.data)

    @staticmethod
    def transform_mat4(Vec4 out, Vec4 a, Mat4 m):
        Vec4.c_transform_mat4(&out.data, &a.data, &m.data)

    @staticmethod
    def transform_quat(Vec4 out, Vec4 a, Quat q):
        Vec4.c_transform_quat(&out.data, &a.data, &q.data)

    @staticmethod
    cdef inline void c_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] + (<float *>b)[i]
            
    @staticmethod
    cdef inline void c_ceil(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = c_math.ceil((<float *>a)[i])
        
    @staticmethod
    cdef inline void c_copy(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i]

    @staticmethod
    cdef inline float c_dist(Vec4C *a, Vec4C *b) nogil:
        cdef float out = c_math.sqrt(Vec4.c_sqr_dist(a, b))
        return out
        
    @staticmethod
    cdef inline void c_div(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] / (<float *>b)[i]
        
    @staticmethod
    cdef inline float c_dot(Vec4C *a, Vec4C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out += (<float *>a)[i] * (<float *>b)[i]

    @staticmethod
    cdef inline bint c_equals(Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if (<float *>a)[i] != (<float *>b)[i]:
                return False
        return True
        
    @staticmethod
    cdef inline void c_floor(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = c_math.floor((<float *>a)[i])

    @staticmethod
    cdef inline void c_inv(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = 1.0 / (<float *>a)[i]
        
    @staticmethod
    cdef inline float c_length(Vec4C *a) nogil:
        cdef float out = c_math.sqrt(Vec4.c_sqr_length(a))
        return out

    @staticmethod
    cdef inline void c_lerp(Vec4C *out, Vec4C *a, Vec4C *b, float t) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] + t * ((<float *>b)[i] - (<float *>a)[i])
        
    @staticmethod
    cdef inline void c_max_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = max((<float *>a)[i], (<float *>b)[i])

    @staticmethod
    cdef inline void c_min_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = min((<float *>a)[i], (<float *>b)[i])
        
    @staticmethod
    cdef inline void c_mul(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] * (<float *>b)[i]
            
    @staticmethod
    cdef inline bint c_nearly_equals(Vec4C *a, Vec4C *b, float epsilon=0.000001) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if c_math.fabs((<float *>a)[i] - (<float *>b)[i]) > epsilon * max(1.0, c_math.fabs((<float *>a)[i]), c_math.fabs((<float *>b)[i])):
                return False
        return True

    @staticmethod
    cdef inline void c_negate(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] * -1
        
    @staticmethod
    cdef inline void c_norm(Vec4C *out, Vec4C *a) nogil:
        cdef float mag = Vec4.c_length(a)
        Vec4.c_scale_add(out, a, scale=1.0/mag)
        
    @staticmethod
    cdef inline void c_random(Vec4C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = rand() / <float>RAND_MAX
        
    @staticmethod
    cdef inline void c_round(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = c_math.round((<float *>a)[i])
        
    @staticmethod
    cdef inline void c_scale_add(Vec4C *out, Vec4C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = scale * (<float *>a)[i] + add
        
    @staticmethod
    cdef inline void c_set_data(Vec4C *out, float x=0.0, float y=0.0, float z=0.0, float w=0.0) nogil:
        out.x = x
        out.y = y
        out.z = z
        out.w = w
        
    @staticmethod
    cdef inline float c_sqr_dist(Vec4C *a, Vec4C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out += ((<float *>b)[i] - (<float *>a)[i])*((<float *>b)[i] - (<float *>a)[i])
        return out
        
    @staticmethod
    cdef inline float c_sqr_length(Vec4C *a) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out += (<float *>a)[i] * (<float *>a)[i]
        return out
        
    @staticmethod
    cdef inline void c_sub(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] - (<float *>b)[i]
            
    @staticmethod
    cdef inline void c_transform_mat4(Vec4C *out, Vec4C *a, Mat4C *m) nogil:
        out.x = m.m00*a.x + m.m10*a.y + m.m20*a.z + m.m30*a.w
        out.y = m.m01*a.x + m.m11*a.y + m.m21*a.z + m.m31*a.w
        out.z = m.m02*a.x + m.m12*a.y + m.m22*a.z + m.m32*a.w
        out.w = m.m03*a.x + m.m13*a.y + m.m23*a.z + m.m33*a.w
        
    @staticmethod
    cdef inline void c_transform_quat(Vec4C *out, Vec4C *a, QuatC *q) nogil:
        cdef QuatC i        
        i.x = q.w * a.x + q.y * a.z - q.z * a.y
        i.y = q.w * a.y + q.z * a.x - q.x * a.z
        i.z = q.w * a.z + q.x * a.y - q.y * a.x
        i.w = -q.x * a.x - q.y * a.y - q.z * a.z
        out.x = i.x * q.w + i.w * -q.x + i.y * -q.z - i.z * -q.y
        out.y = i.y * q.w + i.w * -q.y + i.z * -q.x - i.x * -q.z
        out.z = i.z * q.w + i.w * -q.z + i.x * -q.y - i.y * -q.x
        out.w = a.w