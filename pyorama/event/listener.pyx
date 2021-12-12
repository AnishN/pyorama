cdef class Listener(HandleObject):

    cdef ListenerC *get_ptr(self) except *:
        return <ListenerC *>event.slots.c_get_ptr(self.handle)

    cpdef void create(self, uint16_t event_type, object callback, list args=None, dict kwargs=None) except *:
        cdef:
            ListenerC *listener_ptr
            VectorC *handles_ptr
        
        if args == None: args = []
        if kwargs == None: kwargs = {}
        self.handle = event.slots.c_create(EVENT_SLOT_LISTENER)
        listener_ptr = self.get_ptr()
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
        
        listener_ptr = self.get_ptr()
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