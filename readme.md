# pyorama
A performant game engine written in cython

This library has the following dependencies:
* SDL2
* OpenGL (including GLEW, excluding GLUT)
* OpenAL
* Assimp
* Chipmunk
* Ogg/Vorbis
* xxhash (not actually used at this point)

## Installation instructions (for Ubuntu):
The above dependencies need to be installed. The following commands should be able to accomplish this:
> sudo apt-get install libsdl2-dev mesa-utils glew-utils libglew-dev libopenal-dev libassimp4 chipmunk-dev libogg-dev libvorbis-dev

Then download the repository (git clone).
Then compile the repository with the following command:
> python3 setup.py build_ext -i

Once this process is complete, you can run the example file using the following:
> python3 main.py
