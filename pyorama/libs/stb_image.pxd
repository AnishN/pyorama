from pyorama.libs.c cimport *

cdef extern from "stb/stb_image.h" nogil:
    char *stbi_load(char *file_path, int *x, int *y, int *num_channels_in_file, int num_desired_channels)
    char *stbi_failure_reason()