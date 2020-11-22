#version 100
precision highp float;
uniform sampler2D u_texture_0;
uniform vec2 u_atlas_size;
varying vec4 v_vertex_index_type;
void main()
{
    /*
    vec2 column_row = vec2(
        mod(v_vertex_index_type.w, u_atlas_size.y),
        floor(v_vertex_index_type.w / u_atlas_size.y)
    );
    vec2 column_row_fractions = column_row / u_atlas_size.yx;
    vec2 tex_coord = v_vertex_index_type.xy * column_row_fractions;
    */

    vec2 column_row = vec2(
        mod(v_vertex_index_type.w, u_atlas_size.y),
        floor(v_vertex_index_type.w / u_atlas_size.y)
    );
    vec2 column_row_fractions = column_row / u_atlas_size.yx;
    vec2 tex_coord = (v_vertex_index_type.xy / u_atlas_size.yx) + column_row_fractions;

    vec4 tex_color = texture2D(u_texture_0, tex_coord);
    gl_FragColor = tex_color;
}