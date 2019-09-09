cdef class Quat:
    
    def __init__(self, float x=0.0, float y=0.0, float z=0.0, float w=0.0):
        self.ptr = <QuatC *>calloc(1, sizeof(QuatC))
        Quat.c_set_data(self.ptr, x, y, z, w)
    
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
        def __get__(self): return self.ptr[0][0]
        def __set__(self, float new_z): self.ptr[0][0] = new_z
        
    property w:
        def __get__(self): return self.ptr[0][0]
        def __set__(self, float new_w): self.ptr[0][0] = new_w
        
    @staticmethod
    def add(Quat out, Quat a, Quat b): pass

    @staticmethod
    def calculate_w(Quat out, Quat a): pass

    @staticmethod
    def conjugate(Quat out, Quat a): pass

    @staticmethod
    def copy(Quat out, Quat a): pass

    #@staticmethod
    #def float dot(Quat a, Quat b): pass

    #@staticmethod
    #def bint equals(Quat a, Quat b): pass

    @staticmethod
    def from_euler(Quat out, float x, float y, float z): pass

    @staticmethod
    def from_mat3(Quat out, Mat3 a): pass

    #@staticmethod
    #def float get_axis_angle(Vec3 out, Quat a): pass

    @staticmethod
    def identity(Quat out): pass

    @staticmethod
    def inv(Quat out, Quat a): pass

    #@staticmethod
    #def float length(Quat a): pass

    @staticmethod
    def lerp(Quat out, Quat a, Quat b, float t): pass

    @staticmethod
    def mul(Quat out, Quat a, Quat b): pass

    #@staticmethod
    #def bint nearly_equals(Quat a, Quat b, float epsilon=epsilon): pass

    @staticmethod
    def norm(Quat out, Quat a): pass

    @staticmethod
    def rotate_x(Quat out, Quat a, float radians): pass

    @staticmethod
    def rotate_y(Quat out, Quat a, float radians): pass

    @staticmethod
    def rotate_z(Quat out, Quat a, float radians): pass

    @staticmethod
    def rotation_to(Quat out, Vec3 a, Vec3 b): pass

    @staticmethod
    def scale_add(Quat out, Quat a, float scale=1.0, float add=0.0): pass

    @staticmethod
    def set_axes(Quat out, Vec3 view, Vec3 right, Vec3 up): pass

    @staticmethod
    def set_axis_angle(Quat out, Vec3 axis, float radians): pass

    @staticmethod
    def set_data(Quat out, float x=0.0, float y=0.0, float z=0.0, float w=0.0): pass

    @staticmethod
    def slerp(Quat out, Quat a, Quat b, float t): pass

    #@staticmethod
    #def float sqr_length(Quat a): pass
    
    @staticmethod
    cdef inline void c_add(QuatC *out, QuatC *a, QuatC *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] + b[0][i]

    @staticmethod
    cdef inline void c_calculate_w(QuatC *out, QuatC *a) nogil:
        cdef float x = a[0][0]
        cdef float y = a[0][1]
        cdef float z = a[0][2]
        out[0][0] = x
        out[0][1] = y
        out[0][2] = z
        out[0][3] = c_math.sqrt(c_math.fabs(1.0 - x * x - y * y - z * z))

    @staticmethod
    cdef inline void c_conjugate(QuatC *out, QuatC *a) nogil:
        out[0][0] = -a[0][0]
        out[0][1] = -a[0][1]
        out[0][2] = -a[0][2]
        out[0][3] = a[0][3]

    @staticmethod
    cdef inline void c_copy(QuatC *out, QuatC *a) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i]

    @staticmethod
    cdef inline float c_dot(QuatC *a, QuatC *b) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out += a[0][i] * b[0][i]
        return out

    @staticmethod
    cdef inline bint c_equals(QuatC *a, QuatC *b) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if a[0][i] != b[0][i]:
                return False
        return True

    @staticmethod
    cdef inline void c_from_euler(QuatC *out, float x, float y, float z) nogil:
        cdef float half_to_rad = 0.5 * c_math.M_PI / 180.0
        x *= half_to_rad
        y *= half_to_rad
        z *= half_to_rad
        cdef float sx = c_math.sin(x)
        cdef float cx = c_math.cos(x)
        cdef float sy = c_math.sin(y)
        cdef float cy = c_math.cos(y)
        cdef float sz = c_math.sin(z)
        cdef float cz = c_math.cos(z)
        out[0][0] = sx * cy * cz - cx * sy * sz
        out[0][1] = cx * sy * cz + sx * cy * sz
        out[0][2] = cx * cy * sz - sx * sy * cz
        out[0][3] = cx * cy * cz + sx * sy * sz

    @staticmethod
    cdef inline void c_from_mat3(QuatC *out, Mat3C *a) nogil:
        cdef float f_trace = a[0][0] + a[0][4] + a[0][8]
        cdef float f_root
        cdef int i, j, k
        
        if f_trace > 0.0:
            f_root = c_math.sqrt(f_trace + 1.0)
            out[0][3] = 0.5 * f_root
            f_root = 0.5/f_root
            out[0][0] = (a[0][5] - a[0][7]) * f_root
            out[0][1] = (a[0][6] - a[0][2]) * f_root
            out[0][2] = (a[0][1] - a[0][3]) * f_root
        else:
            i = 0
            if a[0][4] > a[0][0]: i = 1
            if a[0][8] > a[0][i*3+i]: i = 2
            j = (i + 1) % 3
            k = (i + 2) % 3
            f_root = c_math.sqrt(a[0][i*3+i]-a[0][j*3+j]-a[0][k*3+k] + 1.0)
            out[0][i] = 0.5 * f_root
            f_root = 0.5 / f_root
            out[0][3] = (a[0][j*3+k] - a[0][k*3+j]) * f_root
            out[0][j] = (a[0][j*3+i] + a[0][i*3+j]) * f_root
            out[0][k] = (a[0][k*3+i] + a[0][i*3+k]) * f_root

    @staticmethod
    cdef inline float c_get_axis_angle(Vec3C *out, QuatC *a) nogil:
        cdef float rad = c_math.acos(a[0][3]) * 2.0
        cdef float s = c_math.sin(rad/2.0)
        if not s:
            out[0][0] = a[0][0] / s
            out[0][1] = a[0][1] / s
            out[0][2] = a[0][2] / s
        else:
            out[0][0] = 1
            out[0][1] = 0
            out[0][2] = 0
        return rad

    @staticmethod
    cdef inline void c_identity(QuatC *out) nogil:
        out[0][0] = 0
        out[0][1] = 0
        out[0][2] = 0
        out[0][3] = 1

    @staticmethod
    cdef inline void c_inv(QuatC *out, QuatC *a) nogil:
        cdef float x = a[0][0]
        cdef float y = a[0][1]
        cdef float z = a[0][2]
        cdef float w = a[0][3]
        cdef float dot = x*x + y*y + z*z + w*w
        cdef float inv_dot = 1.0/dot if dot else 0
        out[0][0] = -x*inv_dot
        out[0][1] = -y*inv_dot
        out[0][2] = -z*inv_dot
        out[0][3] = w*inv_dot

    @staticmethod
    cdef inline float c_length(QuatC *a) nogil:
        cdef float out = c_math.sqrt(Quat.c_sqr_length(a))
        return out

    @staticmethod
    cdef inline void c_lerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = a[0][i] + t * (b[0][i] - a[0][i])

    @staticmethod
    cdef inline void c_mul(QuatC *out, QuatC *a, QuatC *b) nogil:
        cdef float ax = a[0][0]
        cdef float ay = a[0][1]
        cdef float az = a[0][2]
        cdef float aw = a[0][3]
        cdef float bx = b[0][0]
        cdef float by = b[0][1]
        cdef float bz = b[0][2]
        cdef float bw = b[0][3]
        
        out[0][0] = ax * bw + aw * bx + ay * bz - az * by
        out[0][1] = ay * bw + aw * by + az * bx - ax * bz
        out[0][2] = az * bw + aw * bz + ax * by - ay * bx
        out[0][3] = aw * bw - ax * bx - ay * by - az * bz

    @staticmethod
    cdef inline bint c_nearly_equals(QuatC *a, QuatC *b, float epsilon=0.000001) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            if c_math.fabs(a[0][i] - b[0][i]) > epsilon * max(1.0, c_math.fabs(a[0][i]), c_math.fabs(b[0][i])):
                return False
        return True

    @staticmethod
    cdef inline void c_norm(QuatC *out, QuatC *a) nogil:
        cdef float mag = Quat.c_length(a)
        Quat.c_scale_add(out, a, scale=1.0/mag)

    @staticmethod
    cdef inline void c_rotate_x(QuatC *out, QuatC *a, float radians) nogil:
        cdef float rad = radians * 0.5
        cdef float x = a[0][0]
        cdef float y = a[0][1]
        cdef float z = a[0][2]
        cdef float w = a[0][3]
        cdef float s = c_math.sin(rad)
        cdef float c = c_math.cos(rad)
        out[0][0] = x * c + w * s
        out[0][1] = y * c + z * s
        out[0][2] = z * c - y * s
        out[0][3] = w * c - x * s

    @staticmethod
    cdef inline void c_rotate_y(QuatC *out, QuatC *a, float radians) nogil:
        cdef float rad = radians * 0.5
        cdef float x = a[0][0]
        cdef float y = a[0][1]
        cdef float z = a[0][2]
        cdef float w = a[0][3]
        cdef float s = c_math.sin(rad)
        cdef float c = c_math.cos(rad)
        out[0][0] = x * c - z * s
        out[0][1] = y * c + w * s
        out[0][2] = z * c + x * s
        out[0][3] = w * c - y * s

    @staticmethod
    cdef inline void c_rotate_z(QuatC *out, QuatC *a, float radians) nogil:
        cdef float rad = radians * 0.5
        cdef float x = a[0][0]
        cdef float y = a[0][1]
        cdef float z = a[0][2]
        cdef float w = a[0][3]
        cdef float s = c_math.sin(rad)
        cdef float c = c_math.cos(rad)
        out[0][0] = x * c + y * s
        out[0][1] = y * c - x * s
        out[0][2] = z * c + w * s
        out[0][3] = w * c - z * s

    @staticmethod
    cdef inline void c_rotation_to(QuatC *out, Vec3C *a, Vec3C *b) nogil:
        cdef Vec3C temp
        cdef Vec3C x_unit = (1, 0, 0)
        cdef Vec3C y_unit = (0, 1, 0)
        cdef float dot
        
        dot = Vec3.c_dot(a, b)
        if dot < -0.999999:
            Vec3.c_cross(&temp, &x_unit, a)
            if Vec3.c_length(&temp) < 0.000001:
                Vec3.c_cross(&temp, &y_unit, a)
            Vec3.c_norm(&temp, &temp)
            Quat.c_set_axis_angle(out, &temp, c_math.M_PI)
        elif dot > 0.999999:
            out[0][0] = 0
            out[0][1] = 0
            out[0][2] = 0
            out[0][3] = 1
        else:
            Vec3.c_cross(&temp, a, b)
            out[0][0] = temp[0]
            out[0][1] = temp[1]
            out[0][2] = temp[2]
            out[0][3] = 1 + dot
            Quat.c_norm(out, out)

    @staticmethod
    cdef inline void c_scale_add(QuatC *out, QuatC *a, float scale=1.0, float add=0.0) nogil:
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out[0][i] = scale * a[0][i] + add

    @staticmethod
    cdef inline void c_set_axes(QuatC *out, Vec3C *view, Vec3C *right, Vec3C *up) nogil:
        cdef Mat3C m
        m[0] = right[0][0]
        m[3] = right[0][1]
        m[6] = right[0][2]
        m[1] = up[0][0]
        m[4] = up[0][1]
        m[7] = up[0][2]
        m[2] = -view[0][0]
        m[5] = -view[0][1]
        m[8] = -view[0][2]
        Quat.c_from_mat3(out, &m)
        Quat.c_norm(out, out)

    @staticmethod
    cdef inline void c_set_axis_angle(QuatC *out, Vec3C *axis, float radians) nogil:
        cdef float rad = radians * 0.5
        cdef float c = c_math.cos(rad)
        cdef float s = c_math.sin(rad)
        out[0][0] = s * axis[0][0]
        out[0][1] = s * axis[0][1]
        out[0][2] = s * axis[0][2]
        out[0][3] = c

    @staticmethod
    cdef inline void c_set_data(QuatC *out, float x=0.0, float y=0.0, float z=0.0, float w=0.0) nogil:
        out[0][0] = x
        out[0][1] = y
        out[0][2] = z
        out[0][3] = w

    @staticmethod
    cdef inline void c_slerp(QuatC *out, QuatC *a, QuatC *b, float t) nogil:
        cdef float ax = a[0][0]
        cdef float ay = a[0][1]
        cdef float az = a[0][2]
        cdef float aw = a[0][3]
        cdef float bx = b[0][0]
        cdef float by = b[0][1]
        cdef float bz = b[0][2]
        cdef float bw = b[0][3]
        cdef float omega, cosom, sinom, scale0, scale1
        
        cosom = ax * bx + ay * by + az * bz + aw * bw
        if cosom < 0.0:
            cosom = -cosom
            bx = -bx
            by = -by
            bz = -bz
            bw = -bw
        if (1.0 - cosom) > 0.000001:
            omega  = c_math.acos(cosom)
            sinom  = c_math.sin(omega)
            scale0 = c_math.sin((1.0 - t) * omega) / sinom
            scale1 = c_math.sin(t * omega) / sinom
        else:
            scale0 = 1.0 - t
            scale1 = t
        out[0][0] = scale0 * ax + scale1 * bx
        out[0][1] = scale0 * ay + scale1 * by
        out[0][2] = scale0 * az + scale1 * bz
        out[0][3] = scale0 * aw + scale1 * bw

    @staticmethod
    cdef inline float c_sqr_length(QuatC *a) nogil:
        cdef float out = 0.0
        cdef size_t i = 0
        cdef size_t size = 4
        for i in range(size):
            out += a[0][i] * a[0][i]
        return out