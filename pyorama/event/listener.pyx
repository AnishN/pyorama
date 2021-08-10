"""
cdef class Listener:
    cdef ListenerC *c_get_ptr(self) except *:
        return <ListenerC *>event.slots.c_get_ptr(self.handle)

    cpdef void create(self, uint16_t event_type, object callback, list args=None, dict kwargs=None) except *:
        cdef:
            ListenerC *listener_ptr
            PyObject *handles_ptr
        
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
        handles_ptr = event.listener_handles[event_type]
        (<Vector>handles_ptr).c_push(&event_type)

    cpdef void delete(self) except *:
        cdef:
            ListenerC *listener_ptr
            PyObject *handles_ptr
            size_t handle_index
        
        listener_ptr = self.c_get_ptr()
        handles_ptr = event.listener_handles[listener_ptr.event_type]
        handle_index = (<Vector>handles_ptr).c_find(&self.handle)
        (<Vector>handles_ptr).c_remove_empty(handle_index)
        Py_XDECREF(listener_ptr.callback)
        Py_XDECREF(listener_ptr.args)
        Py_XDECREF(listener_ptr.kwargs)
        listener_ptr.event_type = 0
        listener_ptr.callback = NULL
        listener_ptr.args = NULL
        listener_ptr.kwargs = NULL
        event.slots.c_delete(self.handle)
        self.handle = 0
"""

cdef ListenerC *listener_get_ptr(Handle listener) except *:
    return <ListenerC *>event.slots.c_get_ptr(listener)

cpdef Handle listener_create(uint16_t event_type, object callback, list args=None, dict kwargs=None) except *:
    cdef:
        Handle listener
        ListenerC *listener_ptr
        PyObject *handles_ptr
    
    if args == None: args = []
    if kwargs == None: kwargs = {}
    listener = event.slots.c_create(EVENT_SLOT_LISTENER)
    listener_ptr = listener_get_ptr(listener)
    listener_ptr.event_type = event_type
    listener_ptr.callback = <PyObject *>callback
    listener_ptr.args = <PyObject *>args
    listener_ptr.kwargs = <PyObject *>kwargs
    Py_XINCREF(listener_ptr.callback)
    Py_XINCREF(listener_ptr.args)
    Py_XINCREF(listener_ptr.kwargs)
    handles_ptr = event.listener_handles[event_type]
    (<Vector>handles_ptr).c_push(&listener)
    return listener

cpdef void listener_delete(Handle listener) except *:
    cdef:
        ListenerC *listener_ptr
        PyObject *handles_ptr
        size_t handle_index
    
    listener_ptr = listener_get_ptr(listener)
    handles_ptr = event.listener_handles[listener_ptr.event_type]
    handle_index = (<Vector>handles_ptr).c_find(&listener)
    (<Vector>handles_ptr).c_remove_empty(handle_index)
    Py_XDECREF(listener_ptr.callback)
    Py_XDECREF(listener_ptr.args)
    Py_XDECREF(listener_ptr.kwargs)
    listener_ptr.event_type = 0
    listener_ptr.callback = NULL
    listener_ptr.args = NULL
    listener_ptr.kwargs = NULL
    event.slots.c_delete(listener)