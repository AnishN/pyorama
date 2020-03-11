from setuptools import setup, Extension, find_packages
from Cython.Build import cythonize
import numpy as np
import os
import shutil
import platform

libraries = {
    "Linux": [
        "GL", "GLU", "GLEW", 
        "SDL2", "SDL2_image", "SDL2_mixer", 
        "openal", 
        "ogg", "vorbis", "vorbisfile", "vorbisenc",
        "opusfile", "FLAC", "chipmunk", "assimp",
    ],
    "Windows": [
        "opengl32", "libglew32", 
        "SDL2", "SDL2_image", "SDL2_mixer", 
        "openal",
    ],
}
language = "c"
args = ["-w", "-std=c11", "-O3", "-ffast-math", "-march=native", "-fno-var-tracking-assignments"]
link_args = ["-std=c11"]
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
    #"c_string_type": "unicode",
    #"c_string_encoding": "utf-8",
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
                    extra_link_args=link_args,
                    include_dirs = [np.get_include()],
                )
                extensions.append(ext)
    
    #setup all extensions
    ext_modules = cythonize(
        extensions, 
        annotate=annotate, 
        compiler_directives=directives,
        quiet=quiet
    )
    setup(
        name="pyorama",
        packages=find_packages(),
        version="0.0.1",
        license="MIT",
        description="A performant game engine written in cython.",
        author="Anish Narayanan",
        author_email="anish.narayanan32@gmail.com",
        url="https://github.com/AnishN/pyorama",
        download_url="https://github.com/AnishN/pyorama/archive/v0.0.1.tar.gz",
        keywords=["game", "2D", "3D", "rendering", "cython", "performance"],
        install_requires=[],
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