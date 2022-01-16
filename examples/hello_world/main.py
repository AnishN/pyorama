import pyorama
from pyorama import app
from pyorama.math import *
from pyorama.data import *
from pyorama.event import *
from pyorama.graphics import *

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
        app.trigger_quit()

width = 800
height = 600
title = b"Hello, world!"
clear_flags = VIEW_CLEAR_COLOR | VIEW_CLEAR_DEPTH
clear_color = 0x443355FF
clear_depth = 1.0
clear_stencil = 0

app.init()
window = Window.init_create(width, height, title)
frame_buffer = FrameBuffer.init_create_from_window(window)
view = View.init_create()
view.set_clear(clear_flags, clear_color, clear_depth, clear_stencil)
view.set_rect(0, 0, width, height)
view.set_frame_buffer(frame_buffer)
view.touch()

on_window_listener = Listener.init_create(EVENT_TYPE_WINDOW, on_window_event)

app.run()

on_window_listener.delete()
view.delete()
frame_buffer.delete()
window.delete()
app.quit()