"""
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