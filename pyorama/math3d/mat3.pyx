cdef class Mat3:
    
    def __init__(self):
        self.ptr = <Mat3C *>calloc(1, sizeof(Mat3C))
        Mat3.c_identity(self.ptr)
    
    def __dealloc__(self):
        free(self.ptr)
        self.ptr = NULL
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = self.ptr
        buffer.len = 9
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
        cdef size_t size = 9
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        return self.ptr[0][i]
        
    def __setitem__(self, size_t i, float value):
        cdef size_t size = 9
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        self.ptr[0][i] = value
    
    @staticmethod
    def add(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_add(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def copy(Mat3 out, Mat3 a):
        Mat3.c_copy(out.ptr, a.ptr)

    @staticmethod
    def det(Mat3 a):
        return Mat3.c_det(a.ptr)

    @staticmethod
    def div(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_div(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def dot(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_dot(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def equals(Mat3 a, Mat3 b):
        return Mat3.c_equals(a.ptr, b.ptr)

    @staticmethod
    def from_mat4(Mat3 out, Mat4 a):
        Mat3.c_from_mat4(out.ptr, a.ptr)

    @staticmethod
    def from_quat(Mat3 out, Quat a):
        Mat3.c_from_quat(out.ptr, a.ptr)

    @staticmethod
    def from_rotation(Mat3 out, float radians):
        Mat3.c_from_rotation(out.ptr, radians)

    @staticmethod
    def from_scaling(Mat3 out, Vec2 scale):
        Mat3.c_from_scaling(out.ptr, scale.ptr)

    @staticmethod
    def from_skewing(Mat3 out, Vec2 factor):
        Mat3.c_from_skewing(out.ptr, factor.ptr)

    @staticmethod
    def from_skewing_x(Mat3 out, float radians):
        Mat3.c_from_skewing_x(out.ptr, radians.ptr)

    @staticmethod
    def from_skewing_y(Mat3 out, float radians):
        Mat3.c_from_skewing_y(out.ptr, radians.ptr)

    @staticmethod
    def from_translation(Mat3 out, Vec2 shift):
        Mat3.c_from_translation(out.ptr, shift.ptr)

    @staticmethod
    def identity(Mat3 out):
        Mat3.c_identity(out.ptr)

    @staticmethod
    def inv(Mat3 out, Mat3 a):
        Mat3.c_inv(out.ptr, a.ptr)

    @staticmethod
    def mul(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_mul(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def nearly_equals(Mat3 a, Mat3 b, float epsilon=epsilon):
        return Mat3.c_nearly_equals(a.ptr, b.ptr, epsilon)

    @staticmethod
    def normal_from_mat4(Mat3 out, Mat4 a):
        Mat3.c_normal_from_mat4(out.ptr, a.ptr)

    @staticmethod
    def random(Mat3 out):
        Mat3.c_random(out.ptr)

    @staticmethod
    def rotate(Mat3 out, Mat3 a, float radians):
        Mat3.c_rotate(out.ptr, a.ptr, radians)

    @staticmethod
    def scale(Mat3 out, Mat3 a, Vec2 factor):
        Mat3.c_scale(out.ptr, a.ptr, factor.ptr)

    @staticmethod
    def scale_add(Mat3 out, Mat3 a, float scale=1.0, float add=0.0):
        Mat3.c_scale_add(out.ptr, a.ptr, scale, add)

    @staticmethod
    def set_data(Mat3 out, float m00=0.0, float m01=0.0, float m02=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0):
        Mat3.c_set_data(out.ptr,
                m00, m01, m02,
                m10, m11, m12,
                m20, m21, m22)

    @staticmethod
    def skew(Mat3 out, Mat3 a, Vec2 factor):
        Mat3.c_skew(out.ptr, a.ptr, factor.ptr)

    @staticmethod
    def skew_x(Mat3 out, Mat3 a, float radians):
        Mat3.c_skew_x(out.ptr, a.ptr, radians)

    @staticmethod
    def skew_y(Mat3 out, Mat3 a, float radians):
        Mat3.c_skew_y(out.ptr, a.ptr, radians)

    @staticmethod
    def sub(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_sub(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def transpose(Mat3 out, Mat3 a):
        Mat3.c_transpose(out.ptr, a.ptr)

    @staticmethod
    def translate(Mat3 out, Mat3 a, Vec2 shift):
        Mat3.c_translate(out.ptr, a.ptr, shift.ptr)
    
    @staticmethod
    cdef inline void c_add(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            out[0][i] = a[0][i] + b[0][i]

    @staticmethod
    cdef inline void c_copy(Mat3C *out, Mat3C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            out[0][i] = a[0][i]

    @staticmethod
    cdef inline float c_det(Mat3C *a) nogil:
        cdef float out = a[0][0] * (a[0][8] * a[0][4] - a[0][5] * a[0][7]) + \
            a[0][3] * (a[0][1] * a[0][8] - a[0][2] * a[0][7]) + \
            a[0][6] * (a[0][1] * a[0][5] - a[0][2] * a[0][4])
        return out

    @staticmethod
    cdef inline void c_div(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            out[0][i] = a[0][i] / b[0][i]

    @staticmethod
    cdef inline void c_dot(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        cdef float a0, a1, a2, a3, a4, a5, a6, a7, a8
        cdef float b0, b1, b2, b3, b4, b5, b6, b7, b8
        a0 = a[0][0]; a1 = a[0][1]; a2 = a[0][2]; 
        a3 = a[0][3]; a4 = a[0][4]; a5 = a[0][5];
        a6 = a[0][6]; a7 = a[0][7]; a8 = a[0][8];
        b0 = b[0][0]; b1 = b[0][1]; b2 = b[0][2]; 
        b3 = b[0][3]; b4 = b[0][4]; b5 = b[0][5];
        b6 = b[0][6]; b7 = b[0][7]; b8 = b[0][8];
        out[0][0] = a0*b0 + a3*b1 + a6*b2
        out[0][1] = a1*b0 + a4*b1 + a7*b2
        out[0][2] = a2*b0 + a5*b1 + a8*b2
        out[0][3] = a0*b3 + a3*b4 + a6*b5
        out[0][4] = a1*b3 + a4*b4 + a7*b5
        out[0][5] = a2*b3 + a5*b4 + a8*b5
        out[0][6] = a0*b6 + a3*b7 + a6*b8
        out[0][7] = a1*b6 + a4*b7 + a7*b8
        out[0][8] = a2*b6 + a5*b7 + a8*b8

    @staticmethod
    cdef inline bint c_equals(Mat3C *a, Mat3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            if a[0][i] != b[0][i]:
                return False
        return True

    @staticmethod
    cdef inline void c_from_mat4(Mat3C *out, Mat4C *a) nogil:
        cdef int *indices = [0, 1, 2, 4, 5, 6, 8, 9, 10]
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            out[0][i] = a[0][indices[i]]

    @staticmethod
    cdef inline void c_from_quat(Mat3C *out, QuatC *a) nogil:
        cdef float x = a[0][0]
        cdef float y = a[0][1]
        cdef float z = a[0][2]
        cdef float w = a[0][3]

        cdef float x2 = x + x
        cdef float y2 = y + y
        cdef float z2 = z + z
        cdef float xx = x * x2
        cdef float yx = y * x2
        cdef float yy = y * y2
        cdef float zx = z * x2
        cdef float zy = z * y2
        cdef float zz = z * z2
        cdef float wx = w * x2
        cdef float wy = w * y2
        cdef float wz = w * z2
        
        out[0][0] = 1 - yy - zz
        out[0][3] = yx - wz
        out[0][6] = zx + wy
        out[0][1] = yx + wz
        out[0][4] = 1 - xx - zz
        out[0][7] = zy - wx
        out[0][2] = zx - wy
        out[0][5] = zy + wx
        out[0][8] = 1 - xx - yy

    @staticmethod
    cdef inline void c_from_rotation(Mat3C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out[0][0] = c
        out[0][1] = s
        out[0][2] = 0
        out[0][3] = -s
        out[0][4] = c
        out[0][5] = 0
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 1

    @staticmethod
    cdef inline void c_from_scaling(Mat3C *out, Vec2C *scale) nogil:
        out[0][0] = scale[0][0]
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = scale[0][1]
        out[0][5] = 0
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 1

    @staticmethod
    cdef inline void c_from_skewing(Mat3C *out, Vec2C *factor) nogil:
        out[0][0] = 1
        out[0][1] = c_math.tan(factor[0][0])
        out[0][2] = 0
        out[0][3] = c_math.tan(factor[0][1])
        out[0][4] = 1
        out[0][5] = 0
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 1

    @staticmethod
    cdef inline void c_from_skewing_x(Mat3C *out, float radians) nogil:
        out[0][0] = 1
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = c_math.tan(radians)
        out[0][4] = 1
        out[0][5] = 0
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 1

    @staticmethod
    cdef inline void c_from_skewing_y(Mat3C *out, float radians) nogil:
        out[0][0] = 1
        out[0][1] = c_math.tan(radians)
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 1
        out[0][5] = 0
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 1

    @staticmethod
    cdef inline void c_from_translation(Mat3C *out, Vec2C *shift) nogil:
        out[0][0] = 1
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 1
        out[0][5] = 0
        out[0][6] = shift[0][0]
        out[0][7] = shift[0][1]
        out[0][8] = 1

    @staticmethod
    cdef inline void c_identity(Mat3C *out) nogil:
        out[0][0] = 1
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 1
        out[0][5] = 0
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 1

    @staticmethod
    cdef inline void c_inv(Mat3C *out, Mat3C *a) nogil:
        cdef float a0, a1, a2, a3, a4, a5, a6, a7, a8
        a0 = a[0][0]; a1 = a[0][1]; a2 = a[0][2]; 
        a3 = a[0][3]; a4 = a[0][4]; a5 = a[0][5];
        a6 = a[0][6]; a7 = a[0][7]; a8 = a[0][8];
        cdef float d = Mat3.c_det(a)
        if d == 0.0:
            raise ValueError("{0} is not an invertible matrix".format(a[0]))
        d = 1.0 / d
        out[0][0] = (a8 * a4 - a5 * a7) * d
        out[0][1] = (a2 * a7 - a8 * a1) * d
        out[0][2] = (a5 * a1 - a2 * a4) * d
        out[0][3] = (a1 * a8 - a2 * a7) * d
        out[0][4] = (a8 * a0 - a2 * a6) * d
        out[0][5] = (a2 * a3 - a5 * a0) * d
        out[0][6] = (a1 * a5 - a2 * a4) * d
        out[0][7] = (a1 * a6 - a7 * a0) * d
        out[0][8] = (a4 * a0 - a1 * a3) * d

    @staticmethod
    cdef inline void c_mul(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            out[0][i] = a[0][i] * b[0][i]

    @staticmethod
    cdef inline bint c_nearly_equals(Mat3C *a, Mat3C *b, float epsilon=epsilon) nogil:
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            if c_math.fabs(a[0][i] - b[0][i]) > epsilon * max(1.0, c_math.fabs(a[0][i]), c_math.fabs(b[0][i])):
                return False
        return True

    @staticmethod
    cdef inline void c_normal_from_mat4(Mat3C *out, Mat4C *a) nogil:
        cdef Mat4C a_t
        if Mat4.c_det(a) != 0:
            Mat4.c_transpose(&a_t, a)
            Mat4.c_inv(&a_t, &a_t)
            Mat3.c_from_mat4(out, &a_t)

    @staticmethod
    cdef inline void c_random(Mat3C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            out[0][i] = rand() / float(RAND_MAX)

    @staticmethod
    cdef inline void c_rotate(Mat3C *out, Mat3C *a, float radians) nogil:
        cdef Mat3C rot_mat
        Mat3.c_from_rotation(&rot_mat, radians)
        Mat3.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef inline void c_scale(Mat3C *out, Mat3C *a, Vec2C *factor) nogil:
        cdef Mat3C scale_mat
        Mat3.c_from_scaling(&scale_mat, factor)
        Mat3.c_dot(out, a, &scale_mat)

    @staticmethod
    cdef inline void c_scale_add(Mat3C *out, Mat3C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            out[0][i] = scale * a[0][i] + add

    @staticmethod
    cdef inline void c_set_data(Mat3C *out, float m00=0.0, float m01=0.0, float m02=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0) nogil:
        out[0][0] = m00
        out[0][1] = m01
        out[0][2] = m02
        out[0][3] = m10
        out[0][4] = m11
        out[0][5] = m12
        out[0][6] = m20
        out[0][7] = m21
        out[0][8] = m22

    @staticmethod
    cdef inline void c_skew(Mat3C *out, Mat3C *a, Vec2C *factor) nogil:
        cdef Mat3C skew_mat
        Mat3.c_from_skewing(&skew_mat, factor)
        Mat3.c_dot(out, a, &skew_mat)

    @staticmethod
    cdef inline void c_skew_x(Mat3C *out, Mat3C *a, float radians) nogil:
        cdef Mat3C skew_mat
        Mat3.c_from_skewing_x(&skew_mat, radians)
        Mat3.c_dot(out, a, &skew_mat)

    @staticmethod
    cdef inline void c_skew_y(Mat3C *out, Mat3C *a, float radians) nogil:
        cdef Mat3C skew_mat
        Mat3.c_from_skewing_y(&skew_mat, radians)
        Mat3.c_dot(out, a, &skew_mat)

    @staticmethod
    cdef inline void c_sub(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 9
        for i in xrange(size):
            out[0][i] = a[0][i] - b[0][i]

    @staticmethod
    cdef inline void c_transpose(Mat3C *out, Mat3C *a) nogil:
        cdef float a0, a1, a2, a3, a4, a5, a6, a7, a8
        a0 = a[0][0]; a1 = a[0][1]; a2 = a[0][2]; 
        a3 = a[0][3]; a4 = a[0][4]; a5 = a[0][5];
        a6 = a[0][6]; a7 = a[0][7]; a8 = a[0][8];
        out[0][0] = a0
        out[0][1] = a3
        out[0][2] = a6
        out[0][3] = a1
        out[0][4] = a4
        out[0][5] = a7
        out[0][6] = a2
        out[0][7] = a5
        out[0][8] = a8

    @staticmethod
    cdef inline void c_translate(Mat3C *out, Mat3C *a, Vec2C *shift) nogil:
        cdef Mat3C trans_mat
        Mat3.c_from_translation(&trans_mat, shift)
        Mat3.c_dot(out, a, &trans_mat)