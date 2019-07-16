cdef class CompArray:
    
    cpdef void init(self, size_t max_items, size_t item_size, bytes item_format) except *:
        self.max_items = max_items
        self.item_size = item_size
        self.item_format = item_format
        self.items = calloc(self.max_items, self.item_size)
        if self.items == NULL:
            raise MemoryError("CompArray: cannot allocate memory")
    
    cpdef void free(self):
        self.max_items = 0
        self.item_size = 0
        self.item_format = b""
        free(self.items)
        self.items = NULL

    def __getbuffer__(self, Py_buffer *buffer, int flags):
        buffer.buf = <char *>self.items
        buffer.format = self.item_format
        buffer.internal = NULL
        buffer.itemsize = self.item_size
        buffer.len = self.max_items * self.item_size
        buffer.ndim = 1
        buffer.obj = self
        buffer.readonly = 0
        buffer.shape = <Py_ssize_t *>&self.max_items
        buffer.strides = <Py_ssize_t *>&self.item_size
        buffer.suboffsets = NULL
    
    def __releasebuffer__(self, Py_buffer *buffer):
        pass
    
    cdef void *c_get_ptr(self, size_t i=0) nogil:
        return self.items + (i * self.item_size)
    
    cdef void c_get(self, size_t i, void *item) nogil:
        memcpy(item, self.c_get_ptr(i), self.item_size)
        
    cdef void c_set(self, size_t i, void *item) nogil:
        memcpy(self.c_get_ptr(i), item, self.item_size)
    
    cdef void c_swap(self, size_t a, size_t b) nogil:
        cdef:
            char *a_ptr
            char *b_ptr
            size_t i
        
        a_ptr = <char *>self.c_get_ptr(a)
        b_ptr = <char *>self.c_get_ptr(b)
        for i in range(self.item_size):
            a_ptr[i], b_ptr[i] = b_ptr[i], a_ptr[i]
        
    cdef void c_clear(self, size_t i) nogil:
        memset(self.c_get_ptr(i), 0, self.item_size)
        
    cdef void c_clear_all(self) nogil:
        memset(self.items, 0, self.max_items * self.item_size)
