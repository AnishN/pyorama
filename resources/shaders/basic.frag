#version 330 core
uniform sampler2D sampler;
in vec2 v_tex_coords;
out vec4 frag_color;
void main()
{
    frag_color = texture2D(sampler, v_tex_coords);
}