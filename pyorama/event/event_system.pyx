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

    def init(self):
        cdef:
            size_t i
            PyObject *handles_ptr
        
        print(self.name, "init")
        SDL_InitSubSystem(SDL_INIT_EVENTS)
        self.timestamp = 0.0
        self.slots.c_init(self.slot_sizes)
        for i in range(MAX_EVENT_TYPES):
            handles_ptr = <PyObject *>self.listener_handles[i]
            (<Vector>handles_ptr).c_init(sizeof(Handle))

    def quit(self):
        cdef:
            size_t i
            PyObject *handles_ptr
        
        print(self.name, "quit")
        for i in range(MAX_EVENT_TYPES):
            handles_ptr = <PyObject *>self.listener_handles[i]
            (<Vector>handles_ptr).c_free()
        self.slots.c_free()
        SDL_QuitSubSystem(SDL_INIT_EVENTS)

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
        
        print(self.name, "update")
        while SDL_PollEvent(&event):
            ignore_event = False
            if event.type == EVENT_TYPE_WINDOW:
                #if event.window.windowID == SDL_GetWindowID(graphics.root_window):
                if not graphics.window_ids.c_contains(event.window.windowID):
                    ignore_event = True
                else:
                    event_data = self.parse_window_event(event.window)
            if not ignore_event:
                listeners = self.slots.get_slot_map(EVENT_SLOT_LISTENER).items
                for i in range(listeners.num_items):
                    listener_ptr = <ListenerC *>listeners.c_get_ptr(i)
                    if listener_ptr.event_type == event.type:
                        #values_ptr = self.listeners[event.type]
                        #for i in range((<Vector>values_ptr).num_items):
                        #listener_ptr = <ListenerC *>(<Vector>values_ptr).c_get_ptr(i)
                        #listener_ptr = self.slots.c_get_ptr(
                        callback = <object>listener_ptr.callback
                        args = <list>listener_ptr.args
                        kwargs = <dict>listener_ptr.kwargs
                        callback(event_data, *args, **kwargs)