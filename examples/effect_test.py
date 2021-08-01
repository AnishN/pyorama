from pyorama.core import *
from pyorama.event import *
from pyorama.graphics import *

class Game(App):
    
    def init(self):
        super().init()
        self.window = Window(self.graphics)
        self.window.create(800, 600, b"Effect Test")
        self.window_listener = Listener(self.event)
        self.window_listener.create(EVENT_TYPE_WINDOW, self.on_window_event)

        self.composer = EffectComposer(self.graphics)
        self.render_pass = RenderPass(self.graphics)
        self.effect_pass = EffectPass(self.graphics)

        self.camera = Camera(self.graphics)
        """
        self.camera.create(
            position=Vec2(400, 300),
            offset=Vec2(0, 0),
            zoom=Vec2(1, 1),
            rotation=0.0
        )
        self.scene = Scene(self.graphics)
        """
    
    def quit(self):
        super().quit()

    def on_window_event(self, event_data):
        if event_data["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
            self.quit()
    
if __name__ == "__main__":
    game = Game()
    game.run()