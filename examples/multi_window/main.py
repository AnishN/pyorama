import pyorama
from pyorama import app
from pyorama.math import *
from pyorama.data import *
from pyorama.event import *
from pyorama.graphics import *

def on_window_event(event):
    global num_windows
    if event["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
        window = Window()
        window.load_from_id(event["window_id"])
        window.delete()
        num_windows -= 1
        if num_windows == 0:
            app.trigger_quit()

def on_enter_frame_event(event):
    for view in views:
        view.touch()

windows = []
frame_buffers = []
views = []
num_windows = 3

init_params = [
    (550, 400, b"RED!"),
    (550, 400, b"GREEN!"),
    (550, 400, b"BLUE!"),
]

clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH
clear_colors = [0xFF0000FF, 0x00FF00FF, 0x0000FFFF]
clear_depth = 1.0
clear_stencil = 0

app.init()

for i in range(num_windows):
    width, height, title = init_params[i]
    clear_color = clear_colors[i]
    window = Window.init_create(width, height, title)
    frame_buffer = FrameBuffer.init_create_from_window(window)
    view = View.init_create()
    view.set_frame_buffer(frame_buffer)
    view.set_clear(clear_flags, clear_color, clear_depth, clear_stencil)
    view.set_rect(0, 0, width, height)
    windows.append(window)
    frame_buffers.append(frame_buffer)
    views.append(view)

on_enter_frame_listener = Listener.init_create(EventType._ENTER_FRAME, on_enter_frame_event)
on_window_listener = Listener.init_create(EventType._WINDOW, on_window_event)

app.run()

on_window_listener.delete()
on_enter_frame_listener.delete()
for frame_buffer in frame_buffers:
    frame_buffer.delete()
for view in views:
    view.delete()
app.quit()