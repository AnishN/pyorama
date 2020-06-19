#version 100
attribute vec4 a_quad;
varying vec4 v_quad;
void main()
{
    gl_Position = vec4(a_quad.xy, 0.0, 1.0);
    v_quad = a_quad;
}