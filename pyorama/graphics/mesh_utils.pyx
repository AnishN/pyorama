import subprocess

"""
cdef str c_get_shader_type_str(ShaderType shader_type):
    cdef str shader_type_str
    if shader_type == SHADER_TYPE_VERTEX:
        shader_type_str = "v"
    elif shader_type == SHADER_TYPE_FRAGMENT:
        shader_type_str = "f"
    elif shader_type == SHADER_TYPE_COMPUTE:
        shader_type_str = "c"
    return shader_type_str

cdef str c_get_target_str(ShaderTargetPlatform target):
    cdef:
        PlatformOS platform_os
        str target_str
    if target == SHADER_TARGET_PLATFORM_AUTO:
        platform_os = app.c_get_platform_os()
        if platform_os == app.PLATFORM_OS_WINDOWS:
            target_str = "windows"
        elif platform_os == app.PLATFORM_OS_LINUX:
            target_str = "linux"
        elif platform_os == app.PLATFORM_OS_MACOS:
            target_str = "osx"
    elif target == SHADER_TARGET_PLATFORM_ANDROID:
        target_str = "android"
    elif target == SHADER_TARGET_PLATFORM_ASM_JS:
        target_str = "asm.js"
    elif target == SHADER_TARGET_PLATFORM_IOS:
        target_str = "ios"
    elif target == SHADER_TARGET_PLATFORM_LINUX:
        target_str = "linux"
    elif target == SHADER_TARGET_PLATFORM_ASM_JS:
        target_str = "orbis"
    elif target == SHADER_TARGET_PLATFORM_MACOS:
        target_str = "osx"
    elif target == SHADER_TARGET_PLATFORM_WINDOWS:
        target_str = "windows"
    return target_str

cdef str c_get_shader_model_auto_str(ShaderType shader_type):
    cdef:
        str model_str
        bgfx_renderer_type_t renderer
        int GL
        int GLES
    
    renderer = bgfx_get_renderer_type()
    if renderer == BGFX_RENDERER_TYPE_NOOP:
        raise ValueError("GraphicsUtils: invalid renderer type")
    elif renderer == BGFX_RENDERER_TYPE_DIRECT3D9:
        if shader_type == SHADER_TYPE_VERTEX:
            model_str = "vs_3_0"
        elif shader_type == SHADER_TYPE_FRAGMENT:
            model_str = "ps_3_0"
        elif shader_type == SHADER_TYPE_COMPUTE:
            raise ValueError("GraphicsUtils: compute shaders not supported in HLSL 3.0")
    elif renderer == BGFX_RENDERER_TYPE_DIRECT3D11:
        if shader_type == SHADER_TYPE_VERTEX:
            model_str = "vs_5_0"
        elif shader_type == SHADER_TYPE_FRAGMENT:
            model_str = "ps_5_0"
        elif shader_type == SHADER_TYPE_COMPUTE:
            model_str = "cs_5_0"
    elif renderer == BGFX_RENDERER_TYPE_DIRECT3D12:
        if shader_type == SHADER_TYPE_VERTEX:
            model_str = "vs_5_0"
        elif shader_type == SHADER_TYPE_FRAGMENT:
            model_str = "ps_5_0"
        elif shader_type == SHADER_TYPE_COMPUTE:
            model_str = "cs_5_0"
    elif renderer == BGFX_RENDERER_TYPE_GNM:
        model_str = "pssl"
    elif renderer == BGFX_RENDERER_TYPE_METAL:
        model_str = "metal"
    elif renderer == BGFX_RENDERER_TYPE_NVN:
        raise ValueError("GraphicsUtils: invalid renderer type")
    elif renderer == BGFX_RENDERER_TYPE_OPENGLES:
        GLES = BGFX_CONFIG_RENDERER_OPENGLES
        if GLES == 30:
            model_str = "300_es"
        elif GLES == 31:
            model_str = "310_es"
        elif GLES == 32:
            model_str = "320_es"
        else:
            model_str = "100_es"
    elif renderer == BGFX_RENDERER_TYPE_OPENGL:
        GL = BGFX_CONFIG_RENDERER_OPENGL
        if GL == 31:
            model_str = "140"
        elif GL == 32:
            model_str = "150"
        elif GL == 33:
            model_str = "330"
        elif GL == 40:
            model_str = "400"
        elif GL == 41:
            model_str = "410"
        elif GL == 42:
            model_str = "420"
        elif GL == 43:
            model_str = "430"
        elif GL == 44:
            model_str = "440"
        elif GL == 45:
            model_str = "450"
        elif GL == 46:
            model_str = "460"
        else:
            model_str = "120"
    elif renderer == BGFX_RENDERER_TYPE_VULKAN:
        model_str = "spirv"#not sure how to detect version
    elif renderer == BGFX_RENDERER_TYPE_WEBGPU:
        raise ValueError("GraphicsUtils: invalid renderer type")
    return model_str

cdef str c_get_shader_model_str(ShaderModel model, ShaderType shader_type):
    cdef:
        str model_str
    
    if model == SHADER_MODEL_AUTO:
        model_str = c_get_shader_model_auto_str(shader_type)
    elif model == SHADER_MODEL_ES_100:
        model_str = "100_es"
    elif model == SHADER_MODEL_ES_300:
        model_str = "300_es"
    elif model == SHADER_MODEL_ES_310:
        model_str = "310_es"
    elif model == SHADER_MODEL_ES_320:
        model_str = "320_es"
    elif model == SHADER_MODEL_HLSL_3_0:
        if shader_type == SHADER_TYPE_VERTEX:
            model_str = "vs_3_0"
        elif shader_type == SHADER_TYPE_FRAGMENT:
            model_str = "ps_3_0"
        elif shader_type == SHADER_TYPE_COMPUTE:
            raise ValueError("GraphicsUtils: compute shaders not supported in HLSL 3.0")
    elif model == SHADER_MODEL_HLSL_4_0:
        if shader_type == SHADER_TYPE_VERTEX:
            model_str = "vs_4_0"
        elif shader_type == SHADER_TYPE_FRAGMENT:
            model_str = "ps_4_0"
        elif shader_type == SHADER_TYPE_COMPUTE:
            model_str = "cs_4_0"
    elif model == SHADER_MODEL_HLSL_5_0:
        if shader_type == SHADER_TYPE_VERTEX:
            model_str = "vs_5_0"
        elif shader_type == SHADER_TYPE_FRAGMENT:
            model_str = "ps_5_0"
        elif shader_type == SHADER_TYPE_COMPUTE:
            model_str = "cs_5_0"
    elif model == SHADER_MODEL_METAL:
        model_str = "metal"
    elif model == SHADER_MODEL_PSSL:
        model_str = "pssl"
    elif model == SHADER_MODEL_SPIRV_13_11:
        model_str = "spirv13-11"
    elif model == SHADER_MODEL_SPIRV_14_11:
        model_str = "spirv14-11"
    elif model == SHADER_MODEL_SPIRV_15_12:
        model_str = "spirv15-12"
    elif model == SHADER_MODEL_SPIRV_10_10:
        model_str = "spirv10-10"
    elif model == SHADER_MODEL_SPIRV:
        model_str = "spirv"
    elif model == SHADER_MODEL_GLSL_120:
        model_str = "120"
    elif model == SHADER_MODEL_GLSL_130:
        model_str = "130"
    elif model == SHADER_MODEL_GLSL_140:
        model_str = "140"
    elif model == SHADER_MODEL_GLSL_150:
        model_str = "150"
    elif model == SHADER_MODEL_GLSL_330:
        model_str = "330"
    elif model == SHADER_MODEL_GLSL_400:
        model_str = "400"
    elif model == SHADER_MODEL_GLSL_410:
        model_str = "410"
    elif model == SHADER_MODEL_GLSL_420:
        model_str = "420"
    elif model == SHADER_MODEL_GLSL_430:
        model_str = "430"
    elif model == SHADER_MODEL_GLSL_440:
        model_str = "440"
    return model_str
"""

