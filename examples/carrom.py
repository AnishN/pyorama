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
        super().init()
        self.setup_window()
        self.setup_uniforms()
        self.setup_shaders()
        self.setup_textures()
        self.setup_positions()
        self.setup_sprites()
        self.setup_physics()
        self.setup_view()
        self.setup_listeners()
        
    def quit(self):
        super().quit()
    
    def setup_window(self):
        self.width = 800
        self.height = 600
        self.title = b"Carrom"
        self.window = self.graphics.window_create(self.width, self.height, self.title)

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
        
        self.board_view = self.graphics.view_create()
        self.update_board_view()
        self.coin_view = self.graphics.view_create()
        self.update_coin_view()

    def setup_textures(self):
        coin_image_path = b"./resources/textures/carrom_base.png"
        self.coin_image = self.graphics.image_create_from_file(coin_image_path)
        self.coin_texture = self.graphics.texture_create(mipmaps=True, filter=TEXTURE_FILTER_LINEAR)
        self.graphics.texture_set_data_2d_from_image(self.coin_texture, self.coin_image)
        board_image_path = b"./resources/textures/carrom_board.png"
        self.board_image = self.graphics.image_create_from_file(board_image_path)
        self.board_texture = self.graphics.texture_create(mipmaps=True, filter=TEXTURE_FILTER_LINEAR)
        self.graphics.texture_set_data_2d_from_image(self.board_texture, self.board_image)

    def setup_positions(self):
        self.radius = 12.0
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

    def setup_sprites(self):
        #setup coin sprites
        self.sprites = []
        red_tint = Vec3(1.0, 0.0, 0.0)
        white_tint = Vec3(1.0, 0.9, 0.8)
        black_tint = Vec3(0.3, 0.3, 0.3)
        tints = [red_tint, white_tint, black_tint]
        positions = [self.red_positions, self.white_positions, self.black_positions]
        for tint, color_positions in zip(tints, positions):
            for color_position in color_positions:
                sprite = self.graphics.sprite_create(self.radius * 2, self.radius * 2)
                self.graphics.sprite_set_position(sprite, color_position)
                self.graphics.sprite_set_anchor(sprite, Vec2(0.5, 0.5))
                self.graphics.sprite_set_tint(sprite, tint)
                self.sprites.append(sprite)
        self.coin_batch = self.graphics.sprite_batch_create()
        self.sprites = np.array(self.sprites, dtype=np.uint64)
        self.graphics.sprite_batch_set_sprites(self.coin_batch, self.sprites)
        self.vbo = self.graphics.sprite_batch_get_vertex_buffer(self.coin_batch)
        self.ibo = self.graphics.sprite_batch_get_index_buffer(self.coin_batch)
        
        #setup board sprite
        min_window_dim = min(self.width, self.height)
        self.board_sprite = self.graphics.sprite_create(min_window_dim, min_window_dim)
        self.graphics.sprite_set_anchor(self.board_sprite, Vec2(0.5, 0.5))
        self.graphics.sprite_set_position(self.board_sprite, Vec2(self.width / 2, self.height / 2))

        self.board_sprites = np.array([self.board_sprite], dtype=np.uint64)
        self.board_batch = self.graphics.sprite_batch_create()
        self.graphics.sprite_batch_set_sprites(self.board_batch, self.board_sprites)
        self.board_vbo = self.graphics.sprite_batch_get_vertex_buffer(self.board_batch)
        self.board_ibo = self.graphics.sprite_batch_get_index_buffer(self.board_batch)

    def setup_physics(self):
        self.num_coins = len(self.sprites)
        self.damping = 0.5
        self.friction = 0.4
        self.elasticity = 0.7
        self.space = self.physics.space_create()
        self.physics.space_set_gravity(self.space, Vec2())
        self.physics.space_set_damping(self.space, self.damping)#simulates friction with board...
        self.bodies = []
        self.shapes = []

        offset = Vec2()
        self.coin_mass = 0.5
        self.coin_moment = self.physics.moment_for_circle(self.coin_mass, 0, self.radius, offset)
        positions = self.red_positions + self.white_positions + self.black_positions
        self.num_coins = 19
        for i in range(self.num_coins):
            body = self.physics.body_create(self.coin_mass, self.coin_moment)
            shape = self.physics.shape_create_circle(body, self.radius, offset)
            self.physics.space_add_body(self.space, body)
            self.physics.body_set_position(body, positions[i])
            self.physics.shape_set_friction(shape, self.friction)
            self.physics.shape_set_elasticity(shape, self.elasticity)
            self.physics.space_add_shape(self.space, shape)
            self.bodies.append(body)
            self.shapes.append(shape)
        
        self.physics.body_set_force(self.bodies[0], Vec2(100000.0, 30000.0))

        self.board_body = self.physics.body_create(type=BODY_TYPE_STATIC)
        self.physics.space_add_body(self.space, self.board_body)
        self.board_top = (Vec2(0.0, self.height), Vec2(self.width, self.height))
        self.board_bottom = (Vec2(0.0, 0.0), Vec2(self.width, 0.0))
        self.board_left = (Vec2(0.0, 0.0), Vec2(0.0, self.height))
        self.board_right = (Vec2(self.width, 0.0), Vec2(self.width, self.height))
        self.board_edges = [self.board_top, self.board_bottom, self.board_left, self.board_right]
        self.edge_shapes = []
        for edge in self.board_edges:
            edge_shape = self.physics.shape_create_segment(self.board_body, *edge, 0.0)
            self.physics.shape_set_elasticity(edge_shape, self.elasticity)
            self.physics.space_add_shape(self.space, edge_shape)
            self.edge_shapes.append(edge_shape)

    def setup_listeners(self):
        self.window_listener = self.event.listener_create(EVENT_TYPE_WINDOW, self.on_window)
        self.enter_frame_listener = self.event.listener_create(EVENT_TYPE_ENTER_FRAME, self.on_enter_frame)

    def update_coin_view(self):
        self.graphics.view_set_clear_flags(self.coin_view, 0)
        self.graphics.view_set_rect(self.coin_view, 0, 0, self.width, self.height)
        self.graphics.view_set_program(self.coin_view, self.program)
        self.graphics.view_set_uniforms(self.coin_view, self.uniforms)
        self.graphics.view_set_vertex_buffer(self.coin_view, self.vbo)
        self.graphics.view_set_index_buffer(self.coin_view, self.ibo)
        self.graphics.view_set_textures(self.coin_view, {
            TEXTURE_UNIT_0: self.coin_texture,
        })
        self.graphics.view_set_frame_buffer(self.coin_view, self.fbo)
    
    def update_board_view(self):
        self.graphics.view_set_rect(self.board_view, 0, 0, self.width, self.height)
        self.graphics.view_set_program(self.board_view, self.program)
        self.graphics.view_set_uniforms(self.board_view, self.uniforms)
        self.graphics.view_set_vertex_buffer(self.board_view, self.board_vbo)
        self.graphics.view_set_index_buffer(self.board_view, self.board_ibo)
        self.graphics.view_set_textures(self.board_view, {
            TEXTURE_UNIT_0: self.board_texture,
        })
        self.graphics.view_set_frame_buffer(self.board_view, self.fbo)

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