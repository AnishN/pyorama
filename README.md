# pyorama
A performant game engine written in cython

This library has the following dependencies:
* Graphics: 
    * Bgfx (for cross-platform rendering)
    * SDL2 (for window creation, including sub-dependencies such as SDL2_image, SDL2_mixer, SDL2_net, and SDL2_ttf)
    * Assimp (for 3d mesh/asset loading)
    * Freetype and Harfbuzz (for planned text rendering)
    * Dear ImGUI (cimgui specifically, for debug UI rendering)
* Audio:
    * OpenAL (for planned 3d spatial audio)
    * Ogg/Vorbis, Opus, FLAC (for planned audio file loading)
* Physics:
    * Chipmunk (for planned 2d physics)

## Installation instructions:
The above C library dependencies are included in the repository as .so (shared library) files.
The libraries were built on both Windows 10 and Ubuntu 21.04. Work-in-progress build instructions can be found in BUILD_INSTRUCTIONS.md.
Working on getting OSX builds as well as (eventually) convenient .whl files.
Cython and setuptools are needed to build the cython portion of the code.

Install manually as follows:
```
git clone https://github.com/AnishN/pyorama.git
cd ./pyorama
python3 setup.py build_ext -i -q
```

Install the library as a development library using pip:
```
python3 -m pip install -e . --user
```

Once this process is complete, you can run files in the example folder as follows:
```
python3 ./examples/cubes.py
```