#version 330 core
layout (location = 0) in vec3 vertices;
layout (location = 1) in vec2 tex_coords;
out vec2 v_tex_coords;
uniform mat4 model_view;
void main()
{
    gl_Position = model_view * vec4(vertices, 1.0);
    v_tex_coords = tex_coords;
}