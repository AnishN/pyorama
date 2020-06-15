cdef class Mat2:
    def __init__(self):
        Mat2.c_identity(&self.data)
    
    def __dealloc__(self):
        memset(&self.data, 0, sizeof(Mat2C))
    
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
    
    @staticmethod
    def add(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_add(&out.data, &a.data, &b.data)
    
    @staticmethod
    def copy(Mat2 out, Mat2 a):
        Mat2.c_copy(&out.data, &a.data)

    @staticmethod
    def det(Mat2 a):
        return Mat2.c_det(&a.data)

    @staticmethod
    def div(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_div(&out.data, &a.data, &b.data)

    @staticmethod
    def dot(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_dot(&out.data, &a.data, &b.data)

    @staticmethod
    def equals(Mat2 a, Mat2 b):
        return Mat2.c_equals(&a.data, &b.data)

    @staticmethod
    def from_rotation(Mat2 out, float radians):
        Mat2.c_from_rotation(&out.data, radians)

    @staticmethod
    def from_scaling(Mat2 out, Vec3 scale):
        Mat2.c_from_scaling(&out.data, &scale.data)
    
    @staticmethod
    def identity(Mat2 out):
        Mat2.c_identity(&out.data)

    @staticmethod
    def inv(Mat2 out, Mat2 a):
        Mat2.c_inv(&out.data, &a.data)

    @staticmethod
    def mul(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    def nearly_equals(Mat2 a, Mat2 b, float epsilon=0.000001):
        return Mat2.c_nearly_equals(&a.data, &b.data, epsilon)

    @staticmethod
    def random(Mat2 out):
        Mat2.c_random(&out.data)

    @staticmethod
    def rotate(Mat2 out, Mat2 a, float radians):
        Mat2.c_rotate(&out.data, &a.data, radians)

    @staticmethod
    def scale(Mat2 out, Mat2 a, Vec3 factor):
        Mat2.c_scale(&out.data, &a.data, &factor.data)

    @staticmethod
    def scale_add(Mat2 out, Mat2 a, float scale=1.0, float add=0.0):
        Mat2.c_scale_add(&out.data, &a.data, scale, add)

    @staticmethod
    def set_data(Mat2 out, float m00=0.0, float m01=0.0, float m10=0.0, float m11=0.0):
        Mat2.c_set_data(&out.data, m00, m01, m10, m11)

    @staticmethod
    def sub(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_sub(&out.data, &a.data, &b.data)
    
    @staticmethod
    def transpose(Mat2 out, Mat2 a):
        Mat2.c_transpose(&out.data, &a.data)
    
    @staticmethod
    cdef void c_add(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] + (<float *>b)[i]
        
    @staticmethod
    cdef void c_copy(Mat2C *out, Mat2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i]
        
    @staticmethod
    cdef float c_det(Mat2C *a) nogil:
        cdef float out = (a.m00 * a.m11) - (a.m10 * a.m01)
        return out
        
    @staticmethod
    cdef void c_div(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] / (<float *>b)[i]
        
    @staticmethod
    cdef void c_dot(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        a.m00 = a.m00; a.m01 = a.m01; a.m10 = a.m10; a.m11 = a.m11
        b.m00 = b.m00; b.m01 = b.m01; b.m10 = b.m10; b.m11 = b.m11
        out.m00 = a.m00*b.m00 + a.m10*b.m01
        out.m01 = a.m01*b.m00 + a.m11*b.m01
        out.m10 = a.m00*b.m10 + a.m10*b.m11
        out.m11 = a.m01*b.m10 + a.m11*b.m11
        
    @staticmethod
    cdef bint c_equals(Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if (<float *>a)[i] != (<float *>b)[i]:
                return False
        return True
        
    @staticmethod
    cdef void c_from_rotation(Mat2C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out.m00 = c
        out.m01 = s
        out.m10 = -s
        out.m11 = c
        
    @staticmethod
    cdef void c_from_scaling(Mat2C *out, Vec3C *scale) nogil:
        out.m00 = scale.x
        out.m01 = 0
        out.m10 = 0
        out.m11 = scale.y

    @staticmethod
    cdef void c_identity(Mat2C *out) nogil:
        out.m00 = 1
        out.m01 = 0
        out.m10 = 0
        out.m11 = 1
        
    @staticmethod
    cdef void c_inv(Mat2C *out, Mat2C *a) nogil:
        cdef float d = Mat2.c_det(a)
        if d == 0.0:
            raise ValueError("{0} is not an invertible matrix".format(a[0]))
        d = 1.0 / d
        out.m00 = a.m11 * d
        out.m01 = -a.m01 * d
        out.m10 = -a.m10 * d
        out.m11 = a.m00 * d

    @staticmethod
    cdef void c_mul(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] * (<float *>b)[i]
            
    @staticmethod
    cdef bint c_nearly_equals(Mat2C *a, Mat2C *b, float epsilon=0.000001) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if c_math.fabs((<float *>a)[i] - (<float *>b)[i]) > epsilon * max(1.0, c_math.fabs((<float *>a)[i]), c_math.fabs((<float *>b)[i])):
                return False
        return True

    @staticmethod
    cdef void c_random(Mat2C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = rand() / <float>RAND_MAX
        
    @staticmethod
    cdef void c_rotate(Mat2C *out, Mat2C *a, float radians) nogil:
        Mat2.c_from_rotation(out, radians)
        Mat2.c_dot(out, a, out)
        
    @staticmethod
    cdef void c_scale(Mat2C *out, Mat2C *a, Vec3C *factor) nogil:
        Mat2.c_from_scaling(out, factor)
        Mat2.c_dot(out, a, out)
        
    @staticmethod
    cdef void c_scale_add(Mat2C *out, Mat2C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = scale * (<float *>a)[i] + add
        
    @staticmethod
    cdef void c_set_data(Mat2C *out, float m00=0.0, float m01=0.0, float m10=0.0, float m11=0.0) nogil:
        out.m00 = m00
        out.m01 = m01
        out.m10 = m10
        out.m11 = m11

    @staticmethod
    cdef void c_sub(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] - (<float *>b)[i]
            
    @staticmethod
    cdef void c_transpose(Mat2C *out, Mat2C *a) nogil:
        out.m00 = a.m00
        out.m01 = a.m10
        out.m10 = a.m01
        out.m11 = a.m11
