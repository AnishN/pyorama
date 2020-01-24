cdef class EventManager:

    def __cinit__(self):
        self.listeners = {}

    def __dealloc__(self):
        self.listeners = None
    
    def update(self, double delta, double time):
        pass
    
    #def create_keyboard_command(
    #def create_mouse_command(
    #def create_touch_command(
    #def create_window_command(

"""
Perhaps there should be a Manager base class.
This would operate on an app and a series of its components.
E.g. how to share window objects between EventManager and GraphicsManager?
E.g. how to share app time with all of these manager objects?
Perhaps they should all just hold a reference to the parent app? -> aka dependency inversion

Need to create a COMMAND interface
By that, I need to map an input to a command int value, which could then be passed around everywhere.
That way, a specific input could be quickly mapped!
And it makes rebinds simple (no hard-coding controls, and easy to swap the binds just in one place!)

Or you could argue that there is no difference between commands and listeners...
Maybe just have a command class instead? Hmm...

cdef class Command:
    cdef void c_execute(self):
    def execute(self):
        pass
"""