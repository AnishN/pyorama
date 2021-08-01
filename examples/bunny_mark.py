import math
import os
from pyorama import *

class Game(App):
    
    def init(self):
        super().init()
        self.setup_window()
        self.setup_uniforms()
        self.setup_shaders()
        self.setup_sprites()
        self.setup_view()
        self.setup_listeners()

    def quit(self):
        super().quit()
    
    def setup_window(self):
        self.width = 800
        self.height = 600
        self.window = Window(self.graphics)
        self.window.create(self.width, self.height, b"BunnyMark")

    def setup_uniforms(self):
        self.u_texture = Uniform(self.graphics)
        self.u_texture.create(self.graphics.u_fmt_texture_0)
        self.u_texture.set_data(TEXTURE_UNIT_0)

        self.proj_mat = Mat4()
        Mat4.ortho(self.proj_mat, 0, self.width, 0, self.height, -1, 1)
        self.u_proj = Uniform(self.graphics)
        self.u_proj.create(self.graphics.u_fmt_proj)
        self.u_proj.set_data(self.proj_mat)

        self.view_mat = Mat4()
        self.u_view = Uniform(self.graphics)
        self.u_view.create(self.graphics.u_fmt_view)
        self.u_view.set_data(self.view_mat)

        u_rect_data = Vec4(0, 0, self.width, self.height)
        self.u_rect = Uniform(self.graphics)
        self.u_rect.create(self.graphics.u_fmt_rect)
        self.u_rect.set_data(u_rect_data)

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

    def setup_sprites(self):
        image_path = b"./resources/textures/bunny.png"
        self.image = Image(self.graphics)
        self.image.create_from_file(image_path)
        self.texture = Texture(self.graphics)
        self.texture.create(mipmaps=True, filter=TEXTURE_FILTER_LINEAR)
        self.texture.set_data_2d_from_image(self.image)

        self.bunny_width = self.image.get_width()
        self.bunny_height = self.image.get_height()
        
        #setup piece sprites
        self.sprites = []
        self.num_sprites = 10000
        position = Vec2()
        window_size = Vec2(self.width, self.height)
        for i in range(self.num_sprites):
            Vec2.random(position)
            Vec2.mul(position, position, window_size)
            sprite = Sprite(self.graphics)
            sprite.create(self.bunny_width, self.bunny_height)
            sprite.set_position(position)
            sprite.set_anchor(Vec2(0.5, 0.5))
            #sprite.anchor = Vec2(0.5, 0.5)
            #sprite.set_alpha(0.3)
            self.sprites.append(sprite)
        self.sprite_batch = SpriteBatch(self.graphics)
        self.sprite_batch.create()
        self.sprite_batch.set_sprites(self.sprites)
        
        self.vbo = self.sprite_batch.get_vertex_buffer()
        self.ibo = self.sprite_batch.get_index_buffer()

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
        self.view.set_blend_func(
            src_rgb=BLEND_FUNC_SRC_ALPHA,
            dst_rgb=BLEND_FUNC_ONE_MINUS_SRC_ALPHA,
            src_alpha=BLEND_FUNC_ONE,
            dst_alpha=BLEND_FUNC_ONE_MINUS_SRC_ALPHA,
        )

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
        position = Vec2()
        shift = Vec2()
        for i in range(self.num_sprites):
            Vec2.random(shift)
            Vec2.scale_add(shift, shift, 2.0, -1.0)
            sprite = self.sprites[i]
            position = sprite.get_position()
            Vec2.add(position, position, shift)
            sprite.set_position(position)
        fps = round(self.get_fps(), 1)
        title = ("BunnyMark (FPS: {0})".format(fps)).encode("utf-8")
        self.window.set_title(title)
    
if __name__ == "__main__":
    game = Game()
    game.run()

"""
WHAT SHOULD THE API LOOK LIKE?

sprite_pass = SpritePass(self.graphics)
sprite_pass.create(sprites, camera)
    - position texture
    - albedo texture
    - normal texture
    - specular texture
    - texture_4
    - texture_5
    - texture_6
    - texture_7

tint_pass = TintEffectPass(self.graphics)
tint_pass.create(
    tint=Vec4(1.0, 0.0, 0.0, 1.0),
    input_textures=[],
    output_textures=[],
)
effect_passes = [
    tint_pass,
]

composer = EffectComposer(self.graphics)
composer.set_render_pass(sprite_pass)
composer.set_effect_passes(effect_passes)#with a given order
"""