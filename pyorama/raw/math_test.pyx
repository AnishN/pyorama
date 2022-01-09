from pyorama.libs.cglm cimport *
from pyorama.app cimport *
from pyorama.math.mat2 cimport *

print("math_test") 
#print(GLM_BEZIER_MAT)
#print(GLM_HERMITE_MAT)
#print(CGLM_DECASTEL_EPS, CGLM_DECASTEL_MAX, CGLM_DECASTEL_SMALL)

cdef int testing(int renderer_type=graphics.renderer_type) nogil:
    return renderer_type

cdef:
    vec3 eye = [0, 0, 1000]
    vec3 at = GLM_VEC3_ZERO
    vec3 up = [0, 1, 0]
    mat4 proj
    float width = 800
    float height = 600
    float near = 0
    float far = 1
    mat2 m = [[1, 0], [0, 1]]
    Mat2 a
    Mat2 b

"""
glm_ortho(0, width, 0, height, near, far, proj)
print(eye, at, up)
print(proj, proj[3][1])
glm_ortho_lh_no(0, width, 0, height, near, far, proj)
print("lh_no", proj)
glm_ortho_lh_zo(0, width, 0, height, near, far, proj)
print("lh_zo", proj)
glm_ortho_rh_no(0, width, 0, height, near, far, proj)
print("rh_no", proj)
glm_ortho_rh_zo(0, width, 0, height, near, far, proj)
print("rh_zo", proj)
print(testing())
"""

a = Mat2.c_from_data(m)
b = Mat2()
print(a.data, b.data)
Mat2.copy(b, a)
print(a.data, b.data)