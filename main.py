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
        image_path = b"./resources/textures/test.png"
        self.image = self.graphics.image_create_from_file(image_path)
        self.texture = self.graphics.texture_create()
        self.graphics.texture_set_image(self.texture, self.image)

        self.view = self.graphics.view_create()
        self.uniforms = np.array([self.u_tint], dtype=np.uint64)
        self.graphics.view_set_uniforms(self.view, self.uniforms)
    
    def quit(self):
        self.graphics.vertex_format_delete(self.v_fmt)
        self.graphics.vertex_buffer_delete(self.vbo)
        self.graphics.index_buffer_delete(self.ibo)
        self.graphics.uniform_format_delete(self.u_tint_fmt)
        self.graphics.uniform_delete(self.u_tint)
        self.graphics.shader_delete(self.vs)
        self.graphics.shader_delete(self.fs)
        self.graphics.program_delete(self.program)
        super().quit()
    
    def update(self, delta):
        print(delta)
        self.graphics.update()

if __name__ == "__main__":
    game = Game()
    game.run()