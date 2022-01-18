import pyorama
from pyorama.math import *
from pyorama.data import Buffer, BufferFormat
import math

"""
pyorama.graphics.ibo_create(
pyorama.graphics.fbo_create(
pyorama.graphics.vbo_create(

Stage object??? (this is what phaser uses)

Transform:
    think using a "linked list" approach to nodes may be useful...
    parent
    first_child
    prev_sibling
    next_sibling

Definitely need to use MRT (multitexturing?, multiple render targets, whatever)
Need some way to detect the number of textures that are bound at a single time for a batch (need to use multitexturing)

Attribute:
    public buffer: number;
    public size: number;
    public normalized: boolean;
    public type: TYPES;
    public stride: number;
    public start: number;
    public instance: boolean;

    constructor(buffer: number, size = 0, normalized = false, type = TYPES.FLOAT, stride?: number, start?: number, instance?: boolean)
    destroy(): void
    static from(buffer: number, size?: number, normalized?: boolean, type?: TYPES, stride?: number): Attribute

interface ITypedArray extends IArrayBuffer
    readonly length: number;
    [index: number]: number;
    readonly BYTES_PER_ELEMENT: number;

Buffer:
    public data: ITypedArray;
    /**
     * The type of buffer this is, one of:
     * + ELEMENT_ARRAY_BUFFER - used as an index buffer
     * + ARRAY_BUFFER - used as an attribute buffer
     * + UNIFORM_BUFFER - used as a uniform buffer (if available)
     */
    public type: BUFFER_TYPE;
    public static: boolean;
    public id: number;
     disposeRunner: Runner;
    _glBuffers: {[key: number]: GLBuffer};
    _updateID: number;

    constructor(data?: IArrayBuffer, _static = true, index = false)
    update(data?: IArrayBuffer | Array<number>): void
    dispose(): void
    destroy(): void
    set index(value: boolean)
    get index(): boolean
    static from(data: IArrayBuffer | number[]): Buffer
}

Geometry:
    public buffers: Array<Buffer>;
    public indexBuffer: Buffer;
    public attributes: {[key: string]: Attribute};
    public id: number;
    public instanced: boolean;
    public instanceCount: number;
    glVertexArrayObjects: {[key: number]: {[key: string]: WebGLVertexArrayObject}};
    disposeRunner: Runner;
    refCount: number;

    constructor(buffers: Array<Buffer> = [], attributes: {[key: string]: Attribute} = {})
    addAttribute(id: string, buffer: Buffer|Float32Array|Uint32Array|Array<number>, size = 0, normalized = false,
            type?: TYPES, stride?: number, start?: number, instance = false): this
    getAttribute(id: string): Attribute
    getBuffer(id: string): Buffer
    addIndex(buffer?: Buffer | IArrayBuffer | number[]): Geometry
    getIndex(): Buffer
    interleave(): Geometry
    getSize(): number
    dispose()
    destroy()
    clone(): Geometry
    static merge(geometries: Array<Geometry>): Geometry


"""

def on_window_event(event, *args, **kwargs):
    if event["sub_type"] == pyorama.event.WINDOW_EVENT_TYPE_CLOSE:
        window = event["window"]
        pyorama.app.trigger_quit()

def on_enter_frame_event(event, *args, **kwargs):
    global counter
    Vec3.set_data(eye, math.sin(float(counter) / 100) * 8, 2, math.cos(float(counter) / 100) * 8)
    Mat4.look_at(view_mat, eye, at, up)
    Mat4.perspective(proj_mat, math.radians(60.0), float(width) / float(height),  0.01, 1000.0)
    Mat4.identity(model_mat)
    Mat4.from_rotation_x(mtx_x, counter * 0.007)
    Mat4.from_rotation_y(mtx_y, counter * 0.01)
    Mat4.dot(model_mat, mtx_x, mtx_y)
    pyorama.graphics.view_set_transform_model(view, model_mat)
    pyorama.graphics.view_set_transform_view(view, view_mat)
    pyorama.graphics.view_set_transform_projection(view, proj_mat)
    pyorama.graphics.view_submit(view)
    counter += 1

width = 800
height = 600
title = b"Lights"

clear_color = 0x443355FF
counter = 0
at = Vec3(0.0, 0.0, 0.0)
eye = Vec3()
up = Vec3(0.0, 1.0, 0.0)
view_mat = Mat4()
proj_mat = Mat4()
model_mat = Mat4()
mtx_x = Mat4()
mtx_y = Mat4()

