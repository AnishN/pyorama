import glob
import time
from pyorama.core.app import *
from pyorama.graphics.graphics_manager import *
from pyorama.graphics.gltf_loader import *

class Game(App):
        
    def init(self):
        super().init()
        self.prev_time = time.time()
        self.curr_time = self.prev_time
        
    def quit(self):
        super().quit()

    def update(self):
        self.curr_time = time.time()
        print(self.curr_time - self.prev_time)
        self.prev_time = self.curr_time

#game = Game(use_sleep=True, use_vsync=False, ms_per_update=1000.0/60.0)
graphics = GraphicsManager()
gltf = GLTFLoader()
#gltf.load_gltf_json_file("./models/glTF-Sample-Models/2.0/Triangle/glTF/Triangle.gltf", graphics)

gltf_base_path = "./models/glTF-Sample-Models/2.0/*/glTF/*.gltf"
gltf_file_paths = sorted(glob.glob(gltf_base_path))
for gltf_path in gltf_file_paths:
    print(gltf_path)
    gltf.load_gltf_json_file(gltf_path, graphics)