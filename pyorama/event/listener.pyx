cdef class Listener(HandleObject):

    @staticmethod
    cdef Listener c_from_handle(Handle handle):
        cdef Listener obj
        if handle == 0:
            raise ValueError("Listener: invalid handle")
        obj = Listener.__new__(Listener)
        obj.handle = handle
        return obj

    cdef ListenerC *c_get_ptr(self) except *:
        return <ListenerC *>event.slots.c_get_ptr(self.handle)

    @staticmethod
    def init_create(bytes event_type_name, object callback, list args=None, dict kwargs=None):
        cdef:
            Listener listener

        listener = Listener.__new__(Listener)
        listener.create(event_type_name, callback, args, kwargs)
        return listener

    cpdef void create(self, bytes event_type_name, object callback, list args=None, dict kwargs=None) except *:
        cdef:
            uint16_t event_type
            ListenerC *listener_ptr
            VectorC *handles_ptr
        
        event_type = app.event.event_type_get_id(event_type_name)
        if args == None: args = []
        if kwargs == None: kwargs = {}
        self.handle = event.slots.c_create(EVENT_SLOT_LISTENER)
        listener_ptr = self.c_get_ptr()
        listener_ptr.event_type = event_type
        listener_ptr.callback = <PyObject *>callback
        listener_ptr.args = <PyObject *>args
        listener_ptr.kwargs = <PyObject *>kwargs
        Py_XINCREF(listener_ptr.callback)
        Py_XINCREF(listener_ptr.args)
        Py_XINCREF(listener_ptr.kwargs)
        handles_ptr = &event.listener_handles[event_type]
        vector_push(handles_ptr, &self.handle)

    cpdef void delete(self) except *:
        cdef:
            ListenerC *listener_ptr
            VectorC *handles_ptr
            size_t handle_index
        
        listener_ptr = self.c_get_ptr()
        handles_ptr = &event.listener_handles[listener_ptr.event_type]
        vector_find(handles_ptr, &self.handle, &handle_index)
        vector_remove_empty(handles_ptr, handle_index)
        Py_XDECREF(listener_ptr.callback)
        Py_XDECREF(listener_ptr.args)
        Py_XDECREF(listener_ptr.kwargs)
        listener_ptr.event_type = 0
        listener_ptr.callback = NULL
        listener_ptr.args = NULL
        listener_ptr.kwargs = NULL
        event.slots.c_delete(self.handle)
        self.handle = 0