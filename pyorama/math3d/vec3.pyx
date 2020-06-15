cdef class Vec3:
    
    def __init__(self, float x=0.0, float y=0.0, float z=0.0):
        Vec3.c_set_data(&self.data, x, y, z)
    
    def __dealloc__(self):
        memset(&self.data, 0, sizeof(Vec3C))
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = &self.data
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
    
    property x:
        def __get__(self): return self.x
        def __set__(self, float new_x): self.x = new_x
    
    property y:
        def __get__(self): return self.data.y
        def __set__(self, float new_y): self.data.y = new_y
        
    property z:
        def __get__(self): return self.data.z
        def __set__(self, float new_z): self.data.z = new_z
    
    @staticmethod
    def add(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_add(&out.data, &a.data, &b.data)

    @staticmethod
    def angle(Vec3 a, Vec3 b):
        return Vec3.c_angle(&a.data, &b.data)

    @staticmethod
    def ceil(Vec3 out, Vec3 a):
        Vec3.c_ceil(&out.data, &a.data)

    @staticmethod
    def copy(Vec3 out, Vec3 a):
        Vec3.c_copy(&out.data, &a.data)

    @staticmethod
    def cross(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_cross(&out.data, &a.data, &b.data)

    @staticmethod
    def dist(Vec3 a, Vec3 b):
        return Vec3.c_dist(&a.data, &b.data)

    @staticmethod
    def div(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_div(&out.data, &a.data, &b.data)

    @staticmethod
    def dot(Vec3 a, Vec3 b):
        return Vec3.c_dot(&a.data, &b.data)

    @staticmethod
    def equals(Vec3 a, Vec3 b):
        return Vec3.c_equals(&a.data, &b.data)

    @staticmethod
    def floor(Vec3 out, Vec3 a):
        Vec3.c_floor(&out.data, &a.data)

    @staticmethod
    def inv(Vec3 out, Vec3 a):
        Vec3.c_inv(&out.data, &a.data)

    @staticmethod
    def length(Vec3 a):
        return Vec3.c_length(&a.data)

    @staticmethod
    def lerp(Vec3 out, Vec3 a, Vec3 b, float t):
        Vec3.c_lerp(&out.data, &a.data, &b.data, t)

    @staticmethod
    def max_comps(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_max_comps(&out.data, &a.data, &b.data)

    @staticmethod
    def min_comps(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_min_comps(&out.data, &a.data, &b.data)

    @staticmethod
    def mul(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    def nearly_equals(Vec3 a, Vec3 b, float epsilon=0.000001):
        Vec3.c_nearly_equals(&a.data, &b.data, epsilon)

    @staticmethod
    def negate(Vec3 out, Vec3 a):
        Vec3.c_negate(&out.data, &a.data)

    @staticmethod
    def norm(Vec3 out, Vec3 a):
        Vec3.c_norm(&out.data, &a.data)

    @staticmethod
    def random(Vec3 out):
        Vec3.c_random(&out.data)

    @staticmethod
    def round(Vec3 out, Vec3 a):
        Vec3.c_round(&out.data, &a.data)

    @staticmethod
    def scale_add(Vec3 out, Vec3 a, float scale=1.0, float add=0.0):
        Vec3.c_scale_add(&out.data, &a.data, scale, add)

    @staticmethod
    def set_data(Vec3 out, float x=0.0, float y=0.0, float z=0.0):
        Vec3.c_set_data(&out.data, x, y, z)

    @staticmethod
    def sqr_dist(Vec3 a, Vec3 b):
        return Vec3.c_sqr_dist(&a.data, &b.data)

    @staticmethod
    def sqr_length(Vec3 a):
        return Vec3.c_sqr_length(&a.data)

    @staticmethod
    def sub(Vec3 out, Vec3 a, Vec3 b):
        Vec3.c_sub(&out.data, &a.data, &b.data)

    @staticmethod
    def transform_mat3(Vec3 out, Vec3 a, Mat3 m):
        Vec3.c_transform_mat3(&out.data, &a.data, &m.data)

    @staticmethod
    def transform_mat4(Vec3 out, Vec3 a, Mat4 m):
        Vec3.c_transform_mat4(&out.data, &a.data, &m.data)

    @staticmethod
    def transform_quat(Vec3 out, Vec3 a, Quat q):
        Vec3.c_transform_quat(&out.data, &a.data, &q.data)

    @staticmethod
    cdef void c_add(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        out.x = a.x + b.x
        out.y = a.y + b.y
        out.z = a.z + b.z
        
    @staticmethod
    cdef float c_angle(Vec3C *a, Vec3C *b) nogil:
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
    cdef void c_ceil(Vec3C *out, Vec3C *a) nogil:
        out.x = c_math.ceil(a.x)
        out.y = c_math.ceil(a.y)
        out.z = c_math.ceil(a.z)

    @staticmethod
    cdef void c_copy(Vec3C *out, Vec3C *a) nogil:
        out.x = a.x
        out.y = a.y
        out.z = a.z

    @staticmethod
    cdef void c_cross(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        out.x = a.y * b.z - a.z * b.y
        out.y = a.z * b.x - a.x * b.z
        out.z = a.x * b.y - a.y * b.x

    @staticmethod
    cdef float c_dist(Vec3C *a, Vec3C *b) nogil:
        cdef float out = c_math.sqrt(Vec3.c_sqr_dist(a, b))
        return out

    @staticmethod
    cdef void c_div(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        out.x = a.x / b.x
        out.y = a.y / b.y
        out.z = a.z / b.z

    @staticmethod
    cdef float c_dot(Vec3C *a, Vec3C *b) nogil:
        cdef float out = 0.0
        out += a.x * b.x
        out += a.y * b.y
        out += a.z * b.z
        return out

    @staticmethod
    cdef bint c_equals(Vec3C *a, Vec3C *b) nogil:
        if (
            (a.x != b.x) or 
            (a.y != b.y) or 
            (a.z != b.z)
        ): 
            return False
        return True
        
    @staticmethod
    cdef void c_floor(Vec3C *out, Vec3C *a) nogil:
        out.x = c_math.floor(a.x)
        out.y = c_math.floor(a.y)
        out.z = c_math.floor(a.z)

    @staticmethod
    cdef void c_inv(Vec3C *out, Vec3C *a) nogil:
        out.x = 1.0 / a.x
        out.y = 1.0 / a.y
        out.z = 1.0 / a.z
        
    @staticmethod
    cdef float c_length(Vec3C *a) nogil:
        cdef float out = c_math.sqrt(Vec3.c_sqr_length(a))
        return out
        
    @staticmethod
    cdef void c_lerp(Vec3C *out, Vec3C *a, Vec3C *b, float t) nogil:
        out.x = a.x + t * (b.x - a.x)
        out.y = a.y + t * (b.y - a.y)
        out.z = a.z + t * (b.z - a.z)
        
    @staticmethod
    cdef void c_max_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        out.x = max(a.x, b.x)
        out.y = max(a.y, b.y)
        out.z = max(a.z, b.z)

    @staticmethod
    cdef void c_min_comps(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        out.x = min(a.x, b.x)
        out.y = min(a.y, b.y)
        out.z = min(a.z, b.z)
        
    @staticmethod
    cdef void c_mul(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        out.x = a.x * b.x
        out.y = a.y * b.y
        out.z = a.z * b.z
            
    @staticmethod
    cdef bint c_nearly_equals(Vec3C *a, Vec3C *b, float epsilon=0.000001) nogil:
        if (
            c_math.fabs(a.x - b.x) > epsilon * max(1.0, c_math.fabs(a.x), c_math.fabs(b.x)) or
            c_math.fabs(a.y - b.y) > epsilon * max(1.0, c_math.fabs(a.y), c_math.fabs(b.y)) or
            c_math.fabs(a.z - b.z) > epsilon * max(1.0, c_math.fabs(a.z), c_math.fabs(b.z))
        ): 
            return False
        return True
        
    @staticmethod
    cdef void c_negate(Vec3C *out, Vec3C *a) nogil:
        out.x = -a.x
        out.y = -a.y
        out.z = -a.z
        
    @staticmethod
    cdef void c_norm(Vec3C *out, Vec3C *a) nogil:
        cdef float mag = Vec3.c_length(a)
        Vec3.c_scale_add(out, a, scale=1.0/mag)
        
    @staticmethod
    cdef void c_random(Vec3C *out) nogil:
        out.x = rand() / <float>RAND_MAX
        out.y = rand() / <float>RAND_MAX
        out.z = rand() / <float>RAND_MAX

    @staticmethod
    cdef void c_round(Vec3C *out, Vec3C *a) nogil:
        out.x = c_math.round(a.x)
        out.y = c_math.round(a.y)
        out.z = c_math.round(a.z)
        
    @staticmethod
    cdef void c_scale_add(Vec3C *out, Vec3C *a, float scale=1.0, float add=0.0) nogil:
        out.x = scale * a.x + add
        out.y = scale * a.y + add
        out.z = scale * a.z + add
        
    @staticmethod
    cdef void c_set_data(Vec3C *out, float x=0.0, float y=0.0, float z=0.0) nogil:
        out.x = x
        out.y = y
        out.z = z
        
    @staticmethod
    cdef float c_sqr_dist(Vec3C *a, Vec3C *b) nogil:
        cdef float out = 0.0
        out += (b.x - a.x) * (b.x - a.x)
        out += (b.y - a.y) * (b.y - a.y)
        out += (b.z - a.z) * (b.z - a.z)
        return out
        
    @staticmethod
    cdef float c_sqr_length(Vec3C *a) nogil:
        cdef float out = 0.0
        out += a.x * a.x
        out += a.y * a.y
        out += a.z * a.z
        return out
        
    @staticmethod
    cdef void c_sub(Vec3C *out, Vec3C *a, Vec3C *b) nogil:
        out.x = a.x - b.x
        out.y = a.y - b.y
        out.z = a.z - b.z
            
    @staticmethod
    cdef void c_transform_mat3(Vec3C *out, Vec3C *a, Mat3C *m) nogil:
        out.x = m.m00*a.x + m.m10*a.y + m.m20*a.z
        out.y = m.m01*a.x + m.m11*a.y + m.m21*a.z
        out.z = m.m02*a.x + m.m12*a.y + m.m22*a.z
        
    @staticmethod
    cdef void c_transform_mat4(Vec3C *out, Vec3C *a, Mat4C *m) nogil:
        cdef float w = 0.0
        w = m.m03*a.x + m.m13*a.y + m.m23*a.z + m.m33
        if w == 0:
            w = 1.0
        out.x = (m.m00*a.x + m.m10*a.y + m.m20*a.z + m.m30) / w
        out.y = (m.m01*a.x + m.m11*a.y + m.m21*a.z + m.m31) / w
        out.z = (m.m02*a.x + m.m12*a.y + m.m22*a.z + m.m32) / w
        
    @staticmethod
    cdef void c_transform_quat(Vec3C *out, Vec3C *a, QuatC *q) nogil:
        cdef QuatC i     
        i.x = q.w * a.x + q.y * a.z - q.z * a.y
        i.y = q.w * a.y + q.z * a.x - q.x * a.z
        i.z = q.w * a.z + q.x * a.y - q.y * a.x
        i.w = -q.x * a.x - q.y * a.y - q.z * a.z
        out.x = i.x * q.w + i.w * -q.x + i.y * -q.z - i.z * -q.y
        out.y = i.y * q.w + i.w * -q.y + i.z * -q.x - i.x * -q.z
        out.z = i.z * q.w + i.w * -q.z + i.x * -q.y - i.y * -q.x