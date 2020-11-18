import math
import numpy as np
from pyorama.core.app import *
from pyorama.event.event_enums import *
from pyorama.event.event_manager import *
from pyorama.event.listener import *

from pyorama.graphics.graphics_enums import *
from pyorama.graphics.graphics_manager import *
from pyorama.graphics.frame_buffer import *
from pyorama.graphics.image import *
from pyorama.graphics.program import *
from pyorama.graphics.shader import *
from pyorama.graphics.sprite import *
from pyorama.graphics.sprite_batch import *
from pyorama.graphics.texture import *
from pyorama.graphics.uniform import *
from pyorama.graphics.view import *
from pyorama.graphics.window import *

from pyorama.physics.physics_enums import *
from pyorama.physics.physics_manager import *
from pyorama.physics.body import *
from pyorama.physics.shape import *
from pyorama.physics.space import *

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
        self.window = Window(self.graphics)
        self.window.create(self.width, self.height, self.title)
    
    def setup_uniforms(self):
        self.u_texture = Uniform(self.graphics)
        self.u_texture.create(self.graphics.u_fmt_texture_0)
        self.u_texture.set_data(TEXTURE_UNIT_0)

        self.proj_mat = Mat4()
        self.u_proj = Uniform(self.graphics)
        self.u_proj.create(self.graphics.u_fmt_proj)
        Mat4.ortho(self.proj_mat, 0, self.width, 0, self.height, -1, 1)
        self.u_proj.set_data(self.proj_mat)

        self.view_mat = Mat4()
        self.u_view = Uniform(self.graphics)
        self.u_view.create(self.graphics.u_fmt_view)
        self.u_view.set_data(self.view_mat)

        self.u_rect = Uniform(self.graphics)
        self.u_rect.create(self.graphics.u_fmt_rect)
        self.u_rect.set_data(Vec4(0, 0, self.width, self.height))

        self.uniforms = [self.u_texture, self.u_proj, self.u_view, self.u_rect]
    
    def setup_shaders(self):
        vs_path = b"./resources/shaders/sprite.vert"
        self.vs = Shader(self.graphics)
        self.vs.create_from_file(SHADER_TYPE_VERTEX, vs_path)
        fs_path = b"./resources/shaders/sprite.frag"
        self.fs = Shader(self.graphics)
        self.fs.create_from_file(SHADER_TYPE_FRAGMENT, fs_path)
        self.program = Program(self.graphics)
        self.program.create(self.vs, self.fs)

    def setup_view(self):
        self.out_color = Texture(self.graphics)
        self.out_color.create()
        self.out_color.clear(self.width, self.height)
        self.window.set_texture(self.out_color)
        self.fbo = FrameBuffer(self.graphics)
        self.fbo.create()
        self.fbo.attach_textures({
            FRAME_BUFFER_ATTACHMENT_COLOR_0: self.out_color,
        })
        
        self.board_view = View(self.graphics)
        self.board_view.create()
        self.update_board_view()
        self.coin_view = View(self.graphics)
        self.coin_view.create()
        self.update_coin_view()

    def setup_textures(self):
        coin_image_path = b"./resources/textures/carrom_base.png"
        self.coin_image = Image(self.graphics)
        self.coin_image.create_from_file(coin_image_path)
        self.coin_texture = Texture(self.graphics)
        self.coin_texture.create(mipmaps=True, filter=TEXTURE_FILTER_LINEAR)
        self.coin_texture.set_data_2d_from_image(self.coin_image)

        board_image_path = b"./resources/textures/carrom_board.png"
        self.board_image = Image(self.graphics)
        self.board_image.create_from_file(board_image_path)
        self.board_texture = Texture(self.graphics)
        self.board_texture.create(mipmaps=True, filter=TEXTURE_FILTER_LINEAR)
        self.board_texture.set_data_2d_from_image(self.board_image)

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
        self.coin_sprites = []
        red_tint = Vec3(1.0, 0.0, 0.0)
        white_tint = Vec3(1.0, 0.9, 0.8)
        black_tint = Vec3(0.3, 0.3, 0.3)
        tints = [red_tint, white_tint, black_tint]
        positions = [self.red_positions, self.white_positions, self.black_positions]
        for tint, color_positions in zip(tints, positions):
            for color_position in color_positions:
                sprite = Sprite(self.graphics)
                sprite.create(self.radius * 2, self.radius * 2)
                sprite.set_position(color_position)
                sprite.set_anchor(Vec2(0.5, 0.5))
                sprite.set_tint(tint)
                self.coin_sprites.append(sprite)
        self.coin_batch = SpriteBatch(self.graphics)
        self.coin_batch.create()
        self.coin_batch.set_sprites(self.coin_sprites)
        self.vbo = self.coin_batch.get_vertex_buffer()
        self.ibo = self.coin_batch.get_index_buffer()
        
        #setup board sprite
        min_window_dim = min(self.width, self.height)
        self.board_sprites = []
        self.board_sprite = Sprite(self.graphics)
        self.board_sprite.create(min_window_dim, min_window_dim)
        self.board_sprite.set_anchor(Vec2(0.5, 0.5))
        self.board_sprite.set_position(Vec2(self.width / 2, self.height / 2))
        self.board_sprites.append(self.board_sprite)
        self.board_batch = SpriteBatch(self.graphics)
        self.board_batch.create()
        self.board_batch.set_sprites(self.board_sprites)
        self.board_vbo = self.board_batch.get_vertex_buffer()
        self.board_ibo = self.board_batch.get_index_buffer()

    def setup_physics(self):
        self.num_coins = len(self.coin_sprites)
        self.damping = 0.5
        self.friction = 0.4
        self.elasticity = 0.7
        self.space = Space(self.physics)
        self.space.create()
        self.space.set_gravity(Vec2())
        self.space.set_damping(self.damping)#simulates friction with board...
        self.bodies = []
        self.shapes = []

        offset = Vec2()
        self.coin_mass = 0.5
        self.coin_moment = Shape.moment_for_circle(self.coin_mass, 0, self.radius, offset)
        positions = self.red_positions + self.white_positions + self.black_positions
        self.num_coins = 19
        for i in range(self.num_coins):
            body = Body(self.physics)
            body.create(self.coin_mass, self.coin_moment)
            body.set_position(positions[i])
            self.space.add_body(body)
            self.bodies.append(body)

            shape = Shape(self.physics)
            shape.create_circle(body, self.radius, offset)
            shape.set_friction(self.friction)
            shape.set_elasticity(self.elasticity)
            self.space.add_shape(shape)
            self.shapes.append(shape)

        self.bodies[0].set_force(Vec2(100000.0, 30000.0))
        self.board_body = Body(self.physics)
        self.board_body.create(type=BODY_TYPE_STATIC)
        self.space.add_body(self.board_body)
        self.board_top = (Vec2(0.0, self.height), Vec2(self.width, self.height))
        self.board_bottom = (Vec2(0.0, 0.0), Vec2(self.width, 0.0))
        self.board_left = (Vec2(0.0, 0.0), Vec2(0.0, self.height))
        self.board_right = (Vec2(self.width, 0.0), Vec2(self.width, self.height))
        self.board_edges = [self.board_top, self.board_bottom, self.board_left, self.board_right]
        self.edge_shapes = []
        for edge in self.board_edges:
            edge_shape = Shape(self.physics)
            edge_shape.create_segment(self.board_body, *edge, 0.0)
            edge_shape.set_elasticity(self.elasticity)
            self.space.add_shape(edge_shape)
            self.edge_shapes.append(edge_shape)

    def setup_listeners(self):
        self.window_listener = Listener(self.event)
        self.window_listener.create(EVENT_TYPE_WINDOW, self.on_window)
        self.enter_frame_listener = Listener(self.event)
        self.enter_frame_listener.create(EVENT_TYPE_ENTER_FRAME, self.on_enter_frame)

    def update_coin_view(self):
        self.coin_view.set_clear_flags(0)
        self.coin_view.set_rect(0, 0, self.width, self.height)
        self.coin_view.set_program(self.program)
        self.coin_view.set_uniforms(self.uniforms)
        self.coin_view.set_vertex_buffer(self.vbo)
        self.coin_view.set_index_buffer(self.ibo)
        self.coin_view.set_textures({
            TEXTURE_UNIT_0: self.coin_texture,
        })
        self.coin_view.set_frame_buffer(self.fbo)
    
    def update_board_view(self):
        self.board_view.set_rect(0, 0, self.width, self.height)
        self.board_view.set_program(self.program)
        self.board_view.set_uniforms(self.uniforms)
        self.board_view.set_vertex_buffer(self.board_vbo)
        self.board_view.set_index_buffer(self.board_ibo)
        self.board_view.set_textures({
            TEXTURE_UNIT_0: self.board_texture,
        })
        self.board_view.set_frame_buffer(self.fbo)

    def on_window(self, event_data, *args, **kwargs):
        if event_data["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
            self.quit()

    def on_enter_frame(self, event_data, *args, **kwargs):
        for sprite, body in zip(self.coin_sprites, self.bodies):
            position = body.get_position()
            sprite.set_position(position)
    
if __name__ == "__main__":
    game = Game()
    game.run()