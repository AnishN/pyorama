import math
import numpy as np
from pyorama.core.app import *
from pyorama.event.event_enums import *
from pyorama.event.event_manager import *
from pyorama.event.listener import *
from pyorama.graphics.graphics_enums import *
from pyorama.graphics.graphics_manager import *
from pyorama.graphics.window import *
from pyorama.math3d.vec3 import Vec3
from pyorama.math3d.vec4 import Vec4
from pyorama.math3d.mat4 import Mat4

class Game(App):
    
    def init(self):
        super().init()
        self.window = Window(self.graphics)
        self.window.create(800, 600, b"Hello World!")        
        added = Listener(self.event); added.create(EVENT_TYPE_JOYSTICK_ADDED, self.on_added)
        removed = Listener(self.event); removed.create(EVENT_TYPE_JOYSTICK_REMOVED, self.on_removed)
        button_down = Listener(self.event); button_down.create(EVENT_TYPE_JOYSTICK_BUTTON_DOWN, self.on_button_down)
        button_up = Listener(self.event); button_up.create(EVENT_TYPE_JOYSTICK_BUTTON_UP, self.on_button_up)
    
    def quit(self):
        super().quit()
    
    def on_added(self, event_data, *args, **kwargs):
        print("ADDED")
        print(event_data)

    def on_removed(self, event_data, *args, **kwargs):
        print("REMOVED")
        print(event_data)

    def on_button_down(self, event_data, *args, **kwargs):
        print("BUTTON DOWN")
        print(event_data)

    def on_button_up(self, event_data, *args, **kwargs):
        print("BUTTON UP")
        print(event_data)
    
if __name__ == "__main__":
    game = Game()
    game.run()