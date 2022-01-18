from pyorama.event.event_type import EventType

cdef class EventSystem:

    def __cinit__(self, str name):
        self.name = name
        self.slots = SlotManager()
        self.slot_sizes = {
            EVENT_SLOT_LISTENER: sizeof(ListenerC),
        }
    
    def __dealloc__(self):
        self.slot_sizes = None
        self.slots = None

    def init(self, dict config=None):
        cdef:
            size_t i
            VectorC *handles_ptr
        
        #print(self.name, "init")
        SDL_InitSubSystem(SDL_INIT_EVENTS)
        SDL_InitSubSystem(SDL_INIT_JOYSTICK)
        SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1")
        self.timestamp = 0.0
        self.slots.c_init(self.slot_sizes)
        for i in range(MAX_EVENT_TYPES):
            handles_ptr = &self.listener_handles[i]
            vector_init(handles_ptr, sizeof(Handle))
        self.py_event_funcs = {}
        int_hash_map_init(&self.c_event_funcs)

    def quit(self):
        cdef:
            size_t i
            VectorC *handles_ptr
        
        self.py_event_funcs = {}
        int_hash_map_free(&self.c_event_funcs)
        for i in range(MAX_EVENT_TYPES):
            handles_ptr = &self.listener_handles[i]
            vector_free(handles_ptr)
        self.slots.c_free()
        SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "0")
        SDL_QuitSubSystem(SDL_INIT_EVENTS)

    def bind_events(self):
        EventType.KEY_DOWN = SDL_KEYDOWN
        EventType.KEY_UP = SDL_KEYUP
        EventType.MOUSE_MOTION = SDL_MOUSEMOTION
        EventType.MOUSE_BUTTON_DOWN = SDL_MOUSEBUTTONDOWN
        EventType.MOUSE_BUTTON_UP = SDL_MOUSEBUTTONUP
        EventType.MOUSE_WHEEL = SDL_MOUSEWHEEL
        EventType.JOYSTICK_AXIS = SDL_JOYAXISMOTION
        EventType.JOYSTICK_BALL = SDL_JOYBALLMOTION
        EventType.JOYSTICK_HAT = SDL_JOYHATMOTION
        EventType.JOYSTICK_BUTTON_DOWN = SDL_JOYBUTTONDOWN
        EventType.JOYSTICK_BUTTON_UP = SDL_JOYBUTTONUP
        EventType.JOYSTICK_ADDED = SDL_JOYDEVICEADDED
        EventType.JOYSTICK_REMOVED = SDL_JOYDEVICEREMOVED

        self.c_event_type_bind(EventType.JOYSTICK_AXIS, <EventFuncC>c_joystick_axis_event)
        self.c_event_type_bind(EventType.JOYSTICK_BALL, <EventFuncC>c_joystick_ball_event)
        self.c_event_type_bind(EventType.JOYSTICK_HAT, <EventFuncC>c_joystick_hat_event)
        self.c_event_type_bind(EventType.JOYSTICK_BUTTON_DOWN, <EventFuncC>c_joystick_button_event)
        self.c_event_type_bind(EventType.JOYSTICK_BUTTON_UP, <EventFuncC>c_joystick_button_event)
        self.c_event_type_bind(EventType.JOYSTICK_ADDED, <EventFuncC>c_joystick_device_event)
        self.c_event_type_bind(EventType.JOYSTICK_REMOVED, <EventFuncC>c_joystick_device_event)
        self.c_event_type_bind(EventType.KEY_DOWN, <EventFuncC>c_keyboard_event)
        self.c_event_type_bind(EventType.KEY_UP, <EventFuncC>c_keyboard_event)
        self.c_event_type_bind(EventType.MOUSE_BUTTON_DOWN, <EventFuncC>c_mouse_button_event)
        self.c_event_type_bind(EventType.MOUSE_BUTTON_UP, <EventFuncC>c_mouse_button_event)
        self.c_event_type_bind(EventType.MOUSE_MOTION, <EventFuncC>c_mouse_motion_event)
        self.c_event_type_bind(EventType.MOUSE_WHEEL, <EventFuncC>c_mouse_wheel_event)

    cpdef uint16_t event_type_register(self) except *:
        cdef:
            uint32_t sdl_event_type
        
        sdl_event_type = SDL_RegisterEvents(1)
        if sdl_event_type >= MAX_EVENT_TYPES:
            raise ValueError("EventSystem: cannot register additional event types")
    
    cpdef void py_event_type_bind(self, uint16_t event_type, object func_obj) except *:
        self.py_event_funcs[event_type] = func_obj

    cdef void c_event_type_bind(self, uint16_t event_type, EventFuncC func_ptr) except *:
        cdef:
            uint64_t key
            uint64_t value
        
        key = <uint64_t>event_type
        value = <uint64_t>func_ptr
        int_hash_map_insert(&self.c_event_funcs, key, value)

    """
    cpdef void event_type_bind(self, uint16_t event_type, object parse_func) except *:
        self.parse_funcs[event_type] = parse_func

    cpdef uint16_t event_type_register_bind(self, object parse_func) except *:
        cdef:
            uint16_t event_type

        event_type = self.event_type_register()
        self.event_type_bind(event_type, parse_func)
        return event_type
    """

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

    cpdef void update(self, double timestamp) except *:
        cdef:
            SDL_Event event
            bint is_registered
            EventFuncC event_func_ptr
            dict event_data
            VectorC *listeners
            size_t i
            ListenerC *listener_ptr
            object callback
            list args
            dict kwargs
        
        while SDL_PollEvent(&event):
            is_registered = int_hash_map_contains(&self.c_event_funcs, event.type)
            if is_registered:
                event_data = {}
                event_func_ptr = <EventFuncC>int_hash_map_get(&self.c_event_funcs, event.type)
                event_func_ptr(event.type, &event, <PyObject *>event_data)
                listeners = &self.slots.get_slot_map(EVENT_SLOT_LISTENER).items
                for i in range(listeners.num_items):
                    listener_ptr = <ListenerC *>vector_get_ptr_unsafe(listeners, i)
                    if listener_ptr.event_type == event.type:
                        callback = <object>listener_ptr.callback
                        args = <list>listener_ptr.args
                        kwargs = <dict>listener_ptr.kwargs
                        callback(event_data, *args, **kwargs)