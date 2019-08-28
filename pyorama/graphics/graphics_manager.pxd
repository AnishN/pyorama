from pyorama.core.item cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.graphics.gltf cimport *

cdef class GraphicsManager:
    cdef ItemSlotMapC buffers
    cdef ItemSlotMapC buffer_views
    cdef ItemSlotMapC accessors
    cdef ItemSlotMapC samplers
    cdef ItemSlotMapC images
    cdef ItemSlotMapC textures
    cdef ItemSlotMapC materials
    cdef ItemSlotMapC animations
    cdef ItemSlotMapC meshes
    cdef ItemSlotMapC cameras
    cdef ItemSlotMapC skins
    cdef ItemSlotMapC nodes
    cdef ItemSlotMapC scenes