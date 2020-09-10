# pyorama
A performant game engine written in cython

This library has the following dependencies:
* Graphics: 
    * SDL2 (with SDL2_image and SDL2_mixer)
    * OpenGLES2
    * Assimp
* Audio:
    * OpenAL
    * Ogg/Vorbis
    * Opus
    * FLAC
* Physics:
    * Chipmunk

## Installation instructions (Linux only):
The above C library dependencies are included in the repository as .so (shared library) files.
These were built in CentOS 7, so they should be compatible with manylinux2014.
Working on getting Windows and OSX builds (which will be needed for convenient wheels).

Install manually as follows:
> git clone https://github.com/AnishN/pyorama.git
> cd ./pyorama
> python3 setup.py build_ext -i -q -f

Install the library as a development library using pip:
> python3 -m pip install -e . --user

Once this process is complete, you can run files in the example folder as follows:
> python3 ./examples/sprite_test.py