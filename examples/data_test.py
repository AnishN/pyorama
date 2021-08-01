from pyorama.core.app import *
from pyorama.graphics.window import *
from pyorama.event.listener import *
from pyorama.event.event_enums import *

class Game(App):
    
    def init(self):
        super().init()
        self.setup_window()
        
    def quit(self):
        super().quit()

    def setup_window(self):
        self.width = 800
        self.height = 600
        self.window = Window(self.graphics)
        print("window")
        self.window.create(self.width, self.height, b"BunnyMark")
        self.window_listener = Listener(self.event)
        self.window_listener.create(EVENT_TYPE_WINDOW, self.on_window_event)
        print("done")
    
    def quit(self):
        super().quit()

    def on_window_event(self, event_data):
        print("on window event")
        if event_data["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
            self.quit()

if __name__ == "__main__":
    game = Game()
    game.run()