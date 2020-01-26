cdef class Vec4:
    
    def __init__(self, float x=0.0, float y=0.0, float z=0.0, float w=0.0):
        self.ptr = <Vec4C *>calloc(1, sizeof(Vec4C))
        Vec4.c_set_data(self.ptr, x, y, z, w)
    
    def __dealloc__(self):
        free(self.ptr)
        self.ptr = NULL
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = self.ptr
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
        
    def __getitem__(self, size_t i):
        cdef size_t size = 4
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        return self.ptr[0][i]
        
    def __setitem__(self, size_t i, float value):
        cdef size_t size = 4
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        self.ptr[0][i] = value
    
    property x:
        def __get__(self): return self.ptr[0][0]
        def __set__(self, float new_x): self.ptr[0][0] = new_x
    
    property y:
        def __get__(self): return self.ptr[0][1]
        def __set__(self, float new_y): self.ptr[0][1] = new_y
        
    property z:
        def __get__(self): return self.ptr[0][2]
        def __set__(self, float new_z): self.ptr[0][2] = new_z
        
    property w:
        def __get__(self): return self.ptr[0][3]
        def __set__(self, float new_w): self.ptr[0][3] = new_w
        
    @staticmethod
    def add(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_add(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def ceil(Vec4 out, Vec4 a):
        Vec4.c_ceil(out.ptr, a.ptr)

    @staticmethod
    def copy(Vec4 out, Vec4 a):
        Vec4.c_copy(out.ptr, a.ptr)

    @staticmethod
    def dist(Vec4 a, Vec4 b):
        return Vec4.c_dist(a.ptr, b.ptr)

    @staticmethod
    def div(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_div(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def dot(Vec4 a, Vec4 b):
        return Vec4.c_dot(a.ptr, b.ptr)

    @staticmethod
    def equals(Vec4 a, Vec4 b):
        return Vec4.c_equals(a.ptr, b.ptr)

    @staticmethod
    def floor(Vec4 out, Vec4 a):
        Vec4.c_floor(out.ptr, a.ptr)

    @staticmethod
    def inv(Vec4 out, Vec4 a):
        Vec4.c_inv(out.ptr, a.ptr)

    @staticmethod
    def length(Vec4 a):
        Vec4.c_length(a.ptr)

    @staticmethod
    def lerp(Vec4 out, Vec4 a, Vec4 b, float t):
        Vec4.c_lerp(out.ptr, a.ptr, b.ptr, t)

    @staticmethod
    def max_comps(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_max_comps(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def min_comps(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_min_comps(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def mul(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_mul(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def nearly_equals(Vec4 a, Vec4 b, float epsilon=epsilon):
        Vec4.c_nearly_equals(a.ptr, b.ptr, epsilon)

    @staticmethod
    def negate(Vec4 out, Vec4 a):
        Vec4.c_negate(out.ptr, a.ptr)

    @staticmethod
    def norm(Vec4 out, Vec4 a):
        Vec4.c_norm(out.ptr, a.ptr)

    @staticmethod
    def random(Vec4 out):
        Vec4.c_random(out.ptr)

    @staticmethod
    def round(Vec4 out, Vec4 a):
        Vec4.c_round(out.ptr, a.ptr)

    @staticmethod
    def scale_add(Vec4 out, Vec4 a, float scale=1.0, float add=0.0):
        Vec4.c_scale_add(out.ptr, a.ptr, scale, add)

    @staticmethod
    def set_data(Vec4 out, float x=0.0, float y=0.0, float z=0.0, float w=0.0):
        Vec4.c_set_data(out.ptr, x, y, z, w)

    @staticmethod
    def sqr_dist(Vec4 a, Vec4 b):
        return Vec4.c_sqr_dist(a.ptr, b.ptr)

    @staticmethod
    def sqr_length(Vec4 a):
        return Vec4.c_sqr_length(a.ptr)

    @staticmethod
    def sub(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_sub(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def transform_mat4(Vec4 out, Vec4 a, Mat4 m):
        Vec4.c_transform_mat4(out.ptr, a.ptr, m.ptr)

    @staticmethod
    def transform_quat(Vec4 out, Vec4 a, Quat q):
        Vec4.c_transform_quat(out.ptr, a.ptr, q.ptr)

    @staticmethod
    cdef inline void c_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] + b[0][i]
            
    @staticmethod
    cdef inline void c_ceil(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = c_math.ceil(a[0][i])
        
    @staticmethod
    cdef inline void c_copy(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i]

    @staticmethod
    cdef inline float c_dist(Vec4C *a, Vec4C *b) nogil:
        cdef float out = c_math.sqrt(Vec4.c_sqr_dist(a, b))
        return out
        
    @staticmethod
    cdef inline void c_div(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] / b[0][i]
        
    @staticmethod
    cdef inline float c_dot(Vec4C *a, Vec4C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out += a[0][i] * b[0][i]

    @staticmethod
    cdef inline bint c_equals(Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if a[0][i] != b[0][i]:
                return False
        return True
        
    @staticmethod
    cdef inline void c_floor(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = c_math.floor(a[0][i])

    @staticmethod
    cdef inline void c_inv(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = 1.0 / a[0][i]
        
    @staticmethod
    cdef inline float c_length(Vec4C *a) nogil:
        cdef float out = c_math.sqrt(Vec4.c_sqr_length(a))
        return out

    @staticmethod
    cdef inline void c_lerp(Vec4C *out, Vec4C *a, Vec4C *b, float t) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] + t * (b[0][i] - a[0][i])
        
    @staticmethod
    cdef inline void c_max_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = max(a[0][i], b[0][i])

    @staticmethod
    cdef inline void c_min_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = min(a[0][i], b[0][i])
        
    @staticmethod
    cdef inline void c_mul(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] * b[0][i]
            
    @staticmethod
    cdef inline bint c_nearly_equals(Vec4C *a, Vec4C *b, float epsilon=0.000001) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if c_math.fabs(a[0][i] - b[0][i]) > epsilon * max(1.0, c_math.fabs(a[0][i]), c_math.fabs(b[0][i])):
                return False
        return True

    @staticmethod
    cdef inline void c_negate(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] * -1
        
    @staticmethod
    cdef inline void c_norm(Vec4C *out, Vec4C *a) nogil:
        cdef float mag = Vec4.c_length(a)
        Vec4.c_scale_add(out, a, scale=1.0/mag)
        
    @staticmethod
    cdef inline void c_random(Vec4C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = rand() / float(RAND_MAX)
        
    @staticmethod
    cdef inline void c_round(Vec4C *out, Vec4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = c_math.round(a[0][i])
        
    @staticmethod
    cdef inline void c_scale_add(Vec4C *out, Vec4C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = scale * a[0][i] + add
        
    @staticmethod
    cdef inline void c_set_data(Vec4C *out, float x=0.0, float y=0.0, float z=0.0, float w=0.0) nogil:
        out[0][0] = x
        out[0][1] = y
        out[0][2] = z
        out[0][3] = w
        
    @staticmethod
    cdef inline float c_sqr_dist(Vec4C *a, Vec4C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out += (b[0][i] - a[0][i])*(b[0][i] - a[0][i])
        return out
        
    @staticmethod
    cdef inline float c_sqr_length(Vec4C *a) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out += a[0][i] * a[0][i]
        return out
        
    @staticmethod
    cdef inline void c_sub(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] - b[0][i]
            
    @staticmethod
    cdef inline void c_transform_mat4(Vec4C *out, Vec4C *a, Mat4C *m) nogil:
        out[0][0] = m[0][0]*a[0][0] + m[0][4]*a[0][1] + m[0][8]*a[0][2] + m[0][12]*a[0][3]
        out[0][1] = m[0][1]*a[0][0] + m[0][5]*a[0][1] + m[0][9]*a[0][2] + m[0][13]*a[0][3]
        out[0][2] = m[0][2]*a[0][0] + m[0][6]*a[0][1] + m[0][10]*a[0][2] + m[0][14]*a[0][3]
        out[0][3] = m[0][3]*a[0][0] + m[0][7]*a[0][1] + m[0][11]*a[0][2] + m[0][15]*a[0][3]
        
    @staticmethod
    cdef inline void c_transform_quat(Vec4C *out, Vec4C *a, QuatC *q) nogil:
        cdef float x = a[0][0]
        cdef float y = a[0][1]
        cdef float z = a[0][2]
        cdef float w = a[0][3]
        cdef float qx = q[0][0]
        cdef float qy = q[0][1]
        cdef float qz = q[0][2]
        cdef float qw = q[0][3]
        
        cdef float ix = qw * x + qy * z - qz * y
        cdef float iy = qw * y + qz * x - qx * z
        cdef float iz = qw * z + qx * y - qy * x
        cdef float iw = -qx * x - qy * y - qz * z
        
        out[0][0] = ix * qw + iw * -qx + iy * -qz - iz * -qy
        out[0][1] = iy * qw + iw * -qy + iz * -qx - ix * -qz
        out[0][2] = iz * qw + iw * -qz + ix * -qy - iy * -qx
        out[0][3] = a[0][3]