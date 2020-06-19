import sys
import numpy as np
from pyorama.core.app import App
from pyorama.graphics.graphics_enums import *
from pyorama.graphics.graphics_manager import GraphicsManager
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4

class Game(App):

    def init(self):
        super().init()
        self.graphics = GraphicsManager()
        self.v_fmt = self.graphics.vertex_format_create([
            (b"a_position", VERTEX_COMP_TYPE_F32, 3, False),
            (b"a_tex_coord_0", VERTEX_COMP_TYPE_F32, 2, False),
        ])
        self.u_tint_fmt = self.graphics.uniform_format_create(b"u_tint", UNIFORM_TYPE_VEC4)
        self.u_tint = self.graphics.uniform_create(self.u_tint_fmt)
        self.graphics.uniform_set_data(self.u_tint, Vec4(1.0, 0.0, 0.0, 1.0))

        self.u_texture_0_fmt = self.graphics.uniform_format_create(b"u_texture_0", UNIFORM_TYPE_INT)
        self.u_texture_0 = self.graphics.uniform_create(self.u_texture_0_fmt)
        self.graphics.uniform_set_data(self.u_texture_0, TEXTURE_UNIT_5)

        self.u_texture_1_fmt = self.graphics.uniform_format_create(b"u_texture_1", UNIFORM_TYPE_INT)
        self.u_texture_1 = self.graphics.uniform_create(self.u_texture_1_fmt)
        self.graphics.uniform_set_data(self.u_texture_1, TEXTURE_UNIT_7)

        self.uniforms = np.array([self.u_tint, self.u_texture_0, self.u_texture_1], dtype=np.uint64)
        
        self.v_data = np.array([
            -1.0, -1.0, 0.0, 0.0, 0.0,
             0.0, 1.0, 0.0, 0.5, 1.0, 
             1.0, -1.0, 0.0, 1.0, 0.0,
            ], dtype=np.float32,
        )
        
        self.vbo = self.graphics.vertex_buffer_create(self.v_fmt, BUFFER_USAGE_STATIC)
        self.graphics.vertex_buffer_set_data(self.vbo, self.v_data.view(np.uint8))
        self.i_data = np.array([0, 1, 2], dtype=np.int32)
        self.ibo = self.graphics.index_buffer_create(INDEX_FORMAT_U32, BUFFER_USAGE_STATIC)
        self.graphics.index_buffer_set_data(self.ibo, self.i_data.view(np.uint8))
        out = self.i_data.view(np.uint8)
        vs_path = b"./resources/shaders/basic.vert"
        self.vs = self.graphics.shader_create_from_file(SHADER_TYPE_VERTEX, vs_path)
        fs_path = b"./resources/shaders/basic.frag"
        self.fs = self.graphics.shader_create_from_file(SHADER_TYPE_FRAGMENT, fs_path)
        self.program = self.graphics.program_create(self.vs, self.fs)
        image_0_path = b"./resources/textures/image_0.png"
        image_1_path = b"./resources/textures/image_1.png"
        self.image_0 = self.graphics.image_create_from_file(image_0_path)
        self.image_1 = self.graphics.image_create_from_file(image_1_path)
        self.texture_0 = self.graphics.texture_create()
        self.graphics.texture_set_image(self.texture_0, self.image_0)
        self.texture_1 = self.graphics.texture_create()
        self.graphics.texture_set_image(self.texture_1, self.image_1)
        
        self.view = self.graphics.view_create()
        self.graphics.view_set_clear_flags(self.view, VIEW_CLEAR_COLOR)
        self.graphics.view_set_clear_color(self.view, Vec4(0.2, 0.3, 0.3, 1.0))
        self.graphics.view_set_program(self.view, self.program)
        self.graphics.view_set_uniforms(self.view, self.uniforms)
        self.graphics.view_set_vertex_buffer(self.view, self.vbo)
        self.graphics.view_set_index_buffer(self.view, self.ibo)
        self.graphics.view_set_texture(self.view, self.texture_0, TEXTURE_UNIT_5)
        self.graphics.view_set_texture(self.view, self.texture_1, TEXTURE_UNIT_7)
    
    def quit(self):
        #really should call *_delete methods on all created graphics handles
        #in testing so far, this function is never called, so am lazy with clean up here.
        super().quit()
    
    def update(self, delta):
        print(delta)
        self.graphics.update()

if __name__ == "__main__":
    game = Game()
    game.run()