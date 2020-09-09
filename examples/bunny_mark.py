import math
import numpy as np
from pyorama.core.app import *
from pyorama.event.event_enums import *
from pyorama.event.event_manager import *
from pyorama.graphics.graphics_enums import *
from pyorama.graphics.graphics_manager import *
from pyorama.physics.physics_enums import *
from pyorama.physics.physics_manager import *
from pyorama.math3d.vec2 import Vec2
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4
from pyorama.math3d.mat4 import Mat4

class Game(App):
    
    def init(self):
        super().init(ms_per_update=1000.0/60.0)
        self.setup_window()
        self.setup_uniforms()
        self.setup_shaders()
        
        #setup sprites
        image_path = b"./resources/textures/bunny.png"
        self.image = self.graphics.image_create_from_file(image_path)
        self.texture = self.graphics.texture_create(mipmaps=True, filter=TEXTURE_FILTER_LINEAR)
        self.graphics.texture_set_data_2d_from_image(self.texture, self.image)

        self.width = 800
        self.height = 600
        self.bunny_width = 26
        self.bunny_height = 37

        #setup piece sprites
        self.sprites = []
        #self.num_sprites = 2 ** 16 - 1
        self.num_sprites = 50000
        position = Vec2()
        window_size = Vec2(self.width, self.height)
        for i in range(self.num_sprites):
            Vec2.random(position)
            Vec2.mul(position, position, window_size)
            sprite = self.graphics.sprite_create(self.bunny_width, self.bunny_height)
            self.graphics.sprite_set_position(sprite, position)
            self.graphics.sprite_set_anchor(sprite, Vec2(0.5, 0.5))
            self.sprites.append(sprite)
        self.sprite_batch = self.graphics.sprite_batch_create()
        self.sprites = np.array(self.sprites, dtype=np.uint64)
        self.graphics.sprite_batch_set_sprites(self.sprite_batch, self.sprites)
        self.vbo = self.graphics.sprite_batch_get_vertex_buffer(self.sprite_batch)
        self.ibo = self.graphics.sprite_batch_get_index_buffer(self.sprite_batch)
        
        self.setup_view()
        self.previous_time = 0.0
        self.current_time = 0.0
        self.time_delta = 0.0
        window_listener = self.event.listener_create(EVENT_TYPE_WINDOW, self.on_window)
        enter_frame_listener = self.event.listener_create(EVENT_TYPE_ENTER_FRAME, self.on_enter_frame)

    def quit(self):
        super().quit()
    
    def setup_window(self):
        self.width = 800
        self.height = 600
        self.window = self.graphics.window_create(self.width, self.height, b"BunnyMark")

    def setup_uniforms(self):
        self.u_texture = self.graphics.uniform_create(self.graphics.u_fmt_texture_0)
        self.graphics.uniform_set_data(self.u_texture, TEXTURE_UNIT_0)
        self.u_proj = self.graphics.uniform_create(self.graphics.u_fmt_proj)
        self.proj_mat = Mat4()
        Mat4.ortho(self.proj_mat, 0, self.width, 0, self.height, -1, 1)
        self.graphics.uniform_set_data(self.u_proj, self.proj_mat)
        self.view_mat = Mat4()
        self.u_view = self.graphics.uniform_create(self.graphics.u_fmt_view)
        self.graphics.uniform_set_data(self.u_view, self.view_mat)
        self.u_rect = self.graphics.uniform_create(self.graphics.u_fmt_rect)
        self.graphics.uniform_set_data(self.u_rect, Vec4(0, 0, self.width, self.height))
        self.uniforms = np.array([self.u_texture, self.u_proj, self.u_view, self.u_rect], dtype=np.uint64)
    
    def setup_shaders(self):
        vs_path = b"./resources/shaders/sprite.vert"
        self.vs = self.graphics.shader_create_from_file(SHADER_TYPE_VERTEX, vs_path)
        fs_path = b"./resources/shaders/sprite.frag"
        self.fs = self.graphics.shader_create_from_file(SHADER_TYPE_FRAGMENT, fs_path)
        self.program = self.graphics.program_create(self.vs, self.fs)

    def setup_view(self):
        self.out_color = self.graphics.texture_create()
        self.graphics.texture_clear(self.out_color, self.width, self.height)
        self.graphics.window_set_texture(self.window, self.out_color)
        self.fbo = self.graphics.frame_buffer_create()
        self.graphics.frame_buffer_attach_textures(self.fbo, {
            FRAME_BUFFER_ATTACHMENT_COLOR_0: self.out_color,
        })
        
        self.view = self.graphics.view_create()
        self.update_view()
    
    def update_view(self):
        self.graphics.view_set_rect(self.view, 0, 0, self.width, self.height)
        self.graphics.view_set_program(self.view, self.program)
        self.graphics.view_set_uniforms(self.view, self.uniforms)
        self.graphics.view_set_vertex_buffer(self.view, self.vbo)
        self.graphics.view_set_index_buffer(self.view, self.ibo)
        self.graphics.view_set_textures(self.view, {
            TEXTURE_UNIT_0: self.texture,
        })
        self.graphics.view_set_frame_buffer(self.view, self.fbo)

    def on_window(self, event_data, *args, **kwargs):
        if event_data["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
            self.quit()

    def on_enter_frame(self, event_data, *args, **kwargs):
        self.current_time = event_data["timestamp"]
        position = Vec2()
        shift = Vec2()
        for i in range(self.num_sprites):
            Vec2.random(shift)
            Vec2.scale_add(shift, shift, 2.0, -1.0)
            position = self.graphics.sprite_get_position(self.sprites[i])
            Vec2.add(position, position, shift)
            self.graphics.sprite_set_position(self.sprites[i], position)
        self.time_delta = self.current_time - self.previous_time
        fps = min(round(1000.0 / self.ms_per_update), round(1.0 / self.time_delta))
        title = ("BunnyMark (FPS: {0})".format(fps)).encode("utf-8")
        self.graphics.window_set_title(self.window, title)
        self.previous_time = self.current_time
    
if __name__ == "__main__":
    game = Game()
    game.run()
