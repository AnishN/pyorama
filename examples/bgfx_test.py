from pyorama import app
from pyorama.event.event_system import *
from pyorama.event.listener import *
from pyorama.graphics.frame_buffer import *
from pyorama.graphics.view import *
from pyorama.graphics.window import *

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == WINDOW_EVENT_TYPE_CLOSE:
        print(event, args, kwargs)
        window_id = event["window_id"]
        window = Window()
        window.load_from_id(window_id)
        window.delete()

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

red_window = Window()
red_window.create(550, 400, b"RED!")

green_window = Window()
green_window.create(550, 400, b"GREEN!")

blue_window = Window()
blue_window.create(550, 400, b"BLUE!")
print("created windows")

windows = [red_window, green_window, blue_window]
colors = [0xFF0000FF, 0x00FF00FF, 0x0000FFFF]
print("python code init end")

fbo = FrameBuffer()
for i in range(len(windows)):
    window = windows[i]
    window.get_frame_buffer(fbo)
    view = View()
    view.create()
    view.set_frame_buffer(fbo)
    view.set_clear(VIEW_CLEAR_COLOR, colors[i], 0.0, 1.0)
    view.set_rect(0, 0, 550, 400)

app.run()
app.quit()