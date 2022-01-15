from pyorama.libs.cglm cimport *

cdef:
    float C_MATH_F_E
    float C_MATH_F_LOG2E
    float C_MATH_F_LOG10E
    float C_MATH_F_LN2
    float C_MATH_F_LN10
    float C_MATH_F_PI
    float C_MATH_F_PI_2
    float C_MATH_F_PI_4
    float C_MATH_F_1_PI
    float C_MATH_F_2_PI
    float C_MATH_F_2_SQRTPI
    float C_MATH_F_SQRT2
    float C_MATH_F_SQRT1_2

    double C_MATH_D_E
    double C_MATH_D_LOG2E
    double C_MATH_D_LOG10E
    double C_MATH_D_LN2
    double C_MATH_D_LN10
    double C_MATH_D_PI
    double C_MATH_D_PI_2
    double C_MATH_D_PI_4
    double C_MATH_D_1_PI
    double C_MATH_D_2_PI
    double C_MATH_D_2_SQRTPI
    double C_MATH_D_SQRT2
    double C_MATH_D_SQRT1_2

ctypedef struct Vec2C:
    float x
    float y

ctypedef struct Vec3C:
    float x
    float y
    float z

ctypedef struct Vec4C:
    float x
    float y
    float z
    float w

ctypedef struct Mat2C:
    float m00, m01
    float m10, m11

ctypedef struct Mat3C:
    float m00, m01, m02
    float m10, m11, m12
    float m20, m21, m22

ctypedef struct Mat4C:
    float m00, m01, m02, m03
    float m10, m11, m12, m13
    float m20, m21, m22, m23
    float m30, m31, m32, m33

ctypedef struct QuatC:
    float x
    float y
    float z
    float w

ctypedef struct Box2C:
    Vec2C min
    Vec2C max

ctypedef struct Box3C:
    Vec3C min
    Vec3C max