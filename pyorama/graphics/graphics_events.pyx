cdef void c_window_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data  = <dict>event_data_ptr
        SDL_WindowEvent event = event_ptr.window
    
    event_data["type"] = event.type
    event_data["sub_type"] = event.event
    #event_data["timestamp"] = self.timestamp
    event_data["window_id"] = event.windowID
    if event.event == SDL_WINDOWEVENT_MOVED:
        event_data["x"] = event.data1
        event_data["y"] = event.data2
    elif event.event == SDL_WINDOWEVENT_RESIZED or event.event == SDL_WINDOWEVENT_SIZE_CHANGED:
        event_data["width"] = event.data1
        event_data["height"] = event.data2

cdef void c_enter_frame_event(uint16_t event_type, SDL_Event *event_ptr, PyObject *event_data_ptr) except *:
    cdef:
        dict event_data  = <dict>event_data_ptr
        SDL_UserEvent event = event_ptr.user

    event_data["type"] = event.type,
    #event_data["timestamp"] = self.timestamp
    event_data["data"] = <dict>event.data1
    Py_XDECREF(<PyObject *>event.data1)