base_path = b"./examples/006_lights/"
image_path = base_path + b"textures/cube.png"
mesh_path =  base_path + b"meshes/cube.obj"
vs_source_path = base_path + b"shaders/vs_mesh.sc"
fs_source_path = base_path + b"shaders/fs_mesh.sc"
vs_bin_path = base_path + b"shaders/vs_mesh.bin"
fs_bin_path = base_path + b"shaders/fs_mesh.bin"

pyorama.app.init()


"""
ball_sprite = pyorama.graphics.sprite_create(5)
paddle_sprite = pyorama.graphics.sprite_create(5)
sprite_batch = pyorama.graphics.sprite_batch_create(
    [ball_sprite, paddle_sprite],
)
"""

"""
dir_light = pyorama.graphics.light_create(
    pyorama.graphics.LIGHT_TYPE_DIRECTION,
    params={
        "direction": Vec3(1, 2, 3),
        "color": 0xFF0000FF,
        "intensity": 5.0,
    },
)

pt_light = pyorama.graphics.light_create(
    pyorama.graphics.LIGHT_TYPE_POINT,
    params={
        "position": Vec3(10, 10, 10),
        "color": 0xFF0000FF,
        "intensity": 10.0,
    },
)
"""

"""
pipeline object
pipeline_node (needs inputs and outputs)

ctypedef struct ShaderMaterialC:
    uniforms
    

ctypedef struct MaterialC:
    Handle handle
    Vec4C pbr_base_color
    Handle pbr_base_texture
    float pbr_metallic_factor
    float pbr_roughness_factor
    Handle pbr_metallic_roughness_texture
    Handle normal_texture
    float normal_scale
    Handle occlusion_texture
    float occlusion_strength
    Handle emissive_texture
    Vec3C emissive_color
    MaterialAlphaMode alpha_mode (opaque, mask, blend)
    float alpha_cutoff
    bint double_sided

ctypedef struct MaterialC:
    Handle handle
    Handle shader
    Handle texture
    Vec4C albedo
    float metallic
    float smoothness
    bint use_alpha

ctypedef struct ModelC:
    Handle handle
    Handle mesh
    Handle material
    Handle transform
    
ctypedef struct RenderPassC:
    Handle handle
    RenderPassType type_
    Handle *objects
    size_t num_objects
    bint dynamic = False
    Handle vertex_buffer
    Handle index_buffer
    uint64_t output_texture_flags
    Handle *samplers
    Handle *input_textures
    Handle *output_textures

ctypedef struct RenderPassC:
    Handle handle
    Handle program
    Handle batch
    Handle *uniforms

pyorama.graphics.RENDER_PASS_PROGRAM_ANIM_MODEL_BATCH
pyorama.graphics.RENDER_PASS_PROGRAM_MODEL_BATCH
pyorama.graphics.RENDER_PASS_PROGRAM_SPRITE_BATCH
pyorama.graphics.EFFECT_PASS_PROGRAM_TINT
pyorama.graphics.EFFECT_PASS_PROGRAM_COPY
pyorama.graphics.EFFECT_PASS_PROGRAM_CLEAR

render_pass = pyorama.graphics.render_pass_create(program, batch, uniforms, outputs)
effect_pass_1 = pyorama.graphics.effect_pass_create(program, uniforms, inputs, outputs)
effect_pass_2 = pyorama.graphics.effect_pass_create(program, uniforms, intputs, outputs)

pipeline = pyorama.graphics.pipeline_create()
pipeline.submit([render_pass, effect_pass_1, effect_pass_2])

pyorama.graphics.render_pass_update()#this is something that needs to be done for dynamic vbos/ibos

uniforms
inputs
outputs

#these need to build a vbo basically, right?
#is this a dynamic thing or a static one?
#need to define the texture/fbo/mrt outputs as well
#need to define a camera input

pyorama.graphics.render_pass_create(
    render_pass_type,
    render_pass_objects[:],
)
pyorama.graphics.pipeline_create(render_passes[:])

pyorama.graphics.render_pass_create_from_sprites()
pyorama.graphics.render_pass_create_from_models()
pyorama.graphics.render_pass_create_from_anim_models()

pyorama.graphics.pipeline_set_pass_order()

pyorama.graphics.pipeline_create()
pyorama.graphics.pipeline_node_create()
pyorama.graphics.pipeline_node_set_program()
pyorama.graphics.pipeline_node_set_inputs()
pyorama.graphics.pipeline_node_set_outputs()
pyorama.graphics.pipeline_node_delete()
pyorama.graphics.pipeline_submit()
pyorama.graphics.pipeline_delete()

types of nodes:
    - geometry node:
    - camera node:
    - animation node:
    - light node:
    - 

build_pass_from_dict:
    - pass

types of passes:
render pass:
    - takes a scene, which has a camera, list of meshes, list of lights

effect pass:
    - takes a series of inputs and converts them to outputs
"""

