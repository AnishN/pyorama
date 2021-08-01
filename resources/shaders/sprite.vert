#version 100
attribute vec4 a_vertex_tex_coord;
attribute vec4 a_pos_z_rot;
attribute vec4 a_size_scale;
attribute vec4 a_tint_alpha;
attribute vec4 a_anchor;
uniform vec4 u_rect;
uniform mat4 u_view;
uniform mat4 u_proj;
varying vec2 v_tex_coord_0;
varying vec4 v_tint_alpha;

void main()
{
    mat4 translation = mat4(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        a_pos_z_rot.x, a_pos_z_rot.y, 0.0, 1.0
    );
    float c = cos(a_pos_z_rot.w);
    float s = sin(a_pos_z_rot.w);
    mat4 rotation = mat4(
        c, s, 0.0, 0.0,
        -s, c, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    );
    mat4 scale = mat4(
        a_size_scale.z, 0.0, 0.0, 0.0,
        0.0, a_size_scale.w, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    );
    mat4 model = translation * rotation * scale;
    vec4 position = vec4((a_vertex_tex_coord.xy - a_anchor.xy) * a_size_scale.xy, 0.0, 1.0);
    gl_Position = u_proj * u_view * model * position;
    v_tex_coord_0 = a_vertex_tex_coord.zw;
    v_tint_alpha = a_tint_alpha;
}