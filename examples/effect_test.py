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
    
    def quit(self):
        super().quit()

    def on_window_event(self, event_data):
        if event_data["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
            self.quit()
    
if __name__ == "__main__":
    game = Game()
    game.run()