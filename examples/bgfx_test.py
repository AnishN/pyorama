from pyorama import app
from pyorama.graphics.frame_buffer import *
from pyorama.graphics.view import *
from pyorama.graphics.window import *

app.init()

red_window = Window()
red_window.create(550, 400, b"RED!")

green_window = Window()
green_window.create(550, 400, b"GREEN!")

blue_window = Window()
blue_window.create(550, 400, b"BLUE!")

windows = [red_window, green_window, blue_window]
colors = [0xFF0000FF, 0x00FF00FF, 0x0000FFFF]

fbo = FrameBuffer()
for i in range(len(windows)):
    window = windows[i]
    window.get_frame_buffer(fbo)
    view = View()
    view.create()
    view.set_frame_buffer(fbo)
    view.set_clear(VIEW_CLEAR_COLOR, colors[i], 0.0, 1.0)
    view.set_rect(0, 0, 550, 400)

app.update()
app.quit()