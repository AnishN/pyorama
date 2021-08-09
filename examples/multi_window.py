from pyorama import app
from pyorama.event import *
from pyorama.graphics import *

def on_window_event(event, *args, **kwargs):
    global num_windows
    if event["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
        window_id = event["window_id"]
        window = Window()
        window.load_from_id(window_id)
        window.delete()
        num_windows -= 1
        if num_windows == 0:
            app.trigger_quit()

app.init({
    #"use_sleep": True,
    "use_sleep": False,
})

args = ["a", "b", "c"]
kwargs = {
    "d": 1,
    "e": 2,
    "f": 3,
}

on_window_listener = Listener()
on_window_listener.create(EVENT_TYPE_WINDOW, on_window_event, args, kwargs)

num_windows = 3
window = Window()
colors = [0xFF0000FF, 0x00FF00FF, 0x0000FFFF]
init_params = [
    (550, 400, b"RED!"),
    (550, 400, b"GREEN!"),
    (550, 400, b"BLUE!"),
]

fbo = FrameBuffer()
for i in range(num_windows):
    width, height, title = init_params[i]
    color = colors[i]
    window.create(width, height, title)
    window.get_frame_buffer(fbo)
    view = View()
    view.create()
    view.set_frame_buffer(fbo)
    view.set_clear(VIEW_CLEAR_COLOR, color, 0.0, 1.0)
    view.set_rect(0, 0, width, height)

app.run()
app.quit()