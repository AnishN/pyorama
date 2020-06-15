cdef class Mat4:
    
    def __init__(self):
        Mat4.c_identity(&self.data)
    
    def __dealloc__(self):
        memset(&self.data, 0, sizeof(Mat4C))
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = &self.data
        buffer.len = 16
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
        cdef size_t size = 16
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        return (<float *>self.data)[i]
        
    def __setitem__(self, size_t i, float value):
        cdef size_t size = 16
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        (<float *>self.data)[i] = value
    """
    
    @staticmethod
    def add(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_add(&out.data, &a.data, &b.data)

    @staticmethod
    def copy(Mat4 out, Mat4 a):
        Mat4.c_copy(&out.data, &a.data)

    @staticmethod
    def det(Mat4 a):
        return Mat4.c_det(&a.data)

    @staticmethod
    def div(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_div(&out.data, &a.data, &b.data)

    @staticmethod
    def dot(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_dot(&out.data, &a.data, &b.data)

    @staticmethod
    def equals(Mat4 a, Mat4 b):
        return Mat4.c_equals(&a.data, &b.data)

    @staticmethod
    def from_quat(Mat4 out, Quat a):
        Mat4.c_from_quat(&out.data, &a.data)

    @staticmethod
    def from_rotation(Mat4 out, float radians, Vec3 axis):
        Mat4.c_from_rotation(&out.data, radians, &axis.data)

    @staticmethod
    def from_rotation_x(Mat4 out, float radians):
        Mat4.c_from_rotation_x(&out.data, radians)

    @staticmethod
    def from_rotation_y(Mat4 out, float radians):
        Mat4.c_from_rotation_y(&out.data, radians)

    @staticmethod
    def from_rotation_z(Mat4 out, float radians):
        Mat4.c_from_rotation_z(&out.data, radians)

    @staticmethod
    def from_scaling(Mat4 out, Vec3 scale):
        Mat4.c_from_scaling(&out.data, &scale.data)

    @staticmethod
    def from_translation(Mat4 out, Vec3 shift):
        Mat4.c_from_translation(&out.data, &shift.data)

    @staticmethod
    def frustum(Mat4 out, float left, float right, float bottom, float top, float near, float far):
        Mat4.c_frustum(&out.data, left, right, bottom, top, near, far)

    @staticmethod
    def get_rotation(Quat out, Mat4 a):
        Mat4.c_get_rotation(&out.data, &a.data)

    @staticmethod
    def get_scale(Vec3 out, Mat4 a):
        Mat4.c_get_scale(&out.data, &a.data)

    @staticmethod
    def get_translation(Vec3 out, Mat4 a):
        Mat4.c_get_translation(&out.data, &a.data)

    @staticmethod
    def identity(Mat4 out):
        Mat4.c_identity(&out.data)

    @staticmethod
    def inv(Mat4 out, Mat4 a):
        Mat4.c_inv(&out.data, &a.data)

    @staticmethod
    def look_at(Mat4 out, Vec3 eye, Vec3 center, Vec3 up):
        Mat4.c_look_at(&out.data, &eye.data, &center.data, &up.data)

    @staticmethod
    def mul(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_mul(&out.data, &a.data, &b.data)

    @staticmethod
    def nearly_equals(Mat4 a, Mat4 b, float epsilon=0.000001):
        return Mat4.c_nearly_equals(&a.data, &b.data, epsilon)

    @staticmethod
    def ortho(Mat4 out, float left, float right, float bottom, float top, float near, float far):
        Mat4.c_ortho(&out.data, left, right, bottom, top, near, far)

    @staticmethod
    def perspective(Mat4 out, float fovy, float aspect, float near, float far):
        Mat4.c_perspective(&out.data, fovy, aspect, near, far)

    @staticmethod
    def random(Mat4 out):
        Mat4.c_random(&out.data)

    @staticmethod
    def rotate(Mat4 out, Mat4 a, float radians, Vec3 axis):
        Mat4.c_rotate(&out.data, &a.data, radians, &axis.data)

    @staticmethod
    def rotate_x(Mat4 out, Mat4 a, float radians):
        Mat4.c_rotate_x(&out.data, &a.data, radians)

    @staticmethod
    def rotate_y(Mat4 out, Mat4 a, float radians):
        Mat4.c_rotate_y(&out.data, &a.data, radians)

    @staticmethod
    def rotate_z(Mat4 out, Mat4 a, float radians):
        Mat4.c_rotate_z(&out.data, &a.data, radians)

    @staticmethod
    def scale(Mat4 out, Mat4 a, Vec3 factor):
        Mat4.c_scale(&out.data, &a.data, &factor.data)

    @staticmethod
    def scale_add(Mat4 out, Mat4 a, float scale=1.0, float add=0.0):
        Mat4.c_scale_add(&out.data, &a.data, scale, add)

    @staticmethod
    def set_data(Mat4 out, float m00=0.0, float m01=0.0, float m02=0.0, float m03=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0, float m13=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0, float m23=0.0,
            float m30=0.0, float m31=0.0, float m32=0.0, float m33=0.0):
        Mat4.c_set_data(&out.data, 
                m00, m01, m02, m03,
                m10, m11, m12, m13,
                m20, m21, m22, m23,
                m30, m31, m32, m33)

    @staticmethod
    def sub(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_sub(&out.data, &a.data, &b.data)

    @staticmethod
    def translate(Mat4 out, Mat4 a, Vec3 shift):
        Mat4.c_translate(&out.data, &a.data, &shift.data)

    @staticmethod
    def transpose(Mat4 out, Mat4 a):
        Mat4.c_transpose(&out.data, &a.data)
    
    @staticmethod
    cdef void c_add(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] + (<float *>b)[i]

    @staticmethod
    cdef void c_copy(Mat4C *out, Mat4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i]

    @staticmethod
    cdef float c_det(Mat4C *a) nogil:
        cdef float a00 = a.m00 * a.m11 - a.m01 * a.m10
        cdef float a01 = a.m00 * a.m12 - a.m02 * a.m10
        cdef float a02 = a.m00 * a.m13 - a.m03 * a.m10
        cdef float a03 = a.m01 * a.m12 - a.m02 * a.m11
        cdef float a04 = a.m01 * a.m13 - a.m03 * a.m11
        cdef float a05 = a.m02 * a.m13 - a.m03 * a.m12
        cdef float a06 = a.m20 * a.m31 - a.m21 * a.m30
        cdef float a07 = a.m20 * a.m32 - a.m22 * a.m30
        cdef float a08 = a.m20 * a.m33 - a.m23 * a.m30
        cdef float a09 = a.m21 * a.m32 - a.m22 * a.m31
        cdef float a10 = a.m21 * a.m33 - a.m23 * a.m31
        cdef float a11 = a.m22 * a.m33 - a.m23 * a.m32
        cdef float out = a00 * a11 - a01 * a10 + a02 * a09 + a03 * a08 - a04 * a07 + a05 * a06
        return out

    @staticmethod
    cdef void c_div(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] / (<float *>b)[i]

    @staticmethod
    cdef void c_dot(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        out.m00 = a.m00*b.m00 + a.m10*b.m01 + a.m20*b.m02 + a.m30*b.m03
        out.m01 = a.m01*b.m00 + a.m11*b.m01 + a.m21*b.m02 + a.m31*b.m03
        out.m02 = a.m02*b.m00 + a.m12*b.m01 + a.m22*b.m02 + a.m32*b.m03
        out.m03 = a.m03*b.m00 + a.m13*b.m01 + a.m23*b.m02 + a.m33*b.m03
        out.m10 = a.m00*b.m10 + a.m10*b.m11 + a.m20*b.m12 + a.m30*b.m13
        out.m11 = a.m01*b.m10 + a.m11*b.m11 + a.m21*b.m12 + a.m31*b.m13
        out.m12 = a.m02*b.m10 + a.m12*b.m11 + a.m22*b.m12 + a.m32*b.m13
        out.m13 = a.m03*b.m10 + a.m13*b.m11 + a.m23*b.m12 + a.m33*b.m13
        out.m20 = a.m00*b.m20 + a.m10*b.m21 + a.m20*b.m22 + a.m30*b.m23
        out.m21 = a.m01*b.m20 + a.m11*b.m21 + a.m21*b.m22 + a.m31*b.m23
        out.m22 = a.m02*b.m20 + a.m12*b.m21 + a.m22*b.m22 + a.m32*b.m23
        out.m23 = a.m03*b.m20 + a.m13*b.m21 + a.m23*b.m22 + a.m33*b.m23
        out.m30 = a.m00*b.m30 + a.m10*b.m31 + a.m20*b.m32 + a.m30*b.m33
        out.m31 = a.m01*b.m30 + a.m11*b.m31 + a.m21*b.m32 + a.m31*b.m33
        out.m32 = a.m02*b.m30 + a.m12*b.m31 + a.m22*b.m32 + a.m32*b.m33
        out.m33 = a.m03*b.m30 + a.m13*b.m31 + a.m23*b.m32 + a.m33*b.m33

    @staticmethod
    cdef bint c_equals(Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in range(size):
            if (<float *>a)[i] != (<float *>b)[i]:
                return False
        return True

    @staticmethod
    cdef void c_from_quat(Mat4C *out, QuatC *a) nogil:
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
        out.m01 = yx + wz
        out.m02 = zx - wy
        out.m03 = 0
        out.m10 = yx - wz
        out.m11 = 1 - xx - zz
        out.m12 = zy + wx
        out.m13 = 0
        out.m20 = zx + wy
        out.m21 = zy - wx
        out.m22 = 1 - xx - yy
        out.m23 = 0
        out.m30 = 0
        out.m31 = 0
        out.m32 = 0
        out.m33 = 1

    @staticmethod
    cdef void c_from_rotation(Mat4C *out, float radians, Vec3C *axis) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        cdef float nc = 1.0 - c
        cdef Vec3C a_norm
        Vec3.c_norm(&a_norm, axis)
        cdef float x = a_norm.x
        cdef float y = a_norm.y
        cdef float z = a_norm.z
        out.m00 = x*x*nc+c
        out.m01 = x*y*nc+z*s
        out.m02 = x*z*nc-y*s
        out.m03 = 0
        out.m10 = x*y*nc-z*s
        out.m11 = y*y*nc+c
        out.m12 = y*z*nc+x*s
        out.m13 = 0
        out.m20 = x*z*nc+y*s
        out.m21 = y*z*nc-x*s
        out.m22 = z*z*nc+c
        out.m23 = 0
        out.m30 = 0
        out.m31 = 0
        out.m32 = 0
        out.m33 = 1

    @staticmethod
    cdef void c_from_rotation_x(Mat4C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out.m00 = 1
        out.m01 = 0
        out.m02 = 0
        out.m03 = 0
        out.m10 = 0
        out.m11 = c
        out.m12 = s
        out.m13 = 0
        out.m20 = 0
        out.m21 = -s
        out.m22 = c
        out.m23 = 0
        out.m30 = 0
        out.m31 = 0
        out.m32 = 0
        out.m33 = 1

    @staticmethod
    cdef void c_from_rotation_y(Mat4C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out.m00 = c
        out.m01 = 0
        out.m02 = -s
        out.m03 = 0
        out.m10 = 0
        out.m11 = 1
        out.m12 = 0
        out.m13 = 0
        out.m20 = s
        out.m21 = 0
        out.m22 = c
        out.m23 = 0
        out.m30 = 0
        out.m31 = 0
        out.m32 = 0
        out.m33 = 1

    @staticmethod
    cdef void c_from_rotation_z(Mat4C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out.m00 = c
        out.m01 = s
        out.m02 = 0
        out.m03 = 0
        out.m10 = -s
        out.m11 = c
        out.m12 = 0
        out.m13 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = 1
        out.m23 = 0
        out.m30 = 0
        out.m31 = 0
        out.m32 = 0
        out.m33 = 1

    @staticmethod
    cdef void c_from_scaling(Mat4C *out, Vec3C *scale) nogil:
        out.m00 = scale.x
        out.m01 = 0
        out.m02 = 0
        out.m03 = 0
        out.m10 = 0
        out.m11 = scale.y
        out.m12 = 0
        out.m13 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = scale.z
        out.m23 = 0
        out.m30 = 0
        out.m31 = 0
        out.m32 = 0
        out.m33 = 1

    @staticmethod
    cdef void c_from_translation(Mat4C *out, Vec3C *shift) nogil:
        out.m00 = 1
        out.m01 = 0
        out.m02 = 0
        out.m03 = 0
        out.m10 = 0
        out.m11 = 1
        out.m12 = 0
        out.m13 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = 1
        out.m23 = 0
        out.m30 = shift.x
        out.m31 = shift.y
        out.m32 = shift.z
        out.m33 = 1

    @staticmethod
    cdef void c_frustum(Mat4C *out, float left, float right, float bottom, float top, float near, float far) nogil:
        out.m00 = 2 * near/(right - left)
        out.m01 = 0
        out.m02 = 0
        out.m03 = 0
        out.m10 = 0
        out.m11 = 2 * near/(top - bottom)
        out.m12 = 0
        out.m13 = 0
        out.m20 = (right + left)/(right - left)
        out.m21 = (top + bottom)/(top - bottom)
        out.m22 = -(far + near)/(far - near)
        out.m23 = -1
        out.m30 = 0
        out.m31 = 0
        out.m32 = -2 * far * near/(far - near)
        out.m33 = 0

    @staticmethod
    cdef void c_get_rotation(QuatC *out, Mat4C *a) nogil:
        cdef:
            Vec3C i
            Vec3C j
            Vec3C k
            Mat3C rot
        i = [a.m00, a.m01, a.m02]
        j = [a.m10, a.m11, a.m12]
        k = [a.m20, a.m21, a.m22]
        Vec3.c_norm(&i, &i)
        Vec3.c_norm(&j, &j)
        Vec3.c_norm(&k, &k)
        rot.m00 = i.x
        rot.m01 = i.y
        rot.m02 = i.z
        rot.m10 = j.x
        rot.m11 = j.y
        rot.m12 = j.z
        rot.m20 = k.x
        rot.m21 = k.y
        rot.m22 = k.z
        Quat.c_from_mat3(out, &rot)

    @staticmethod
    cdef void c_get_scale(Vec3C *out, Mat4C *a) nogil:
        cdef:
            Vec3C i
            Vec3C j
            Vec3C k
        i = [a.m00, a.m01, a.m02]
        j = [a.m10, a.m11, a.m12]
        k = [a.m20, a.m21, a.m22]
        out.x = Vec3.c_length(&i)
        out.y = Vec3.c_length(&j)
        out.z = Vec3.c_length(&k)

    @staticmethod
    cdef void c_get_translation(Vec3C *out, Mat4C *a) nogil:
        out.x = a.m30
        out.y = a.m31
        out.z = a.m32

    @staticmethod
    cdef void c_identity(Mat4C *out) nogil:
        out.m00 = 1
        out.m01 = 0
        out.m02 = 0
        out.m03 = 0
        out.m10 = 0
        out.m11 = 1
        out.m12 = 0
        out.m13 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = 1
        out.m23 = 0
        out.m30 = 0
        out.m31 = 0
        out.m32 = 0
        out.m33 = 1

    @staticmethod
    cdef void c_inv(Mat4C *out, Mat4C *a) nogil:
        cdef float a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
        a0 = a.m00; a1 = a.m01; a2 = a.m02; a3 = a.m03; 
        a4 = a.m10; a5 = a.m11; a6 = a.m12; a7 = a.m13; 
        a8 = a.m20; a9 = a.m21; a10 = a.m22; a11 = a.m23;
        a12 = a.m30; a13 = a.m31; a14 = a.m32; a15 = a.m33;
        cdef float b0 = a0 * a5 - a1 * a4
        cdef float b1 = a0 * a6 - a2 * a4
        cdef float b2 = a0 * a7 - a3 * a4
        cdef float b3 = a1 * a6 - a2 * a5
        cdef float b4 = a1 * a7 - a3 * a5
        cdef float b5 = a2 * a7 - a3 * a6
        cdef float b6 = a8 * a13 - a9 * a12
        cdef float b7 = a8 * a14 - a10 * a12
        cdef float b8 = a8 * a15 - a11 * a12
        cdef float b9 = a9 * a14 - a10 * a13
        cdef float b10 = a9 * a15 - a11 * a13
        cdef float b11 = a10 * a15 - a11 * a14
        cdef float det = b0 * b11 - b1 * b10 + b2 * b9 + b3 * b8 - b4 * b7 + b5 * b6
        if det == 0.0:
            raise ValueError("{0} is not an invertible matrix".format(a[0]))
        det = 1.0 / det
        out.m00 = (a5 * b11 - a6 * b10 + a7 * b9) * det
        out.m01 = (a2 * b10 - a1 * b11 - a3 * b9) * det
        out.m02 = (a13 * b5 - a14 * b4 + a15 * b3) * det
        out.m03 = (a10 * b4 - a9 * b5 - a11 * b3) * det
        out.m10 = (a6 * b8 - a4 * b11 - a7 * b7) * det
        out.m11 = (a0 * b11 - a2 * b8 + a3 * b7) * det
        out.m12 = (a14 * b2 - a12 * b5 - a15 * b1) * det
        out.m13 = (a8 * b5 - a10 * b2 + a11 * b1) * det
        out.m20 = (a4 * b10 - a5 * b8 + a7 * b6) * det
        out.m21 = (a1 * b8 - a0 * b10 - a3 * b6) * det
        out.m22 = (a12 * b4 - a13 * b2 + a15 * b0) * det
        out.m23 = (a9 * b2 - a8 * b4 - a11 * b0) * det
        out.m30 = (a5 * b7 - a4 * b9 - a6 * b6) * det
        out.m31 = (a0 * b9 - a1 * b7 + a2 * b6) * det
        out.m32 = (a13 * b1 - a12 * b3 - a14 * b0) * det
        out.m33 = (a8 * b3 - a9 * b1 + a10 * b0) * det

    @staticmethod
    cdef void c_look_at(Mat4C *out, Vec3C *eye, Vec3C *center, Vec3C *up) nogil:
        cdef Vec3C F, f, U, s, u, n_eye
        cdef Mat4C look1, look2
        Vec3.c_sub(&F, center, eye)
        Vec3.c_norm(&f, &F)
        Vec3.c_norm(&U, up)
        Vec3.c_cross(&s, &f, &U)
        Vec3.c_norm(&s, &s)
        Vec3.c_cross(&u, &s, &f)
        Mat4.c_set_data(&look1, 
            s.x, u.x, -f.x, 0,
            s.y, u.y, -f.y, 0,
            s.z, u.z, -f.z, 0,
            0, 0, 0, 1,
        )
        Vec3.c_negate(&n_eye, eye)
        Mat4.c_from_translation(&look2, &n_eye)
        Mat4.c_dot(out, &look1, &look2)

    @staticmethod
    cdef void c_mul(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] * (<float *>b)[i]

    @staticmethod
    cdef bint c_nearly_equals(Mat4C *a, Mat4C *b, float epsilon=0.000001) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in range(size):
            if c_math.fabs((<float *>a)[i] - (<float *>b)[i]) > epsilon * max(1.0, c_math.fabs((<float *>a)[i]), c_math.fabs((<float *>b)[i])):
                return False
        return True

    @staticmethod
    cdef void c_ortho(Mat4C *out, float left, float right, float bottom, float top, float near, float far) nogil:
        out.m00 = 2.0/(right - left)
        out.m01 = 0
        out.m02 = 0
        out.m03 = 0
        out.m10 = 0
        out.m11 = 2.0/(top - bottom)
        out.m12 = 0
        out.m13 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = -2.0/(far - near)
        out.m23 = 0
        out.m30 = -(right + left)/(right - left)
        out.m31 = -(top + bottom)/(top - bottom)
        out.m32 = -(far + near)/(far - near)
        out.m33 = 1

    @staticmethod
    cdef void c_perspective(Mat4C *out, float fovy, float aspect, float near, float far) nogil:
        cdef float f = 1.0/c_math.tan(fovy/2.0)
        out.m00 = f/aspect
        out.m01 = 0
        out.m02 = 0
        out.m03 = 0
        out.m10 = 0
        out.m11 = f
        out.m12 = 0
        out.m13 = 0
        out.m20 = 0
        out.m21 = 0
        out.m22 = (far+near)/(near-far)
        out.m23 = -1
        out.m30 = 0
        out.m31 = 0
        out.m32 = (2*far*near)/(near-far)
        out.m33 = 1

    @staticmethod
    cdef void c_random(Mat4C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in range(size):
            (<float *>out)[i] = rand() / <float>RAND_MAX

    @staticmethod
    cdef void c_rotate(Mat4C *out, Mat4C *a, float radians, Vec3C *axis) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_rotation(&rot_mat, radians, axis)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef void c_rotate_quat(Mat4C *out, Mat4C *a, QuatC *quat) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_quat(&rot_mat, quat)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef void c_rotate_x(Mat4C *out, Mat4C *a, float radians) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_rotation_x(&rot_mat, radians)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef void c_rotate_y(Mat4C *out, Mat4C *a, float radians) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_rotation_y(&rot_mat, radians)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef void c_rotate_z(Mat4C *out, Mat4C *a, float radians) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_rotation_z(&rot_mat, radians)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef void c_scale(Mat4C *out, Mat4C *a, Vec3C *factor) nogil:
        cdef Mat4C scale_mat
        Mat4.c_from_scaling(&scale_mat, factor)
        Mat4.c_dot(out, a, &scale_mat)

    @staticmethod
    cdef void c_scale_add(Mat4C *out, Mat4C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in range(size):
            (<float *>out)[i] = scale * (<float *>a)[i] + add

    @staticmethod
    cdef void c_set_data(Mat4C *out, float m00=0.0, float m01=0.0, float m02=0.0, float m03=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0, float m13=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0, float m23=0.0,
            float m30=0.0, float m31=0.0, float m32=0.0, float m33=0.0) nogil:
        out.m00 = m00
        out.m01 = m01
        out.m02 = m02
        out.m03 = m03
        out.m10 = m10
        out.m11 = m11
        out.m12 = m12
        out.m13 = m13
        out.m20 = m20
        out.m21 = m21
        out.m22 = m22
        out.m23 = m23
        out.m30 = m30
        out.m31 = m31
        out.m32 = m32
        out.m33 = m33

    @staticmethod
    cdef void c_sub(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in range(size):
            (<float *>out)[i] = (<float *>a)[i] - (<float *>b)[i]

    @staticmethod
    cdef void c_translate(Mat4C *out, Mat4C *a, Vec3C *shift) nogil:
        cdef Mat4C trans_mat
        Mat4.c_from_translation(&trans_mat, shift)
        Mat4.c_dot(out, a, &trans_mat)

    @staticmethod
    cdef void c_transpose(Mat4C *out, Mat4C *a) nogil:
        cdef float a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
        a0 = a.m00; a1 = a.m01; a2 = a.m02; a3 = a.m03; 
        a4 = a.m10; a5 = a.m11; a6 = a.m12; a7 = a.m13; 
        a8 = a.m20; a9 = a.m21; a10 = a.m22; a11 = a.m23;
        a12 = a.m30; a13 = a.m31; a14 = a.m32; a15 = a.m33;
        out.m00 = a0
        out.m01 = a4
        out.m02 = a8
        out.m03 = a12
        out.m10 = a1
        out.m11 = a5
        out.m12 = a9
        out.m13 = a13
        out.m20 = a2
        out.m21 = a6
        out.m22 = a10
        out.m23 = a14
        out.m30 = a3
        out.m31 = a7
        out.m32 = a11
        out.m33 = a15