sampler = pyorama.graphics.uniform_create(b"s_tex0", pyorama.graphics.UNIFORM_TYPE_SAMPLER)

mesh = pyorama.graphics.mesh_create_from_file(mesh_path, load_normals=False)
vertex_format = BufferFormat([
    (b"a_position", 3, pyorama.data.BUFFER_FIELD_TYPE_F32),
    (b"a_texcoord0", 2, pyorama.data.BUFFER_FIELD_TYPE_F32),
])

vertices = Buffer(vertex_format)
vertex_layout = pyorama.graphics.vertex_layout_create(vertex_format)
pyorama.graphics.mesh_get_vertices(mesh, vertices)
vertex_buffer = pyorama.graphics.vertex_buffer_create(vertex_layout, vertices)

index_layout = pyorama.graphics.INDEX_LAYOUT_U32
index_format = BufferFormat([
    (b"a_indices", 1, pyorama.data.BUFFER_FIELD_TYPE_U32),
])
indices = Buffer(index_format)
pyorama.graphics.mesh_get_indices(mesh, indices)
index_buffer = pyorama.graphics.index_buffer_create(index_layout, indices)

image = pyorama.graphics.image_create_from_file(image_path)
texture = pyorama.graphics.texture_create_2d_from_image(image)

pyorama.graphics.utils_runtime_compile_shader(vs_source_path, vs_bin_path, pyorama.graphics.SHADER_TYPE_VERTEX)
pyorama.graphics.utils_runtime_compile_shader(fs_source_path, fs_bin_path, pyorama.graphics.SHADER_TYPE_FRAGMENT)
vertex_shader = pyorama.graphics.shader_create_from_file(pyorama.graphics.SHADER_TYPE_VERTEX, vs_bin_path)
fragment_shader = pyorama.graphics.shader_create_from_file(pyorama.graphics.SHADER_TYPE_FRAGMENT,fs_bin_path)
program = pyorama.graphics.program_create(vertex_shader, fragment_shader)
window = pyorama.graphics.window_create(width, height, title)
frame_buffer = pyorama.graphics.frame_buffer_create_from_window(window)
view = pyorama.graphics.view_create()
on_window_listener = pyorama.event.listener_create(pyorama.event.EventType._WINDOW, on_window_event, None, None)
on_enter_frame_listener = pyorama.event.listener_create(pyorama.event.EventType._ENTER_FRAME, on_enter_frame_event, None, None)

clear_flags = pyorama.graphics.VIEW_CLEAR_COLOR | pyorama.graphics.VIEW_CLEAR_DEPTH
pyorama.graphics.view_set_clear(view, clear_flags, clear_color, 1.0, 0)
pyorama.graphics.view_set_rect(view, 0, 0, width, height)
pyorama.graphics.view_set_frame_buffer(view, frame_buffer)
pyorama.graphics.view_set_vertex_buffer(view, vertex_buffer)
pyorama.graphics.view_set_index_buffer(view, index_buffer)
pyorama.graphics.view_set_program(view, program)
pyorama.graphics.view_set_texture(view, sampler, texture, 0)

pyorama.app.run()

pyorama.event.listener_delete(on_enter_frame_listener)
pyorama.event.listener_delete(on_window_listener)
pyorama.graphics.uniform_delete(sampler)
pyorama.graphics.texture_delete(texture)
pyorama.graphics.image_delete(image)
pyorama.graphics.program_delete(program)
pyorama.graphics.shader_delete(fragment_shader)
pyorama.graphics.shader_delete(vertex_shader)
pyorama.graphics.index_buffer_delete(index_buffer)
pyorama.graphics.vertex_buffer_delete(vertex_buffer)
pyorama.graphics.mesh_delete(mesh)
pyorama.graphics.view_delete(view)
pyorama.graphics.frame_buffer_delete(frame_buffer)
pyorama.graphics.window_delete(window)
pyorama.app.quit()