cdef ImageC *image_get_ptr(Handle image) except *:
    return <ImageC *>graphics.slots.c_get_ptr(image)

cpdef Handle image_create_from_file(bytes file_path) except *:
    cdef:
        Handle image
        ImageC *image_ptr
        SDL_Surface *surface
        SDL_Surface *converted_surface
        size_t pixels_size
        uint8_t *sdl_pixels

    image = graphics.slots.c_create(GRAPHICS_SLOT_IMAGE)
    image_ptr = image_get_ptr(image)

    surface = IMG_Load(file_path)
    if surface == NULL:
        raise ValueError("Image: {0}".format(IMG_GetError().decode("utf-8")))
    converted_surface = SDL_ConvertSurfaceFormat(surface, SDL_PIXELFORMAT_RGBA32, 0)
    if converted_surface == NULL:
        raise ValueError("Image: cannot convert to RGBA format")
    image_ptr.width = converted_surface.w
    image_ptr.height = converted_surface.h
    pixels_size = image_ptr.width * image_ptr.height * 4
    image_ptr.pixels = <uint8_t *>calloc(pixels_size, sizeof(uint8_t))
    if image_ptr.pixels == NULL:
        raise MemoryError("Image: cannot allocate pixels")
    sdl_pixels  = <uint8_t *>converted_surface.pixels
    memcpy(image_ptr.pixels, sdl_pixels, pixels_size)
    SDL_FreeSurface(surface)
    SDL_FreeSurface(converted_surface)
    return image

cpdef void image_delete(Handle image) except *:
    cdef:
        ImageC *image_ptr

    image_ptr = image_get_ptr(image)
    free(image_ptr.pixels); image_ptr.pixels = NULL
    image_ptr.width = 0
    image_ptr.height = 0

cpdef void image_flip_x(Handle image) except *:
    cdef:
        ImageC *image_ptr
        uint8_t *pixels
        uint32_t width, height
        size_t src, dst
        size_t y
        uint32_t left, right
    
    image_ptr = image_get_ptr(image)
    pixels = image_ptr.pixels
    width = image_ptr.width
    height = image_ptr.height
    for y in range(height):
        left = 0
        right = width - 1
        while left < right:
            src = y * width + left
            dst = y * width + right
            pixels[src], pixels[dst] = pixels[dst], pixels[src]
            left += 1
            right -= 1

cpdef void image_flip_y(Handle image) except *:
    cdef:
        ImageC *image_ptr
        uint8_t *pixels
        uint32_t width, height
        size_t src, dst
        size_t x
        uint32_t top, bottom

    image_ptr = image_get_ptr(image)
    pixels = image_ptr.pixels
    width = image_ptr.width
    height = image_ptr.height
    for x in range(width):
        top = 0
        bottom = height - 1
        while top < bottom:
            src = top * width + x
            dst = bottom * width + x
            pixels[src], pixels[dst] = pixels[dst], pixels[src]
            top += 1
            bottom -= 1

cpdef void image_premultiply_alpha(Handle image) except *:
    cdef:
        ImageC *image_ptr
        uint8_t *pixels
        uint32_t width, height
        size_t i

    image_ptr = image_get_ptr(image)
    pixels = image_ptr.pixels
    width = image_ptr.width
    height = image_ptr.height
    for i in range(0, width * height * 4, 4):
        pixels[i] = pixels[i] * pixels[i + 3] / 255
        pixels[i + 1] = pixels[i + 1] * pixels[i + 3] / 255
        pixels[i + 2] = pixels[i + 2] * pixels[i + 3] / 255