from pyorama.libs.cgltf cimport *

def load_scene_from_file(file_path):
    cdef:
        cgltf_options options
        cgltf_data *data = NULL
        cgltf_result result
        cgltf_mesh *mesh
        cgltf_buffer *buffer
        cgltf_primitive *primitve
        size_t i

    memset(&options, 0, sizeof(cgltf_options))
    result = cgltf_parse_file(&options, <char *>file_path, &data)
    if result == cgltf_result_success:
        print(data.meshes_count)
        mesh = data.meshes
        print(mesh.name)
        print(mesh.primitives_count)
        print(data.buffers_count)
        for i in range(data.buffers_count):
            buffer = &data.buffers[i]
            print("buffer", i)
            #print(buffer.name)
            #print(buffer.uri)
            #print(buffer.size)
            #print("")
            """
            char* name;
            cgltf_size size;
            char* uri;
            void* data; /* loaded by cgltf_load_buffers */
            cgltf_data_free_method data_free_method;
            cgltf_extras extras;
            cgltf_size extensions_count;
            cgltf_extension* extensions;
            """

        for i in range(mesh.primitives_count):
            primitive = mesh.primitives[i]
            print(i)
            print(primitive.type)
            print(primitive.attributes_count)
            print(primitive.targets_count)
            print("")
            #cgltf_primitive_type type;
            #cgltf_accessor* indices;
            #cgltf_material* material;
            #cgltf_attribute* attributes;
            #cgltf_size attributes_count;
            #cgltf_morph_target* targets;
            #cgltf_size targets_count;
            #cgltf_extras extras;
            #cgltf_bool has_draco_mesh_compression;
            #cgltf_draco_mesh_compression draco_mesh_compression;
            #cgltf_material_mapping* mappings;
            #cgltf_size mappings_count;
            #cgltf_size extensions_count;
            #cgltf_extension* extensions;
        print(mesh.weights_count)
        #print(mesh.target_names[0])
        #print(mesh.target_names_count)
        cgltf_free(data)
    else:
        print("failed_to_load_gltf", result)
    print("testing")

"""
cgltf_primitive* primitives;
	cgltf_size primitives_count;
	cgltf_float* weights;
	cgltf_size weights_count;
	char** target_names;
	cgltf_size target_names_count;
	cgltf_extras extras;
	cgltf_size extensions_count;
	cgltf_extension* extensions;
"""

"""
#define CGLTF_IMPLEMENTATION
#include "cgltf.h"

cgltf_options options = {0};
cgltf_data* data = NULL;
cgltf_result result = cgltf_parse_file(&options, "scene.gltf", &data);
if (result == cgltf_result_success)
{
	/* TODO make awesome stuff */
	cgltf_free(data);
}
Loading from memory:

#define CGLTF_IMPLEMENTATION
#include "cgltf.h"

void* buf; /* Pointer to glb or gltf file data */
size_t size; /* Size of the file data */

cgltf_options options = {0};
cgltf_data* data = NULL;
cgltf_result result = cgltf_parse(&options, buf, size, &data);
if (result == cgltf_result_success)
{
	/* TODO make awesome stuff */
	cgltf_free(data);
}
"""

file_path = b"./examples/mesh/meshes/helmet.glb"
load_scene_from_file(file_path)