cpdef void utils_runtime_compile_mesh(
        bytes in_file_path, 
        bytes out_file_path, 
        float scale=1.0,
        bint ccw=True,
        bint flip_v=False,
        int num_obb_steps=17,
        bint pack_normals=False,
        bint pack_uvs=False,
        bint calc_tangents=False,
        bint calc_barycentrics=False,
        bint compress_indices=False,
        bytes coord_system=b"lh-up+y") except *:
    
    cdef:
        PlatformOS platform_os
        bytes geometryc_path
        list cmd_args

    #find the geometryc executable path
    platform_os = app.c_get_platform_os()
    if platform_os == app.PLATFORM_OS_WINDOWS:
        geometryc_path = b"./pyorama/libs/shared/Windows/geometrycRelease.exe"
    elif platform_os == app.PLATFORM_OS_LINUX:
        geometryc_path = b"./pyorama/libs/shared/Linux/geometrycRelease"
    elif platform_os == app.PLATFORM_OS_MACOS:
        raise NotImplementedError("Runtime compilation on mac os is not yet supported")
    else:
        raise NotImplementedError("Runtime compilation on this unknown platform is not supported")

    #shader_type_str = c_get_shader_type_str(shader_type)
    #target_str = c_get_target_str(target)
    #model_str = c_get_shader_model_str(model, shader_type)
    
    cmd_args = [
        geometryc_path,
        "-f", in_file_path,
        "-o", out_file_path,
    ]

    if scale != 1.0:
        cmd_args.extend(["--scale", scale])
    if ccw == True:
        cmd_args.append("--ccw")
    if flip_v == True:
        cmd_args.append("--flipv")
    if num_obb_steps != 17:
        cmd_args.extend(["--obb", num_obb_steps])
    if pack_normals == True:
        cmd_args.extend(["--packnormal", 1])
    if pack_uvs == True:
        cmd_args.extend(["--packuv", 1])
    if calc_tangents == True:
        cmd_args.append("--tangent")
    if calc_barycentrics == True:
        cmd_args.append("--barycentric")
    if compress_indices == True:
        cmd_args.append("--compress")
    if coord_system != b"lh-up+y":
        cmd_args.append("--" + coord_system)
    try:
        subprocess.check_output(cmd_args)
    except subprocess.CalledProcessError as error:
        error_str = error.output.decode("utf-8")
        raise ValueError("GeometryC compilation failed: {0}".format(error_str))

