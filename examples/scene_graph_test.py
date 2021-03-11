import random
import os
import time
from pyorama.core import *
from pyorama.event import *
from pyorama.graphics import *
from pyorama.math3d import *

class Game(App):
    
    def init(self):
        super().init()
        self.scene = Scene(self.graphics)
        self.scene.create()
        self.create_random_graph()
        #self.create_small_graph()
        os._exit(-1)

    def create_small_graph(self):
        num_nodes = 5
        nodes = []
        root = Node(self.graphics)
        self.scene.get_root_node(root)
        for i in range(num_nodes):
            node = Node(self.graphics)
            node.create_empty(NODE_TYPE_MESH)
            nodes.append(node)
        a, b, c, d, e = nodes
        print(root.handle, [node.handle for node in nodes])
        self.scene.add_child(root, a)
        self.scene.add_child(root, b)
        self.scene.add_child(root, c)
        self.scene.add_child(b, d)
        self.scene.add_child(d, e)
        print("")
        self.scene.update()
        print("")
        self.scene.remove_child(d)
        self.scene.update()

    def create_random_graph(self):
        num_nodes = 100000
        root = Node(self.graphics)
        self.scene.get_root_node(root)

        start = time.time()
        self.scene.update()
        end = time.time()
        print(end - start)

        nodes = [root]
        random_transform = Mat4()
        for i in range(num_nodes):
            random_parent = random.choice(nodes)
            child = Node(self.graphics)
            child.create_empty(NODE_TYPE_MESH)
            Mat4.random(random_transform)
            child.set_local(random_transform)
            #print(i, random_parent.handle, child.handle)
            self.scene.add_child(random_parent, child)
            nodes.append(child)

        start = time.time()
        self.scene.update()
        end = time.time()
        print(end - start)

        self.scene.remove_children(nodes[1:])

        start = time.time()
        self.scene.update()
        end = time.time()
        print(end - start)

if __name__ == "__main__":
    game = Game()
    game.run()