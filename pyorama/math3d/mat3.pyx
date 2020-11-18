cdef class Mat3:
    
    def __cinit__(self):
        Mat3.c_identity(&self.data)
    
    def __dealloc__(self):
        memset(&self.data, 0, sizeof(Mat3C))
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = &self.data
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
    
    @staticmethod
    def add(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_add(&out.data, &a.data, &b.data)

    @staticmethod
    def copy(Mat3 out, Mat3 a):
        Mat3.c_copy(&out.data, &a.data)

    @staticmethod
    def det(Mat3 a):
        return Mat3.c_det(&a.data)

    @staticmethod
    def div(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_div(&out.data, &a.data, &b.data)

    @staticmethod
    def dot(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_dot(&out.data, &a.data, &b.data)

    @staticmethod
    def equals(Mat3 a, Mat3 b):
        return Mat3.c_equals(&a.data, &b.data)

    @staticmethod
    def from_mat4(Mat3 out, Mat4 a):
        Mat3.c_from_mat4(&out.data, &a.data)

    @staticmethod
    def from_quat(Mat3 out, Quat a):
        Mat3.c_from_quat(&out.data, &a.data)

    @staticmethod
    def from_rotation(Mat3 out, float radians):
        Mat3.c_from_rotation(&out.data, radians)

    @staticmethod
    def from_scaling(Mat3 out, Vec2 scale):
        Mat3.c_from_scaling(&out.data, &scale.data)

    @staticmethod
    def from_skewing(Mat3 out, Vec2 factor):
        Mat3.c_from_skewing(&out.data, &factor.data)

    @staticmethod
    def from_skewing_x(Mat3 out, float radians):
        Mat3.c_from_skewing_x(&out.data, radians)

    @staticmethod
    def from_skewing_y(Mat3 out, float radians):
        Mat3.c_from_skewing_y(&out.data, radians)

    @staticmethod
    def from_translation(Mat3 out, Vec2 shift):
        Mat3.c_from_translation(&out.data, &shift.data)

    @staticmethod
    def identity(Mat3 out):
        Mat3.c_identity(&out.data)

    @staticmethod
    def inv(Mat3 out, Mat3 a):
        Mat3.c_inv(&out.data, &a.data)

    @staticmethod
    def mul(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    def nearly_equals(Mat3 a, Mat3 b, float epsilon=0.000001):
        return Mat3.c_nearly_equals(&a.data, &b.data, epsilon)

    @staticmethod
    def normal_from_mat4(Mat3 out, Mat4 a):
        Mat3.c_normal_from_mat4(&out.data, &a.data)

    @staticmethod
    def random(Mat3 out):
        Mat3.c_random(&out.data)

    @staticmethod
    def rotate(Mat3 out, Mat3 a, float radians):
        Mat3.c_rotate(&out.data, &a.data, radians)

    @staticmethod
    def scale(Mat3 out, Mat3 a, Vec2 factor):
        Mat3.c_scale(&out.data, &a.data, &factor.data)

    @staticmethod
    def scale_add(Mat3 out, Mat3 a, float scale=1.0, float add=0.0):
        Mat3.c_scale_add(&out.data, &a.data, scale, add)

    @staticmethod
    def set_data(Mat3 out, float m00=0.0, float m01=0.0, float m02=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0):
        Mat3.c_set_data(&out.data,
                m00, m01, m02,
                m10, m11, m12,
                m20, m21, m22)

    @staticmethod
    def skew(Mat3 out, Mat3 a, Vec2 factor):
        Mat3.c_skew(&out.data, &a.data, &factor.data)

    @staticmethod
    def skew_x(Mat3 out, Mat3 a, float radians):
        Mat3.c_skew_x(&out.data, &a.data, radians)

    @staticmethod
    def skew_y(Mat3 out, Mat3 a, float radians):
        Mat3.c_skew_y(&out.data, &a.data, radians)

    @staticmethod
    def sub(Mat3 out, Mat3 a, Mat3 b):
        Mat3.c_sub(&out.data, &a.data, &b.data)

    @staticmethod
    def transpose(Mat3 out, Mat3 a):
        Mat3.c_transpose(&out.data, &a.data)

    @staticmethod
    def translate(Mat3 out, Mat3 a, Vec2 shift):
        Mat3.c_translate(&out.data, &a.data, &shift.data)
    
    @staticmethod
    cdef void c_add(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        out.m00 = a.m00 + b.m00
        out.m01 = a.m01 + b.m01
        out.m02 = a.m02 + b.m02
        out.m10 = a.m10 + b.m10
        out.m11 = a.m11 + b.m11
        out.m12 = a.m12 + b.m12
        out.m20 = a.m20 + b.m20
        out.m21 = a.m21 + b.m21
        out.m22 = a.m22 + b.m22

    @staticmethod
    cdef void c_copy(Mat3C *out, Mat3C *a) nogil:
        out.m00 = a.m00
        out.m01 = a.m01
        out.m02 = a.m02
        out.m10 = a.m10
        out.m11 = a.m11
        out.m12 = a.m12
        out.m20 = a.m20
        out.m21 = a.m21
        out.m22 = a.m22

    @staticmethod
    cdef float c_det(Mat3C *a) nogil:
        cdef float out = a.m00 * (a.m22 * a.m11 - a.m12 * a.m21) + \
            a.m10 * (a.m01 * a.m22 - a.m02 * a.m21) + \
            a.m20 * (a.m01 * a.m12 - a.m02 * a.m11)
        return out

    @staticmethod
    cdef void c_div(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        out.m00 = a.m00 / b.m00
        out.m01 = a.m01 / b.m01
        out.m02 = a.m02 / b.m02
        out.m10 = a.m10 / b.m10
        out.m11 = a.m11 / b.m11
        out.m12 = a.m12 / b.m12
        out.m20 = a.m20 / b.m20
        out.m21 = a.m21 / b.m21
        out.m22 = a.m22 / b.m22

    @staticmethod
    cdef void c_dot(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        out.m00 = a.m00*b.m00 + a.m10*b.m01 + a.m20*b.m02
        out.m01 = a.m01*b.m00 + a.m11*b.m01 + a.m21*b.m02
        out.m02 = a.m02*b.m00 + a.m12*b.m01 + a.m22*b.m02
        out.m10 = a.m00*b.m10 + a.m10*b.m11 + a.m20*b.m12
        out.m11 = a.m01*b.m10 + a.m11*b.m11 + a.m21*b.m12
        out.m12 = a.m02*b.m10 + a.m12*b.m11 + a.m22*b.m12
        out.m20 = a.m00*b.m20 + a.m10*b.m21 + a.m20*b.m22
        out.m21 = a.m01*b.m20 + a.m11*b.m21 + a.m21*b.m22
        out.m22 = a.m02*b.m20 + a.m12*b.m21 + a.m22*b.m22

    @staticmethod
    cdef bint c_equals(Mat3C *a, Mat3C *b) nogil:
        if (
            (a.m00 != b.m00) or 
            (a.m01 != b.m01) or 
            (a.m02 != b.m02) or
            (a.m10 != b.m10) or 
            (a.m11 != b.m11) or 
            (a.m12 != b.m12) or
            (a.m20 != b.m20) or 
            (a.m21 != b.m21) or 
            (a.m22 != b.m22)
        ): 
            return False
        return True

    @staticmethod
    cdef void c_from_mat4(Mat3C *out, Mat4C *a) nogil:
        out.m00 = a.m00
        out.m01 = a.m01
        out.m02 = a.m02
        out.m10 = a.m10
        out.m11 = a.m11
        out.m12 = a.m12
        out.m20 = a.m20
        out.m21 = a.m21
        out.m22 = a.m22

    @staticmethod
    cdef void c_from_quat(Mat3C *out, QuatC *a) nogil:
        cdef float x = a.x
        cdef float y = a.y
        cdef float z = a.z
        cdef float w = a.w

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
        
        out.m00 = 1 - yy - zz
        out.m10 = yx - wz
        out.m20 = zx + wy
        out.m01 = yx + wz
        out.m11 = 1 - xx - zz
        out.m21 = zy - wx
        out.m02 = zx - wy
        out.m12 = zy + wx
        out.m22 = 1 - xx - yy

    @staticmethod
    cdef void c_from_rotation(Mat3C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out.m00 = c
        out.m01 = s
        out.m02 = 0
        out.m10 = -s
        out.m11 = c
        out.m12 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = 1

    @staticmethod
    cdef void c_from_scaling(Mat3C *out, Vec2C *scale) nogil:
        out.m00 = scale.x
        out.m01 = 0
        out.m02 = 0
        out.m10 = 0
        out.m11 = scale.y
        out.m12 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = 1

    @staticmethod
    cdef void c_from_skewing(Mat3C *out, Vec2C *factor) nogil:
        out.m00 = 1
        out.m01 = c_math.tan(factor.x)
        out.m02 = 0
        out.m10 = c_math.tan(factor.y)
        out.m11 = 1
        out.m12 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = 1

    @staticmethod
    cdef void c_from_skewing_x(Mat3C *out, float radians) nogil:
        out.m00 = 1
        out.m01 = 0
        out.m02 = 0
        out.m10 = c_math.tan(radians)
        out.m11 = 1
        out.m12 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = 1

    @staticmethod
    cdef void c_from_skewing_y(Mat3C *out, float radians) nogil:
        out.m00 = 1
        out.m01 = c_math.tan(radians)
        out.m02 = 0
        out.m10 = 0
        out.m11 = 1
        out.m12 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = 1

    @staticmethod
    cdef void c_from_translation(Mat3C *out, Vec2C *shift) nogil:
        out.m00 = 1
        out.m01 = 0
        out.m02 = 0
        out.m10 = 0
        out.m11 = 1
        out.m12 = 0
        out.m20 = shift.x
        out.m21 = shift.y
        out.m22 = 1

    @staticmethod
    cdef void c_identity(Mat3C *out) nogil:
        out.m00 = 1
        out.m01 = 0
        out.m02 = 0
        out.m10 = 0
        out.m11 = 1
        out.m12 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = 1

    @staticmethod
    cdef void c_inv(Mat3C *out, Mat3C *a) nogil:
        cdef float d = Mat3.c_det(a)
        if d == 0.0:
            raise ValueError("{0} is not an invertible matrix".format(a[0]))
        d = 1.0 / d
        out.m00 = (a.m22 * a.m11 - a.m12 * a.m21) * d
        out.m01 = (a.m02 * a.m21 - a.m22 * a.m01) * d
        out.m02 = (a.m12 * a.m01 - a.m02 * a.m11) * d
        out.m10 = (a.m01 * a.m22 - a.m02 * a.m21) * d
        out.m11 = (a.m22 * a.m00 - a.m02 * a.m20) * d
        out.m12 = (a.m02 * a.m10 - a.m12 * a.m00) * d
        out.m20 = (a.m01 * a.m12 - a.m02 * a.m11) * d
        out.m21 = (a.m01 * a.m20 - a.m21 * a.m00) * d
        out.m22 = (a.m11 * a.m00 - a.m01 * a.m10) * d

    @staticmethod
    cdef void c_mul(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        out.m00 = a.m00 * b.m00
        out.m01 = a.m01 * b.m01
        out.m02 = a.m02 * b.m02
        out.m10 = a.m10 * b.m10
        out.m11 = a.m11 * b.m11
        out.m12 = a.m12 * b.m12
        out.m20 = a.m20 * b.m20
        out.m21 = a.m21 * b.m21
        out.m22 = a.m22 * b.m22

    @staticmethod
    cdef bint c_nearly_equals(Mat3C *a, Mat3C *b, float epsilon=0.000001) nogil:
        if (
            c_math.fabs(a.m00 - b.m00) > epsilon * max(1.0, c_math.fabs(a.m00), c_math.fabs(b.m00)) or
            c_math.fabs(a.m01 - b.m01) > epsilon * max(1.0, c_math.fabs(a.m01), c_math.fabs(b.m01)) or
            c_math.fabs(a.m02 - b.m02) > epsilon * max(1.0, c_math.fabs(a.m02), c_math.fabs(b.m02)) or
            c_math.fabs(a.m10 - b.m10) > epsilon * max(1.0, c_math.fabs(a.m10), c_math.fabs(b.m10)) or
            c_math.fabs(a.m11 - b.m11) > epsilon * max(1.0, c_math.fabs(a.m11), c_math.fabs(b.m11)) or
            c_math.fabs(a.m12 - b.m12) > epsilon * max(1.0, c_math.fabs(a.m12), c_math.fabs(b.m12)) or
            c_math.fabs(a.m20 - b.m20) > epsilon * max(1.0, c_math.fabs(a.m20), c_math.fabs(b.m20)) or
            c_math.fabs(a.m21 - b.m21) > epsilon * max(1.0, c_math.fabs(a.m21), c_math.fabs(b.m21)) or
            c_math.fabs(a.m22 - b.m22) > epsilon * max(1.0, c_math.fabs(a.m22), c_math.fabs(b.m22))
        ): 
            return False
        return True

    @staticmethod
    cdef void c_normal_from_mat4(Mat3C *out, Mat4C *a) nogil:
        cdef Mat4C a_t
        if Mat4.c_det(a) != 0:
            Mat4.c_transpose(&a_t, a)
            Mat4.c_inv(&a_t, &a_t)
            Mat3.c_from_mat4(out, &a_t)

    @staticmethod
    cdef void c_random(Mat3C *out) nogil:
        out.m00 = rand() / <float>RAND_MAX
        out.m01 = rand() / <float>RAND_MAX
        out.m02 = rand() / <float>RAND_MAX
        out.m10 = rand() / <float>RAND_MAX
        out.m11 = rand() / <float>RAND_MAX
        out.m12 = rand() / <float>RAND_MAX
        out.m20 = rand() / <float>RAND_MAX
        out.m21 = rand() / <float>RAND_MAX
        out.m22 = rand() / <float>RAND_MAX

    @staticmethod
    cdef void c_rotate(Mat3C *out, Mat3C *a, float radians) nogil:
        cdef Mat3C rot_mat
        Mat3.c_from_rotation(&rot_mat, radians)
        Mat3.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef void c_scale(Mat3C *out, Mat3C *a, Vec2C *factor) nogil:
        cdef Mat3C scale_mat
        Mat3.c_from_scaling(&scale_mat, factor)
        Mat3.c_dot(out, a, &scale_mat)

    @staticmethod
    cdef void c_scale_add(Mat3C *out, Mat3C *a, float scale=1.0, float add=0.0) nogil:
        out.m00 = scale * a.m00 + add
        out.m01 = scale * a.m01 + add
        out.m02 = scale * a.m02 + add
        out.m10 = scale * a.m10 + add
        out.m11 = scale * a.m11 + add
        out.m12 = scale * a.m12 + add
        out.m20 = scale * a.m20 + add
        out.m21 = scale * a.m21 + add
        out.m22 = scale * a.m22 + add

    @staticmethod
    cdef void c_set_data(Mat3C *out, float m00=0.0, float m01=0.0, float m02=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0) nogil:
        out.m00 = m00
        out.m01 = m01
        out.m02 = m02
        out.m10 = m10
        out.m11 = m11
        out.m12 = m12
        out.m20 = m20
        out.m21 = m21
        out.m22 = m22

    @staticmethod
    cdef void c_skew(Mat3C *out, Mat3C *a, Vec2C *factor) nogil:
        cdef Mat3C skew_mat
        Mat3.c_from_skewing(&skew_mat, factor)
        Mat3.c_dot(out, a, &skew_mat)

    @staticmethod
    cdef void c_skew_x(Mat3C *out, Mat3C *a, float radians) nogil:
        cdef Mat3C skew_mat
        Mat3.c_from_skewing_x(&skew_mat, radians)
        Mat3.c_dot(out, a, &skew_mat)

    @staticmethod
    cdef void c_skew_y(Mat3C *out, Mat3C *a, float radians) nogil:
        cdef Mat3C skew_mat
        Mat3.c_from_skewing_y(&skew_mat, radians)
        Mat3.c_dot(out, a, &skew_mat)

    @staticmethod
    cdef void c_sub(Mat3C *out, Mat3C *a, Mat3C *b) nogil:
        out.m00 = a.m00 - b.m00
        out.m01 = a.m01 - b.m01
        out.m02 = a.m02 - b.m02
        out.m10 = a.m10 - b.m10
        out.m11 = a.m11 - b.m11
        out.m12 = a.m12 - b.m12
        out.m20 = a.m20 - b.m20
        out.m21 = a.m21 - b.m21
        out.m22 = a.m22 - b.m22

    @staticmethod
    cdef void c_transpose(Mat3C *out, Mat3C *a) nogil:
        out.m00 = a.m00
        out.m01 = a.m10
        out.m02 = a.m20
        out.m10 = a.m01
        out.m11 = a.m11
        out.m12 = a.m21
        out.m20 = a.m02
        out.m21 = a.m12
        out.m22 = a.m22

    @staticmethod
    cdef void c_translate(Mat3C *out, Mat3C *a, Vec2C *shift) nogil:
        cdef Mat3C trans_mat
        Mat3.c_from_translation(&trans_mat, shift)
        Mat3.c_dot(out, a, &trans_mat)