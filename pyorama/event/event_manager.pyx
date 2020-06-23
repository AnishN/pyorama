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

    def __dealloc__(self):
        self.timestamp = 0.0
        self.listener_keys = None
        cdef:
            size_t i
            ItemVector values
            PyObject *values_ptr
        for i in range(MAX_EVENT_TYPES):
            values_ptr = self.listeners[i]
            Py_XDECREF(values_ptr)
            values = <ItemVector>values_ptr
            values = None

    cdef ListenerKeyC *key_get_ptr(self, Handle listener) except *:
        return <ListenerKeyC *>self.listener_keys.c_get_ptr(listener)

    cdef ListenerC *listener_get_ptr(self, Handle listener) except *:
        cdef:
            ListenerKeyC *key_ptr
            ListenerC *listener_ptr
            PyObject *values_ptr
        key_ptr = self.key_get_ptr(listener)
        values_ptr = self.listeners[key_ptr.event_type]
        listener_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(key_ptr.index)
        return listener_ptr

    cpdef Handle listener_create(self, uint16_t event_type, object callback, list args=[], dict kwargs={}) except *:
        cdef:
            Handle listener
            ListenerKeyC *key_ptr
            PyObject *values_ptr
            ListenerC *listener_ptr
            PyObject *callback_ptr
            PyObject *args_ptr
            PyObject *kwargs_ptr
        listener = self.listener_keys.c_create()
        key_ptr = self.key_get_ptr(listener)
        key_ptr.event_type = event_type
        values_ptr = self.listeners[key_ptr.event_type]
        key_ptr.index = (<ItemVector>values_ptr).num_items

        listener_ptr = self.listener_get_ptr(listener)
        callback_ptr = <PyObject *>callback
        args_ptr = <PyObject *>args
        kwargs_ptr = <PyObject *>kwargs
        Py_XINCREF(callback_ptr)
        Py_XINCREF(args_ptr)
        Py_XINCREF(kwargs_ptr)
        listener_ptr.callback = callback_ptr
        listener_ptr.args = args_ptr
        listener_ptr.kwargs = kwargs_ptr
        (<ItemVector>values_ptr).c_push(listener_ptr)
        return listener
        
    cpdef void listener_delete(self, Handle listener) except *:
        cdef:
            ListenerKeyC *key_ptr
            PyObject *values_ptr
            size_t i
        key_ptr = self.key_get_ptr(listener)
        values_ptr = self.listeners[key_ptr.event_type]
        (<ItemVector>values_ptr).c_remove_empty(key_ptr.index)
        #shift logic (for index in keys coming after)
        for i in range(key_ptr.index, (<ItemVector>values_ptr).num_items):
            key_ptr = <ListenerKeyC *>(<ItemVector>values_ptr).c_get_ptr(i)
            key_ptr.index -= 1

        listener_ptr = self.listener_get_ptr(listener)
        Py_XDECREF(listener_ptr.callback)
        Py_XDECREF(listener_ptr.args)
        Py_XDECREF(listener_ptr.kwargs)
        self.listener_keys.c_delete(listener)
    
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
            if event.type == SDL_WINDOWEVENT:
                event_data = self.parse_window_event(event.window)
            elif event.type in (SDL_KEYDOWN, SDL_KEYUP):
                event_data = self.parse_keyboard_event(event.key)
            elif event.type in (SDL_MOUSEBUTTONDOWN, SDL_MOUSEBUTTONUP):
                event_data = self.parse_mouse_button_event(event.button)
            elif event.type == SDL_MOUSEMOTION:
                event_data = self.parse_mouse_motion_event(event.motion)
            elif event.type == SDL_MOUSEWHEEL:
                event_data = self.parse_mouse_wheel_event(event.wheel)
            elif event.type >= SDL_USEREVENT + 0:
                is_user_event = True
                event_data = self.parse_user_event(event.user)
            else:
                ignore_event = True
            if not ignore_event:
                values_ptr = self.listeners[event.type]
                for i in range((<ItemVector>values_ptr).num_items):
                    listener_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(i)
                    callback = <object>listener_ptr.callback
                    args = <list>listener_ptr.args
                    kwargs = <dict>listener_ptr.kwargs
                    callback(event_data, *args, **kwargs)