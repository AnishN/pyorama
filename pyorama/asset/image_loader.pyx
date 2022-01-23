cdef Error load_image(Handle image, char *file_path, size_t file_path_len, size_t num_channels=4) nogil:
    cdef:
        ImageC *image_ptr
        void *stbi_pixels
        uint8_t *pixels
        int num_channels_in_file
        size_t num_pixel_bytes
        int width
        int height

    image_ptr = <ImageC *>app.graphics.slots.c_get_ptr_unsafe(image)
    stbi_set_flip_vertically_on_load(True)#TODO: move this line elsewhere
    stbi_pixels = stbi_load(<char *>file_path, &width, &height, &num_channels_in_file, num_channels)
    if stbi_pixels == NULL:
        return FILE_ERROR
        #stbi_error = stbi_failure_reason()
        #printf(b"%s\n", stbi_error)
    else:
        num_pixel_bytes = height * width * num_channels
        pixels = <uint8_t *>calloc(num_pixel_bytes, sizeof(uint8_t))
        if pixels == NULL:
            return MEMORY_ERROR
        memcpy(pixels, stbi_pixels, num_pixel_bytes)
        image_ptr.pixels = <uint8_t *>pixels
        image_ptr.width = width
        image_ptr.height = height
        image_ptr.num_channels = num_channels
        free(stbi_pixels)