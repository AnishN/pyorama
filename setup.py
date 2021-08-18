from setuptools import setup, Extension
from Cython.Build import cythonize
import os
import platform
import glob

libraries = {
    "Linux": [
        "bgfx-shared-libRelease",
        #"z", "jpeg", "png", "webp", "jbig85",
        "SDL2", "SDL2_image", "SDL2_mixer", 
        "assimp",
        "chipmunk",
        "openal",
        "FLAC", "opus",
        "ogg", "vorbis", "vorbisfile", "vorbisenc",
	    "freetype", "harfbuzz",
    ],
    "Windows": [
        "bgfx-shared-libRelease", 
        "SDL2main", "SDL2", "SDL2_image", "SDL2_mixer", "SDL2_net",
        "assimp",
        "chipmunk",
        "openal-1",
        "FLAC-8", "opus-0", "opusfile-0", "vorbis-0", "vorbisfile-3",
        "webp-7", 
        "zlib1",
        "freetype-6", "harfbuzz-0",
    ],
}
language = "c"
release_args = ["-w", "-std=c11", "-O3", "-ffast-math", "-march=native"]
debug_args = ["-w", "-std=c11", "-O0"]
#args = debug_args
args = release_args
macros = []

include_dirs = ["./pyorama/libs/include"]
library_dirs = {
    "Linux": ["./pyorama/libs/shared/Linux"],
    "Windows": ["./pyorama/libs/shared/Windows"],
}
annotate = True
quiet = False
directives = {
    "binding": True,
    "boundscheck": False,
    "cdivision": True,
    "initializedcheck": False,
    "language_level": "3",
    "nonecheck": False,
    "wraparound": False,
}

if __name__ == "__main__":
    system = platform.system()
    old_path = os.environ["PATH"]
    os.environ["PATH"] = old_path + os.pathsep + library_dirs[system][0]
    
    libs = libraries[system]
    lib_dirs = library_dirs[system]
    extensions = []
    ext_modules = []

    #create extensions
    for path, dirs, file_names in os.walk("."):
        for file_name in file_names:
            if file_name.endswith("pyx"):
                ext_path = "{0}/{1}".format(path, file_name)
                ext_name = ext_path \
                    .replace("./", "") \
                    .replace("/", ".") \
                    .replace(".pyx", "")
                ext = Extension(
                    name=ext_name, 
                    sources=[ext_path], 
                    libraries=libs,
                    language=language,
                    extra_compile_args=args,
                    include_dirs=include_dirs,
                    library_dirs=lib_dirs,
                    runtime_library_dirs=lib_dirs,
                    define_macros=macros,
                )
                extensions.append(ext)
    
    #setup all extensions
    ext_modules = cythonize(
        extensions, 
        annotate=annotate, 
        compiler_directives=directives,
        quiet=quiet,
        #gdb_debug=True
    )

    setup(
        ext_modules=ext_modules,
    )

    os.environ["PATH"] = old_path
