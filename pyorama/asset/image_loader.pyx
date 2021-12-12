cdef Error load_image(Handle image, char *file_path, size_t file_path_len, size_t num_channels=4) nogil:
    cdef:
        ImageC *image_ptr
        void *pixels
        int width
        int height
        int int_num_chal

    image_ptr = <ImageC *>app.graphics.slots.c_get_ptr_unsafe(image)
    pixels = stbi_load(<char *>file_path, &width, &height, <int *>&num_channels, 0)#int *num_channels_in_file, int num_desired_channels)
    if pixels == NULL:
        stbi_error = stbi_failure_reason()
        printf(b"%s\n", stbi_error)
    else:
        image_ptr.pixels = <uint8_t *>pixels
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.bytes_per_pixel = num_channels
    #print(file_path, width, height, num_channels)