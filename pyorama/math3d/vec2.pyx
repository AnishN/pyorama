cdef class Vec2:
    
    def __init__(self, float x=0.0, float y=0.0):
        Vec2.c_set_data(&self.data, x, y)
    
    def __dealloc__(self):
        memset(&self.data, 0, sizeof(Vec2C))

    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = &self.data
        buffer.len = 2
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
        cdef size_t size = 2
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        return (<float *>self.data)[i]
        
    def __setitem__(self, size_t i, float value):
        cdef size_t size = 2
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
    
    @staticmethod
    def add(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_add(&out.data, &a.data, &b.data)

    @staticmethod
    def ceil(Vec2 out, Vec2 a):
        Vec2.c_ceil(&out.data, &a.data)

    @staticmethod
    def copy(Vec2 out, Vec2 a):
        Vec2.c_copy(&out.data, &a.data)

    @staticmethod
    def cross(Vec3 out, Vec2 a, Vec2 b):
        Vec2.c_cross(&out.data, &a.data, &b.data)

    @staticmethod
    def dist(Vec2 a, Vec2 b):
        return Vec2.c_dist(&a.data, &b.data)

    @staticmethod
    def div(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_div(&out.data, &a.data, &b.data)

    @staticmethod
    def dot(Vec2 a, Vec2 b):
        return Vec2.c_dot(&a.data, &b.data)

    @staticmethod
    def equals(Vec2 a, Vec2 b):
        return Vec2.c_equals(&a.data, &b.data)

    @staticmethod
    def floor(Vec2 out, Vec2 a):
        Vec2.c_floor(&out.data, &a.data)

    @staticmethod
    def inv(Vec2 out, Vec2 a):
        Vec2.c_inv(&out.data, &a.data)

    @staticmethod
    def length(Vec2 a):
        Vec2.c_length(&a.data)

    @staticmethod
    def lerp(Vec2 out, Vec2 a, Vec2 b, float t):
        Vec2.c_lerp(&out.data, &a.data, &b.data, t)

    @staticmethod
    def max_comps(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_max_comps(&out.data, &a.data, &b.data)

    @staticmethod
    def min_comps(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_min_comps(&out.data, &a.data, &b.data)

    @staticmethod
    def mul(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    def nearly_equals(Vec2 a, Vec2 b, float epsilon=0.000001):
        return Vec2.c_nearly_equals(&a.data, &b.data, epsilon)

    @staticmethod
    def negate(Vec2 out, Vec2 a):
        Vec2.c_negate(&out.data, &a.data)

    @staticmethod
    def norm(Vec2 out, Vec2 a):
        Vec2.c_norm(&out.data, &a.data)

    @staticmethod
    def random(Vec2 out):
        Vec2.c_random(&out.data)

    @staticmethod
    def round(Vec2 out, Vec2 a):
        Vec2.c_round(&out.data, &a.data)

    @staticmethod
    def scale_add(Vec2 out, Vec2 a, float scale=1.0, float add=0.0):
        Vec2.c_scale_add(&out.data, &a.data, scale, add)

    @staticmethod
    def set_data(Vec2 out, float x=0.0, float y=0.0):
        Vec2.c_set_data(&out.data, x, y)

    @staticmethod
    def sqr_dist(Vec2 a, Vec2 b):
        return Vec2.c_sqr_dist(&a.data, &b.data)

    @staticmethod
    def sqr_length(Vec2 a):
        return Vec2.c_sqr_length(&a.data)

    @staticmethod
    def sub(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_sub(&out.data, &a.data, &b.data)

    @staticmethod
    def transform_mat2(Vec2 out, Vec2 a, Mat2 m):
        Vec2.c_transform_mat2(&out.data, &a.data, &m.data)

    @staticmethod
    def transform_mat3(Vec2 out, Vec2 a, Mat3 m):
        Vec2.c_transform_mat3(&out.data, &a.data, &m.data)

    @staticmethod
    def transform_mat4(Vec2 out, Vec2 a, Mat4 m):
        Vec2.c_transform_mat4(&out.data, &a.data, &m.data)

    @staticmethod
    cdef void c_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] + (<float *>b)[i]

    @staticmethod
    cdef void c_ceil(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = c_math.ceil((<float *>a)[i])

    @staticmethod
    cdef void c_copy(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i]

    @staticmethod
    cdef void c_cross(Vec3C *out, Vec2C *a, Vec2C *b) nogil:
        out.x = 0
        out.y = 0
        (<float *>out)[2] = a.x * b.y - a.y * b.x

    @staticmethod
    cdef float c_dist(Vec2C *a, Vec2C *b) nogil:
        cdef float out = c_math.sqrt(Vec2.c_sqr_dist(a, b))
        return out

    @staticmethod
    cdef void c_div(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] / (<float *>b)[i]

    @staticmethod
    cdef float c_dot(Vec2C *a, Vec2C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out += (<float *>a)[i] * (<float *>b)[i]

    @staticmethod
    cdef bint c_equals(Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            if (<float *>a)[i] != (<float *>b)[i]:
                return False
        return True

    @staticmethod
    cdef void c_floor(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = c_math.floor((<float *>a)[i])

    @staticmethod
    cdef void c_inv(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = 1.0 / (<float *>a)[i]

    @staticmethod
    cdef float c_length(Vec2C *a) nogil:
        cdef float out = c_math.sqrt(Vec2.c_sqr_length(a))
        return out

    @staticmethod
    cdef void c_lerp(Vec2C *out, Vec2C *a, Vec2C *b, float t) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] + t * ((<float *>b)[i] - (<float *>a)[i])

    @staticmethod
    cdef void c_max_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = max((<float *>a)[i], (<float *>b)[i])

    @staticmethod
    cdef void c_min_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = min((<float *>a)[i], (<float *>b)[i])

    @staticmethod
    cdef void c_mul(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] * (<float *>b)[i]

    @staticmethod
    cdef bint c_nearly_equals(Vec2C *a, Vec2C *b, float epsilon=0.000001) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            if c_math.fabs((<float *>a)[i] - (<float *>b)[i]) > epsilon * max(1.0, c_math.fabs((<float *>a)[i]), c_math.fabs((<float *>b)[i])):
                return False
        return True

    @staticmethod
    cdef void c_negate(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] * -1

    @staticmethod
    cdef void c_norm(Vec2C *out, Vec2C *a) nogil:
        cdef float mag = Vec2.c_length(a)
        Vec2.c_scale_add(out, a, scale=1.0/mag)

    @staticmethod
    cdef void c_random(Vec2C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = rand() / <float>RAND_MAX

    @staticmethod
    cdef void c_round(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = c_math.round((<float *>a)[i])

    @staticmethod
    cdef void c_scale_add(Vec2C *out, Vec2C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = scale * (<float *>a)[i] + add

    @staticmethod
    cdef void c_set_data(Vec2C *out, float x=0.0, float y=0.0) nogil:
        out.x = x
        out.y = y

    @staticmethod
    cdef float c_sqr_dist(Vec2C *a, Vec2C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out += ((<float *>b)[i] - (<float *>a)[i])*((<float *>b)[i] - (<float *>a)[i])
        return out

    @staticmethod
    cdef float c_sqr_length(Vec2C *a) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out += (<float *>a)[i] * (<float *>a)[i]
        return out

    @staticmethod
    cdef void c_sub(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] - (<float *>b)[i]

    @staticmethod
    cdef void c_transform_mat2(Vec2C *out, Vec2C *a, Mat2C *m) nogil:
        out.x = m.m00 * a.x + m.m10 * a.y
        out.y = m.m01 * a.x + m.m11 * a.y

    @staticmethod
    cdef void c_transform_mat3(Vec2C *out, Vec2C *a, Mat3C *m) nogil:
        out.x = m.m00 * a.x + m.m10 * a.y + m.m20
        out.y = m.m01 * a.x + m.m11 * a.y + m.m21

    @staticmethod
    cdef void c_transform_mat4(Vec2C *out, Vec2C *a, Mat4C *m) nogil:
        out.x = m.m00 * a.x + m.m10 * a.y + m.m20
        out.y = m.m01 * a.x + m.m11 * a.y + m.m21