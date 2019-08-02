import time
import numpy as np
from pyorama.core.app import *
from pyorama.core.system import *
from pyorama.core.world import *

"""
GraphicsMeshComp:
GraphicsMaterialComp:

graphics_mesh_init(
graphics_mesh_free(
graphics_mesh_set_vertices(
graphics_mesh_update(

graphics_material_init(
graphics_material_free(

AudioDataComp:
AudioSourceComp:
AudioListenerComp:

PhysicsBodyComp:
PhysicsSpaceComp:

InputKeyboardComp:
InputMouseComp:
InputControllerComp:

cdef class EventSystem:
    pass

cdef class GraphicsSystem:
    pass

cdef class AudioSystem:
    pass

Inter-system communication needs to happen via a pub-sub organization of event data.
#self.system.sub_to_event(
#self.system.unsub_to_event(

I really do need a pool implementation, with returned handles.
Will likely have to modify my handle class to distinguish between pool handles and comp handles.
These pools are then owned by managers that belong to a particular App object.
Should I use PyCapsules to store pointers to pass to python, or cdef class objects?
The latter should be faster (could even create a Pointer class to wrap!).
Use integers to type compare...
Perhaps comp types and pool pointer types should be registered at the App level...

But really, a memory pool SlotMap is just like a CompMap!
The difference is that they could be non-fixed size or fixed-size.
ResourceID
CompID
EntityID

cdef uint64_t NUM_INDEX_BITS = 24
cdef uint64_t NUM_VERSION_BITS = 23
cdef uint64_t NUM_TYPE_BITS = 8
cdef uint64_t NUM_FREE_BITS = 1
cdef uint64_t NUM_META_BITS = 8
This a reasonble compromise, but I hate losing type-safety checks on ranges...
But realistically, no parts of the ECS need to be concerned with this outside of pools and slotmaps.
Also would rather reserve more type bits..., But I hate the lack of type safety...

Should reserve some extra bits to tell these all apart.
Maybe just a uint8_t at the front - should not need to bitmask this out...
And the "Managers" that own the memory that the ResourceID points to should have NO NOTION OF THE ECS!!!
And need to distinguish between fixed-sized pools and variable-sized pools.
Otherwise, how to malloc within these pools?
"""

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