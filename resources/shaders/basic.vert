#version 100
attribute vec3 a_position;
attribute vec2 a_tex_coord_0;
varying vec2 v_tex_coord_0;
void main()
{
    gl_Position = vec4(a_position, 1.0);
    v_tex_coord_0 = a_tex_coord_0;
}