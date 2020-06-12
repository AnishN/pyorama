import sys
from pyorama.core.app import App
from pyorama.graphics import GraphicsManager
from pyorama.graphics.window import Window

class Game(App):

    def init(self):
        self.graphics = GraphicsManager()
        self.window = Window(self.graphics)

    def update(self, delta):
        print(delta)
        sys.exit()

if __name__ == "__main__":
    game = Game()
    game.run()