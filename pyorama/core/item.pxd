from pyorama.graphics.gltf cimport *

cpdef enum ItemTypes:
    BUFFER
    BUFFER_VIEW
    ACCESSOR
    SAMPLER
    IMAGE
    TEXTURE
    MATERIAL
    ANIMATION
    MESH
    CAMERA
    SKIN
    NODE
    SCENE

cpdef enum ItemSizes:
    BUFFER_SIZE = sizeof(BufferC)
    BUFFER_VIEW_SIZE = sizeof(BufferViewC)
    ACCESSOR_SIZE = sizeof(AccessorC)
    SAMPLER_SIZE = sizeof(SamplerC)
    IMAGE_SIZE = sizeof(ImageC)
    TEXTURE_SIZE = sizeof(TextureC)
    MATERIAL_SIZE = sizeof(MaterialC)
    ANIMATION_SIZE = sizeof(AnimationC)
    MESH_SIZE = sizeof(MeshC)
    CAMERA_SIZE = sizeof(CameraC)
    SKIN_SIZE = sizeof(SkinC)
    NODE_SIZE = sizeof(NodeC)
    SCENE_SIZE = sizeof(SceneC)
