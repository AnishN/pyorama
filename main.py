import time
import numpy as np
from pyorama.core.app import *
from pyorama.core.system import *
from pyorama.core.world import *

class EnemySystem(System):

    def init(self):
        pass
        
    def quit(self):
        pass
    
    def update(self):
        COMP_GROUP = self.comp_group_types["test"]
        comp_types = self.world.get_comp_group(COMP_GROUP)
        comp_data = self.world.get_comp_group_data(COMP_GROUP)
        #print(id(self.world), COMP_GROUP, comp_types)
        matches = np.asarray(comp_data)
        for i in range(matches.shape[0]):
            pass

class Game(App):
        
    def init(self):
        MAX_ENTITIES = 100000
        COMP_A = 5
        COMP_B = 17
        COMP_GROUP = 123
        
        super().init()
        self.world = World()
        self.world.init(MAX_ENTITIES)

        self.world.register_comp_type(COMP_A, 1000, 32, b"4Q")
        self.world.register_comp_type(COMP_B, 1000, 8, b"Q")

        self.world.register_comp_group_type(COMP_GROUP, [COMP_A, COMP_B])

        ent_a = self.world.create_entity()
        ent_b = self.world.create_entity()
        ent_c = self.world.create_entity()
        self.world.delete_entity(ent_c)

        comp_a = self.world.create_comp(COMP_A)
        comp_b1 = self.world.create_comp(COMP_B)
        comp_b2 = self.world.create_comp(COMP_B)
        print(ent_a, ent_b, comp_a, comp_b1, comp_b2)

        self.world.attach_comp(ent_a, comp_a)
        self.world.attach_comp(ent_a, comp_b1)
        self.world.attach_comp(ent_b, comp_a)
        self.world.attach_comp(ent_b, comp_b2)
        
        enemy_system = EnemySystem()
        self.world.attach_system(enemy_system, {"test": COMP_GROUP})
        self.world.set_system_update_order([enemy_system])
        
    def quit(self):
        super().quit()

    def update(self):
        start = time.time()
        self.world.update()
        end = time.time()
        print(end - start)

game = Game(use_sleep=True, use_vsync=False, ms_per_update=1000.0/60.0)
#game = Game()
game.run()