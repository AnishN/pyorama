#version 330 core
layout (location = 0) in vec3 vertices;
layout (location = 1) in vec2 tex_coords;
layout (location = 2) in vec3 normals;
uniform usamplerBuffer transform;
uniform mat4 projection;
uniform mat4 view;
out vec2 v_tex_coords;

void main()
{
    int transform_index = int(normals.z);
    /*
    mat4 model_view;
    
    for(int i = 0; i < 16; i++)
    {
        model_view[i] = texelFetch(transform, transform_index + i);
    }
    */
    gl_Position = projection * view * vec4(vertices, 1.0);
    v_tex_coords = tex_coords;
}