from pyorama cimport app
from pyorama.graphics.shader cimport *

cpdef enum ShaderTargetPlatform:
    SHADER_TARGET_PLATFORM_AUTO
    SHADER_TARGET_PLATFORM_ANDROID
    SHADER_TARGET_PLATFORM_ASM_JS
    SHADER_TARGET_PLATFORM_IOS
    SHADER_TARGET_PLATFORM_LINUX
    SHADER_TARGET_PLATFORM_ORBIS
    SHADER_TARGET_PLATFORM_MACOS
    SHADER_TARGET_PLATFORM_WINDOWS

cpdef enum ShaderModel:
    SHADER_MODEL_AUTO
    SHADER_MODEL_ES_100
    SHADER_MODEL_ES_300
    SHADER_MODEL_ES_310
    SHADER_MODEL_ES_320
    SHADER_MODEL_HLSL_3_0
    SHADER_MODEL_HLSL_4_0
    SHADER_MODEL_HLSL_5_0
    SHADER_MODEL_METAL
    SHADER_MODEL_PSSL
    SHADER_MODEL_SPIRV_13_11
    SHADER_MODEL_SPIRV_14_11
    SHADER_MODEL_SPIRV_15_12
    SHADER_MODEL_SPIRV_10_10
    SHADER_MODEL_SPIRV
    SHADER_MODEL_GLSL_120
    SHADER_MODEL_GLSL_130
    SHADER_MODEL_GLSL_140
    SHADER_MODEL_GLSL_150
    SHADER_MODEL_GLSL_330
    SHADER_MODEL_GLSL_400
    SHADER_MODEL_GLSL_410
    SHADER_MODEL_GLSL_420
    SHADER_MODEL_GLSL_430
    SHADER_MODEL_GLSL_440

cpdef void utils_runtime_compile_shader(
        bytes in_file_path, 
        bytes out_file_path, 
        ShaderType shader_type, bytes varying_def_path=*, 
        ShaderTargetPlatform target=*, 
        ShaderModel model=*) except *