import math
import numpy as np
from pyorama.core.app import *
from pyorama.event.event_enums import *
from pyorama.event.event_manager import *
from pyorama.graphics.graphics_enums import *
from pyorama.graphics.graphics_manager import *
from pyorama.physics.physics_manager import *
from pyorama.math3d.vec2 import Vec2
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4
from pyorama.math3d.mat4 import Mat4

class Game(App):
    
    def init(self):
        super().init()
        self.setup_window()
        self.setup_uniforms()
        self.setup_shaders()
        
        #setup sprites
        image_path = b"./resources/textures/carrom_base.png"
        self.image = self.graphics.image_create_from_file(image_path)
        self.texture = self.graphics.texture_create(mipmaps=True, filter=TEXTURE_FILTER_LINEAR)
        self.graphics.texture_set_data_2d_from_image(self.texture, self.image)

        self.width = 800
        self.height = 600
        self.radius = 16.0
        self.center = Vec2(self.width / 2.0, self.height / 2.0)
        self.inner_offset = Vec2(2.0 * self.radius, 0.0)
        self.outer_corner_offset = Vec2(4.0 * self.radius, 0.0)
        self.outer_edge_offset = Vec2(
            math.sqrt(8 * self.radius * self.radius * (1 - math.cos(math.radians(120)))), 
            0.0,
        )#law of cosines
        self.red_positions = [Vec2(self.center.x, self.center.y)]
        self.white_positions = []
        self.black_positions = []
        self.base_offset = Vec2()
        Vec2.add(self.base_offset, self.center, self.inner_offset)

        #white inner
        for i in range(3):
            offset = Vec2()
            angle = math.radians(30 + i * 120)
            Vec2.rotate(offset, self.base_offset, self.center, angle)
            self.white_positions.append(offset)

        #black inner
        for i in range(3):
            offset = Vec2()
            angle = math.radians(90 + i * 120)
            Vec2.rotate(offset, self.base_offset, self.center, angle)
            self.black_positions.append(offset)

        #white outer
        Vec2.add(self.base_offset, self.center, self.outer_corner_offset)
        for i in range(6):
            offset = Vec2()
            angle = math.radians(30 + 60 * i)
            Vec2.rotate(offset, self.base_offset, self.center, angle)
            self.white_positions.append(offset)
        
        #black outer
        Vec2.add(self.base_offset, self.center, self.outer_edge_offset)
        for i in range(6):
            offset = Vec2()
            angle = math.radians(60 * i)
            Vec2.rotate(offset, self.base_offset, self.center, angle)
            self.black_positions.append(offset)
        
        #setup piece sprites
        self.sprites = []
        red_tint = Vec3(1.0, 0.0, 0.0)
        white_tint = Vec3(1.0, 0.9, 0.8)
        black_tint = Vec3(0.2, 0.2, 0.2)
        tints = [red_tint, white_tint, black_tint]
        positions = [self.red_positions, self.white_positions, self.black_positions]
        for tint, color_positions in zip(tints, positions):
            for color_position in color_positions:
                sprite = self.graphics.sprite_create(self.radius * 2, self.radius * 2)
                self.graphics.sprite_set_position(sprite, color_position)
                self.graphics.sprite_set_anchor(sprite, Vec2(0.5, 0.5))
                self.graphics.sprite_set_tint(sprite, tint)
                self.sprites.append(sprite)
        self.sprite_batch = self.graphics.sprite_batch_create()
        self.sprites = np.array(self.sprites, dtype=np.uint64)
        self.graphics.sprite_batch_set_sprites(self.sprite_batch, self.sprites)
        self.vbo = self.graphics.sprite_batch_get_vertex_buffer(self.sprite_batch)
        self.ibo = self.graphics.sprite_batch_get_index_buffer(self.sprite_batch)

        self.num_pieces = 19#len(self.sprites)
        #print(self.num_pieces)
        self.space = self.physics.space_create()
        self.physics.space_set_gravity(self.space, Vec2())
        self.physics.space_set_damping(self.space, 0.4)#simulates friction with board...
        self.bodies = []
        self.shapes = []

        offset = Vec2()
        piece_mass = 1.0
        piece_friction = 0.4
        piece_moment = self.physics.moment_for_circle(piece_mass, 0, self.radius, offset)
        positions = self.red_positions + self.white_positions + self.black_positions
        self.num_pieces = 19
        for i in range(self.num_pieces):
            body = self.physics.body_create(piece_mass, piece_moment)
            shape = self.physics.shape_create_circle(body, self.radius, offset)
            self.bodies.append(body)
            self.shapes.append(shape)

            self.physics.space_add_body(self.space, self.bodies[i])
            self.physics.body_set_position(self.bodies[i], positions[i])
            self.physics.shape_set_friction(self.shapes[i], piece_friction)
            self.physics.space_add_shape(self.space, self.shapes[i])

        self.physics.body_set_force(self.bodies[0], Vec2(70000.0, 70000.0))
        
        self.setup_view()
        window_listener = self.event.listener_create(EVENT_TYPE_WINDOW, self.on_window)
        enter_frame_listener = self.event.listener_create(EVENT_TYPE_ENTER_FRAME, self.on_enter_frame)
        
    def quit(self):
        super().quit()
    
    def setup_window(self):
        self.width = 800
        self.height = 600
        self.window = self.graphics.window_create(self.width, self.height, b"Carrom")

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
        self.graphics.view_set_clear_flags(self.view, VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH | VIEW_CLEAR_STENCIL)
        self.graphics.view_set_clear_color(self.view, Vec4(0.0, 0.0, 0.0, 1.0))
        self.graphics.view_set_clear_depth(self.view, 1.0)
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
        for sprite, body in zip(self.sprites, self.bodies):
            position = self.physics.body_get_position(body)
            self.graphics.sprite_set_position(sprite, position)
    
if __name__ == "__main__":
    game = Game()
    game.run()