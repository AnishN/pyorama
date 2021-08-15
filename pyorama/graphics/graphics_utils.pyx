import subprocess

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

cpdef void utils_runtime_compile_shader(
        bytes in_file_path, 
        bytes out_file_path, 
        ShaderType shader_type, bytes varying_def_path=None, 
        ShaderTargetPlatform target=SHADER_TARGET_PLATFORM_AUTO, 
        ShaderModel model=SHADER_MODEL_AUTO) except *:
    cdef:
        PlatformOS platform_os
        bytes shaderc_path
        list cmd_args
        str shader_type_str = ""
        str target_str = ""
        str model_str = ""
        str error_str

    #find the shaderc executable path
    platform_os = app.c_get_platform_os()
    if platform_os == app.PLATFORM_OS_WINDOWS:
        shaderc_path = b"./pyorama/libs/shared/Windows/shadercRelease.exe"
    elif platform_os == app.PLATFORM_OS_LINUX:
        shaderc_path = b"./pyorama/libs/shared/Linux/shadercRelease"
    elif platform_os == app.PLATFORM_OS_MACOS:
        raise NotImplementedError("Runtime compilation on mac os is not yet supported")
    else:
        raise NotImplementedError("Runtime compilation on this unknown platform is not supported")

    shader_type_str = c_get_shader_type_str(shader_type)
    target_str = c_get_target_str(target)
    model_str = c_get_shader_model_str(model, shader_type)
    
    cmd_args = [
        shaderc_path,
        "-f", in_file_path,
        "-o", out_file_path,
        "--type", shader_type_str,
        "--platform", target_str,
        "--profile", model_str,
    ]
    try:
        subprocess.check_output(cmd_args)
    except subprocess.CalledProcessError as error:
        error_str = error.output.decode("utf-8")
        raise ValueError("ShaderC compilation failed: {0}".format(error_str))
