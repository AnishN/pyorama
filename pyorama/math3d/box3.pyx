from pyorama.libs.c cimport *
from pyorama.math3d.common cimport *
from pyorama.math3d.vec3 cimport *

cdef class Box3:
    
    @staticmethod
    cdef void c_center(Vec3C *out, Box3C *a) nogil:
        out.x = 0.5 * (a.min.x + a.max.x)
        out.y = 0.5 * (a.min.y + a.max.y)
        out.z = 0.5 * (a.min.z + a.max.z)

    @staticmethod
    cdef void c_copy(Box3C *out, Box3C *a) nogil:
        out.min.x = a.min.x
        out.max.x = a.max.x
        out.min.y = a.min.y
        out.max.y = a.max.y
        out.min.z = a.min.z
        out.max.z = a.max.z

    @staticmethod
    cdef void c_diagonal(Vec3C *out, Box3C *a) nogil:
        out.x = a.max.x - a.min.x
        out.y = a.max.y - a.min.y
        out.z = a.max.z - a.min.z

    @staticmethod
    cdef float c_diagonal_length(Box3C *a) nogil:
        cdef:
            Vec3C diagonal
            float length
        Box3.c_diagonal(&diagonal, a)
        length = Vec3.c_length(&diagonal)
        return length

    @staticmethod
    cdef void c_difference(Box3C *out, Box3C *a, Box3C *b) nogil:
        Box3.c_copy(out, a)
        if b.min.y <= a.min.y and b.max.y >= a.max.y and b.min.z <= a.min.z and b.max.z >= a.max.z:
            out.min.x = c_math.fmax(a.min.x, b.max.x)
            out.max.x = c_math.fmin(a.max.x, b.min.x)
        if b.min.x <= a.min.x and b.max.x >= a.max.x and b.min.z <= a.min.z and b.max.z >= a.max.z:
            out.min.y = c_math.fmax(a.min.y, b.max.y)
            out.max.y = c_math.fmin(a.max.y, b.min.y)
        if b.min.x <= a.min.x and b.max.x >= a.max.x and b.min.y <= a.min.y and b.max.y >= a.max.y:
            out.min.z = c_math.fmax(a.min.z, b.max.z)
            out.max.z = c_math.fmin(a.max.z, b.min.z)

    @staticmethod
    cdef bint c_equals(Box3C *a, Box3C *b) nogil:
        if (
            (a.min.x != b.min.x) or 
            (a.min.y != b.min.y) or 
            (a.min.z != b.min.z) or 
            (a.max.x != b.max.x) or 
            (a.max.y != b.max.y) or 
            (a.max.z != b.max.z)
        ):
            return False
        return True

    @staticmethod
    cdef void c_expand(Box3C *out, Box3C *a, Vec3C *distance) nogil:
        out.min.x = a.min.x - distance.x
        out.min.y = a.min.y - distance.y
        out.min.z = a.min.z - distance.z
        out.max.x = a.max.x + distance.x
        out.max.y = a.max.y + distance.y
        out.max.z = a.max.z + distance.z
    
    @staticmethod
    cdef void c_expand_relative(Box3C *out, Box3C *a, Vec3C *scale) nogil:
        cdef:
            Vec3C center
            Vec3C half_diag
            Vec3C scaled_half_diag
        
        Box3.c_center(&center, a)
        Box3.c_diagonal(&half_diag, a)
        Vec3.c_scale_add(&half_diag, &half_diag, scale=0.5)
        Vec3.c_mul(&scaled_half_diag, &half_diag, scale)

        out.min.x = center.x - scaled_half_diag.x
        out.min.y = center.y - scaled_half_diag.y
        out.min.z = center.z - scaled_half_diag.z
        out.max.x = center.x + scaled_half_diag.x
        out.max.y = center.y + scaled_half_diag.y
        out.max.z = center.z + scaled_half_diag.z

    @staticmethod
    cdef bint c_has_non_negative_extent(Box3C *a) nogil:
        return ( 
            a.max.x >= a.min.x and 
            a.max.y >= a.min.y and 
            a.max.z >= a.min.z
        )

    @staticmethod
    cdef bint c_has_positive_extent(Box3C *a) nogil:
        return ( 
            a.max.x > a.min.x and 
            a.max.y > a.min.y and 
            a.max.z > a.min.z
        )

    @staticmethod
    cdef void c_intersection(Box3C *out, Box3C *a, Box3C *b) nogil:
        out.min.x = c_math.fmax(a.min.x, b.min.x)
        out.min.y = c_math.fmax(a.min.y, b.min.y)
        out.min.z = c_math.fmax(a.min.z, b.min.z)
        out.max.x = c_math.fmin(a.max.x, b.max.x)
        out.max.y = c_math.fmin(a.max.y, b.max.y)
        out.max.z = c_math.fmin(a.max.z, b.max.z)

    @staticmethod
    cdef bint c_intersects_plane(Box3C *a, Vec3C *origin, Vec3C *normal) nogil:
        cdef:
            Vec3C pos_vertex
            Vec3C neg_vertex
            float pos_dist
            float neg_dist
            bint result
        
        pos_vertex.x = a.max.x if normal.x > 0 else a.min.x
        pos_vertex.y = a.max.y if normal.y > 0 else a.min.y
        pos_vertex.z = a.max.z if normal.z > 0 else a.min.z
        Vec3.c_sub(&pos_vertex, &pos_vertex, origin)
        pos_dist = Vec3.c_dot(&pos_vertex, normal)

        neg_vertex.x = a.min.x if normal.x > 0 else a.max.x
        neg_vertex.y = a.min.y if normal.y > 0 else a.max.y
        neg_vertex.z = a.min.z if normal.z > 0 else a.max.z
        Vec3.c_sub(&neg_vertex, &neg_vertex, origin)
        neg_dist = Vec3.c_dot(&neg_vertex, normal)
        
        result = pos_dist * neg_dist <= 0
        return result

    @staticmethod
    cdef bint c_intersects_ray(Box3C *a, Vec3C *origin, Vec3C *direction) nogil:
        cdef:
            Vec3C inv_dir
            Box3C t

        Vec3.c_inv(&inv_dir, direction)
        t.min.x = ((a.min.x if inv_dir.x >= 0 else a.max.x) - origin.x) * inv_dir.x
        t.max.x = ((a.max.x if inv_dir.x >= 0 else a.min.x) - origin.x) * inv_dir.x
        t.min.y = ((a.min.y if inv_dir.y >= 0 else a.max.y) - origin.y) * inv_dir.y
        t.max.y = ((a.max.y if inv_dir.y >= 0 else a.min.y) - origin.y) * inv_dir.y
        
        if t.min.x > t.max.y or t.min.y > t.max.x:
            return False
        if t.min.y > t.min.x or t.min.x != t.min.x:
            t.min.x = t.min.y
        if t.max.y < t.max.x or t.max.x != t.max.x:
            t.max.x = t.max.y

        t.min.z = ((a.min.z if inv_dir.z >= 0 else a.max.z) - origin.z) * inv_dir.z
        t.max.z = ((a.max.z if inv_dir.z >= 0 else a.min.z) - origin.z) * inv_dir.z

        if t.min.x > t.max.z or t.min.z > t.max.x:
            return False
        if t.min.z > t.min.x or t.min.x != t.min.x: 
            t.min.x = t.min.z
        if t.max.z < t.max.x or t.max.x != t.max.x:
            t.max.x = t.max.z

        if t.max.x < 0:
            return False
        return True

    @staticmethod
    cdef bint c_nearly_equals(Box3C *a, Box3C *b, float epsilon=0.000001) nogil:
        if (
            c_math.fabs(a.min.x - b.min.x) > epsilon * max(1.0, c_math.fabs(a.min.x), c_math.fabs(b.min.x)) or
            c_math.fabs(a.min.y - b.min.y) > epsilon * max(1.0, c_math.fabs(a.min.y), c_math.fabs(b.min.y)) or
            c_math.fabs(a.min.z - b.min.z) > epsilon * max(1.0, c_math.fabs(a.min.z), c_math.fabs(b.min.z)) or
            c_math.fabs(a.max.x - b.max.x) > epsilon * max(1.0, c_math.fabs(a.max.x), c_math.fabs(b.max.x)) or
            c_math.fabs(a.max.y - b.max.y) > epsilon * max(1.0, c_math.fabs(a.max.y), c_math.fabs(b.max.y)) or
            c_math.fabs(a.max.z - b.max.z) > epsilon * max(1.0, c_math.fabs(a.max.z), c_math.fabs(b.max.z))
        ):
            return False
        return True

    @staticmethod
    cdef void c_normalize(Box3C *out, Box3C *a) nogil:
        if a.max.x < a.min.x:
            out.min.x = 0.5 * (a.max.x + a.min.x)
            out.max.x = 0.5 * (a.max.x + a.min.x)
        else:
            out.min.x = a.min.x
            out.max.x = a.max.x

        if a.max.y < a.min.y:
            out.min.y = 0.5 * (a.max.y + a.min.y)
            out.max.y = 0.5 * (a.max.y + a.min.y)
        else:
            out.min.y = a.min.y
            out.max.y = a.max.y

        if a.max.z < a.min.z:
            out.min.z = 0.5 * (a.max.z + a.min.z)
            out.max.z = 0.5 * (a.max.z + a.min.z)
        else:
            out.min.z = a.min.z
            out.max.z = a.max.z

    @staticmethod
    cdef float c_radius(Box3C *a) nogil:
        cdef:
            Vec3C delta
        Vec3.c_sub(&delta, &a.max, &a.min)
        return 0.5 * Vec3.c_length(&delta)

    @staticmethod
    cdef void c_scale(Box3C *out, Box3C *a, Vec3C *scale) nogil:
        cdef:
            Vec3C v1
            Vec3C v2
        Vec3.c_mul(&v1, &a.min, scale)
        Vec3.c_mul(&v2, &a.max, scale)
        Vec3.c_min_comps(&out.min, &v1, &v2)
        Vec3.c_max_comps(&out.max, &v1, &v2)

    @staticmethod
    cdef void c_set_data(Box3C *out, Vec3C *min, Vec3C *max) nogil:
        out.min = min[0]
        out.max = max[0]

    @staticmethod
    cdef void c_shape(Vec3C *out, Box3C *a) nogil:
        Vec3.c_sub(out, &a.max, &a.min)

    @staticmethod
    cdef float c_squared_diagonal_length(Box3C *a) nogil:
        return Vec3.c_sqr_dist(&a.min, &a.max)

    @staticmethod
    cdef float c_squared_radius(Box3C *a) nogil:
        return 0.25 * Vec3.c_sqr_dist(&a.min, &a.max)

    @staticmethod
    cdef float c_surface_area(Box3C *a) nogil:
        cdef:
            Vec3C delta
        Vec3.c_sub(&delta, &a.max, &a.min)
        return 2.0 * (
            delta.y * delta.z + 
            delta.x * delta.z + 
            delta.x * delta.y
        )

    @staticmethod
    cdef void c_transform_mat3(Box3C *out, Box3C *a, Mat3C *m) nogil:
        Vec3.c_transform_mat3(&out.min, &a.min, m)
        Vec3.c_transform_mat3(&out.max, &a.max, m)

    @staticmethod
    cdef void c_transform_mat4(Box3C *out, Box3C *a, Mat4C *m) nogil:
        Vec3.c_transform_mat4(&out.min, &a.min, m)
        Vec3.c_transform_mat4(&out.max, &a.max, m)

    @staticmethod
    cdef void c_transform_quat(Box3C *out, Box3C *a, QuatC *q) nogil:
        Vec3.c_transform_quat(&out.min, &a.min, q)
        Vec3.c_transform_quat(&out.max, &a.max, q)

    @staticmethod
    cdef void c_translate(Box3C *out, Box3C *a, Vec3C *b) nogil:
        Vec3.c_add(&out.min, &a.min, b)
        Vec3.c_add(&out.max, &a.max, b)

    @staticmethod
    cdef void c_union(Box3C *out, Box3C *a, Box3C *b) nogil:
        Vec3.c_min_comps(&out.min, &a.min, &b.min)
        Vec3.c_max_comps(&out.max, &a.max, &b.max)

    @staticmethod
    cdef float c_volume(Box3C *a) nogil:
        return (a.max.x - a.min.x) * (a.max.y - a.min.y) * (a.max.z - a.min.z)