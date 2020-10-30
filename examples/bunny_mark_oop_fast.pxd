from pyorama.core.app cimport *
from pyorama.event.event_enums cimport *
from pyorama.event.event_manager cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.graphics.graphics_structs cimport *
from pyorama.graphics.sprite cimport *
from pyorama.math3d.common cimport *
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
        Handle sprite_batch
        Handle window
        Handle image, texture
        Handle u_texture, u_proj, u_view, u_rect
        Mat4 proj_mat, view_mat
        Handle[::1] uniforms
        Handle vs, fs, program
        Handle vbo, ibo
        Handle fbo, view
        double time_delta
        list times