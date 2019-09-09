cdef class Vec2:
    
    def __init__(self, float x=0.0, float y=0.0):
        self.ptr = <Vec2C *>calloc(1, sizeof(Vec2C))
        Vec2.c_set_data(self.ptr, x, y)
    
    def __dealloc__(self):
        free(self.ptr)
        self.ptr = NULL
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = self.ptr
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
        
    def __getitem__(self, size_t i):
        cdef size_t size = 2
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        return self.ptr[0][i]
        
    def __setitem__(self, size_t i, float value):
        cdef size_t size = 2
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        self.ptr[0][i] = value
    
    property x:
        def __get__(self): return self.ptr[0][0]
        def __set__(self, float new_x): self.ptr[0][0] = new_x
    
    property y:
        def __get__(self): return self.ptr[0][1]
        def __set__(self, float new_y): self.ptr[0][1] = new_y
    
    @staticmethod
    def add(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_add(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def ceil(Vec2 out, Vec2 a):
        Vec2.c_ceil(out.ptr, a.ptr)

    @staticmethod
    def copy(Vec2 out, Vec2 a):
        Vec2.c_copy(out.ptr, a.ptr)

    @staticmethod
    def cross(Vec3 out, Vec2 a, Vec2 b):
        Vec2.c_cross(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def dist(Vec2 a, Vec2 b):
        return Vec2.c_dist(a.ptr, b.ptr)

    @staticmethod
    def div(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_div(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def dot(Vec2 a, Vec2 b):
        return Vec2.c_dot(a.ptr, b.ptr)

    @staticmethod
    def equals(Vec2 a, Vec2 b):
        return Vec2.c_equals(a.ptr, b.ptr)

    @staticmethod
    def floor(Vec2 out, Vec2 a):
        Vec2.c_floor(out.ptr, a.ptr)

    @staticmethod
    def inv(Vec2 out, Vec2 a):
        Vec2.c_inv(out.ptr, a.ptr)

    @staticmethod
    def length(Vec2 a):
        Vec2.c_length(a.ptr)

    @staticmethod
    def lerp(Vec2 out, Vec2 a, Vec2 b, float t):
        Vec2.c_lerp(out.ptr, a.ptr, b.ptr, t)

    @staticmethod
    def max_comps(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_max_comps(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def min_comps(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_min_comps(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def mul(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_mul(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def nearly_equals(Vec2 a, Vec2 b, float epsilon=epsilon):
        return Vec2.c_nearly_equals(a.ptr, b.ptr, epsilon)

    @staticmethod
    def negate(Vec2 out, Vec2 a):
        Vec2.c_negate(out.ptr, a.ptr)

    @staticmethod
    def norm(Vec2 out, Vec2 a):
        Vec2.c_norm(out.ptr, a.ptr)

    @staticmethod
    def random(Vec2 out):
        Vec2.c_random(out.ptr)

    @staticmethod
    def round(Vec2 out, Vec2 a):
        Vec2.c_round(out.ptr, a.ptr)

    @staticmethod
    def scale_add(Vec2 out, Vec2 a, float scale=1.0, float add=0.0):
        Vec2.c_scale_add(out.ptr, a.ptr, scale, add)

    @staticmethod
    def set_data(Vec2 out, float x=0.0, float y=0.0):
        Vec2.c_set_data(out.ptr, x, y)

    @staticmethod
    def sqr_dist(Vec2 a, Vec2 b):
        return Vec2.c_sqr_dist(a.ptr, b.ptr)

    @staticmethod
    def sqr_length(Vec2 a):
        return Vec2.c_sqr_length(a.ptr)

    @staticmethod
    def sub(Vec2 out, Vec2 a, Vec2 b):
        Vec2.c_sub(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def transform_mat2(Vec2 out, Vec2 a, Mat2 m):
        Vec2.c_transform_mat2(out.ptr, a.ptr, m.ptr)

    @staticmethod
    def transform_mat3(Vec2 out, Vec2 a, Mat3 m):
        Vec2.c_transform_mat3(out.ptr, a.ptr, m.ptr)

    @staticmethod
    def transform_mat4(Vec2 out, Vec2 a, Mat4 m):
        Vec2.c_transform_mat4(out.ptr, a.ptr, m.ptr)

    @staticmethod
    cdef inline void c_add(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = a[0][i] + b[0][i]

    @staticmethod
    cdef inline void c_ceil(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = c_math.ceil(a[0][i])

    @staticmethod
    cdef inline void c_copy(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = a[0][i]

    @staticmethod
    cdef inline void c_cross(Vec3C *out, Vec2C *a, Vec2C *b) nogil:
        out[0][0] = 0
        out[0][1] = 0
        out[0][2] = a[0][0] * b[0][1] - a[0][1] * b[0][0]

    @staticmethod
    cdef inline float c_dist(Vec2C *a, Vec2C *b) nogil:
        cdef float out = c_math.sqrt(Vec2.c_sqr_dist(a, b))
        return out

    @staticmethod
    cdef inline void c_div(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = a[0][i] / b[0][i]

    @staticmethod
    cdef inline float c_dot(Vec2C *a, Vec2C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out += a[0][i] * b[0][i]

    @staticmethod
    cdef inline bint c_equals(Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            if a[0][i] != b[0][i]:
                return False
        return True

    @staticmethod
    cdef inline void c_floor(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = c_math.floor(a[0][i])

    @staticmethod
    cdef inline void c_inv(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = 1.0 / a[0][i]

    @staticmethod
    cdef inline float c_length(Vec2C *a) nogil:
        cdef float out = c_math.sqrt(Vec2.c_sqr_length(a))
        return out

    @staticmethod
    cdef inline void c_lerp(Vec2C *out, Vec2C *a, Vec2C *b, float t) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = a[0][i] + t * (b[0][i] - a[0][i])

    @staticmethod
    cdef inline void c_max_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = max(a[0][i], b[0][i])

    @staticmethod
    cdef inline void c_min_comps(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = min(a[0][i], b[0][i])

    @staticmethod
    cdef inline void c_mul(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = a[0][i] * b[0][i]

    @staticmethod
    cdef inline bint c_nearly_equals(Vec2C *a, Vec2C *b, float epsilon=epsilon) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            if c_math.fabs(a[0][i] - b[0][i]) > epsilon * max(1.0, c_math.fabs(a[0][i]), c_math.fabs(b[0][i])):
                return False
        return True

    @staticmethod
    cdef inline void c_negate(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = a[0][i] * -1

    @staticmethod
    cdef inline void c_norm(Vec2C *out, Vec2C *a) nogil:
        cdef float mag = Vec2.c_length(a)
        Vec2.c_scale_add(out, a, scale=1.0/mag)

    @staticmethod
    cdef inline void c_random(Vec2C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = rand() / float(RAND_MAX)

    @staticmethod
    cdef inline void c_round(Vec2C *out, Vec2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = c_math.round(a[0][i])

    @staticmethod
    cdef inline void c_scale_add(Vec2C *out, Vec2C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = scale * a[0][i] + add

    @staticmethod
    cdef inline void c_set_data(Vec2C *out, float x=0.0, float y=0.0) nogil:
        out[0][0] = x
        out[0][1] = y

    @staticmethod
    cdef inline float c_sqr_dist(Vec2C *a, Vec2C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out += (b[0][i] - a[0][i])*(b[0][i] - a[0][i])
        return out

    @staticmethod
    cdef inline float c_sqr_length(Vec2C *a) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out += a[0][i] * a[0][i]
        return out

    @staticmethod
    cdef inline void c_sub(Vec2C *out, Vec2C *a, Vec2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 2
        for i in range(size):
            out[0][i] = a[0][i] - b[0][i]

    @staticmethod
    cdef inline void c_transform_mat2(Vec2C *out, Vec2C *a, Mat2C *m) nogil:
        out[0][0] = m[0][0] * a[0][0] + m[0][2] * a[0][1]
        out[0][1] = m[0][1] * a[0][0] + m[0][3] * a[0][1]

    @staticmethod
    cdef inline void c_transform_mat3(Vec2C *out, Vec2C *a, Mat3C *m) nogil:
        out[0][0] = m[0][0] * a[0][0] + m[0][3] * a[0][1] + m[0][6]
        out[0][1] = m[0][1] * a[0][0] + m[0][4] * a[0][1] + m[0][7]

    @staticmethod
    cdef inline void c_transform_mat4(Vec2C *out, Vec2C *a, Mat4C *m) nogil:
        out[0][0] = m[0][0] * a[0][0] + m[0][4] * a[0][1] + m[0][12]
        out[0][1] = m[0][1] * a[0][0] + m[0][5] * a[0][1] + m[0][13]