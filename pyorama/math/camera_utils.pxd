cimport cython
from pyorama.libs.c cimport *
from pyorama.libs.cglm cimport *
from pyorama.math.common cimport *

@cython.final
cdef class CameraUtils:

    @staticmethod
    cdef void c_look(Mat4C *out, Vec3C *eye, Vec3C *dir_, Vec3C *up, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_look_any_up(Mat4C *out, Vec3C *eye, Vec3C *dir_, Vec3C *up, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_look_at(Mat4C *out, Vec3C *eye, Vec3C *center, Vec3C *up, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_look_from_quat(Mat4C *out, Vec3C *eye, QuatC *origin) nogil
    @staticmethod
    cdef void c_look_rot(QuatC *out, Vec3C *dir_, Vec3C *up) nogil
    @staticmethod
    cdef void c_look_rot_from_pos(QuatC *out, Vec3C *a, Vec3C *b, Vec3C *up) nogil
    @staticmethod
    cdef void c_orthographic(Mat4C *out, float left, float right, float bottom, float top, float near_z, float far_z, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_orthographic_box(Mat4C *out, Box3C *box, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_orthographic_box_pad(Mat4C *out, Box3C *box, float padding, bint pad_z, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_orthographic_cube(Mat4C *out, float aspect, float size, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_orthographic_unit(Mat4C *out, float aspect, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_perspective(Mat4C *out, float fovy, float aspect, float near_z, float far_z, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_perspective_decompose(Mat4C *m, Box3C *box, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef float c_perspective_decompose_far(Mat4C *m, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef float c_perspective_decompose_near(Mat4C *m, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_perspective_decompose_x(Mat4C *m, Vec2C *v, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_perspective_decompose_y(Mat4C *m, Vec2C *v, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_perspective_decompose_z(Mat4C *m, Vec2C *v, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_perspective_move_far(Mat4C *out, float delta_far, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_perspective_plane_sizes(Mat4C *m, float fovy, Vec2C *near, Vec2C *far, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_perspective_resize(Mat4C *out, float aspect, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_perspective_unit(Mat4C *out, float aspect, bint right_handed=*, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_project(Vec3C *out, Vec3C *pos, Mat4C *m, Vec4C *viewport, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_unproject(Vec3C *out, Vec3C *pos, Mat4C *m, Vec4C *viewport, bint homogeneous_depth=*) nogil
    @staticmethod
    cdef void c_unproject_inv(Vec3C *out, Vec3C *pos, Mat4C *m, Vec4C *viewport, bint homogeneous_depth=*) nogil
    
"""
#glm_euler_h
    ctypedef enum glm_euler_seq:
        GLM_EULER_XYZ
        GLM_EULER_XZY
        GLM_EULER_YZX
        GLM_EULER_YXZ
        GLM_EULER_ZXY
        GLM_EULER_ZYX
    glm_euler_seq glm_euler_order(int newOrder[4])
    void glm_euler_angles(Mat4C *m, vec4 dest)
    void glm_euler(vec4 angles, Mat4C *dest)
    void glm_euler_xyz(vec4 angles, Mat4C *dest)
    void glm_euler_zyx(vec4 angles, Mat4C *dest)
    void glm_euler_zxy(vec4 angles, Mat4C *dest)
    void glm_euler_xzy(vec4 angles, Mat4C *dest)
    void glm_euler_yzx(vec4 angles, Mat4C *dest)
    void glm_euler_yxz(vec4 angles, Mat4C *dest)
    void glm_euler_by_order(vec4 angles, glm_euler_seq ord, Mat4C *dest)

@staticmethod
cdef void c_frustum(Mat4C *out, float left, float right, float bottom, float top, float near_z, float far_z, bint right_handed=*, bint homogeneous_depth=*) nogil

@staticmethod
cdef void c_frustum(Mat4C *out, float left, float right, float bottom, float top, float near_z, float far_z, bint right_handed=graphics.right_handed, bint homogeneous_depth=graphics.homogeneous_depth) nogil:
    if right_handed:
        if homogeneous_depth: glm_frustum_rh_no(left, right, bottom, top, near_z, far_z, <mat4>out)
        else: glm_frustum_rh_zo(left, right, bottom, top, near_z, far_z, <mat4>out)
    else:
        if homogeneous_depth: glm_frustum_lh_no(left, right, bottom, top, near_z, far_z, <mat4>out)
        else: glm_frustum_lh_zo(left, right, bottom, top, near_z, far_z, <mat4>out)

#cglm_frustum_h
    enum:
        GLM_LBN
        GLM_LTN
        GLM_RTN
        GLM_RBN
        GLM_LBF
        GLM_LTF
        GLM_RTF
        GLM_RBF
    enum:
        GLM_LEFT
        GLM_RIGHT
        GLM_BOTTOM
        GLM_TOP
        GLM_NEAR
        GLM_FAR
    vec4 GLM_CSCOORD_LBN
    vec4 GLM_CSCOORD_LTN
    vec4 GLM_CSCOORD_RTN
    vec4 GLM_CSCOORD_RBN
    vec4 GLM_CSCOORD_LBF
    vec4 GLM_CSCOORD_LTF
    vec4 GLM_CSCOORD_RTF
    vec4 GLM_CSCOORD_RBF
    void glm_frustum_planes(mat4 m, vec4 dest[6])
    void glm_frustum_corners(mat4 invMat, vec4 dest[8])
    void glm_frustum_center(vec4 corners[8], vec4 dest)
    void glm_frustum_box(vec4 corners[8], mat4 m, vec3 box[2])
    void glm_frustum_corners_at(vec4 corners[8], float splitDist, float farDist, vec4 planeCorners[4])
"""