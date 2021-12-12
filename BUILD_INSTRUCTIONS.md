# Build Instructions:

The following instructions are for Ubuntu 21.04. The vast majority of steps should be the same across multiple Linux distros (and even Windows if using mingw64 under msys2 as I am currently). These steps should not be needed if using my pre-built shared libraries though (.dll or .so files). NOTE: for mingw64, using mingw32-make wherever make is listed instead.

First install the basic compilation tools (this IS platform dependent).
```
sudo apt-get install build-essential git cmake libxext-dev
```

Bgfx (with its dependencies and GeNie compile system)
```
sudo apt-get install mesa-common-dev (needed for GL.h header)
git clone https://github.com/bkaradzic/genie.git
git clone https://github.com/bkaradzic/bx.git
git clone https://github.com/bkaradzic/bimg.git
git clone https://github.com/bkaradzic/bgfx.git
cd ./genie
make
cd ../bgfx

#This next step IS platform dependent.
#Below is for linux 64 bit systems. For mingw64, replace with -gcc=mingw-gcc
../genie/bin/linux/genie --with-tools --with-combined-examples --with-shared-lib --gcc=linux-gcc gmake
#For mingw64, replace with make mingw-gcc-release64
make linux-release64

#verify if the examples work
cd ./examples/runtime
../../.build/linux64_gcc/bin/examplesRelease
```

STB nothings libraries (such as stb_image):
```
There is nothing to build (header-only).
```

CGLTF:
```
There is nothing to build (header-only).
```

Chipmunk:
```
git clone https://github.com/slembcke/Chipmunk2D.git
cd ./Chipmunk2D
cmake . -DCMAKE_C_FLAGS="-DCP_USE_DOUBLES=0" -DBUILD_DEMOS=OFF
make
```

Ogg:
```
git clone https://github.com/xiph/ogg.git
cd ./ogg
cmake . -DBUILD_SHARED_LIBS=ON
make
```

Vorbis:
```
git clone https://github.com/xiph/vorbis.git
cd ./vorbis
cmake . -DBUILD_SHARED_LIBS=ON -DOGG_INCLUDE_DIR="../ogg/include" -DOGG_LIBRARY="../ogg/libogg.so"
make
```

Flac:
```
git clone https://github.com/xiph/flac.git
cd ./flac
cmake . -DBUILD_SHARED_LIBS=ON -DOGG_INCLUDE_DIR="../ogg/include" -DOGG_LIBRARY="../ogg/libogg.so"
make
```

Opus:
```
git clone https://github.com/xiph/opus.git
cd ./opus
cmake . -DOPUS_BUILD_SHARED_LIBRARY=ON
make
```

FFmpeg (in LGPLv2.1 style, as portable as possible without assembly code):
```
git clone https://github.com/FFmpeg/FFmpeg.git
cd ./FFmpeg
./configure --disable-x86asm --enable-shared --disable-static
make
```

OpenAL-Soft:
```
git clone https://github.com/kcat/openal-soft.git
cd ./openal-soft
cmake . -DLIBTYPE=SHARED
make
```

SDL2 (and SDL2_image, SDL2_mixer, SDL2_net, but NOT SDL2_ttf)
```
#Using autotools, setting prefix to whereever you need to build your shared library and header files so that they are NOT installed across the system. Replace /home/pyorama/projects/repos/SDL2_all with whatever ABSOLUTE path you would like!

wget https://www.libsdl.org/release/SDL2-2.0.12.zip
wget https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.5.zip
wget https://www.libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.zip
wget https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.1.zip
wget https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.zip
unzip SDL2-2.0.12.zip
unzip SDL2_image-2.0.5.zip
unzip SDL2_mixer-2.0.4.zip
unzip SDL2_net-2.0.1.zip
unzip SDL2_ttf-2.0.15.zip
cd ./SDL2-2.0.12
./configure --prefix=/home/pyorama/projects/repos/SDL2_all
make
make install

cd ./SDL2_image-2.0.5
PKG_CONFIG_PATH=/home/pyorama/projects/repos/SDL2_all/lib/pkgconfig ./configure --prefix=/home/pyorama/projects/repos/SDL2_all
make
make install

cd ./SDL2_mixer-2.0.4
PKG_CONFIG_PATH=/home/pyorama/projects/repos/SDL2_all/lib/pkgconfig ./configure --prefix=/home/pyorama/projects/repos/SDL2_all
make
make install

cd ./SDL2_net-2.0.1
PKG_CONFIG_PATH=/home/pyorama/projects/repos/SDL2_all/lib/pkgconfig ./configure --prefix=/home/pyorama/projects/repos/SDL2_all
make
make install
```

Freetype:
```
wget https://download.savannah.gnu.org/releases/freetype/freetype-2.10.2.tar.gz
tar xzf freetype-2.10.2.tar.gz
cd ./freetype-2.10.2/
./configure --with-png=no --prefix=/home/pyorama/projects/repos/SDL2_all
make
make install
```

SDL2_ttf (freetype needed first):
```
cd ./SDL2_ttf-2.0.15
PKG_CONFIG_PATH=/home/pyorama/projects/repos/SDL2_all/lib/pkgconfig ./configure --prefix=/home/pyorama/projects/repos/SDL2_all
make
make install
```

Harfbuzz:
```
wget https://github.com/harfbuzz/harfbuzz/releases/download/2.7.2/harfbuzz-2.7.2.tar.xz
tar xf harfbuzz-2.7.2.tar.xz
cd ./harfbuzz-2.7.2
./configure
make
```

Assimp:
```
git clone https://github.com/assimp/assimp.git
cd ./assimp
mkdir build
cd ./build
cmake -G "MinGW Makefiles" ../
make
```

CImGUI:
```
git clone --recursive https://github.com/cimgui/cimgui.git
cd ./cimgui
make
```

Basic readme cython code build instructions:
```
sudo apt-get install python3-pip
python3 -m pip install cython setuptools
python3 setup.py build_ext -i
python3 -m pip install -e .
python3 ./examples/cubes.py
```