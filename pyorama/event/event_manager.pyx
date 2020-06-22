cdef class EventManager:

    def __cinit__(self):
        self.timestamp = 0.0

    def __dealloc__(self):
        self.timestamp = 0.0
    
    cdef dict parse_keyboard_event(self, SDL_KeyboardEvent keyboard_event):
        cdef SDL_KeyboardEvent event = keyboard_event
        #cdef str event_type = self.ids_types[event.type]
        cdef dict event_data = {
            #"type": event_type,
            "timestamp": self.timestamp,
            "window_id": event.windowID,
            "state": event.state,
            "repeat": event.repeat,
            "scancode": event.keysym.scancode,
            "keycode": event.keysym.sym,
            "modifiers": event.keysym.mod,
        }
        return event_data
        
    cdef dict parse_mouse_button_event(self, SDL_MouseButtonEvent mouse_button_event):
        cdef SDL_MouseButtonEvent event = mouse_button_event
        #cdef str event_type = self.ids_types[event.type]
        cdef dict event_data = {
            #"type": event_type,
            "timestamp": self.timestamp,
            "window_id": event.windowID,
            "which": event.which,
            "button": event.button,
            "state": event.state,
            "clicks": event.clicks,
            "x": event.x,
            "y": event.y,
        }
        return event_data
        
    cdef dict parse_mouse_motion_event(self, SDL_MouseMotionEvent mouse_motion_event):
        cdef SDL_MouseMotionEvent event = mouse_motion_event
        #cdef str event_type = self.ids_types[event.type]
        cdef dict event_data = {
            #"type": event_type,
            "timestamp": self.timestamp,
            "window_id": event.windowID,
            "which": event.which,
            "state": event.state,
            "x": event.x,
            "y": event.y,
            "relative_x": event.xrel,
            "relative_y": event.yrel,
        }
        return event_data
    
    cdef dict parse_mouse_wheel_event(self, SDL_MouseWheelEvent mouse_wheel_event):
        cdef SDL_MouseWheelEvent event = mouse_wheel_event
        #cdef str event_type = self.ids_types[event.type]
        cdef dict event_data = {
            #"type": event_type,
            "timestamp": self.timestamp,
            "window_id": event.windowID,
            "which": event.which,
            "x": event.x,
            "y": event.y,
            "direction": event.direction,
        }
        return event_data
    
    
    cdef dict parse_user_event(self, SDL_UserEvent user_event):
        cdef SDL_UserEvent event = user_event
        #cdef str event_type = self.ids_types[event.type]
        cdef dict event_data = {
            #"type": event_type,
            "timestamp": self.timestamp,
            "data": <dict>event.data1,
        }
        return event_data
        
    cdef dict parse_window_event(self, SDL_WindowEvent window_event):
        cdef SDL_WindowEvent event = window_event
        cdef dict event_data = {
            #"type": "window",
            "sub_type": event.event,
            "timestamp": self.timestamp,
            "window_id": event.windowID,
        }
        if event.event == SDL_WINDOWEVENT_MOVED:
            event_data["x"] = event.data1
            event_data["y"] = event.data2
        elif event.event == SDL_WINDOWEVENT_RESIZED or event.event == SDL_WINDOWEVENT_SIZE_CHANGED:
            event_data["width"] = event.data1
            event_data["height"] = event.data2
        return event_data

    cpdef void update(self, double timestamp) except *:
        cdef:
            SDL_Event event
            dict out = {}
        self.timestamp = timestamp
        while SDL_PollEvent(&event):
            if event.type == SDL_WINDOWEVENT:
                out = self.parse_window_event(event.window)
            elif event.type in (SDL_KEYDOWN, SDL_KEYUP):
                out = self.parse_keyboard_event(event.key)
            elif event.type in (SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP):
                out = self.parse_mouse_button_event(event.button)
            elif event.type == SDL_MOUSEMOTION:
                out = self.parse_mouse_motion_event(event.motion)
            elif event.type == SDL_MOUSEWHEEL:
                out = self.parse_mouse_wheel_event(event.wheel)
            elif event.type >= SDL_USEREVENT + 0:
                is_user_event = True
                out = self.parse_user_event(event.user)
            print(out)