cdef void mesh_create_from_binary_file(Mesh mesh, bytes file_path) except *:
    cdef:
        FILE *file_ptr
        size_t file_size
        uint32_t chunk
        uint32_t MAGIC_VBO = magic_to_int(b"V", b"B", b" ", 0x1)
        uint32_t MAGIC_VBO_COMPRESSED = magic_to_int(b"V", b"B", b"C", 0x0)
        uint32_t MAGIC_IBO = magic_to_int(b"I", b"B", b" ", 0x0)
        uint32_t MAGIC_IBO_COMPRESSED = magic_to_int(b"I", b"B", b"C", 0x1)
        uint32_t MAGIC_PRIMITIVE = magic_to_int(b"P", b"R", b"I", 0x0)

    file_ptr = fopen(file_path, b"r")
    fseek(file_ptr, 0, SEEK_END)
    file_size = ftell(file_ptr)
    rewind(file_ptr)
    print(file_size)

    mesh.handle = app.graphics.slots.c_create(GRAPHICS_SLOT_MESH)

    while fread(&chunk, sizeof(uint32_t), 1, file_ptr) != 0:
        if chunk == MAGIC_VBO:
            print("vbo")
            parse_vbo(mesh, file_ptr)
            print("parsed_vbo", ftell(file_ptr))
        elif chunk == MAGIC_VBO_COMPRESSED:
            raise NotImplementedError()
        elif chunk == MAGIC_IBO:
            print("ibo")
            parse_ibo(mesh, file_ptr)
            print("parsed_ibo", ftell(file_ptr))
        elif chunk == MAGIC_IBO_COMPRESSED:
            raise NotImplementedError()
        elif chunk == MAGIC_PRIMITIVE:
            raise NotImplementedError()

ctypedef struct SphereDataC:
    float[3] center
    float radius

ctypedef struct AabbDataC:
    float[3] min
    float[3] max

