cdef class EventSystem:

    def __cinit__(self):
        slot_map_init(&self.listeners, EVENT_SLOT_LISTENER, sizeof(ListenerC))
    
    def __dealloc__(self):
        slot_map_free(&self.listeners)

    def init(self, dict config=None):
        cdef:
            size_t i
            VectorC *handles_ptr
        
        SDL_InitSubSystem(SDL_INIT_EVENTS)
        SDL_InitSubSystem(SDL_INIT_JOYSTICK)
        SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "1")
        self.timestamp = 0.0
        for i in range(MAX_EVENT_TYPES):
            handles_ptr = &self.listener_handles[i]
            vector_init(handles_ptr, sizeof(Handle))
        self.py_event_funcs = {}
        int_hash_map_init(&self.c_event_funcs)
        str_hash_map_init(&self.event_type_names_map)

    def quit(self):
        cdef:
            size_t i
            VectorC *handles_ptr
        
        self.py_event_funcs = {}
        str_hash_map_free(&self.event_type_names_map)
        int_hash_map_free(&self.c_event_funcs)
        for i in range(MAX_EVENT_TYPES):
            handles_ptr = &self.listener_handles[i]
            vector_free(handles_ptr)
        SDL_SetHint(SDL_HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS, "0")
        SDL_QuitSubSystem(SDL_INIT_EVENTS)

    def bind_events(self):
        self.event_type_register(b"key_down", SDL_KEYDOWN)
        self.event_type_register(b"key_up", SDL_KEYUP)
        self.event_type_register(b"mouse_button_down", SDL_MOUSEBUTTONDOWN)
        self.event_type_register(b"mouse_button_up", SDL_MOUSEBUTTONUP)
        self.event_type_register(b"mouse_motion", SDL_MOUSEMOTION)
        self.event_type_register(b"mouse_wheel", SDL_MOUSEWHEEL)
        self.event_type_register(b"joystick_axis", SDL_JOYAXISMOTION)
        self.event_type_register(b"joystick_ball", SDL_JOYBALLMOTION)
        self.event_type_register(b"joystick_hat", SDL_JOYHATMOTION)
        self.event_type_register(b"joystick_button_down", SDL_JOYBUTTONDOWN)
        self.event_type_register(b"joystick_button_up", SDL_JOYBUTTONUP)
        self.event_type_register(b"joystick_added", SDL_JOYDEVICEADDED)
        self.event_type_register(b"joystick_removed", SDL_JOYDEVICEREMOVED)

        self.c_event_type_bind(b"key_down", <EventFuncC>c_keyboard_event)
        self.c_event_type_bind(b"key_up", <EventFuncC>c_keyboard_event)
        self.c_event_type_bind(b"mouse_button_down", <EventFuncC>c_mouse_button_event)
        self.c_event_type_bind(b"mouse_button_up", <EventFuncC>c_mouse_button_event)
        self.c_event_type_bind(b"mouse_motion", <EventFuncC>c_mouse_motion_event)
        self.c_event_type_bind(b"mouse_wheel", <EventFuncC>c_mouse_wheel_event)
        self.c_event_type_bind(b"joystick_axis", <EventFuncC>c_joystick_axis_event)
        self.c_event_type_bind(b"joystick_ball", <EventFuncC>c_joystick_ball_event)
        self.c_event_type_bind(b"joystick_hat", <EventFuncC>c_joystick_hat_event)
        self.c_event_type_bind(b"joystick_button_down", <EventFuncC>c_joystick_button_event)
        self.c_event_type_bind(b"joystick_button_up", <EventFuncC>c_joystick_button_event)
        self.c_event_type_bind(b"joystick_added", <EventFuncC>c_joystick_device_event)
        self.c_event_type_bind(b"joystick_removed", <EventFuncC>c_joystick_device_event)

    cpdef void event_type_register(self, bytes name, uint16_t event_type=0) except *:
        cdef:
            uint32_t sdl_event_type
            size_t name_len
            char *name_ptr
        
        if event_type == 0:
            sdl_event_type = SDL_RegisterEvents(1)
            if sdl_event_type >= MAX_EVENT_TYPES:
                raise ValueError("EventSystem: cannot register additional event types")
            event_type = <uint16_t>sdl_event_type
        
        name_len = <size_t>len(name)
        name_ptr = <char *>calloc(name_len + 1, sizeof(char))
        if name_ptr == NULL:
            raise MemoryError()
        memcpy(name_ptr, <char *>name, name_len)
        self.event_type_names[event_type] = name_ptr
        str_hash_map_insert(&self.event_type_names_map, name_ptr, name_len, event_type)
    
    cpdef uint16_t event_type_get_id(self, bytes name) except *:
        cdef:
            size_t name_len
            char *name_ptr
            bint is_valid
            uint16_t event_type
        
        name_len = len(name)
        name_ptr = <char *>name
        is_valid = str_hash_map_contains(&self.event_type_names_map, name_ptr, name_len)
        if not is_valid:
            raise ValueError("EventSystem: Invalid event type name")
        event_type = <uint16_t>str_hash_map_get(&self.event_type_names_map, name_ptr, name_len)
        return event_type

    cpdef void py_event_type_bind(self, bytes name, object func_obj) except *:
        self.py_event_funcs[name] = func_obj

    cdef void c_event_type_bind(self, bytes name, EventFuncC func_ptr) except *:
        cdef:
            uint64_t key
            uint64_t value
        
        key = self.event_type_get_id(name)
        value = <uint64_t>func_ptr
        int_hash_map_insert(&self.c_event_funcs, key, value)

    cpdef void event_type_emit(self, bytes name, dict event_data={}) except *:
        cdef:
            uint16_t event_type
            SDL_Event event
            PyObject *event_data_ptr
        
        event_type = self.event_type_get_id(name)
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
            VectorC *listeners_ptr
            size_t i
            ListenerC *listener_ptr
            object callback
            list args
            dict kwargs
        
        while SDL_PollEvent(&event):
            is_registered = int_hash_map_contains(&self.c_event_funcs, event.type)
            if is_registered:
                event_data = {}
                CHECK_ERROR(int_hash_map_get(&self.c_event_funcs, event.type, <uint64_t *>&event_func_ptr))
                event_func_ptr(event.type, &event, <PyObject *>event_data)
                listeners_ptr = &self.listeners.items
                for i in range(listeners_ptr.num_items):
                    listener_ptr = <ListenerC *>vector_get_ptr_unsafe(listeners_ptr, i)
                    if listener_ptr.event_type == event.type:
                        callback = <object>listener_ptr.callback
                        args = <list>listener_ptr.args
                        kwargs = <dict>listener_ptr.kwargs
                        callback(event_data, *args, **kwargs)