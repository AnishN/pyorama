$input a_position, a_normal, a_texcoord0, a_color0
$output v_color0, v_texcoord0
#include "common.sh"

void main()
{
    mat4 t_mat = mtxFromCols(
        vec4(1, 0, 0, 0),
        vec4(0, 1, 0, 0),
        vec4(0, 0, 1, 0),
        vec4(a_position.x, a_position.y, a_position.z, 1)
    );
    mat4 r_mat = mtxFromCols(
        vec4(cos(a_position.w), -sin(a_position.w), 0, 0),
        vec4(sin(a_position.w), cos(a_position.w), 0, 0),
        vec4(0, 0, 1, 0),
        vec4(0, 0, 0, 1)
    );
    mat4 s_mat = mtxFromCols(
        vec4(a_normal.x * a_normal.z, 0, 0, 0),
        vec4(0, a_normal.y * a_normal.w, 0, 0),
        vec4(0, 0, 0, 0),
        vec4(0, 0, 0, 1)
    );

    //gl_Position = mul(u_modelViewProj, mul(t_mat, mul(r_mat, mul(s_mat, vec4(a_texcoord0.xy, 0.0, 1.0)))));
    //gl_Position = mul(u_modelViewProj, vec4(a_position.xyz, 1.0));
    //gl_Position = mul(u_modelViewProj, vec4(a_texcoord0.x * 500, a_texcoord0.y * 200, 0, 1.0));
    gl_Position = mul(u_modelViewProj, mul(t_mat, mul(r_mat, mul(s_mat, vec4(a_texcoord0.xy, 0, 1)))));
    v_color0 = a_color0;
    v_texcoord0 = a_texcoord0;
}