ctypedef struct ObbDataC:
    float[16] data

ctypedef struct LayoutDataC:
    uint32_t hash
    uint16_t stride
    uint16_t[<size_t>BGFX_ATTRIB_COUNT] offset
    uint16_t[<size_t>BGFX_ATTRIB_COUNT] attributes

cdef void parse_vbo(Mesh mesh, FILE *file_ptr) except *:
    cdef:
        SphereDataC sphere
        AabbDataC aabb
        ObbDataC obb
        uint8_t num_attributes
        uint16_t stride

        size_t i
        uint16_t offset
        uint16_t attribute_id
        uint8_t count
        uint16_t attribute_type_id
        bint normalized
        bint as_int

        uint16_t num_vertices
        uint8_t *vertices
    
    fread(&sphere, sizeof(SphereDataC), 1, file_ptr)
    fread(&aabb, sizeof(AabbDataC), 1, file_ptr)
    fread(&obb, sizeof(ObbDataC), 1, file_ptr)
    fread(&num_attributes, sizeof(uint8_t), 1, file_ptr)
    fread(&stride, sizeof(uint16_t), 1, file_ptr)
    print(sphere, aabb, obb)
    print(num_attributes, stride)

    for i in range(num_attributes):
        fread(&offset, sizeof(uint16_t), 1, file_ptr)
        fread(&attribute_id, sizeof(uint16_t), 1, file_ptr)
        fread(&count, sizeof(uint8_t), 1, file_ptr)
        fread(&attribute_type_id, sizeof(uint16_t), 1, file_ptr)
        fread(&normalized, sizeof(bint), 1, file_ptr)
        fread(&as_int, sizeof(bint), 1, file_ptr)
        print(i, offset, attribute_id, count, attribute_type_id, normalized, as_int)

    fread(&num_vertices, sizeof(uint16_t), 1, file_ptr)
    vertices = <uint8_t *>calloc(stride, num_vertices)
    if vertices == NULL:
        raise MemoryError()
    fread(&vertices, stride, num_vertices, file_ptr)
    print("done")

cdef void parse_ibo(Mesh mesh, FILE *file_ptr) except *:
    cdef:
        uint32_t num_indices
        uint16_t *indices

    fread(&num_indices, sizeof(uint32_t), 1, file_ptr)
    indices = <uint16_t *>calloc(sizeof(uint16_t), num_indices)
    if indices == NULL:
        raise MemoryError()
    fread(&indices, sizeof(uint16_t), num_indices, file_ptr)
    print("done")

cdef uint32_t magic_to_int(uint8_t a, uint8_t b, uint8_t c, uint8_t d):
    return (
        (<uint32_t>a) | 
        (<uint32_t>b << 8) | 
        (<uint32_t>c << 16) | 
        (<uint32_t>d << 24)
    )

"""
void Mesh::load(bx::ReaderSeekerI* _reader, bool _ramcopy)
{
	while (4 == bx::read(_reader, chunk, &err)
	   &&  err.isOk() )
	{
		switch (chunk)
		{
			case kChunkPrimitive:
			{
				uint16_t len;
				read(_reader, len, &err);

				stl::string material;
				material.resize(len);
				read(_reader, const_cast<char*>(material.c_str() ), len, &err);

				uint16_t num;
				read(_reader, num, &err);

				for (uint32_t ii = 0; ii < num; ++ii)
				{
					read(_reader, len, &err);

					stl::string name;
					name.resize(len);
					read(_reader, const_cast<char*>(name.c_str() ), len, &err);

					Primitive prim;
					read(_reader, prim.m_startIndex, &err);
					read(_reader, prim.m_numIndices, &err);
					read(_reader, prim.m_startVertex, &err);
					read(_reader, prim.m_numVertices, &err);
					read(_reader, prim.m_sphere, &err);
					read(_reader, prim.m_aabb, &err);
					read(_reader, prim.m_obb, &err);

					group.m_prims.push_back(prim);
				}

				m_groups.push_back(group);
				group.reset();
			}
				break;

			default:
				DBG("%08x at %d", chunk, bx::skip(_reader, 0) );
				break;
		}
	}
}
"""