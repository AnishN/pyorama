import pyorama

def on_window_event(event, *args, **kwargs):
    global num_windows
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
        window = event["window"]
        pyorama.graphics.window_delete(window)
        num_windows -= 1
        if num_windows == 0:
            pyorama.app.trigger_quit()

def on_enter_frame_event(event, *args, **kwargs):
    for view in views:
        pyorama.graphics.view_touch(view)

pyorama.app.init({
    #"use_sleep": True,
    "use_sleep": False,
})

args = ["a", "b", "c"]
kwargs = {
    "d": 1,
    "e": 2,
    "f": 3,
}

on_window_listener = pyorama.event.listener_create(
    pyorama.event.EVENT_TYPE_WINDOW, 
    on_window_event, None, None,
)

on_enter_frame_listener = pyorama.event.listener_create(
    pyorama.event.EVENT_TYPE_ENTER_FRAME,
    on_enter_frame_event, None, None,
)

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
    window = pyorama.graphics.window_create(width, height, title)
    #pyorama.graphics.window_set_flags(window, pyorama.graphics.WINDOW_FLAGS_BORDERLESS)
    #print(pyorama.graphics.window_is_borderless(window))
    #pyorama.graphics.window_set_maximized(window)
    #pyorama.graphics.window_toggle_maximized(window)
    frame_buffer = pyorama.graphics.frame_buffer_create_from_window(window)
    view = pyorama.graphics.view_create()
    pyorama.graphics.view_set_frame_buffer(view, frame_buffer)
    pyorama.graphics.view_set_clear(view, pyorama.graphics.VIEW_CLEAR_COLOR, color, 0.0, 1.0)
    pyorama.graphics.view_set_rect(view, 0, 0, width, height)
    windows.append(window)
    frame_buffers.append(frame_buffer)
    views.append(view)

pyorama.app.run()

for frame_buffer in frame_buffers:
    pyorama.graphics.frame_buffer_delete(frame_buffer)
for view in views:
    pyorama.graphics.view_delete(view)
pyorama.event.listener_delete(on_window_listener)
pyorama.event.listener_delete(on_enter_frame_listener)

pyorama.app.quit()