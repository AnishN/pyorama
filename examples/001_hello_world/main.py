import pyorama
from pyorama.event import *
from pyorama.graphics import *

def on_enter_frame_event(event, *args, **kwargs):
    view.set_clear(clear_flags, clear_color, clear_depth, clear_stencil)
    view.set_rect(0, 0, width, height)
    view.set_frame_buffer(frame_buffer)
    view.touch()

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
        pyorama.app.trigger_quit()

width = 800
height = 600
title = b"Hello, world!"
clear_flags = pyorama.graphics.VIEW_CLEAR_COLOR | pyorama.graphics.VIEW_CLEAR_DEPTH
clear_color = 0x443355FF
clear_depth = 1.0
clear_stencil = 0

pyorama.app.init()
window = Window(); window.create(width, height, title)
frame_buffer = FrameBuffer(); frame_buffer.create_from_window(window)
view = View(); view.create()
on_enter_frame_listener = Listener()
on_enter_frame_listener.create(
    pyorama.event.EVENT_TYPE_ENTER_FRAME,
    on_enter_frame_event, None, None,
)
on_window_listener = Listener()
on_window_listener.create(
    pyorama.event.EVENT_TYPE_WINDOW,
    on_window_event, None, None,
)

pyorama.app.run()

on_enter_frame_listener.delete()
on_window_listener.delete()
view.delete()
frame_buffer.delete()
window.delete()
pyorama.app.quit()