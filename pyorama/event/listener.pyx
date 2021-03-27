cdef class Listener:
    def __cinit__(self, EventManager event):
        self.event = event

    def __dealloc__(self):
        self.event = None
    
    cdef ListenerC *c_get_ptr(self) except *:
        return self.event.listener_c_get_ptr(self.handle)

    cpdef void create(self, uint16_t event_type, object callback, list args=[], dict kwargs={}) except *:
        cdef:
            ListenerKeyC *key_ptr
            PyObject *values_ptr
            ListenerC *listener_ptr
        self.handle = self.event.listener_keys.c_create()
        key_ptr = self.event.key_c_get_ptr(self.handle)
        key_ptr.event_type = event_type
        values_ptr = self.event.listeners[key_ptr.event_type]
        key_ptr.index = (<ItemVector>values_ptr).num_items
        Py_INCREF(callback)
        Py_INCREF(args)
        Py_INCREF(kwargs)
        (<ItemVector>values_ptr).c_push_empty()
        listener_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(key_ptr.index)
        listener_ptr.key = self.handle
        listener_ptr.callback = <PyObject *>callback
        listener_ptr.args = <PyObject *>args
        listener_ptr.kwargs = <PyObject *>kwargs

    cpdef void delete(self) except *:
        cdef:
            ListenerKeyC *key_ptr
            PyObject *values_ptr
            ListenerC *listener_ptr
            ListenerC *value_ptr
            size_t i
            size_t key_index
        key_ptr = self.event.key_c_get_ptr(self.handle)
        values_ptr = self.event.listeners[key_ptr.event_type]
        listener_ptr = self.c_get_ptr()
        Py_XDECREF(listener_ptr.callback)
        Py_XDECREF(listener_ptr.args)
        Py_XDECREF(listener_ptr.kwargs)
        key_index = key_ptr.index
        (<ItemVector>values_ptr).c_remove_empty(key_index)
        for i in range(key_index, (<ItemVector>values_ptr).num_items):
            value_ptr = <ListenerC *>(<ItemVector>values_ptr).c_get_ptr(i)
            key_ptr = <ListenerKeyC *>self.event.key_c_get_ptr(value_ptr.key)
            key_ptr.index -= 1
        self.event.listener_keys.c_delete(self.handle)
        self.handle = 0