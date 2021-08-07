from pyorama.core.graphics_system cimport *
from pyorama.core.user_system cimport *

cdef:
    GraphicsSystem graphics
    UserSystem audio
    UserSystem events
    UserSystem physics
    object user
    dict engine_systems
    list engine_systems_order
    dict user_systems
    list user_systems_order
    str old_path