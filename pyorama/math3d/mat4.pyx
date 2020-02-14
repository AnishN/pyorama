cdef class Mat4:
    
    def __init__(self):
        self.ptr = <Mat4C *>calloc(1, sizeof(Mat4C))
        Mat4.c_identity(self.ptr)
    
    def __dealloc__(self):
        free(self.ptr)
        self.ptr = NULL
    
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = self.ptr
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
        
    def __getitem__(self, size_t i):
        cdef size_t size = 16
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        return self.ptr[0][i]
        
    def __setitem__(self, size_t i, float value):
        cdef size_t size = 16
        if i < 0 or i >= size:
            raise ValueError("invalid index")
        self.ptr[0][i] = value
    
    @staticmethod
    def add(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_add(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def copy(Mat4 out, Mat4 a):
        Mat4.c_copy(out.ptr, a.ptr)

    @staticmethod
    def det(Mat4 a):
        return Mat4.c_det(a.ptr)

    @staticmethod
    def div(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_div(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def dot(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_dot(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def equals(Mat4 a, Mat4 b):
        return Mat4.c_equals(a.ptr, b.ptr)

    @staticmethod
    def from_quat(Mat4 out, Quat a):
        Mat4.c_from_quat(out.ptr, a.ptr)

    @staticmethod
    def from_rotation(Mat4 out, float radians, Vec3 axis):
        Mat4.c_from_rotation(out.ptr, radians, axis.ptr)

    @staticmethod
    def from_rotation_x(Mat4 out, float radians):
        Mat4.c_from_rotation_x(out.ptr, radians)

    @staticmethod
    def from_rotation_y(Mat4 out, float radians):
        Mat4.c_from_rotation_y(out.ptr, radians)

    @staticmethod
    def from_rotation_z(Mat4 out, float radians):
        Mat4.c_from_rotation_z(out.ptr, radians)

    @staticmethod
    def from_scaling(Mat4 out, Vec3 scale):
        Mat4.c_from_scaling(out.ptr, scale.ptr)

    @staticmethod
    def from_translation(Mat4 out, Vec3 shift):
        Mat4.c_from_translation(out.ptr, shift.ptr)

    @staticmethod
    def frustum(Mat4 out, float left, float right, float bottom, float top, float near, float far):
        Mat4.c_frustum(out.ptr, left, right, bottom, top, near, far)

    @staticmethod
    def get_rotation(Quat out, Mat4 a):
        Mat4.c_get_rotation(out.ptr, a.ptr)

    @staticmethod
    def get_scale(Vec3 out, Mat4 a):
        Mat4.c_get_scale(out.ptr, a.ptr)

    @staticmethod
    def get_translation(Vec3 out, Mat4 a):
        Mat4.c_get_translation(out.ptr, a.ptr)

    @staticmethod
    def identity(Mat4 out):
        Mat4.c_identity(out.ptr)

    @staticmethod
    def inv(Mat4 out, Mat4 a):
        Mat4.c_inv(out.ptr, a.ptr)

    @staticmethod
    def look_at(Mat4 out, Vec3 eye, Vec3 center, Vec3 up):
        Mat4.c_look_at(out.ptr, eye.ptr, center.ptr, up.ptr)

    @staticmethod
    def mul(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_mul(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def nearly_equals(Mat4 a, Mat4 b, float epsilon=epsilon):
        return Mat4.c_nearly_equals(a.ptr, b.ptr, epsilon)

    @staticmethod
    def ortho(Mat4 out, float left, float right, float bottom, float top, float near, float far):
        Mat4.c_ortho(out.ptr, left, right, bottom, top, near, far)

    @staticmethod
    def perspective(Mat4 out, float fovy, float aspect, float near, float far):
        Mat4.c_perspective(out.ptr, fovy, aspect, near, far)

    @staticmethod
    def random(Mat4 out):
        Mat4.c_random(out.ptr)

    @staticmethod
    def rotate(Mat4 out, Mat4 a, float radians, Vec3 axis):
        Mat4.c_rotate(out.ptr, a.ptr, radians, axis.ptr)

    @staticmethod
    def rotate_x(Mat4 out, Mat4 a, float radians):
        Mat4.c_rotate_x(out.ptr, a.ptr, radians)

    @staticmethod
    def rotate_y(Mat4 out, Mat4 a, float radians):
        Mat4.c_rotate_y(out.ptr, a.ptr, radians)

    @staticmethod
    def rotate_z(Mat4 out, Mat4 a, float radians):
        Mat4.c_rotate_z(out.ptr, a.ptr, radians)

    @staticmethod
    def scale(Mat4 out, Mat4 a, Vec3 factor):
        Mat4.c_scale(out.ptr, a.ptr, factor.ptr)

    @staticmethod
    def scale_add(Mat4 out, Mat4 a, float scale=1.0, float add=0.0):
        Mat4.c_scale_add(out.ptr, a.ptr, scale, add)

    @staticmethod
    def set_data(Mat4 out, float m00=0.0, float m01=0.0, float m02=0.0, float m03=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0, float m13=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0, float m23=0.0,
            float m30=0.0, float m31=0.0, float m32=0.0, float m33=0.0):
        Mat4.c_set_data(out.ptr, 
                m00, m01, m02, m03,
                m10, m11, m12, m13,
                m20, m21, m22, m23,
                m30, m31, m32, m33)

    @staticmethod
    def sub(Mat4 out, Mat4 a, Mat4 b):
        Mat4.c_sub(out.ptr, a.ptr, b.ptr)

    @staticmethod
    def translate(Mat4 out, Mat4 a, Vec3 shift):
        Mat4.c_translate(out.ptr, a.ptr, shift.ptr)

    @staticmethod
    def transpose(Mat4 out, Mat4 a):
        Mat4.c_transpose(out.ptr, a.ptr)
    
    @staticmethod
    cdef inline void c_add(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in xrange(size):
            out[0][i] = a[0][i] + b[0][i]

    @staticmethod
    cdef inline void c_copy(Mat4C *out, Mat4C *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in xrange(size):
            out[0][i] = a[0][i]

    @staticmethod
    cdef inline float c_det(Mat4C *a) nogil:
        cdef float a00 = a[0][0] * a[0][5] - a[0][1] * a[0][4]
        cdef float a01 = a[0][0] * a[0][6] - a[0][2] * a[0][4]
        cdef float a02 = a[0][0] * a[0][7] - a[0][3] * a[0][4]
        cdef float a03 = a[0][1] * a[0][6] - a[0][2] * a[0][5]
        cdef float a04 = a[0][1] * a[0][7] - a[0][3] * a[0][5]
        cdef float a05 = a[0][2] * a[0][7] - a[0][3] * a[0][6]
        cdef float a06 = a[0][8] * a[0][13] - a[0][9] * a[0][12]
        cdef float a07 = a[0][8] * a[0][14] - a[0][10] * a[0][12]
        cdef float a08 = a[0][8] * a[0][15] - a[0][11] * a[0][12]
        cdef float a09 = a[0][9] * a[0][14] - a[0][10] * a[0][13]
        cdef float a10 = a[0][9] * a[0][15] - a[0][11] * a[0][13]
        cdef float a11 = a[0][10] * a[0][15] - a[0][11] * a[0][14]
        cdef float out = a00 * a11 - a01 * a10 + a02 * a09 + a03 * a08 - a04 * a07 + a05 * a06
        return out

    @staticmethod
    cdef inline void c_div(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in xrange(size):
            out[0][i] = a[0][i] / b[0][i]

    @staticmethod
    cdef inline void c_dot(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        cdef float a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
        cdef float b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15
        a0 = a[0][0]; a1 = a[0][1]; a2 = a[0][2]; a3 = a[0][3]; 
        a4 = a[0][4]; a5 = a[0][5]; a6 = a[0][6]; a7 = a[0][7]; 
        a8 = a[0][8]; a9 = a[0][9]; a10 = a[0][10]; a11 = a[0][11];
        a12 = a[0][12]; a13 = a[0][13]; a14 = a[0][14]; a15 = a[0][15];
        b0 = b[0][0]; b1 = b[0][1]; b2 = b[0][2]; b3 = b[0][3]; 
        b4 = b[0][4]; b5 = b[0][5]; b6 = b[0][6]; b7 = b[0][7]; 
        b8 = b[0][8]; b9 = b[0][9]; b10 = b[0][10]; b11 = b[0][11];
        b12 = b[0][12]; b13 = b[0][13]; b14 = b[0][14]; b15 = b[0][15];
        out[0][0] = a0*b0 + a4*b1 + a8*b2 + a12*b3
        out[0][1] = a1*b0 + a5*b1 + a9*b2 + a13*b3
        out[0][2] = a2*b0 + a6*b1 + a10*b2 + a14*b3
        out[0][3] = a3*b0 + a7*b1 + a11*b2 + a15*b3
        out[0][4] = a0*b4 + a4*b5 + a8*b6 + a12*b7
        out[0][5] = a1*b4 + a5*b5 + a9*b6 + a13*b7
        out[0][6] = a2*b4 + a6*b5 + a10*b6 + a14*b7
        out[0][7] = a3*b4 + a7*b5 + a11*b6 + a15*b7
        out[0][8] = a0*b8 + a4*b9 + a8*b10 + a12*b11
        out[0][9] = a1*b8 + a5*b9 + a9*b10 + a13*b11
        out[0][10] = a2*b8 + a6*b9 + a10*b10 + a14*b11
        out[0][11] = a3*b8 + a7*b9 + a11*b10 + a15*b11
        out[0][12] = a0*b12 + a4*b13 + a8*b14 + a12*b15
        out[0][13] = a1*b12 + a5*b13 + a9*b14 + a13*b15
        out[0][14] = a2*b12 + a6*b13 + a10*b14 + a14*b15
        out[0][15] = a3*b12 + a7*b13 + a11*b14 + a15*b15

    @staticmethod
    cdef inline bint c_equals(Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in xrange(size):
            if a[0][i] != b[0][i]:
                return False
        return True

    @staticmethod
    cdef inline void c_from_quat(Mat4C *out, QuatC *a) nogil:
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
        out[0][1] = yx + wz
        out[0][2] = zx - wy
        out[0][3] = 0
        out[0][4] = yx - wz
        out[0][5] = 1 - xx - zz
        out[0][6] = zy + wx
        out[0][7] = 0
        out[0][8] = zx + wy
        out[0][9] = zy - wx
        out[0][10] = 1 - xx - yy
        out[0][11] = 0
        out[0][12] = 0
        out[0][13] = 0
        out[0][14] = 0
        out[0][15] = 1

    @staticmethod
    cdef inline void c_from_rotation(Mat4C *out, float radians, Vec3C *axis) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        cdef float nc = 1.0 - c
        cdef Vec3C a_norm
        Vec3.c_norm(&a_norm, axis)
        cdef float x = a_norm[0]
        cdef float y = a_norm[1]
        cdef float z = a_norm[2]
        out[0][0] = x*x*nc+c
        out[0][1] = x*y*nc+z*s
        out[0][2] = x*z*nc-y*s
        out[0][3] = 0
        out[0][4] = x*y*nc-z*s
        out[0][5] = y*y*nc+c
        out[0][6] = y*z*nc+x*s
        out[0][7] = 0
        out[0][8] = x*z*nc+y*s
        out[0][9] = y*z*nc-x*s
        out[0][10] = z*z*nc+c
        out[0][11] = 0
        out[0][12] = 0
        out[0][13] = 0
        out[0][14] = 0
        out[0][15] = 1

    @staticmethod
    cdef inline void c_from_rotation_x(Mat4C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out[0][0] = 1
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 0
        out[0][5] = c
        out[0][6] = s
        out[0][7] = 0
        out[0][8] = 0
        out[0][9] = -s
        out[0][10] = c
        out[0][11] = 0
        out[0][12] = 0
        out[0][13] = 0
        out[0][14] = 0
        out[0][15] = 1

    @staticmethod
    cdef inline void c_from_rotation_y(Mat4C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out[0][0] = c
        out[0][1] = 0
        out[0][2] = -s
        out[0][3] = 0
        out[0][4] = 0
        out[0][5] = 1
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = s
        out[0][9] = 0
        out[0][10] = c
        out[0][11] = 0
        out[0][12] = 0
        out[0][13] = 0
        out[0][14] = 0
        out[0][15] = 1

    @staticmethod
    cdef inline void c_from_rotation_z(Mat4C *out, float radians) nogil:
        cdef float c = c_math.cos(radians)
        cdef float s = c_math.sin(radians)
        out[0][0] = c
        out[0][1] = s
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = -s
        out[0][5] = c
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 0
        out[0][9] = 0
        out[0][10] = 1
        out[0][11] = 0
        out[0][12] = 0
        out[0][13] = 0
        out[0][14] = 0
        out[0][15] = 1

    @staticmethod
    cdef inline void c_from_scaling(Mat4C *out, Vec3C *scale) nogil:
        out[0][0] = scale[0][0]
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 0
        out[0][5] = scale[0][1]
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 0
        out[0][9] = 0
        out[0][10] = scale[0][2]
        out[0][11] = 0
        out[0][12] = 0
        out[0][13] = 0
        out[0][14] = 0
        out[0][15] = 1

    @staticmethod
    cdef inline void c_from_translation(Mat4C *out, Vec3C *shift) nogil:
        out[0][0] = 1
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 0
        out[0][5] = 1
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 0
        out[0][9] = 0
        out[0][10] = 1
        out[0][11] = 0
        out[0][12] = shift[0][0]
        out[0][13] = shift[0][1]
        out[0][14] = shift[0][2]
        out[0][15] = 1

    @staticmethod
    cdef inline void c_frustum(Mat4C *out, float left, float right, float bottom, float top, float near, float far) nogil:
        out[0][0] = 2 * near/(right - left)
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 0
        out[0][5] = 2 * near/(top - bottom)
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = (right + left)/(right - left)
        out[0][9] = (top + bottom)/(top - bottom)
        out[0][10] = -(far + near)/(far - near)
        out[0][11] = -1
        out[0][12] = 0
        out[0][13] = 0
        out[0][14] = -2 * far * near/(far - near)
        out[0][15] = 0

    @staticmethod
    cdef inline void c_get_rotation(QuatC *out, Mat4C *a) nogil:
        cdef:
            Vec3C i
            Vec3C j
            Vec3C k
            Mat3C rot
        i = (a[0][0], a[0][1], a[0][2])
        j = (a[0][4], a[0][5], a[0][6])
        k = (a[0][8], a[0][9], a[0][10])
        Vec3.c_norm(&i, &i)
        Vec3.c_norm(&j, &j)
        Vec3.c_norm(&k, &k)
        rot[0] = i[0]
        rot[1] = i[1]
        rot[2] = i[2]
        rot[3] = j[0]
        rot[4] = j[1]
        rot[5] = j[2]
        rot[6] = k[0]
        rot[7] = k[1]
        rot[8] = k[2]
        Quat.c_from_mat3(out, &rot)

    @staticmethod
    cdef inline void c_get_scale(Vec3C *out, Mat4C *a) nogil:
        cdef:
            Vec3C i
            Vec3C j
            Vec3C k
        i = (a[0][0], a[0][1], a[0][2])
        j = (a[0][4], a[0][5], a[0][6])
        k = (a[0][8], a[0][9], a[0][10])
        out[0][0] = Vec3.c_length(&i)
        out[0][1] = Vec3.c_length(&j)
        out[0][2] = Vec3.c_length(&k)

    @staticmethod
    cdef inline void c_get_translation(Vec3C *out, Mat4C *a) nogil:
        out[0][0] = a[0][12]
        out[0][1] = a[0][13]
        out[0][2] = a[0][14]

    @staticmethod
    cdef inline void c_identity(Mat4C *out) nogil:
        out[0][0] = 1
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 0
        out[0][5] = 1
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 0
        out[0][9] = 0
        out[0][10] = 1
        out[0][11] = 0
        out[0][12] = 0
        out[0][13] = 0
        out[0][14] = 0
        out[0][15] = 1

    @staticmethod
    cdef inline void c_inv(Mat4C *out, Mat4C *a) nogil:
        cdef float a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
        a0 = a[0][0]; a1 = a[0][1]; a2 = a[0][2]; a3 = a[0][3]; 
        a4 = a[0][4]; a5 = a[0][5]; a6 = a[0][6]; a7 = a[0][7]; 
        a8 = a[0][8]; a9 = a[0][9]; a10 = a[0][10]; a11 = a[0][11];
        a12 = a[0][12]; a13 = a[0][13]; a14 = a[0][14]; a15 = a[0][15];
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
        out[0][0] = (a5 * b11 - a6 * b10 + a7 * b9) * det
        out[0][1] = (a2 * b10 - a1 * b11 - a3 * b9) * det
        out[0][2] = (a13 * b5 - a14 * b4 + a15 * b3) * det
        out[0][3] = (a10 * b4 - a9 * b5 - a11 * b3) * det
        out[0][4] = (a6 * b8 - a4 * b11 - a7 * b7) * det
        out[0][5] = (a0 * b11 - a2 * b8 + a3 * b7) * det
        out[0][6] = (a14 * b2 - a12 * b5 - a15 * b1) * det
        out[0][7] = (a8 * b5 - a10 * b2 + a11 * b1) * det
        out[0][8] = (a4 * b10 - a5 * b8 + a7 * b6) * det
        out[0][9] = (a1 * b8 - a0 * b10 - a3 * b6) * det
        out[0][10] = (a12 * b4 - a13 * b2 + a15 * b0) * det
        out[0][11] = (a9 * b2 - a8 * b4 - a11 * b0) * det
        out[0][12] = (a5 * b7 - a4 * b9 - a6 * b6) * det
        out[0][13] = (a0 * b9 - a1 * b7 + a2 * b6) * det
        out[0][14] = (a13 * b1 - a12 * b3 - a14 * b0) * det
        out[0][15] = (a8 * b3 - a9 * b1 + a10 * b0) * det

    @staticmethod
    cdef inline void c_look_at(Mat4C *out, Vec3C *eye, Vec3C *center, Vec3C *up) nogil:
        cdef Vec3C F, f, U, s, u, n_eye
        cdef Mat4C look1, look2
        Vec3.c_sub(&F, center, eye)
        Vec3.c_norm(&f, &F)
        Vec3.c_norm(&U, up)
        Vec3.c_cross(&s, &f, &U)
        Vec3.c_norm(&s, &s)
        Vec3.c_cross(&u, &s, &f)
        Mat4.c_set_data(&look1, 
            s[0], u[0], -f[0], 0,
            s[1], u[1], -f[1], 0,
            s[2], u[2], -f[2], 0,
            0, 0, 0, 1,
        )
        Vec3.c_negate(&n_eye, eye)
        Mat4.c_from_translation(&look2, &n_eye)
        Mat4.c_dot(out, &look1, &look2)

    @staticmethod
    cdef inline void c_mul(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in xrange(size):
            out[0][i] = a[0][i] * b[0][i]

    @staticmethod
    cdef inline bint c_nearly_equals(Mat4C *a, Mat4C *b, float epsilon=epsilon) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in xrange(size):
            if c_math.fabs(a[0][i] - b[0][i]) > epsilon * max(1.0, c_math.fabs(a[0][i]), c_math.fabs(b[0][i])):
                return False
        return True

    @staticmethod
    cdef inline void c_ortho(Mat4C *out, float left, float right, float bottom, float top, float near, float far) nogil:
        out[0][0] = 2.0/(right - left)
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 0
        out[0][5] = 2.0/(top - bottom)
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 0
        out[0][9] = 0
        out[0][10] = -2.0/(far - near)
        out[0][11] = 0
        out[0][12] = -(right + left)/(right - left)
        out[0][13] = -(top + bottom)/(top - bottom)
        out[0][14] = -(far + near)/(far - near)
        out[0][15] = 1

    @staticmethod
    cdef inline void c_perspective(Mat4C *out, float fovy, float aspect, float near, float far) nogil:
        cdef float f = 1.0/c_math.tan(fovy/2.0)
        out[0][0] = f/aspect
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 0
        out[0][4] = 0
        out[0][5] = f
        out[0][6] = 0
        out[0][7] = 0
        out[0][8] = 0
        out[0][9] = 0
        out[0][10] = (far+near)/(near-far)
        out[0][11] = -1
        out[0][12] = 0
        out[0][13] = 0
        out[0][14] = (2*far*near)/(near-far)
        out[0][15] = 1

    @staticmethod
    cdef inline void c_random(Mat4C *out) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in xrange(size):
            out[0][i] = rand() / float(RAND_MAX)

    @staticmethod
    cdef inline void c_rotate(Mat4C *out, Mat4C *a, float radians, Vec3C *axis) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_rotation(&rot_mat, radians, axis)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef inline void c_rotate_quat(Mat4C *out, Mat4C *a, QuatC *quat) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_quat(&rot_mat, quat)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef inline void c_rotate_x(Mat4C *out, Mat4C *a, float radians) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_rotation_x(&rot_mat, radians)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef inline void c_rotate_y(Mat4C *out, Mat4C *a, float radians) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_rotation_y(&rot_mat, radians)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef inline void c_rotate_z(Mat4C *out, Mat4C *a, float radians) nogil:
        cdef Mat4C rot_mat
        Mat4.c_from_rotation_z(&rot_mat, radians)
        Mat4.c_dot(out, a, &rot_mat)

    @staticmethod
    cdef inline void c_scale(Mat4C *out, Mat4C *a, Vec3C *factor) nogil:
        cdef Mat4C scale_mat
        Mat4.c_from_scaling(&scale_mat, factor)
        Mat4.c_dot(out, a, &scale_mat)

    @staticmethod
    cdef inline void c_scale_add(Mat4C *out, Mat4C *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in xrange(size):
            out[0][i] = scale * a[0][i] + add

    @staticmethod
    cdef inline void c_set_data(Mat4C *out, float m00=0.0, float m01=0.0, float m02=0.0, float m03=0.0,
            float m10=0.0, float m11=0.0, float m12=0.0, float m13=0.0,
            float m20=0.0, float m21=0.0, float m22=0.0, float m23=0.0,
            float m30=0.0, float m31=0.0, float m32=0.0, float m33=0.0) nogil:
        out[0][0] = m00
        out[0][1] = m01
        out[0][2] = m02
        out[0][3] = m03
        out[0][4] = m10
        out[0][5] = m11
        out[0][6] = m12
        out[0][7] = m13
        out[0][8] = m20
        out[0][9] = m21
        out[0][10] = m22
        out[0][11] = m23
        out[0][12] = m30
        out[0][13] = m31
        out[0][14] = m32
        out[0][15] = m33

    @staticmethod
    cdef inline void c_sub(Mat4C *out, Mat4C *a, Mat4C *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 16
        for i in xrange(size):
            out[0][i] = a[0][i] - b[0][i]

    @staticmethod
    cdef inline void c_translate(Mat4C *out, Mat4C *a, Vec3C *shift) nogil:
        cdef Mat4C trans_mat
        Mat4.c_from_translation(&trans_mat, shift)
        Mat4.c_dot(out, a, &trans_mat)

    @staticmethod
    cdef inline void c_transpose(Mat4C *out, Mat4C *a) nogil:
        cdef float a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15
        a0 = a[0][0]; a1 = a[0][1]; a2 = a[0][2]; a3 = a[0][3]; 
        a4 = a[0][4]; a5 = a[0][5]; a6 = a[0][6]; a7 = a[0][7]; 
        a8 = a[0][8]; a9 = a[0][9]; a10 = a[0][10]; a11 = a[0][11];
        a12 = a[0][12]; a13 = a[0][13]; a14 = a[0][14]; a15 = a[0][15];
        out[0][0] = a0
        out[0][1] = a4
        out[0][2] = a8
        out[0][3] = a12
        out[0][4] = a1
        out[0][5] = a5
        out[0][6] = a9
        out[0][7] = a13
        out[0][8] = a2
        out[0][9] = a6
        out[0][10] = a10
        out[0][11] = a14
        out[0][12] = a3
        out[0][13] = a7
        out[0][14] = a11
        out[0][15] = a15