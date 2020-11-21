#version 100
precision highp float;
uniform sampler2D u_texture_0;
varying vec2 v_tex_coord_0;
varying vec4 v_tint_alpha;
void main()
{
    vec4 tex_color = texture2D(u_texture_0, v_tex_coord_0);
    vec4 premultiplied_tint_alpha = v_tint_alpha * v_tint_alpha.w;
    gl_FragColor = tex_color * premultiplied_tint_alpha;
    //gl_FragDepth = gl_FragCoord.z;
}