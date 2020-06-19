#version 100
precision highp float;
uniform vec4 u_tint;
uniform sampler2D u_texture_0;
uniform sampler2D u_texture_1;
varying vec2 v_tex_coord_0;
void main()
{
    vec4 tex_color_0 = texture2D(u_texture_0, v_tex_coord_0);
    vec4 tex_color_1 = texture2D(u_texture_1, v_tex_coord_0);
    vec4 tex_color = (tex_color_0 + tex_color_1) / 2.0;
    gl_FragColor = vec4(tex_color * u_tint);
}