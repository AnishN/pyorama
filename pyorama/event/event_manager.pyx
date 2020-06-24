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
        for i in range(EVENT_TYPE_ENTER_FRAME, MAX_EVENT_TYPES):
            self.registered[i] = False

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

    cpdef void event_type_emit(self, uint16_t event_type, dict event_data) except *:
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
        listener = self.listener_keys.c_create()
        key_ptr = self.key_get_ptr(listener)
        key_ptr.event_type = event_type
        values_ptr = self.listeners[key_ptr.event_type]
        key_ptr.index = (<ItemVector>values_ptr).num_items
        Py_INCREF(callback)
        Py_INCREF(args)
        Py_INCREF(kwargs)
        (<ItemVector>values_ptr).c_push_empty()
        listener_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(key_ptr.index)
        listener_ptr.key = listener
        listener_ptr.callback = <PyObject *>callback
        listener_ptr.args = <PyObject *>args
        listener_ptr.kwargs = <PyObject *>kwargs
        return listener
        
    cpdef void listener_delete(self, Handle listener) except *:
        cdef:
            ListenerKeyC *key_ptr
            PyObject *values_ptr
            ListenerC *listener_ptr
            ListenerC *value_ptr
            size_t i
            size_t key_index
        key_ptr = self.key_get_ptr(listener)
        values_ptr = self.listeners[key_ptr.event_type]
        listener_ptr = self.listener_get_ptr(listener)
        Py_XDECREF(listener_ptr.callback)
        Py_XDECREF(listener_ptr.args)
        Py_XDECREF(listener_ptr.kwargs)
        key_index = key_ptr.index

        """
        print("before")
        for i in range((<ItemVector>values_ptr).num_items):
            value_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(i)
            print(i, value_ptr.key)
        """
        #print("removing index", key_index)
        (<ItemVector>values_ptr).c_remove_empty(key_index)
        #print(key_index)
        for i in range(key_index, (<ItemVector>values_ptr).num_items):
            value_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(i)
            key_ptr = <ListenerKeyC *>self.key_get_ptr(value_ptr.key)
            key_ptr.index -= 1
            #print(i, "deleted vector value with key", value_ptr.key)
        self.listener_keys.c_delete(listener)
        """
        print("after")
        for i in range((<ItemVector>values_ptr).num_items):
            value_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(i)
            print(i, value_ptr.key)
        print("deleted listener", listener, (<ItemVector>values_ptr).num_items)
        print(self.listener_keys.items.num_items)
        """
    
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
                #print("process", event_data)
                for i in range((<ItemVector>values_ptr).num_items):
                    listener_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(i)
                    """
                    print(
                        event.type, i,
                        listener_ptr.key, 
                        <uintptr_t>listener_ptr.callback, 
                        <uintptr_t>listener_ptr.args, 
                        <uintptr_t>listener_ptr.kwargs,
                    )
                    """
                    callback = <object>listener_ptr.callback
                    args = <list>listener_ptr.args
                    kwargs = <dict>listener_ptr.kwargs
                    callback(event_data, *args, **kwargs)