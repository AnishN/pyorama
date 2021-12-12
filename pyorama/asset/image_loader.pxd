from pyorama.app cimport *
from pyorama.core.error cimport *
from pyorama.data.handle cimport *
from pyorama.graphics.image cimport *
from pyorama.libs.c cimport *
from pyorama.libs.stb_image cimport *

cdef Error load_image(Handle image, char *file_path, size_t file_path_len, size_t num_channels=*) nogil