ctypedef packed struct Vec2C:
    float x
    float y

ctypedef packed struct Vec3C:
    float x
    float y
    float z

ctypedef packed struct Vec4C:
    float x
    float y
    float z
    float w

ctypedef packed struct Mat2C:
    float m00, m01
    float m10, m11

ctypedef packed struct Mat3C:
    float m00, m01, m02
    float m10, m11, m12
    float m20, m21, m22

ctypedef packed struct Mat4C:
    float m00, m01, m02, m03
    float m10, m11, m12, m13
    float m20, m21, m22, m23
    float m30, m31, m32, m33

ctypedef packed struct QuatC:
    float x
    float y
    float z
    float w