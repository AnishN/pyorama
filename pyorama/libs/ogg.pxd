from libc.stdint cimport int8_t, int16_t, int32_t, int64_t
from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t

cdef extern from "ogg/ogg.h" nogil:
    ctypedef int64_t ogg_int64_t
    
    ctypedef struct ogg_iovec_t:
        void *iov_base
        size_t iov_len
        
    ctypedef struct oggpack_buffer:
        long endbyte
        int  endbit
        unsigned char *buffer
        unsigned char *ptr
        long storage

    ctypedef struct ogg_page:
        unsigned char *header
        long header_len
        unsigned char *body
        long body_len
    
    ctypedef struct ogg_stream_state:
        unsigned char *body_data
        long body_storage
        long body_fill
        long body_returned
        int *lacing_vals
        ogg_int64_t *granule_vals
        long lacing_storage
        long lacing_fill
        long lacing_packet
        long lacing_returned
        unsigned char header[282]
        int header_fill
        int e_o_s
        int b_o_s
        long serialno
        long pageno
        ogg_int64_t packetno
        ogg_int64_t granulepos
    
    ctypedef struct ogg_packet:
        unsigned char *packet
        long bytes
        long b_o_s
        long e_o_s
        ogg_int64_t granulepos
        ogg_int64_t packetno
    
    ctypedef struct ogg_sync_state:
        unsigned char *data
        int storage
        int fill
        int returned
        int unsynced
        int headerbytes
        int bodybytes
    
    void oggpack_writeinit(oggpack_buffer *b)
    int oggpack_writecheck(oggpack_buffer *b)
    void oggpack_writetrunc(oggpack_buffer *b, long bits)
    void oggpack_writealign(oggpack_buffer *b)
    void oggpack_writecopy(oggpack_buffer *b,void *source, long bits)
    void oggpack_reset(oggpack_buffer *b)
    void oggpack_writeclear(oggpack_buffer *b)
    void oggpack_readinit(oggpack_buffer *b, unsigned char *buf, int bytes)
    void oggpack_write(oggpack_buffer *b, unsigned long value, int bits)
    long oggpack_look(oggpack_buffer *b, int bits)
    long oggpack_look1(oggpack_buffer *b)
    void oggpack_adv(oggpack_buffer *b, int bits)
    void oggpack_adv1(oggpack_buffer *b)
    long oggpack_read(oggpack_buffer *b, int bits)
    long oggpack_read1(oggpack_buffer *b)
    long oggpack_bytes(oggpack_buffer *b)
    long oggpack_bits(oggpack_buffer *b)
    unsigned char *oggpack_get_buffer(oggpack_buffer *b)

    void oggpackB_writeinit(oggpack_buffer *b)
    int oggpackB_writecheck(oggpack_buffer *b)
    void oggpackB_writetrunc(oggpack_buffer *b, long bits)
    void oggpackB_writealign(oggpack_buffer *b)
    void oggpackB_writecopy(oggpack_buffer *b, void *source, long bits)
    void oggpackB_reset(oggpack_buffer *b)
    void oggpackB_writeclear(oggpack_buffer *b)
    void oggpackB_readinit(oggpack_buffer *b, unsigned char *buf, int bytes)
    void oggpackB_write(oggpack_buffer *b, unsigned long value,int bits)
    long oggpackB_look(oggpack_buffer *b, int bits)
    long oggpackB_look1(oggpack_buffer *b)
    void oggpackB_adv(oggpack_buffer *b, int bits)
    void oggpackB_adv1(oggpack_buffer *b)
    long oggpackB_read(oggpack_buffer *b, int bits)
    long oggpackB_read1(oggpack_buffer *b)
    long oggpackB_bytes(oggpack_buffer *b)
    long oggpackB_bits(oggpack_buffer *b)
    unsigned char *oggpackB_get_buffer(oggpack_buffer *b)

    int ogg_stream_packetin(ogg_stream_state *os, ogg_packet *op)
    int ogg_stream_iovecin(ogg_stream_state *os, ogg_iovec_t *iov, int count, long e_o_s, ogg_int64_t granulepos)
    int ogg_stream_pageout(ogg_stream_state *os, ogg_page *og)
    int ogg_stream_pageout_fill(ogg_stream_state *os, ogg_page *og, int nfill)
    int ogg_stream_flush(ogg_stream_state *os, ogg_page *og)
    int ogg_stream_flush_fill(ogg_stream_state *os, ogg_page *og, int nfill)

    int ogg_sync_init(ogg_sync_state *oy)
    int ogg_sync_clear(ogg_sync_state *oy)
    int ogg_sync_reset(ogg_sync_state *oy)
    int ogg_sync_destroy(ogg_sync_state *oy)
    int ogg_sync_check(ogg_sync_state *oy)

    char *ogg_sync_buffer(ogg_sync_state *oy, long size)
    int ogg_sync_wrote(ogg_sync_state *oy, long bytes)
    long ogg_sync_pageseek(ogg_sync_state *oy,ogg_page *og)
    int ogg_sync_pageout(ogg_sync_state *oy, ogg_page *og)
    int ogg_stream_pagein(ogg_stream_state *os, ogg_page *og)
    int ogg_stream_packetout(ogg_stream_state *os,ogg_packet *op)
    int ogg_stream_packetpeek(ogg_stream_state *os,ogg_packet *op)

    int ogg_stream_init(ogg_stream_state *os, int serialno)
    int ogg_stream_clear(ogg_stream_state *os)
    int ogg_stream_reset(ogg_stream_state *os)
    int ogg_stream_reset_serialno(ogg_stream_state *os, int serialno)
    int ogg_stream_destroy(ogg_stream_state *os)
    int ogg_stream_check(ogg_stream_state *os)
    int ogg_stream_eos(ogg_stream_state *os)

    void ogg_page_checksum_set(ogg_page *og)

    int ogg_page_version(const ogg_page *og)
    int ogg_page_continued(const ogg_page *og)
    int ogg_page_bos(const ogg_page *og)
    int ogg_page_eos(const ogg_page *og)
    ogg_int64_t ogg_page_granulepos(const ogg_page *og)
    int ogg_page_serialno(const ogg_page *og)
    long ogg_page_pageno(const ogg_page *og)
    int ogg_page_packets(const ogg_page *og)

    void ogg_packet_clear(ogg_packet *op)