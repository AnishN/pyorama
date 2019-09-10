from pyorama.graphics.common cimport *

cpdef enum ItemType:
    ITEM_TYPE_BUFFER
    ITEM_TYPE_BUFFER_VIEW
    ITEM_TYPE_ACCESSOR
    ITEM_TYPE_SAMPLER
    ITEM_TYPE_IMAGE
    ITEM_TYPE_TEXTURE
    ITEM_TYPE_MATERIAL
    ITEM_TYPE_ANIMATION
    ITEM_TYPE_MESH
    ITEM_TYPE_CAMERA
    ITEM_TYPE_SKIN
    ITEM_TYPE_NODE
    ITEM_TYPE_SCENE
    ITEM_TYPE_SHADER
    ITEM_TYPE_PROGRAM

cpdef enum ItemSize:
    ITEM_SIZE_BUFFER = sizeof(BufferC)
    ITEM_SIZE_BUFFER_VIEW = sizeof(BufferViewC)
    ITEM_SIZE_ACCESSOR = sizeof(AccessorC)
    ITEM_SIZE_SAMPLER = sizeof(SamplerC)
    ITEM_SIZE_IMAGE = sizeof(ImageC)
    ITEM_SIZE_TEXTURE = sizeof(TextureC)
    ITEM_SIZE_MATERIAL = sizeof(MaterialC)
    ITEM_SIZE_ANIMATION = sizeof(AnimationC)
    ITEM_SIZE_MESH = sizeof(MeshC)
    ITEM_SIZE_CAMERA = sizeof(CameraC)
    ITEM_SIZE_SKIN = sizeof(SkinC)
    ITEM_SIZE_NODE = sizeof(NodeC)
    ITEM_SIZE_SCENE = sizeof(SceneC)
    ITEM_SIZE_SHADER = sizeof(ShaderC)
    ITEM_SIZE_PROGRAM = sizeof(ProgramC)
