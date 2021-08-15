cdef class EventSystem:

    def __cinit__(self, str name):
        cdef:
            size_t i
            Vector handles
            PyObject *handles_ptr
        
        self.name = name
        self.slots = SlotManager()
        self.slot_sizes = {
            EVENT_SLOT_LISTENER: sizeof(ListenerC),
        }
        for i in range(MAX_EVENT_TYPES):
            handles = Vector()
            handles_ptr = <PyObject *>handles
            Py_XINCREF(handles_ptr)
            self.listener_handles[i] = handles_ptr
    
    def __dealloc__(self):
        cdef:
            size_t i
            PyObject *handles_ptr
        
        for i in range(MAX_EVENT_TYPES):
            handles_ptr = <PyObject *>self.listener_handles[i]
            Py_XDECREF(handles_ptr)
            handles_ptr = NULL
        self.slot_sizes = None
        self.slots = None

    def init(self, dict config=None):
        cdef:
            size_t i
            PyObject *handles_ptr
        
        #print(self.name, "init")
        SDL_InitSubSystem(SDL_INIT_EVENTS)
        SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1")
        self.timestamp = 0.0
        self.slots.c_init(self.slot_sizes)
        for i in range(MAX_EVENT_TYPES):
            handles_ptr = <PyObject *>self.listener_handles[i]
            (<Vector>handles_ptr).c_init(sizeof(Handle))

    def quit(self):
        cdef:
            size_t i
            PyObject *handles_ptr
        
        #print(self.name, "quit")
        for i in range(MAX_EVENT_TYPES):
            handles_ptr = <PyObject *>self.listener_handles[i]
            (<Vector>handles_ptr).c_free()
        self.slots.c_free()
        SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "0")
        SDL_QuitSubSystem(SDL_INIT_EVENTS)

    cpdef void event_type_emit(self, uint16_t event_type, dict event_data={}) except *:
        cdef:
            SDL_Event event
            PyObject *event_data_ptr
        event_data_ptr = <PyObject *>event_data
        Py_XINCREF(event_data_ptr)
        memset(&event, 0, sizeof(event))
        event.type = event_type
        event.user.code = 0
        event.user.data1 = event_data_ptr
        event.user.data2 = NULL
        SDL_PushEvent(&event)#TODO: check for errors here (e.g. what if queue is full)

    cdef dict parse_joystick_axis_event(self, SDL_JoyAxisEvent event):
        cdef dict event_data = {
            "type": event.type,
            "timestamp": self.timestamp,
            "which": event.which,
            "axis": event.axis,
            "value": event.value,
        }
        return event_data

    cdef dict parse_joystick_ball_event(self, SDL_JoyBallEvent event):
        cdef dict event_data = {
            "type": event.type,
            "timestamp": self.timestamp,
            "which": event.which,
            "ball": event.ball,
            "x": event.xrel,
            "y": event.yrel,
        }
        return event_data

    cdef dict parse_joystick_hat_event(self, SDL_JoyHatEvent event):
        cdef dict event_data = {
            "type": event.type,
            "timestamp": self.timestamp,
            "which": event.which,
            "hat": event.hat,
            "value": <JoystickHat>event.value,
        }
        return event_data

    cdef dict parse_joystick_button_event(self, SDL_JoyButtonEvent event):
        cdef dict event_data = {
            "type": event.type,
            "timestamp": self.timestamp,
            "which": event.which,
            "button": event.button,
            "state": <JoystickButtonState>event.state,
        }
        return event_data

    cdef dict parse_joystick_device_event(self, SDL_JoyDeviceEvent event):
        cdef:
            dict event_data
            SDL_Joystick *joy
            
        event_data = {
            "type": event.type,
            "timestamp": self.timestamp,
            "which": event.which,
        }
        if event.type == EVENT_TYPE_JOYSTICK_ADDED:
            if event.which > 65536:
                raise ValueError("EventManager: cannot support more than 65536 joysticks at once")
            SDL_NumJoysticks()
            joy = SDL_JoystickOpen(event.which)
            self.joysticks[event.which] = joy
        elif event.type == EVENT_TYPE_JOYSTICK_REMOVED:
            joy = self.joysticks[event.which]
            SDL_JoystickClose(joy)
            self.joysticks[event.which] = NULL
        return event_data
    
    cdef dict parse_keyboard_event(self, SDL_KeyboardEvent event):
        cdef dict event_data = {
            "type": event.type,
            "timestamp": self.timestamp,
            "window_id": event.windowID,
            "state": event.state,
            "repeat": event.repeat,
            "scancode": event.keysym.scancode,
            "keycode": event.keysym.sym,
            "modifiers": event.keysym.mod,
        }
        return event_data

    cdef dict parse_mouse_button_event(self, SDL_MouseButtonEvent event):
        cdef dict event_data = {
            "type": event.type,
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

    cdef dict parse_mouse_motion_event(self, SDL_MouseMotionEvent event):
        cdef dict event_data = {
            "type": event.type,
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

    cdef dict parse_mouse_wheel_event(self, SDL_MouseWheelEvent event):
        cdef dict event_data = {
            "type": event.type,
            "timestamp": self.timestamp,
            "window_id": event.windowID,
            "which": event.which,
            "x": event.x,
            "y": event.y,
            "direction": event.direction,
        }
        return event_data
    
    cdef dict parse_user_event(self, SDL_UserEvent event):
        cdef dict event_data = {
            "type": event.type,
            "timestamp": self.timestamp,
            "data": <dict>event.data1,
        }
        Py_XDECREF(<PyObject *>event.data1)
        return event_data

    cdef dict parse_window_event(self, SDL_WindowEvent event):
        cdef dict event_data = {
            "type": event.type,
            "sub_type": event.event,
            "timestamp": self.timestamp,
            "window": graphics.window_ids.c_get(event.windowID),
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
            bint ignore_event
            dict event_data
            size_t i
            Vector listeners
            ListenerC *listener_ptr
        
        while SDL_PollEvent(&event):
            ignore_event = False
            if event.type == EVENT_TYPE_WINDOW:
                event_data = self.parse_window_event(event.window)
            elif event.type == EVENT_TYPE_JOYSTICK_AXIS:
                event_data = self.parse_joystick_axis_event(event.jaxis)
            elif event.type == EVENT_TYPE_JOYSTICK_BALL:
                event_data = self.parse_joystick_ball_event(event.jball)
            elif event.type == EVENT_TYPE_JOYSTICK_HAT:
                event_data = self.parse_joystick_hat_event(event.jhat)
            elif event.type in (EVENT_TYPE_JOYSTICK_BUTTON_DOWN, EVENT_TYPE_JOYSTICK_BUTTON_UP):
                event_data = self.parse_joystick_button_event(event.jbutton)
            elif event.type in (EVENT_TYPE_JOYSTICK_ADDED, EVENT_TYPE_JOYSTICK_REMOVED):
                event_data = self.parse_joystick_device_event(event.jdevice)
            elif event.type in (EVENT_TYPE_KEY_DOWN, EVENT_TYPE_KEY_UP):
                event_data = self.parse_keyboard_event(event.key)
            elif event.type in (EVENT_TYPE_MOUSE_BUTTON_DOWN, EVENT_TYPE_MOUSE_BUTTON_UP):
                event_data = self.parse_mouse_button_event(event.button)
            elif event.type == EVENT_TYPE_MOUSE_MOTION:
                event_data = self.parse_mouse_motion_event(event.motion)
            elif event.type == EVENT_TYPE_MOUSE_WHEEL:
                event_data = self.parse_mouse_wheel_event(event.wheel)
            elif EVENT_TYPE_ENTER_FRAME <= event.type < EVENT_TYPE_USER:#pyorama events (using SDL_UserEvent still)
                is_user_event = True
                event_data = self.parse_user_event(event.user)
            elif event.type >= EVENT_TYPE_USER:#true user events
                is_user_event = True
                event_data = self.parse_user_event(event.user)
            else:
                ignore_event = True#must be an SDL2 event I have not written a parser for
            
            if not ignore_event:
                listeners = self.slots.get_slot_map(EVENT_SLOT_LISTENER).items
                for i in range(listeners.num_items):
                    listener_ptr = <ListenerC *>listeners.c_get_ptr(i)
                    if listener_ptr.event_type == event.type:
                        callback = <object>listener_ptr.callback
                        args = <list>listener_ptr.args
                        kwargs = <dict>listener_ptr.kwargs
                        callback(event_data, *args, **kwargs)