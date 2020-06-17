#version 100
precision highp float;
uniform vec4 u_tint;
uniform sampler2D u_texture_0;
varying vec2 v_tex_coord_0;
void main()
{
    vec4 tex_color = texture2D(u_texture_0, v_tex_coord_0);
    gl_FragColor = vec4(tex_color * u_tint);
}