from pyorama.app cimport *

cdef void c_joystick_axis_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data  = <dict>event_data_ptr
        SDL_JoyAxisEvent event = event_ptr.jaxis
    
    event_data["type"] = event.type
    #event_data["timestamp"] = self.timestamp
    event_data["which"] = event.which
    event_data["axis"] = event.axis
    event_data["value"] = event.value

cdef void c_joystick_ball_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data  = <dict>event_data_ptr
        SDL_JoyBallEvent event = event_ptr.jball
    
    event_data["type"] = event.type
    #event_data["timestamp"] = self.timestamp
    event_data["which"] = event.which
    event_data["ball"] = event.ball
    event_data["x"] = event.xrel
    event_data["y"] = event.yrel

cdef void c_joystick_hat_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data  = <dict>event_data_ptr
        SDL_JoyHatEvent event = event_ptr.jhat
    
    event_data["type"] = event.type
    #event_data["timestamp"] = self.timestamp
    event_data["which"] = event.which
    event_data["hat"] = event.hat
    event_data["value"] = <JoystickHat>event.value

cdef void c_joystick_button_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data  = <dict>event_data_ptr
        SDL_JoyButtonEvent event = event_ptr.jbutton
    
    event_data["type"] = event.type
    #event_data["timestamp"] = self.timestamp
    event_data["which"] = event.which
    event_data["button"] = event.button
    event_data["state"] = <JoystickButtonState>event.state

cdef void c_joystick_device_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data  = <dict>event_data_ptr
        SDL_JoyDeviceEvent event = event_ptr.jdevice
        SDL_Joystick *joy
        
    event_data["type"] = event.type
    #event_data["timestamp"] = self.timestamp
    event_data["which"] = event.which

    if event.type == EVENT_TYPE_JOYSTICK_ADDED:
        if event.which > 65536:
            raise ValueError("EventManager: cannot support more than 65536 joysticks at once")
        SDL_NumJoysticks()
        joy = SDL_JoystickOpen(event.which)
        app.event.joysticks[event.which] = joy
    elif event.type == EVENT_TYPE_JOYSTICK_REMOVED:
        joy = app.event.joysticks[event.which]
        SDL_JoystickClose(joy)
        app.event.joysticks[event.which] = NULL

cdef void c_keyboard_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data = <dict>event_data_ptr
        SDL_KeyboardEvent event = event_ptr.key
    
    event_data["type"] = event.type
    #event_data["timestamp"] = self.timestamp
    event_data["window_id"] = event.windowID
    event_data["which"] = event.which
    event_data["state"] = event.state
    event_data["repeat"] = event.repeat
    event_data["scancode"] = event.keysym.scancode
    event_data["keycode"] = event.keysym.sym
    event_data["modifiers"] = event.keysym.mod

cdef void c_mouse_button_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data = <dict>event_data_ptr
        SDL_MouseButtonEvent event = event_ptr.button

    event_data["type"] = event.type
    #event_data["timestamp"] = self.timestamp
    event_data["window_id"] = event.windowID
    event_data["which"] = event.which
    event_data["button"] = event.button
    event_data["state"] = event.state
    event_data["clicks"] = event.clicks
    event_data["x"] = event.x
    event_data["y"] = event.y

cdef void c_mouse_motion_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data = <dict>event_data_ptr
        SDL_MouseMotionEvent event = event_ptr.motion

    event_data["type"] = event.type
    #event_data["timestamp"] = self.timestamp
    event_data["window_id"] = event.windowID
    event_data["which"] = event.which
    event_data["state"] = event.state
    event_data["x"] = event.x
    event_data["y"] = event.y
    event_data["relative_x"] = event.xrel
    event_data["relative_y"] = event.yrel

cdef void c_mouse_wheel_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data = <dict>event_data_ptr
        SDL_MouseWheelEvent event = event_ptr.wheel

    event_data["type"] = event.type
    #event_data["timestamp"] = self.timestamp
    event_data["window_id"] = event.windowID
    event_data["which"] = event.which
    event_data["x"] = event.x
    event_data["y"] = event.y
    event_data["flipped"] = True if event.direction == SDL_MOUSEWHEEL_FLIPPED else False