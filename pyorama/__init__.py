import os, platform
library_dirs = {
    "Linux": ["./pyorama/libs/shared/Linux"],
    "Windows": ["./pyorama/libs/shared/Windows"],
}
system = platform.system()
old_path = os.environ["PATH"]
lib_path = os.path.abspath(library_dirs[system][0])
new_path = old_path + os.pathsep + lib_path
os.environ["PATH"] = new_path

from pyorama.app import *