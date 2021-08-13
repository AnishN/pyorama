#include <bgfx/c99/bgfx.h>

typedef enum ShaderType
{
    SHADER_TYPE_VERTEX,
    SHADER_TYPE_FRAGMENT,
    SHADER_TYPE_COMPUTE,
} ShaderType;

bgfx_memory_t *bgfx_runtime_compile_shader(ShaderType shader_type, char *shader_file_path, char *defines, char *varying_file_path, char *profile)
{
    return NULL;
};