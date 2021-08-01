#version 100
attribute vec3 a_position;
attribute vec2 a_tex_coord_0;
uniform mat4 u_view;
uniform mat4 u_proj;
varying vec2 v_tex_coord_0;
void main()
{
    gl_Position = u_proj * u_view * vec4(a_position, 1.0);
    v_tex_coord_0 = a_tex_coord_0;
}