cdef class Vec3:
    
    def __init__(self, float x=0.0, float y=0.0, float z=0.0):
        self.ptr = <Vec3C *>calloc(1, sizeof(Vec3C))
        Vec3.c_set_data(self.ptr, x, y, z)
    
    def __dealloc__(self):
        free(self.ptr)
        self.ptr = NULL
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = self.ptr
        buffer.len = 3
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
        cdef size_t size = 3
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        return self.ptr[0][i]
        
    def __setitem__(self, size_t i, float value):
        cdef size_t size = 3
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
    
    @staticmethod
    def add(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_add(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def angle(Vec3 a, Vec3 b):
        return Vec3.c_angle(a.ptr, b.ptr)

    @staticmethod
    def ceil(Vec3 out, Vec3 a):
        Vec3.c_ceil(out.ptr, a.ptr)

    @staticmethod
    def copy(Vec3 out, Vec3 a):
        Vec3.c_copy(out.ptr, a.ptr)

    @staticmethod
    def cross(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_cross(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def dist(Vec3 a, Vec3 b):
        return Vec3.c_dist(a.ptr, b.ptr)

    @staticmethod
    def div(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_div(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def dot(Vec3 a, Vec3 b):
        return Vec3.c_dot(a.ptr, b.ptr)

    @staticmethod
    def equals(Vec3 a, Vec3 b):
        return Vec3.c_equals(a.ptr, b.ptr)

    @staticmethod
    def floor(Vec3 out, Vec3 a):
        Vec3.c_floor(out.ptr, a.ptr)

    @staticmethod
    def inv(Vec3 out, Vec3 a):
        Vec3.c_inv(out.ptr, a.ptr)

    @staticmethod
    def length(Vec3 a):
        return Vec3.c_length(a.ptr)

    @staticmethod
    def lerp(Vec3 out, Vec3 a, Vec3 b, float t):
        Vec3.c_lerp(out.ptr, a.ptr, b.ptr, t)

    @staticmethod
    def max_comps(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_max_comps(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def min_comps(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_min_comps(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def mul(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_mul(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def nearly_equals(Vec3 a, Vec3 b, float epsilon=epsilon):
        Vec3.c_nearly_equals(a.ptr, b.ptr, epsilon)

    @staticmethod
    def negate(Vec3 out, Vec3 a):
        Vec3.c_negate(out.ptr, a.ptr)

    @staticmethod
    def norm(Vec3 out, Vec3 a):
        Vec3.c_norm(out.ptr, a.ptr)

    @staticmethod
    def random(Vec3 out):
        Vec3.c_random(out.ptr)

    @staticmethod
    def round(Vec3 out, Vec3 a):
        Vec3.c_round(out.ptr, a.ptr)

    @staticmethod
    def scale_add(Vec3 out, Vec3 a, float scale=1.0, float add=0.0):
        Vec3.c_scale_add(out.ptr, a.ptr, scale, add)

    @staticmethod
    def set_data(Vec3 out, float x=0.0, float y=0.0, float z=0.0):
        Vec3.c_set_data(out.ptr, x, y, z)

    @staticmethod
    def sqr_dist(Vec3 a, Vec3 b):
        return Vec3.c_sqr_dist(a.ptr, b.ptr)

    @staticmethod
    def sqr_length(Vec3 a):
        return Vec3.c_sqr_length(a.ptr)

    @staticmethod
    def sub(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_sub(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def transform_mat3(Vec3 out, Vec3 a, Mat3 m):
        Vec3.c_transform_mat3(out.ptr, a.ptr, m.ptr)

    @staticmethod
    def transform_mat4(Vec3 out, Vec3 a, Mat4 m):
        Vec3.c_transform_mat4(out.ptr, a.ptr, m.ptr)

    @staticmethod
    def transform_quat(Vec3 out, Vec3 a, Quat q):
        Vec3.c_transform_quat(out.ptr, a.ptr, q.ptr)

    @staticmethod
    cdef inline void c_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = a[0][i] + b[0][i]
        
    @staticmethod
    cdef inline float c_angle(Vec3C *a, Vec3C *b) nogil:
        cdef float cosine = 0.0
        cdef float out = 0.0
        cdef Vec3C a_norm
        cdef Vec3C b_norm
        Vec3.c_norm(&a_norm, a)
        Vec3.c_norm(&b_norm, b)
        if a == b:
            return out
        cosine = Vec3.c_dot(&a_norm, &b_norm)
        if cosine <= 1.0:
            out = c_math.acos(cosine)
        return out
        
    @staticmethod
    cdef inline void c_ceil(Vec3C *out, Vec3C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = c_math.ceil(a[0][i])

    @staticmethod
    cdef inline void c_copy(Vec3C *out, Vec3C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = a[0][i]

    @staticmethod
    cdef inline void c_cross(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        out[0][0] = a[0][1] * b[0][2] - a[0][2] * b[0][1]
        out[0][1] = a[0][2] * b[0][0] - a[0][0] * b[0][2]
        out[0][2] = a[0][0] * b[0][1] - a[0][1] * b[0][0]

    @staticmethod
    cdef inline float c_dist(Vec3C *a, Vec3C *b) nogil:
        cdef float out = c_math.sqrt(Vec3.c_sqr_dist(a, b))
        return out

    @staticmethod
    cdef inline void c_div(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = a[0][i] / b[0][i]

    @staticmethod
    cdef inline float c_dot(Vec3C *a, Vec3C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out += a[0][i] * b[0][i]
        return out

    @staticmethod
    cdef inline bint c_equals(Vec3C *a, Vec3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            if a[0][i] != b[0][i]:
                return False
        return True
        
    @staticmethod
    cdef inline void c_floor(Vec3C *out, Vec3C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = c_math.floor(a[0][i])

    @staticmethod
    cdef inline void c_inv(Vec3C *out, Vec3C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = 1.0 / a[0][i]
        
    @staticmethod
    cdef inline float c_length(Vec3C *a) nogil:
        cdef float out = c_math.sqrt(Vec3.c_sqr_length(a))
        return out
        
    @staticmethod
    cdef inline void c_lerp(Vec3C *out, Vec3C *a, Vec3C *b, float t) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = a[0][i] + t * (b[0][i] - a[0][i])
        
    @staticmethod
    cdef inline void c_max_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = max(a[0][i], b[0][i])

    @staticmethod
    cdef inline void c_min_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = min(a[0][i], b[0][i])
        
    @staticmethod
    cdef inline void c_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = a[0][i] * b[0][i]
            
    @staticmethod
    cdef inline bint c_nearly_equals(Vec3C *a, Vec3C *b, float epsilon=epsilon) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            if c_math.fabs(a[0][i] - b[0][i]) > epsilon * max(1.0, c_math.fabs(a[0][i]), c_math.fabs(b[0][i])):
                return False
        return True
        
    @staticmethod
    cdef inline void c_negate(Vec3C *out, Vec3C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = a[0][i] * -1
        
    @staticmethod
    cdef inline void c_norm(Vec3C *out, Vec3C *a) nogil:
        cdef float mag = Vec3.c_length(a)
        Vec3.c_scale_add(out, a, scale=1.0/mag)
        
    @staticmethod
    cdef inline void c_random(Vec3C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = rand() / float(RAND_MAX)

    @staticmethod
    cdef inline void c_round(Vec3C *out, Vec3C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = c_math.round(a[0][i])
        
    @staticmethod
    cdef inline void c_scale_add(Vec3C *out, Vec3C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = scale * a[0][i] + add
        
    @staticmethod
    cdef inline void c_set_data(Vec3C *out, float x=0.0, float y=0.0, float z=0.0) nogil:
        out[0][0] = x
        out[0][1] = y
        out[0][2] = z
        
    @staticmethod
    cdef inline float c_sqr_dist(Vec3C *a, Vec3C *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out += (b[0][i] - a[0][i])*(b[0][i] - a[0][i])
        return out
        
    @staticmethod
    cdef inline float c_sqr_length(Vec3C *a) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out += a[0][i] * a[0][i]
        return out
        
    @staticmethod
    cdef inline void c_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 3
        for i in range(size):
            out[0][i] = a[0][i] - b[0][i]
            
    @staticmethod
    cdef inline void c_transform_mat3(Vec3C *out, Vec3C *a, Mat3C *m) nogil:
        out[0][0] = m[0][0]*a[0][0] + m[0][3]*a[0][1] + m[0][6]*a[0][2]
        out[0][1] = m[0][1]*a[0][0] + m[0][4]*a[0][1] + m[0][7]*a[0][2]
        out[0][2] = m[0][2]*a[0][0] + m[0][5]*a[0][1] + m[0][8]*a[0][2]
        
    @staticmethod
    cdef inline void c_transform_mat4(Vec3C *out, Vec3C *a, Mat4C *m) nogil:
        cdef float w = 0.0
        w = m[0][3]*a[0][0] + m[0][7]*a[0][1] + m[0][11]*a[0][2] + m[0][15]
        if w == 0:
            w = 1.0
        out[0][0] = (m[0][0]*a[0][0] + m[0][4]*a[0][1] + m[0][8]*a[0][2] + m[0][12]) / w
        out[0][1] = (m[0][1]*a[0][0] + m[0][5]*a[0][1] + m[0][9]*a[0][2] + m[0][13]) / w
        out[0][2] = (m[0][2]*a[0][0] + m[0][6]*a[0][1] + m[0][10]*a[0][2] + m[0][14]) / w
        
    @staticmethod
    cdef inline void c_transform_quat(Vec3C *out, Vec3C *a, QuatC *q) nogil:
        cdef float x = a[0][0]
        cdef float y = a[0][1]
        cdef float z = a[0][2]
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