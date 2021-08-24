import pyorama

def on_enter_frame_event(event, *args, **kwargs):
    pyorama.graphics.view_set_clear(view, clear_flags, clear_color, clear_depth, clear_stencil)
    pyorama.graphics.view_set_rect(view, 0, 0, width, height)
    pyorama.graphics.view_set_frame_buffer(view, frame_buffer)
    pyorama.graphics.view_touch(view)

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
window = pyorama.graphics.window_create(width, height, title)
frame_buffer = pyorama.graphics.frame_buffer_create_from_window(window)
view = pyorama.graphics.view_create()

on_enter_frame_listener = pyorama.event.listener_create(
    pyorama.event.EVENT_TYPE_ENTER_FRAME,
    on_enter_frame_event, None, None,
)
on_window_listener = pyorama.event.listener_create(
    pyorama.event.EVENT_TYPE_WINDOW,
    on_window_event, None, None,
)
pyorama.app.run()
pyorama.event.listener_delete(on_enter_frame_listener)

pyorama.graphics.view_delete(view)
pyorama.graphics.frame_buffer_delete(frame_buffer)
pyorama.graphics.window_delete(window)
pyorama.app.quit()