from pyorama.libs.cglm cimport *

print("math_test") 
print(GLM_BEZIER_MAT)
print(GLM_HERMITE_MAT)
print(CGLM_DECASTEL_EPS, CGLM_DECASTEL_MAX, CGLM_DECASTEL_SMALL)

cdef:
    vec3 eye = [0, 0, 1000]
    vec3 at = GLM_VEC3_ZERO
    vec3 up = [0, 1, 0]
    mat4 proj
    float width = 800
    float height = 600
    float near = 0
    float far = 1

glm_ortho(0, width, 0, height, near, far, proj)
print(eye, at, up)
print(proj)
glm_ortho_lh_no(0, width, 0, height, near, far, proj)
print("lh_no", proj)
glm_ortho_lh_zo(0, width, 0, height, near, far, proj)
print("lh_zo", proj)
glm_ortho_rh_no(0, width, 0, height, near, far, proj)
print("rh_no", proj)
glm_ortho_rh_zo(0, width, 0, height, near, far, proj)
print("rh_zo", proj)