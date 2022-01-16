import pyorama
from pyorama.graphics import *
from pyorama.event import *
from pyorama.asset import *

def on_window_event(event, *args, **kwargs):
    global num_windows
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
        window = Window()
        window.load_from_id(event["window_id"])
        window.delete()
        num_windows -= 1
        if num_windows == 0:
            pyorama.app.trigger_quit()

def on_enter_frame_event(event, *args, **kwargs):
    for view in views:
        view.touch()

pyorama.app.init()

windows = []
frame_buffers = []
views = []
num_windows = 3
colors = [0xFF0000FF, 0x00FF00FF, 0x0000FFFF]
init_params = [
    (550, 400, b"RED!"),
    (550, 400, b"GREEN!"),
    (550, 400, b"BLUE!"),
]

for i in range(num_windows):
    width, height, title = init_params[i]
    color = colors[i]
    window = Window(); window.create(width, height, title)
    frame_buffer = FrameBuffer(); frame_buffer.create_from_window(window)
    view = View(); view.create()
    view.set_frame_buffer(frame_buffer)
    view.set_clear(pyorama.graphics.VIEW_CLEAR_COLOR, color, 0.0, 1.0)
    view.set_rect(0, 0, width, height)
    windows.append(window)
    frame_buffers.append(frame_buffer)
    views.append(view)

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

on_window_listener.delete()
on_enter_frame_listener.delete()
for frame_buffer in frame_buffers:
    frame_buffer.delete()
for view in views:
    view.delete()
pyorama.app.quit()