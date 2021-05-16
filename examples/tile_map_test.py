import math
import numpy as np
import os
from pyorama import *

class Game(App):
    
    def init(self):
        super().init()
        self.setup_window()
        self.setup_tiles()
        self.setup_uniforms()
        self.setup_shaders()
        self.setup_view()
        self.setup_listeners()

    def quit(self):
        super().quit()
    
    def setup_window(self):
        self.width = 800
        self.height = 600
        self.window = Window(self.graphics)
        self.window.create(self.width, self.height, b"Tile Map Test")

    def setup_uniforms(self):
        self.tile_map_size = Vec2(self.num_map_rows, self.num_map_columns)
        self.tile_size = Vec2(self.tile_width, self.tile_height)
        self.atlas_size = Vec2(self.num_atlas_rows, self.num_atlas_columns)
        self.proj_mat = Mat4(); Mat4.ortho(self.proj_mat, 0, self.width, 0, self.height, -1, 1)
        self.view_mat = Mat4()
        self.rect = Vec4(0, 0, self.width, self.height)
        uniforms = {
            self.graphics.u_fmt_texture_0: TEXTURE_UNIT_0,
            self.graphics.u_fmt_tile_map_size: self.tile_map_size,
            self.graphics.u_fmt_tile_size: self.tile_size,
            self.graphics.u_fmt_atlas_size: self.atlas_size,
            self.graphics.u_fmt_proj: self.proj_mat,
            self.graphics.u_fmt_view: self.view_mat,
            self.graphics.u_fmt_rect: self.rect,
        }
        self.uniforms = []
        for u_fmt, u_data in uniforms.items():
            uniform = Uniform(self.graphics)
            uniform.create(u_fmt)
            uniform.set_data(u_data)
            self.uniforms.append(uniform)
    
    def setup_shaders(self):
        vs_path = b"./resources/shaders/tile.vert"
        self.vs = Shader(self.graphics)
        self.vs.create_from_file(SHADER_TYPE_VERTEX, vs_path)

        fs_path = b"./resources/shaders/tile.frag"
        self.fs = Shader(self.graphics)
        self.fs.create_from_file(SHADER_TYPE_FRAGMENT, fs_path)
        self.program = Program(self.graphics)
        self.program.create(self.vs, self.fs)

    def setup_tiles(self):
        #Public domain tile-set taken from here: https://adamatomic.itch.io/cavernas
        self.image = Image(self.graphics)
        self.image.create_from_file(b"./resources/textures/cavesofgallet_tiles.png")
        self.texture = Texture(self.graphics)
        self.texture.create()
        self.texture.set_data_2d_from_image(self.image)
        
        self.tile_width = 16
        self.tile_height = 16
        self.num_atlas_rows = int(self.image.get_height() / self.tile_height)
        self.num_atlas_columns = int(self.image.get_width() / self.tile_width)
        self.atlas = TextureGridAtlas(self.graphics)
        self.atlas.create(self.texture, self.num_atlas_rows, self.num_atlas_columns)

        self.num_map_rows = round(self.height / self.tile_height)
        self.num_map_columns = round(self.width / self.tile_width)
        self.tile_map = TileMap(self.graphics)
        self.tile_map.create(self.atlas, self.tile_width, self.tile_height, self.num_map_rows, self.num_map_columns)
        self.tile_indices = np.random.randint(
            low=0,
            high=self.num_atlas_rows * self.num_atlas_columns,
            size=self.num_map_rows * self.num_map_columns, 
            dtype=np.uint32,
        )
        
        self.tile_map.set_indices(self.tile_indices)
        self.vbo = self.tile_map.get_vertex_buffer()
        self.ibo = self.tile_map.get_index_buffer()

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
        
        self.view = View(self.graphics)
        self.view.create()
        self.update_view()
    
    def setup_listeners(self):
        self.window_listener = Listener(self.event)
        self.window_listener.create(EVENT_TYPE_WINDOW, self.on_window)
        self.enter_frame_listener = Listener(self.event)
        self.enter_frame_listener.create(EVENT_TYPE_ENTER_FRAME, self.on_enter_frame)

    def update_view(self):
        self.view.set_rect(0, 0, self.width, self.height)
        self.view.set_program(self.program)
        self.view.set_uniforms(self.uniforms)
        self.view.set_vertex_buffer(self.vbo)
        self.view.set_index_buffer(self.ibo)
        self.view.set_textures({
            TEXTURE_UNIT_0: self.texture,
        })
        self.view.set_frame_buffer(self.fbo)
    
    def on_window(self, event_data, *args, **kwargs):
        if event_data["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
            self.quit()

    def on_enter_frame(self, event_data, *args, **kwargs):
        pass
    
if __name__ == "__main__":
    game = Game()
    game.run()