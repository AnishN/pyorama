from pyorama.core.app cimport *
from pyorama.event.event_enums cimport *
from pyorama.event.event_manager cimport *
from pyorama.graphics.graphics_enums cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.frame_buffer cimport *
from pyorama.graphics.image cimport *
from pyorama.graphics.index_buffer cimport *
from pyorama.graphics.program cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.sprite cimport *
from pyorama.graphics.sprite_batch cimport *
from pyorama.graphics.texture cimport *
from pyorama.graphics.uniform cimport *
from pyorama.graphics.vertex_buffer cimport *
from pyorama.graphics.view cimport *
from pyorama.graphics.window cimport *
from pyorama.physics.physics_enums cimport *
from pyorama.physics.physics_manager cimport *
from pyorama.math3d.vec2 cimport Vec2
from pyorama.math3d.vec3 cimport Vec3
from pyorama.math3d.vec4 cimport Vec4
from pyorama.math3d.mat4 cimport Mat4

cdef class Game(App):
    cdef:
        int width
        int height
        int bunny_width
        int bunny_height
        size_t num_sprites
        list sprites
        SpriteBatch sprite_batch
        Window window
        Image image
        Texture texture, out_color
        Uniform u_texture, u_proj, u_view, u_rect
        Mat4 proj_mat, view_mat
        list uniforms
        Shader vs, fs
        Program program
        VertexBuffer vbo
        IndexBuffer ibo
        FrameBuffer fbo
        View view
        double time_delta
        list times