from setuptools import setup, Extension, find_packages
from Cython.Build import cythonize
import numpy as np
import os
import shutil
import platform

"""
/usr/bin/ld: cannot find -lGLESv2 (libgles2-mesa-dev)
/usr/bin/ld: cannot find -lSDL2 (libsdl2-dev)
/usr/bin/ld: cannot find -lSDL2_image (libsdl2-image-dev)
/usr/bin/ld: cannot find -lSDL2_mixer (libsdl2-mixer-dev)
/usr/bin/ld: cannot find -lopenal (libopenal-dev)
/usr/bin/ld: cannot find -logg (libogg-dev)
/usr/bin/ld: cannot find -lvorbis (libvorbis-dev)
/usr/bin/ld: cannot find -lvorbisfile (libvorbis-dev)
/usr/bin/ld: cannot find -lvorbisenc (libvorbis-dev)
/usr/bin/ld: cannot find -lopus (libopus-dev)
/usr/bin/ld: cannot find -lFLAC (libflac-dev)
/usr/bin/ld: cannot find -lchipmunk (chipmunk-dev)
/usr/bin/ld: cannot find -lassimp (libassimp-dev)
"""

libraries = {
    "Linux": [
        "GLESv2",
        "z", "jpeg", "png", "webp", "jbig",     
        "SDL2", "SDL2_image", "SDL2_mixer",
        "openal",
        "ogg", 
        "vorbis", "vorbisfile", "vorbisenc",
        "opus", 
        "FLAC", 
        "assimp",
        "chipmunk",
    ],
    "Windows": [
        "opengl32", "libglew32", 
        "SDL2", "SDL2_image", "SDL2_mixer", 
        "openal",
    ],
}
language = "c"
args = ["-w", "-std=c11", "-O3", "-ffast-math", "-march=native"]
include_dirs = [np.get_include(), "./pyorama/libs/include"]
library_dirs = ["./pyorama/libs/shared"]
annotate = True
quiet = False
directives = {
    "binding": True,
    "boundscheck": False,
    "wraparound": False,
    "initializedcheck": False,
    "cdivision": True,
    "nonecheck": False,
    "language_level": "3",
}

if __name__ == "__main__":
    system = platform.system()
    libs = libraries[system]
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
                    library_dirs=library_dirs,
                    runtime_library_dirs=library_dirs,
                )
                extensions.append(ext)
    
    #setup all extensions
    ext_modules = cythonize(
        extensions, 
        annotate=annotate, 
        compiler_directives=directives,
        quiet=quiet
    )
    
    #setup all data files
    data_files = {}
    for path, dirs, file_names in os.walk("./resources"):
        if file_names != []:
            data_files[path] = file_names

    setup(
        name="pyorama",
        description="A performant game engine written in cython.",
        version="0.0.2",
        license="MIT",
        url="https://github.com/AnishN/pyorama",
        project_urls={
            "Source Code": "https://github.com/AnishN/pyorama",
        },
        #download_url="https://github.com/AnishN/pyorama/archive/v0.0.2.tar.gz",
        author="Anish Narayanan",
        author_email="anish.narayanan32@gmail.com",
        install_requires=["cython", "numpy", "setuptools"],
        packages=find_packages(),
        package_data=data_files,
        keywords=["game", "2D", "3D", "rendering", "cython", "performance"],
        classifiers=[
            "Development Status :: 3 - Alpha",
            "Intended Audience :: Developers",
            "Topic :: Games/Entertainment",
            "Topic :: Multimedia :: Graphics :: 3D Rendering",
            "Topic :: Multimedia :: Graphics",
            "License :: OSI Approved :: MIT License",
            "Programming Language :: Python :: 3",
        ],
        ext_modules=ext_modules,
    )
