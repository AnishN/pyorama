import time

cdef object INVALID_USER_EVENT_TYPE_ERROR = ValueError("UserEventType: invalid value")

cdef class EventManager:

    def __cinit__(self):
        self.listeners = ItemSlotMap(sizeof(ListenerC), ITEM_TYPE_LISTENER)
        self.listener_map = {
            EVENT_TYPE_WINDOW: ItemVector(sizeof(Handle)),
            EVENT_TYPE_KEY_DOWN: ItemVector(sizeof(Handle)),
            EVENT_TYPE_KEY_UP: ItemVector(sizeof(Handle)),
            EVENT_TYPE_MOUSE_BUTTON_DOWN: ItemVector(sizeof(Handle)),
            EVENT_TYPE_MOUSE_BUTTON_UP: ItemVector(sizeof(Handle)),
            EVENT_TYPE_MOUSE_MOTION: ItemVector(sizeof(Handle)),
            EVENT_TYPE_MOUSE_WHEEL: ItemVector(sizeof(Handle)),
        }
        self.num_user_event_types = 0
        self.free_user_event_types = ItemVector(sizeof(EventType))
    
    def __dealloc__(self):
        self.listener_map = None

    def user_event_type_create(self):
        cdef EventType event_type
        if self.free_user_event_types.num_items > 0:
            self.free_user_event_types.c_pop(&event_type)
        else:
            event_type = EVENT_TYPE_USER + self.num_user_event_types
        self.listener_map[event_type] = ItemVector(sizeof(Handle))
        self.num_user_event_types += 1
        return event_type

    def user_event_type_delete(self, EventType event_type):
        self.c_check_user_event_type(event_type)
        del self.listener_map[event_type]
        self.free_user_event_types.c_push(&event_type)
        self.num_user_event_types -= 1

    cdef void c_check_user_event_type(self, EventType event_type) except *:
        if event_type not in self.listener_map:
            raise INVALID_USER_EVENT_TYPE_ERROR
        elif event_type < EVENT_TYPE_USER:
            raise INVALID_USER_EVENT_TYPE_ERROR
    
    def user_event_type_emit(self, EventType event_type, dict event_data=None):
        cdef SDL_Event event
        self.c_check_user_event_type(event_type)
        event.type = event_type
        event.user.data1 = <PyObject *>event_data
        Py_XINCREF(<PyObject *>event.user.data1)
        SDL_PushEvent(&event)
    
    #Listener
    cdef ListenerC *c_listener_get_ptr(self, Handle listener) except *:
        return <ListenerC *>self.listeners.c_get_ptr(listener)

    def listener_create(self, EventTypes event_type, object callback, dict user_data):
        cdef:
            Handle listener
            ListenerC *listener_ptr
            size_t index
            ItemVector listeners
        listener = self.listeners.c_create()
        listener_ptr = self.c_listener_get_ptr(listener)
        listeners = <ItemVector>(self.listener_map[event_type])
        listener_ptr.event_type = event_type
        listener_ptr.index = listeners.num_items
        listener_ptr.callback = <PyObject *>callback
        listener_ptr.user_data = <PyObject *>user_data
        Py_XINCREF(<PyObject *>callback)
        Py_XINCREF(<PyObject *>user_data)
        listeners.c_push(&listener)
        return listener

    def listener_delete(self, Handle listener):
        cdef:
            ListenerC *listener_ptr
            size_t index
            ItemVector listeners

        listener_ptr = self.c_listener_get_ptr(listener)
        listeners = <ItemVector>(self.listener_map[listener_ptr.event_type])
        listener_ptr.event_type = EVENT_TYPE_NONE
        index = listener_ptr.index
        listener_ptr.index = 0
        Py_XDECREF(listener_ptr.callback)
        Py_XDECREF(listener_ptr.user_data)
        listener_ptr.callback = NULL
        listener_ptr.user_data = NULL
        listeners.c_remove_empty(index)
        self.listeners.c_delete(listener)
    
    cdef dict c_parse_window_event(self, SDL_WindowEvent *event, double time_stamp):
        cdef dict event_data = {
            "type": EVENT_TYPE_WINDOW,
            "sub_type": <WindowEventTypes>event.event,
            "timestamp": time_stamp,
            "window_id": event.windowID,
        }
        if event.event == SDL_WINDOWEVENT_MOVED:
            event_data["x"] = event.data1
            event_data["y"] = event.data2
        elif event.event == SDL_WINDOWEVENT_RESIZED or event.event == SDL_WINDOWEVENT_SIZE_CHANGED:
            event_data["width"] = event.data1
            event_data["height"] = event.data2
        return event_data

    cdef dict c_parse_key_down_event(self, SDL_KeyboardEvent *event, double time_stamp):
        cdef dict event_data = {
            "type": EVENT_TYPE_KEY_DOWN,
            "time_stamp": time_stamp,
            "window_id": event.windowID,
            "state": event.state,
            "repeat": event.repeat,
            "scan_code": event.keysym.scancode,
            "key_code": event.keysym.sym,
            "modifiers": event.keysym.mod,
        }
        return event_data

    cdef dict c_parse_key_up_event(self, SDL_KeyboardEvent *event, double time_stamp):
        cdef dict event_data = {
            "type": EVENT_TYPE_KEY_UP,
            "time_stamp": time_stamp,
            "window_id": event.windowID,
            "state": event.state,
            "repeat": event.repeat,
            "scan_code": event.keysym.scancode,
            "key_code": event.keysym.sym,
            "modifiers": event.keysym.mod,
        }
        return event_data

    cdef dict c_parse_mouse_button_down_event(self, SDL_MouseButtonEvent *event, double time_stamp):
        cdef dict event_data = {
            "type": EVENT_TYPE_MOUSE_BUTTON_DOWN,
            "time_stamp": time_stamp,
            "window_id": event.windowID,
            "which": event.which,
            "button": event.button,
            "state": event.state,
            "clicks": event.clicks,
            "x": event.x,
            "y": event.y,
        }
        return event_data

    cdef dict c_parse_mouse_button_up_event(self, SDL_MouseButtonEvent *event, double time_stamp):
        cdef dict event_data = {
            "type": EVENT_TYPE_MOUSE_BUTTON_UP,
            "time_stamp": time_stamp,
            "window_id": event.windowID,
            "which": event.which,
            "button": event.button,
            "state": event.state,
            "clicks": event.clicks,
            "x": event.x,
            "y": event.y,
        }
        return event_data

    cdef dict c_parse_mouse_motion_event(self, SDL_MouseMotionEvent *event, double time_stamp):
        cdef dict event_data = {
            "type": EVENT_TYPE_MOUSE_MOTION,
            "time_stamp": time_stamp,
            "window_id": event.windowID,
            "which": event.which,
            "state": event.state,
            "x": event.x,
            "y": event.y,
            "relative_x": event.xrel,
            "relative_y": event.yrel,
        }
        return event_data

    cdef dict c_parse_mouse_wheel_event(self, SDL_MouseWheelEvent *event, double time_stamp):
        cdef dict event_data = {
            "type": EVENT_TYPE_MOUSE_WHEEL,
            "time_stamp": time_stamp,
            "window_id": event.windowID,
            "which": event.which,
            "x": event.x,
            "y": event.y,
            "direction": event.direction,
        }
        return event_data
    
    cdef dict c_parse_user_event(self, SDL_UserEvent *event, double time_stamp):
        cdef dict event_data = {
            "type": event.type,
            "timestamp": time_stamp,
            "data": <dict>event.data1,
        }
        Py_XDECREF(<PyObject *>event.data1)
        return event_data

    def update(self):
        cdef:
            double time_stamp
            SDL_Event event
            EventTypes event_type
            ItemVector events
            ItemVector listeners
            Handle listener
            ListenerC *listener_ptr
            size_t i
            object callback
            dict event_data
            dict user_data

        time_stamp = time.time()

        while SDL_PollEvent(&event) != 0:
            if event.type == SDL_WINDOWEVENT:
                event_data = self.c_parse_window_event(&event.window, time_stamp)
            elif event.type == SDL_KEYDOWN:
                event_data = self.c_parse_key_down_event(&event.key, time_stamp)
            elif event.type == SDL_KEYUP:
                event_data = self.c_parse_key_up_event(&event.key, time_stamp)
            elif event.type == SDL_MOUSEBUTTONDOWN:
                event_data = self.c_parse_mouse_button_down_event(&event.button, time_stamp)
            elif event.type == SDL_MOUSEBUTTONUP:
                event_data = self.c_parse_mouse_button_up_event(&event.button, time_stamp)
            elif event.type == SDL_MOUSEMOTION:
                event_data = self.c_parse_mouse_motion_event(&event.motion, time_stamp)
            elif event.type == SDL_MOUSEWHEEL:
                event_data = self.c_parse_mouse_wheel_event(&event.wheel, time_stamp)
            elif event.type >= SDL_USEREVENT:
                event_data = self.c_parse_user_event(&event.user, time_stamp)
            else: pass

            event_type = <EventTypes>event.type
            if event_type in self.listener_map:
                listeners = <ItemVector>self.listener_map[event_type]
                for i in range(listeners.num_items):
                    listeners.c_get(i, &listener)
                    listener_ptr = self.c_listener_get_ptr(listener)
                    callback = <object>listener_ptr.callback
                    user_data = <object>listener_ptr.user_data
                    callback(event_data, user_data)