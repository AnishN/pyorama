from pyorama.core.app import *
from pyorama.math3d.vec2 import *
from pyorama.physics.physics_manager import *

"""
class Game(App):
    
    def init(self):
        super().init()

        self.space = self.physics.space_create()
        self.physics.space_set_gravity(self.space, Vec2())
        self.bodies = []

        piece_mass = 1.0
        piece_moment = 100
        n = 19
        for i in range(n):
            body = self.physics.body_create(piece_mass, piece_moment)
            self.physics.space_add_body(self.space, body)
            self.bodies.append(body)
        print(self.bodies)

    def quit(self):
        super().quit()

if __name__ == "__main__":
    game = Game()
    #game.run()
    game.init()
    game.physics.update(1/60.0)
"""

physics = PhysicsManager()
space = physics.space_create()
bodies = []

piece_mass = 1.0
piece_moment = 100
n = 1000000
for i in range(n):
    body = physics.body_create(piece_mass, piece_moment)
    physics.space_add_body(space, body)
    bodies.append(body)
#print(bodies)
physics.update(1/60.0)