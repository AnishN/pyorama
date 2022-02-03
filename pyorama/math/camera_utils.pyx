from pyorama.app cimport graphics_system#needed for clipspace auto-detection
from pyorama.math.box3 cimport *
from pyorama.math.mat4 cimport *
from pyorama.math.quat cimport *
from pyorama.math.vec2 cimport *
from pyorama.math.vec3 cimport *
from pyorama.math.vec4 cimport *

cdef class CameraUtils:

    @staticmethod
    cdef void c_look(Mat4C *out, Vec3C *eye, Vec3C *dir_, Vec3C *up, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_look_rh_no(<vec3>eye, <vec3>dir_, <vec3>up, <mat4>out)
            else: glm_look_rh_zo(<vec3>eye, <vec3>dir_, <vec3>up, <mat4>out)
        else:
            if homogeneous_depth: glm_look_lh_no(<vec3>eye, <vec3>dir_, <vec3>up, <mat4>out)
            else: glm_look_lh_zo(<vec3>eye, <vec3>dir_, <vec3>up, <mat4>out)
    
    @staticmethod
    def look(Mat4 out, Vec3 eye, Vec3 dir_, Vec3 up, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_look(&out.data, &eye.data, &dir_.data, &up.data, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_look_any_up(Mat4C *out, Vec3C *eye, Vec3C *dir_, Vec3C *up, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_look_anyup_rh_no(<vec3>eye, <vec3>dir_, <mat4>out)
            else: glm_look_anyup_rh_zo(<vec3>eye, <vec3>dir_, <mat4>out)
        else:
            if homogeneous_depth: glm_look_anyup_lh_no(<vec3>eye, <vec3>dir_, <mat4>out)
            else: glm_look_anyup_lh_zo(<vec3>eye, <vec3>dir_, <mat4>out)

    @staticmethod
    def look_any_up(Mat4 out, Vec3 eye, Vec3 dir_, Vec3 up, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_look_any_up(&out.data, &eye.data, &dir_.data, &up.data, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_look_at(Mat4C *out, Vec3C *eye, Vec3C *center, Vec3C *up, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_lookat_rh_no(<vec3>eye, <vec3>center, <vec3>up, <mat4>out)
            else: glm_lookat_rh_zo(<vec3>eye, <vec3>center, <vec3>up, <mat4>out)
        else:
            if homogeneous_depth: glm_lookat_lh_no(<vec3>eye, <vec3>center, <vec3>up, <mat4>out)
            else: glm_lookat_lh_zo(<vec3>eye, <vec3>center, <vec3>up, <mat4>out)

    @staticmethod
    def look_at(Mat4 out, Vec3 eye, Vec3 center, Vec3 up, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_look_at(&out.data, &eye.data, &center.data, &up.data, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_look_from_quat(Mat4C *out, Vec3C *eye, QuatC *origin) nogil:
        glm_quat_look(<vec3>eye, <versor>origin, <mat4>out)

    @staticmethod
    def look_from_quat(Mat4 out, Vec3 eye, Quat origin):
        CameraUtils.c_look_from_quat(&out.data, &eye.data, &origin.data)

    @staticmethod
    cdef void c_look_rot(QuatC *out, Vec3C *dir_, Vec3C *up) nogil:
        glm_quat_for(<vec3>dir_, <vec3>up, <versor>out)

    @staticmethod
    def look_rot(Quat out, Vec3 dir_, Vec3 up):
        CameraUtils.c_look_rot(&out.data, &dir_.data, &up.data)

    @staticmethod
    cdef void c_look_rot_from_pos(QuatC *out, Vec3C *a, Vec3C *b, Vec3C *up) nogil:
        glm_quat_forp(<vec3>a, <vec3>b, <vec3>up, <versor>out)

    @staticmethod
    def look_rot_from_pos(Quat out, Vec3 a, Vec3 b, Vec3 up):
        CameraUtils.c_look_rot_from_pos(&out.data, &a.data, &b.data, &up.data)

    @staticmethod
    cdef void c_orthographic(Mat4C *out, float left, float right, float bottom, float top, float near_z, float far_z, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_ortho_rh_no(left, right, bottom, top, near_z, far_z, <mat4>out)
            else: glm_ortho_rh_zo(left, right, bottom, top, near_z, far_z, <mat4>out)
        else:
            if homogeneous_depth: glm_ortho_lh_no(left, right, bottom, top, near_z, far_z, <mat4>out)
            else: glm_ortho_lh_zo(left, right, bottom, top, near_z, far_z, <mat4>out)
    
    @staticmethod
    def orthographic(Mat4 out, float left, float right, float bottom, float top, float near_z, float far_z, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_orthographic(&out.data, left, right, bottom, top, near_z, far_z, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_orthographic_box(Mat4C *out, Box3C *box, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_ortho_aabb_rh_no(<vec3 *>box, <mat4>out)
            else: glm_ortho_aabb_rh_zo(<vec3 *>box, <mat4>out)
        else:
            if homogeneous_depth: glm_ortho_aabb_lh_no(<vec3 *>box, <mat4>out)
            else: glm_ortho_aabb_lh_zo(<vec3 *>box, <mat4>out)

    @staticmethod
    def orthographic_box(Mat4 out, Box3 box, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_orthographic_box(&out.data, &box.data, right_handed, homogeneous_depth)
    
    @staticmethod
    cdef void c_orthographic_box_pad(Mat4C *out, Box3C *box, float padding, bint pad_z, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if pad_z:
            if right_handed:
                if homogeneous_depth: glm_ortho_aabb_pz_rh_no(<vec3 *>box, padding, <mat4>out)
                else: glm_ortho_aabb_pz_rh_zo(<vec3 *>box, padding, <mat4>out)
            else:
                if homogeneous_depth: glm_ortho_aabb_pz_lh_no(<vec3 *>box, padding, <mat4>out)
                else: glm_ortho_aabb_pz_lh_zo(<vec3 *>box, padding, <mat4>out)
        else:
            if right_handed:
                if homogeneous_depth: glm_ortho_aabb_p_rh_no(<vec3 *>box, padding, <mat4>out)
                else: glm_ortho_aabb_p_rh_zo(<vec3 *>box, padding, <mat4>out)
            else:
                if homogeneous_depth: glm_ortho_aabb_p_lh_no(<vec3 *>box, padding, <mat4>out)
                else: glm_ortho_aabb_p_lh_zo(<vec3 *>box, padding, <mat4>out)
    
    @staticmethod
    def orthographic_box_pad(Mat4 out, Box3 box, float padding, bint pad_z, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_orthographic_box_pad(&out.data, &box.data, padding, pad_z, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_orthographic_cube(Mat4C *out, float aspect, float size, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_ortho_default_s_rh_no(aspect, size, <mat4>out)
            else: glm_ortho_default_s_rh_zo(aspect, size, <mat4>out)
        else:
            if homogeneous_depth: glm_ortho_default_s_lh_no(aspect, size, <mat4>out)
            else: glm_ortho_default_s_lh_zo(aspect, size, <mat4>out)

    @staticmethod
    def orthographic_cube(Mat4 out, float aspect, float size, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_orthographic_cube(&out.data, aspect, size, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_orthographic_unit(Mat4C *out, float aspect, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_ortho_default_rh_no(aspect, <mat4>out)
            else: glm_ortho_default_rh_zo(aspect, <mat4>out)
        else:
            if homogeneous_depth: glm_ortho_default_lh_no(aspect, <mat4>out)
            else: glm_ortho_default_lh_zo(aspect, <mat4>out)
    
    @staticmethod
    def orthographic_unit(Mat4 out, float aspect, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_orthographic_unit(&out.data, aspect, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_perspective(Mat4C *out, float fovy, float aspect, float near_z, float far_z, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_perspective_rh_no(fovy, aspect, near_z, far_z, <mat4>out)
            else: glm_perspective_rh_zo(fovy, aspect, near_z, far_z, <mat4>out)
        else:
            if homogeneous_depth: glm_perspective_lh_no(fovy, aspect, near_z, far_z, <mat4>out)
            else: glm_perspective_lh_zo(fovy, aspect, near_z, far_z, <mat4>out)

    @staticmethod
    def perspective(Mat4 out, float fovy, float aspect, float near_z, float far_z, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_perspective(&out.data, fovy, aspect, near_z, far_z, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_perspective_decompose(Mat4C *m, Box3C *box, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_rh_no(<mat4>m, &box.min_.z, &box.max_.z, &box.min_.y, &box.max_.y, &box.min_.x, &box.max_.x)
            else: glm_persp_decomp_rh_zo(<mat4>m, &box.min_.z, &box.max_.z, &box.min_.y, &box.max_.y, &box.min_.x, &box.max_.x)
        else:
            if homogeneous_depth: glm_persp_decomp_lh_no(<mat4>m, &box.min_.z, &box.max_.z, &box.min_.y, &box.max_.y, &box.min_.x, &box.max_.x)
            else: glm_persp_decomp_lh_zo(<mat4>m, &box.min_.z, &box.max_.z, &box.min_.y, &box.max_.y, &box.min_.x, &box.max_.x)

    @staticmethod
    def perspective_decompose(Mat4 m, Box3 box, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_perspective_decompose(&m.data, &box.data, right_handed, homogeneous_depth)

    @staticmethod
    cdef float c_perspective_decompose_far(Mat4C *m, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        cdef float far_z
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_far_rh_no(<mat4>m, &far_z)
            else: glm_persp_decomp_far_rh_zo(<mat4>m, &far_z)
        else:
            if homogeneous_depth: glm_persp_decomp_far_lh_no(<mat4>m, &far_z)
            else: glm_persp_decomp_far_lh_zo(<mat4>m, &far_z)
        return far_z

    @staticmethod
    def perspective_decompose_far(Mat4 m, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        return CameraUtils.c_perspective_decompose_far(&m.data, right_handed, homogeneous_depth)

    @staticmethod
    cdef float c_perspective_decompose_near(Mat4C *m, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        cdef float near_z
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_near_rh_no(<mat4>m, &near_z)
            else: glm_persp_decomp_near_rh_zo(<mat4>m, &near_z)
        else:
            if homogeneous_depth: glm_persp_decomp_near_lh_no(<mat4>m, &near_z)
            else: glm_persp_decomp_near_lh_zo(<mat4>m, &near_z)
        return near_z

    @staticmethod
    def perspective_decompose_near(Mat4 m, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        return CameraUtils.c_perspective_decompose_near(&m.data, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_perspective_decompose_x(Mat4C *m, Vec2C *v, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_x_rh_no(<mat4>m, &v.x, &v.y)
            else: glm_persp_decomp_x_rh_zo(<mat4>m, &v.x, &v.y)
        else:
            if homogeneous_depth: glm_persp_decomp_x_lh_no(<mat4>m, &v.x, &v.y)
            else: glm_persp_decomp_x_lh_zo(<mat4>m, &v.x, &v.y)
    
    @staticmethod
    def perspective_decompose_x(Mat4 m, Vec2 v, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_perspective_decompose_x(&m.data, &v.data, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_perspective_decompose_y(Mat4C *m, Vec2C *v, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_y_rh_no(<mat4>m, &v.x, &v.y)
            else: glm_persp_decomp_y_rh_zo(<mat4>m, &v.x, &v.y)
        else:
            if homogeneous_depth: glm_persp_decomp_y_lh_no(<mat4>m, &v.x, &v.y)
            else: glm_persp_decomp_y_lh_zo(<mat4>m, &v.x, &v.y)

    @staticmethod
    def perspective_decompose_y(Mat4 m, Vec2 v, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_perspective_decompose_y(&m.data, &v.data, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_perspective_decompose_z(Mat4C *m, Vec2C *v, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_decomp_z_rh_no(<mat4>m, &v.x, &v.y)
            else: glm_persp_decomp_z_rh_zo(<mat4>m, &v.x, &v.y)
        else:
            if homogeneous_depth: glm_persp_decomp_z_lh_no(<mat4>m, &v.x, &v.y)
            else: glm_persp_decomp_z_lh_zo(<mat4>m, &v.x, &v.y)
    
    @staticmethod
    def perspective_decompose_z(Mat4 m, Vec2 v, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_perspective_decompose_z(&m.data, &v.data, right_handed, homogeneous_depth)
    
    @staticmethod
    cdef void c_perspective_move_far(Mat4C *out, float delta_far, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_persp_move_far_rh_no(<mat4>out, delta_far)
            else: glm_persp_move_far_rh_zo(<mat4>out, delta_far)
        else:
            if homogeneous_depth: glm_persp_move_far_lh_no(<mat4>out, delta_far)
            else: glm_persp_move_far_lh_zo(<mat4>out, delta_far)

    @staticmethod
    def perspective_move_far(Mat4 out, float delta_far, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_perspective_move_far(&out.data, delta_far, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_perspective_resize(Mat4C *out, float aspect, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_perspective_resize_rh_no(aspect, <mat4>out)
            else: glm_perspective_resize_rh_zo(aspect, <mat4>out)
        else:
            if homogeneous_depth: glm_perspective_resize_lh_no(aspect, <mat4>out)
            else: glm_perspective_resize_lh_zo(aspect, <mat4>out)

    @staticmethod
    def perspective_resize(Mat4 out, float aspect, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_perspective_resize(&out.data, aspect, right_handed, homogeneous_depth) 

    @staticmethod
    cdef void c_perspective_plane_sizes(Mat4C *m, float fovy, Vec2C *near, Vec2C *far, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        cdef Vec4C dest
        if right_handed:
            if homogeneous_depth: glm_persp_sizes_rh_no(<mat4>m, fovy, <vec4>&dest)
            else: glm_persp_sizes_rh_zo(<mat4>m, fovy, <vec4>&dest)
        else:
            if homogeneous_depth: glm_persp_sizes_lh_no(<mat4>m, fovy, <vec4>&dest)
            else: glm_persp_sizes_lh_zo(<mat4>m, fovy, <vec4>&dest)
        near.x = dest.x
        near.y = dest.y
        far.x = dest.z
        far.y = dest.w

    @staticmethod
    def perspective_plane_sizes(Mat4 m, float fovy, Vec2 near, Vec2 far, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_perspective_plane_sizes(&m.data, fovy, &near.data, &far.data, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_perspective_unit(Mat4C *out, float aspect, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if right_handed:
            if homogeneous_depth: glm_perspective_default_rh_no(aspect, <mat4>out)
            else: glm_perspective_default_rh_zo(aspect, <mat4>out)
        else:
            if homogeneous_depth: glm_perspective_default_lh_no(aspect, <mat4>out)
            else: glm_perspective_default_lh_zo(aspect, <mat4>out)
    
    @staticmethod
    def perspective_unit(Mat4 out, float aspect, bint right_handed=graphics_system.right_handed, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_perspective_unit(&out.data, aspect, right_handed, homogeneous_depth)

    @staticmethod
    cdef void c_project(Vec3C *out, Vec3C *pos, Mat4C *m, Vec4C *viewport, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if homogeneous_depth: glm_project_no(<vec3>pos, <mat4>m, <vec4>viewport, <vec3>out)
        else: glm_project_zo(<vec3>pos, <mat4>m, <vec4>viewport, <vec3>out)

    @staticmethod
    def project(Vec3 out, Vec3 pos, Mat4 m, Vec4 viewport, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_project(&out.data, &pos.data, &m.data, &viewport.data, homogeneous_depth)

    @staticmethod
    cdef void c_unproject(Vec3C *out, Vec3C *pos, Mat4C *m, Vec4C *viewport, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        cdef Mat4C inv
        glm_mat4_inv(<mat4>m, <mat4>&inv)
        if homogeneous_depth: glm_unprojecti_no(<vec3>pos, <mat4>&inv, <vec4>viewport, <vec3>out)
        else: glm_unprojecti_zo(<vec3>pos, <mat4>&inv, <vec4>viewport, <vec3>out)

    @staticmethod
    def unproject(Vec3 out, Vec3 pos, Mat4 m, Vec4 viewport, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_unproject(&out.data, &pos.data, &m.data, &viewport.data, homogeneous_depth)
    
    @staticmethod
    cdef void c_unproject_inv(Vec3C *out, Vec3C *pos, Mat4C *m, Vec4C *viewport, bint homogeneous_depth=graphics_system.homogeneous_depth) nogil:
        if homogeneous_depth: glm_unprojecti_no(<vec3>pos, <mat4>m, <vec4>viewport, <vec3>out)
        else: glm_unprojecti_zo(<vec3>pos, <mat4>m, <vec4>viewport, <vec3>out)

    @staticmethod
    def unproject_inv(Vec3 out, Vec3 pos, Mat4 m, Vec4 viewport, bint homogeneous_depth=graphics_system.homogeneous_depth):
        CameraUtils.c_unproject_inv(&out.data, &pos.data, &m.data, &viewport.data, homogeneous_depth)