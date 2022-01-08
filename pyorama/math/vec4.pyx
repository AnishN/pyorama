cdef class Vec4:
    
    def __init__(self, float x=0.0, float y=0.0, float z=0.0, float w=0.0):#NOT __cinit__ so that __new__ does not call this!
        if self.data == NULL:
            self.data = <Vec4C *>calloc(1, sizeof(Vec4C))
            if self.data == NULL:
                raise MemoryError("Vec4: failed to allocate data")
            self.is_owner = True
        Vec4.c_set_data(self.data, x, y, z, w)
    
    def __dealloc__(self):
        if self.is_owner:
            free(self.data)
            self.data = NULL
            self.is_owner = False
    
    @staticmethod
    cdef Vec4 c_from_ptr(Vec4C *a):
        cdef Vec4 out = Vec4.__new__(Vec4)
        out.data = a
        out.is_owner = False
        return out
    
    cdef void c_set_ptr(self, Vec4C *a) nogil:
        if self.is_owner:
            free(self.data)
            self.data = NULL
            self.is_owner = False
        self.data = a

    property data:
        def __get__(self): return self.data[0]

    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = self.data
        buffer.len = 4
        buffer.readonly = 0
        buffer.format = "f"
        buffer.ndim = 1
        buffer.shape = <Py_ssize_t *>buffer.len
        buffer.strides = NULL
        buffer.suboffsets = NULL
        buffer.itemsize = sizeof(float)
        buffer.internal = NULL

    def __releasebuffer__(self, Py_buffer *buffer):
        pass
    
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
        Vec4.c_add(out.data, a.data, b.data)
    
    @staticmethod
    def ceil(Vec4 out, Vec4 a):
        Vec4.c_ceil(out.data, a.data)

    @staticmethod
    def copy(Vec4 out, Vec4 a):
        Vec4.c_copy(out.data, a.data)

    @staticmethod
    def dist(Vec4 a, Vec4 b):
        return Vec4.c_dist(a.data, b.data)

    @staticmethod
    def div(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_div(out.data, a.data, b.data)

    @staticmethod
    def dot(Vec4 a, Vec4 b):
        return Vec4.c_dot(a.data, b.data)

    @staticmethod
    def equals(Vec4 a, Vec4 b):
        return Vec4.c_equals(a.data, b.data)

    @staticmethod
    def floor(Vec4 out, Vec4 a):
        Vec4.c_floor(out.data, a.data)

    @staticmethod
    def inv(Vec4 out, Vec4 a):
        Vec4.c_inv(out.data, a.data)

    @staticmethod
    def length(Vec4 a):
        Vec4.c_length(a.data)

    @staticmethod
    def lerp(Vec4 out, Vec4 a, Vec4 b, float t):
        Vec4.c_lerp(out.data, a.data, b.data, t)

    @staticmethod
    def max_comps(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_max_comps(out.data, a.data, b.data)

    @staticmethod
    def min_comps(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_min_comps(out.data, a.data, b.data)

    @staticmethod
    def mul(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_mul(out.data, a.data, b.data)

    @staticmethod
    def nearly_equals(Vec4 a, Vec4 b, float epsilon=0.000001):
        Vec4.c_nearly_equals(a.data, b.data, epsilon)

    @staticmethod
    def negate(Vec4 out, Vec4 a):
        Vec4.c_negate(out.data, a.data)

    @staticmethod
    def norm(Vec4 out, Vec4 a):
        Vec4.c_norm(out.data, a.data)

    @staticmethod
    def random(Vec4 out):
        Vec4.c_random(out.data)

    @staticmethod
    def round(Vec4 out, Vec4 a):
        Vec4.c_round(out.data, a.data)

    @staticmethod
    def scale_add(Vec4 out, Vec4 a, float scale=1.0, float add=0.0):
        Vec4.c_scale_add(out.data, a.data, scale, add)

    @staticmethod
    def set_data(Vec4 out, float x=0.0, float y=0.0, float z=0.0, float w=0.0):
        Vec4.c_set_data(out.data, x, y, z, w)

    @staticmethod
    def sqr_dist(Vec4 a, Vec4 b):
        return Vec4.c_sqr_dist(a.data, b.data)

    @staticmethod
    def sqr_length(Vec4 a):
        return Vec4.c_sqr_length(a.data)

    @staticmethod
    def sub(Vec4 out, Vec4 a, Vec4 b):
        Vec4.c_sub(out.data, a.data, b.data)

    @staticmethod
    def transform_mat4(Vec4 out, Vec4 a, Mat4 m):
        Vec4.c_transform_mat4(out.data, a.data, m.data)

    @staticmethod
    def transform_quat(Vec4 out, Vec4 a, Quat q):
        Vec4.c_transform_quat(out.data, a.data, q.data)

    @staticmethod
    cdef void c_add(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        out.x = a.x + b.x
        out.y = a.y + b.y
        out.z = a.z + b.z
        out.w = a.w + b.w
            
    @staticmethod
    cdef void c_ceil(Vec4C *out, Vec4C *a) nogil:
        out.x = c_math.ceil(a.x)
        out.y = c_math.ceil(a.y)
        out.z = c_math.ceil(a.z)
        out.w = c_math.ceil(a.w)
        
    @staticmethod
    cdef void c_copy(Vec4C *out, Vec4C *a) nogil:
        out.x = a.x
        out.y = a.y
        out.z = a.z
        out.w = a.w

    @staticmethod
    cdef float c_dist(Vec4C *a, Vec4C *b) nogil:
        cdef float out = c_math.sqrt(Vec4.c_sqr_dist(a, b))
        return out
        
    @staticmethod
    cdef void c_div(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        out.x = a.x / b.x
        out.y = a.y / b.y
        out.z = a.z / b.z
        out.w = a.w / b.w
        
    @staticmethod
    cdef float c_dot(Vec4C *a, Vec4C *b) nogil:
        cdef float out = 0.0
        out += a.x * b.x
        out += a.y * b.y
        out += a.z * b.z
        out += a.w * b.w
        return out

    @staticmethod
    cdef bint c_equals(Vec4C *a, Vec4C *b) nogil:
        if (
            (a.x != b.x) or 
            (a.y != b.y) or 
            (a.z != b.z) or 
            (a.w != b.w)
        ): 
            return False
        return True
        
    @staticmethod
    cdef void c_floor(Vec4C *out, Vec4C *a) nogil:
        out.x = c_math.floor(a.x)
        out.y = c_math.floor(a.y)
        out.z = c_math.floor(a.z)
        out.w = c_math.floor(a.w)

    @staticmethod
    cdef void c_inv(Vec4C *out, Vec4C *a) nogil:
        out.x = 1.0 / a.x
        out.y = 1.0 / a.y
        out.z = 1.0 / a.z
        out.w = 1.0 / a.w
        
    @staticmethod
    cdef float c_length(Vec4C *a) nogil:
        cdef float out = c_math.sqrt(Vec4.c_sqr_length(a))
        return out

    @staticmethod
    cdef void c_lerp(Vec4C *out, Vec4C *a, Vec4C *b, float t) nogil:
        out.x = a.x + t * (b.x - a.x)
        out.y = a.y + t * (b.y - a.y)
        out.z = a.z + t * (b.z - a.z)
        out.w = a.w + t * (b.w - a.w) 
        
    @staticmethod
    cdef void c_max_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        out.x = max(a.x, b.x)
        out.y = max(a.y, b.y)
        out.z = max(a.z, b.z)
        out.w = max(a.w, b.w)

    @staticmethod
    cdef void c_min_comps(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        out.x = min(a.x, b.x)
        out.y = min(a.y, b.y)
        out.z = min(a.z, b.z)
        out.w = min(a.w, b.w)
        
    @staticmethod
    cdef void c_mul(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        out.x = a.x * b.x
        out.y = a.y * b.y
        out.z = a.z * b.z
        out.w = a.w * b.w
            
    @staticmethod
    cdef bint c_nearly_equals(Vec4C *a, Vec4C *b, float epsilon=0.000001) nogil:
        if (
            c_math.fabs(a.x - b.x) > epsilon * max(1.0, c_math.fabs(a.x), c_math.fabs(b.x)) or
            c_math.fabs(a.y - b.y) > epsilon * max(1.0, c_math.fabs(a.y), c_math.fabs(b.y)) or
            c_math.fabs(a.z - b.z) > epsilon * max(1.0, c_math.fabs(a.z), c_math.fabs(b.z)) or
            c_math.fabs(a.w - b.w) > epsilon * max(1.0, c_math.fabs(a.w), c_math.fabs(b.w))
        ): 
            return False
        return True
    
    @staticmethod
    cdef void c_negate(Vec4C *out, Vec4C *a) nogil:
        out.x = -a.x
        out.y = -a.y
        out.z = -a.z
        out.w = -a.w
        
    @staticmethod
    cdef void c_norm(Vec4C *out, Vec4C *a) nogil:
        cdef float mag = Vec4.c_length(a)
        Vec4.c_scale_add(out, a, scale=1.0/mag)
        
    @staticmethod
    cdef void c_random(Vec4C *out) nogil:
        out.x = rand() / <float>RAND_MAX
        out.y = rand() / <float>RAND_MAX
        out.z = rand() / <float>RAND_MAX
        out.w = rand() / <float>RAND_MAX
        
    @staticmethod
    cdef void c_round(Vec4C *out, Vec4C *a) nogil:
        out.x = c_math.round(a.x)
        out.y = c_math.round(a.y)
        out.z = c_math.round(a.z)
        out.w = c_math.round(a.w)
        
    @staticmethod
    cdef void c_scale_add(Vec4C *out, Vec4C *a, float scale=1.0, float add=0.0) nogil:
        out.x = scale * a.x + add
        out.y = scale * a.y + add
        out.z = scale * a.z + add
        out.w = scale * a.w + add
        
    @staticmethod
    cdef void c_set_data(Vec4C *out, float x=0.0, float y=0.0, float z=0.0, float w=0.0) nogil:
        out.x = x
        out.y = y
        out.z = z
        out.w = w
        
    @staticmethod
    cdef float c_sqr_dist(Vec4C *a, Vec4C *b) nogil:
        cdef float out = 0.0
        out += (b.x - a.x) * (b.x - a.x)
        out += (b.y - a.y) * (b.y - a.y)
        out += (b.z - a.z) * (b.z - a.z)
        out += (b.w - a.w) * (b.w - a.w)
        return out
        
    @staticmethod
    cdef float c_sqr_length(Vec4C *a) nogil:
        cdef float out = 0.0
        out += a.x * a.x
        out += a.y * a.y
        out += a.z * a.z
        out += a.w * a.w
        return out
        
    @staticmethod
    cdef void c_sub(Vec4C *out, Vec4C *a, Vec4C *b) nogil:
        out.x = a.x - b.x
        out.y = a.y - b.y
        out.z = a.z - b.z
        out.w = a.w - b.w
            
    @staticmethod
    cdef void c_transform_mat4(Vec4C *out, Vec4C *a, Mat4C *m) nogil:
        out.x = m.m00*a.x + m.m10*a.y + m.m20*a.z + m.m30*a.w
        out.y = m.m01*a.x + m.m11*a.y + m.m21*a.z + m.m31*a.w
        out.z = m.m02*a.x + m.m12*a.y + m.m22*a.z + m.m32*a.w
        out.w = m.m03*a.x + m.m13*a.y + m.m23*a.z + m.m33*a.w
        
    @staticmethod
    cdef void c_transform_quat(Vec4C *out, Vec4C *a, QuatC *q) nogil:
        cdef QuatC i        
        i.x = q.w * a.x + q.y * a.z - q.z * a.y
        i.y = q.w * a.y + q.z * a.x - q.x * a.z
        i.z = q.w * a.z + q.x * a.y - q.y * a.x
        i.w = -q.x * a.x - q.y * a.y - q.z * a.z
        out.x = i.x * q.w + i.w * -q.x + i.y * -q.z - i.z * -q.y
        out.y = i.y * q.w + i.w * -q.y + i.z * -q.x - i.x * -q.z
        out.z = i.z * q.w + i.w * -q.z + i.x * -q.y - i.y * -q.x
        out.w = a.w