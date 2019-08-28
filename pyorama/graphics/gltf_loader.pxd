from pyorama.core.item cimport *
from pyorama.graphics.graphics_manager cimport *
from pyorama.libs.sdl2 cimport *

cdef class GLTFLoader:
    
    cpdef load_gltf_json_file(self, str file_path, GraphicsManager graphics)
    cpdef bytes load_gltf_bin_file(self, str file_path)
    cpdef load_glb_file(self, str file_path, GraphicsManager graphics)

    cdef dict _parse_buffers(self, dict data, GraphicsManager graphics, str dir_path)
    cdef dict _parse_buffer_views(self, dict data, GraphicsManager graphics, dict buffer_ids)
    cdef dict _parse_accessors(self, dict data, GraphicsManager graphics, dict buffer_view_ids)
    cdef dict _parse_samplers(self, dict data, GraphicsManager graphics)
    cdef dict _parse_images(self, dict data, GraphicsManager graphics, str dir_path, dict buffer_view_ids)
    cdef dict _parse_textures(self, dict data, GraphicsManager graphics, dict sampler_ids, dict image_ids)
    cdef dict _parse_materials(self, dict data, GraphicsManager graphics)
    cdef dict _parse_animations(self, dict data, GraphicsManager graphics)
    cdef dict _parse_meshes(self, dict data, GraphicsManager graphics)
    cdef dict _parse_cameras(self, dict data, GraphicsManager graphics)
    cdef dict _parse_skins(self, dict data, GraphicsManager graphics)
    cdef dict _parse_nodes(self, dict data, GraphicsManager graphics)
    cdef dict _parse_scenes(self, dict data, GraphicsManager graphics)