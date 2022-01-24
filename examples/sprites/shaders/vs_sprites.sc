$input a_position, a_normal, a_texcoord0, a_color0
$output v_color0, v_texcoord0
#include "common.sh"

#define position a_position.xyz
#define rotation a_position.w
#define scale a_normal.xy
#define size a_normal.zw
#define vertex a_texcoord0.xy
#define texcoord a_texcoord0.xy

void main()
{
    mat4 t_mat = mtxFromCols(
        vec4(1, 0, 0, 0),
        vec4(0, 1, 0, 0),
        vec4(0, 0, 1, 0),
        vec4(position, 1)
    );
    mat4 r_mat = mtxFromCols(
        vec4(cos(rotation), -sin(rotation), 0, 0),
        vec4(sin(rotation), cos(rotation), 0, 0),
        vec4(0, 0, 1, 0),
        vec4(0, 0, 0, 1)
    );
    mat4 s_mat = mtxFromCols(
        vec4(scale.x * size.x, 0, 0, 0),
        vec4(0, scale.y * size.y, 0, 0),
        vec4(0, 0, 0, 0),
        vec4(0, 0, 0, 1)
    );

    gl_Position = mul(u_modelViewProj, mul(t_mat, mul(r_mat, mul(s_mat, vec4(vertex, 0, 1)))));
    v_color0 = a_color0;
    v_texcoord0 = a_texcoord0;
}