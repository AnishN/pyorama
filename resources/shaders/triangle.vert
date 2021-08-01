#version 100
attribute vec3 a_position;
uniform mat4 u_view;
uniform mat4 u_proj;
void main()
{
    gl_Position = u_proj * u_view * vec4(a_position, 1.0);
}