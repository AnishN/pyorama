from pyorama.core.item cimport *
from pyorama.core.item_slot_map cimport *
from pyorama.graphics.common cimport *
from pyorama.graphics.sampler cimport *
from pyorama.graphics.image cimport *
from pyorama.graphics.texture cimport *
from pyorama.graphics.shader cimport *
from pyorama.graphics.program cimport *

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
    cdef ItemSlotMapC shaders
    cdef ItemSlotMapC programs