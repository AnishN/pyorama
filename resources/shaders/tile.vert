#version 100
attribute vec4 a_vertex_index_type;
uniform vec2 u_tile_map_size;
uniform vec2 u_tile_size;
uniform vec4 u_rect;
uniform mat4 u_view;
uniform mat4 u_proj;
varying vec2 v_tex_coord_0;
varying vec4 v_vertex_index_type;

void main()
{
    vec2 column_row = vec2(
        mod(a_vertex_index_type.z, u_tile_map_size.y),
        floor(a_vertex_index_type.z / u_tile_map_size.y)
    );
    vec2 tile_pos = u_tile_size * column_row;
    mat4 translation = mat4(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        tile_pos.x, tile_pos.y, 0.0, 1.0
    );
    mat4 rotation = mat4(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    );
    mat4 scale = mat4(
        u_tile_size.x, 0.0, 0.0, 0.0,
        0.0, u_tile_size.y, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
    );
    mat4 model = translation * rotation * scale;
    vec4 position = vec4(a_vertex_index_type.xy, 0.0, 1.0);
    gl_Position = u_proj * u_view * model * position;
    v_vertex_index_type = a_vertex_index_type;
}