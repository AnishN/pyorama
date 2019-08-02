cdef class Mat2:
    
    def __init__(self):
        self.ptr = <Mat2C *>calloc(1, sizeof(Mat2C))
        Mat2.c_identity(self.ptr)
    
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
    
    @staticmethod
    def add(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_add(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def copy(Mat2 out, Mat2 a):
        Mat2.c_copy(out.ptr, a.ptr)

    @staticmethod
    def det(Mat2 a):
        return Mat2.c_det(a.ptr)

    @staticmethod
    def div(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_div(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def dot(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_dot(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def equals(Mat2 a, Mat2 b):
        return Mat2.c_equals(a.ptr, b.ptr)

    @staticmethod
    def from_rotation(Mat2 out, float radians):
        Mat2.c_from_rotation(out.ptr, radians)

    @staticmethod
    def from_scaling(Mat2 out, Vec3 scale):
        Mat2.c_from_scaling(out.ptr, scale.ptr)
    
    @staticmethod
    def identity(Mat2 out):
        Mat2.c_identity(out.ptr)

    @staticmethod
    def inv(Mat2 out, Mat2 a):
        Mat2.c_inv(out.ptr, a.ptr)

    @staticmethod
    def mul(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_mul(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def nearly_equals(Mat2 a, Mat2 b, float epsilon=epsilon):
        return Mat2.c_nearly_equals(a.ptr, b.ptr, epsilon)

    @staticmethod
    def random(Mat2 out):
        Mat2.c_random(out.ptr)

    @staticmethod
    def rotate(Mat2 out, Mat2 a, float radians):
        Mat2.c_rotate(out.ptr, a.ptr, radians)

    @staticmethod
    def scale(Mat2 out, Mat2 a, Vec3 factor):
        Mat2.c_scale(out.ptr, a.ptr, factor.ptr)

    @staticmethod
    def scale_add(Mat2 out, Mat2 a, float scale=1.0, float add=0.0):
        Mat2.c_scale_add(out.ptr, a.ptr, scale, add)

    @staticmethod
    def set_data(Mat2 out, float m00=0.0, float m01=0.0, float m10=0.0, float m11=0.0):
        Mat2.c_set_data(out.ptr, m00, m01, m10, m11)

    @staticmethod
    def sub(Mat2 out, Mat2 a, Mat2 b):
        Mat2.c_sub(out.ptr, a.ptr, b.ptr)
    
    @staticmethod
    def transpose(Mat2 out, Mat2 a):
        Mat2.c_transpose(out.ptr, a.ptr)

    @staticmethod
    cdef inline void c_add(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] + b[0][i]
        
    @staticmethod
    cdef inline void c_copy(Mat2C *out, Mat2C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i]
        
    @staticmethod
    cdef inline float c_det(Mat2C *a) nogil:
        cdef float out = (a[0][0] * a[0][3]) - (a[0][2] * a[0][1])
        return out
        
    @staticmethod
    cdef inline void c_div(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] / b[0][i]
        
    @staticmethod
    cdef inline void c_dot(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        cdef float a0, a1, a2, a3
        cdef float b0, b1, b2, b3
        a0 = a[0][0]; a1 = a[0][1]; a2 = a[0][2]; a3 = a[0][3]
        b0 = b[0][0]; b1 = b[0][1]; b2 = b[0][2]; b3 = b[0][3]
        out[0][0] = a0*b0 + a2*b1
        out[0][1] = a1*b0 + a3*b1
        out[0][2] = a0*b2 + a2*b3
        out[0][3] = a1*b2 + a3*b3
        
    @staticmethod
    cdef inline bint c_equals(Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if a[0][i] != b[0][i]:
                return False
        return True
        
    @staticmethod
    cdef inline void c_from_rotation(Mat2C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out[0][0] = c
        out[0][1] = s
        out[0][2] = -s
        out[0][3] = c
        
    @staticmethod
    cdef inline void c_from_scaling(Mat2C *out, Vec3C *scale) nogil:
        out[0][0] = scale[0][0]
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = scale[0][1]

    @staticmethod
    cdef inline void c_identity(Mat2C *out) nogil:
        out[0][0] = 1
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 1
        
    @staticmethod
    cdef inline void c_inv(Mat2C *out, Mat2C *a) nogil:
        cdef float a0, a1, a2, a3
        a0 = a[0][0]; a1 = a[0][1]; a2 = a[0][2]; a3 = a[0][3]
        cdef float d = Mat2.c_det(a)
        if d == 0.0:
            raise ValueError("{0} is not an invertible matrix".format(a[0]))
        d = 1.0 / d
        out[0][0] = a3 * d
        out[0][1] = -a1 * d
        out[0][2] = -a2 * d
        out[0][3] = a0 * d

    @staticmethod
    cdef inline void c_mul(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] * b[0][i]
            
    @staticmethod
    cdef inline bint c_nearly_equals(Mat2C *a, Mat2C *b, float epsilon=epsilon) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if c_math.fabs(a[0][i] - b[0][i]) > epsilon * max(1.0, c_math.fabs(a[0][i]), c_math.fabs(b[0][i])):
                return False
        return True

    @staticmethod
    cdef inline void c_random(Mat2C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = rand() / float(RAND_MAX)
        
    @staticmethod
    cdef inline void c_rotate(Mat2C *out, Mat2C *a, float radians) nogil:
        Mat2.c_from_rotation(out, radians)
        Mat2.c_dot(out, a, out)
        
    @staticmethod
    cdef inline void c_scale(Mat2C *out, Mat2C *a, Vec3C *factor) nogil:
        Mat2.c_from_scaling(out, factor)
        Mat2.c_dot(out, a, out)
        
    @staticmethod
    cdef inline void c_scale_add(Mat2C *out, Mat2C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = scale * a[0][i] + add
        
    @staticmethod
    cdef inline void c_set_data(Mat2C *out, float m00=0.0, float m01=0.0, float m10=0.0, float m11=0.0) nogil:
        out[0][0] = m00
        out[0][1] = m01
        out[0][2] = m10
        out[0][3] = m11

    @staticmethod
    cdef inline void c_sub(Mat2C *out, Mat2C *a, Mat2C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] - b[0][i]
            
    @staticmethod
    cdef inline void c_transpose(Mat2C *out, Mat2C *a) nogil:
        cdef float a0, a1, a2, a3
        a0 = a[0][0]; a1 = a[0][1]; a2 = a[0][2]; a3 = a[0][3]
        out[0][0] = a0
        out[0][1] = a2
        out[0][2] = a1
        out[0][3] = a3