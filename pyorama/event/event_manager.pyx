cdef class EventManager:

    def __cinit__(self):
        self.timestamp = 0.0
        self.listener_keys = ItemSlotMap(sizeof(ListenerKeyC), EVENT_ITEM_TYPE_LISTENER_KEY)
        cdef:
            size_t i
            ItemVector values
            PyObject *values_ptr
        for i in range(MAX_EVENT_TYPES):
            values = ItemVector(sizeof(ListenerC))
            values_ptr = <PyObject *>values
            Py_XINCREF(values_ptr)
            self.listeners[i] = values_ptr
        for i in range(EVENT_TYPE_ENTER_FRAME):
            self.registered[i] = True
        for i in range(EVENT_TYPE_ENTER_FRAME, EVENT_TYPE_USER):
            self.registered[i] = True
            self.event_type_register()#to ensure pyorama's event types are registered
        for i in range(EVENT_TYPE_USER, MAX_EVENT_TYPES):
            self.registered[i] = False

    def __dealloc__(self):
        self.timestamp = 0.0
        cdef:
            size_t i
            ItemVector values
            PyObject *values_ptr
        for i in range(MAX_EVENT_TYPES):
            values_ptr = self.listeners[i]
            #Py_XDECREF(values_ptr)
            values = <ItemVector>values_ptr
            values = None
        self.listener_keys = None

    cpdef uint16_t event_type_register(self) except *:#TODO: ensure registration corresponds with EVENT_TYPE enums!
        cdef:
            uint32_t event_type_u32#sdl's register function returns uint32_t, even though SDL_LASTEVENT caps way before...
            uint16_t event_type
        event_type_u32 = SDL_RegisterEvents(1)
        if event_type_u32 >= MAX_EVENT_TYPES:
            raise ValueError("EventManager: cannot register any more user event types")
        event_type = <uint16_t> event_type_u32
        self.registered[event_type] = True
        return event_type

    cpdef bint event_type_check_registered(self, uint16_t event_type) except *:
        return self.registered[event_type]

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
    
    cdef ListenerKeyC *key_c_get_ptr(self, Handle listener) except *:
        return <ListenerKeyC *>self.listener_keys.c_get_ptr(listener)

    cdef ListenerC *listener_c_get_ptr(self, Handle listener) except *:
        cdef:
            ListenerKeyC *key_ptr
            ListenerC *listener_ptr
            PyObject *values_ptr
        key_ptr = self.key_c_get_ptr(listener)
        values_ptr = self.listeners[key_ptr.event_type]
        listener_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(key_ptr.index)
        return listener_ptr

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
            bint ignore_event
            PyObject *values_ptr
            ListenerC *listener_ptr
            object callback
            dict event_data
            list args
            dict kwargs
        self.timestamp = timestamp
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
                values_ptr = self.listeners[event.type]
                for i in range((<ItemVector>values_ptr).num_items):
                    listener_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(i)
                    callback = <object>listener_ptr.callback
                    args = <list>listener_ptr.args
                    kwargs = <dict>listener_ptr.kwargs
                    callback(event_data, *args, **kwargs)