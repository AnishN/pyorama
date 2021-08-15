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