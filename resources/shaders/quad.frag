#version 100
precision highp float;
uniform sampler2D u_quad;
varying vec4 v_quad;
void main()
{
    gl_FragColor = texture2D(u_quad, v_quad.zw);
}