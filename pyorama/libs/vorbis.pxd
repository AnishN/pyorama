from libc.stdint cimport int8_t, int16_t, int32_t, int64_t
from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t
from libc.stdio cimport *
from pyorama.libs.ogg cimport *

cdef extern from "vorbis/codec.h" nogil:
    
    ctypedef struct vorbis_info:
        int version
        int channels
        long rate
        long bitrate_upper
        long bitrate_nominal
        long bitrate_lower
        long bitrate_window
        void *codec_setup

    ctypedef struct vorbis_dsp_state:
        int analysisp
        vorbis_info *vi
        float **pcm
        float **pcmret
        int pcm_storage
        int pcm_current
        int pcm_returned
        int preextrapolate
        int eofflag
        long lW
        long W
        long nW
        long centerW
        ogg_int64_t granulepos
        ogg_int64_t sequence
        ogg_int64_t glue_bits
        ogg_int64_t time_bits
        ogg_int64_t floor_bits
        ogg_int64_t res_bits
        void *backend_state
    
    ctypedef struct vorbis_block:
        float **pcm
        oggpack_buffer opb
        long lW
        long W
        long nW
        int pcmend
        int mode
        int eofflag
        ogg_int64_t granulepos
        ogg_int64_t sequence
        vorbis_dsp_state *vd
        void *localstore
        long localtop
        long localalloc
        long totaluse
        alloc_chain *reap
        long glue_bits
        long time_bits
        long floor_bits
        long res_bits
        void *internal
    
    ctypedef struct alloc_chain
    ctypedef struct alloc_chain:
        void *ptr
        alloc_chain *next

    ctypedef struct vorbis_comment:
        char **user_comments
        int *comment_lengths
        int comments
        char *vendor
    
    void vorbis_info_init(vorbis_info *vi)
    void vorbis_info_clear(vorbis_info *vi)
    int vorbis_info_blocksize(vorbis_info *vi, int zo)

    void vorbis_comment_init(vorbis_comment *vc)
    void vorbis_comment_add(vorbis_comment *vc, const char *comment)
    void vorbis_comment_add_tag(vorbis_comment *vc, const char *tag, const char *contents)
    char *vorbis_comment_query(vorbis_comment *vc, const char *tag, int count)
    int vorbis_comment_query_count(vorbis_comment *vc, const char *tag)
    void vorbis_comment_clear(vorbis_comment *vc)

    int vorbis_block_init(vorbis_dsp_state *v, vorbis_block *vb)
    int vorbis_block_clear(vorbis_block *vb)
    void vorbis_dsp_clear(vorbis_dsp_state *v)
    double vorbis_granule_time(vorbis_dsp_state *v, ogg_int64_t granulepos)

    const char *vorbis_version_string()

    int vorbis_analysis_init(vorbis_dsp_state *v, vorbis_info *vi)
    int vorbis_commentheader_out(vorbis_comment *vc, ogg_packet *op)
    int vorbis_analysis_headerout(vorbis_dsp_state *v, vorbis_comment *vc, ogg_packet *op, ogg_packet *op_comm, ogg_packet *op_code)
    float **vorbis_analysis_buffer(vorbis_dsp_state *v, int vals)
    int vorbis_analysis_wrote(vorbis_dsp_state *v, int vals)
    int vorbis_analysis_blockout(vorbis_dsp_state *v, vorbis_block *vb)
    int vorbis_analysis(vorbis_block *vb, ogg_packet *op)
    int vorbis_bitrate_addblock(vorbis_block *vb)
    int vorbis_bitrate_flushpacket(vorbis_dsp_state *vd, ogg_packet *op)

    int vorbis_synthesis_idheader(ogg_packet *op)
    int vorbis_synthesis_headerin(vorbis_info *vi, vorbis_comment *vc, ogg_packet *op)

    int vorbis_synthesis_init(vorbis_dsp_state *v, vorbis_info *vi)
    int vorbis_synthesis_restart(vorbis_dsp_state *v)
    int vorbis_synthesis(vorbis_block *vb, ogg_packet *op)
    int vorbis_synthesis_trackonly(vorbis_block *vb, ogg_packet *op)
    int vorbis_synthesis_blockin(vorbis_dsp_state *v, vorbis_block *vb)
    int vorbis_synthesis_pcmout(vorbis_dsp_state *v, float ***pcm)
    int vorbis_synthesis_lapout(vorbis_dsp_state *v, float ***pcm)
    int vorbis_synthesis_read(vorbis_dsp_state *v, int samples)
    long vorbis_packet_blocksize(vorbis_info *vi, ogg_packet *op)

    int vorbis_synthesis_halfrate(vorbis_info *v, int flag)
    int vorbis_synthesis_halfrate_p(vorbis_info *v)

    cdef enum:
        OV_FALSE
        OV_EOF
        OV_HOLE
        OV_EREAD
        OV_EFAULT
        OV_EIMPL
        OV_EINVAL
        OV_ENOTVORBIS
        OV_EBADHEADER
        OV_EVERSION
        OV_ENOTAUDIO
        OV_EBADPACKET
        OV_EBADLINK
        OV_ENOSEEK
        
cdef extern from "vorbis/vorbisenc.h" nogil:
    int vorbis_encode_init(vorbis_info *vi, long channels, long rate, long max_bitrate, long nominal_bitrate, long min_bitrate)
    int vorbis_encode_setup_managed(vorbis_info *vi, long channels, long rate, long max_bitrate, long nominal_bitrate, long min_bitrate)
    int vorbis_encode_setup_vbr(vorbis_info *vi, long channels, long rate, float quality)
    int vorbis_encode_init_vbr(vorbis_info *vi, long channels, long rate, float base_quality)
    int vorbis_encode_setup_init(vorbis_info *vi)
    int vorbis_encode_ctl(vorbis_info *vi, int number, void *arg)

    ctypedef struct ovectl_ratemanage_arg:
        int management_active
        long bitrate_hard_min
        long bitrate_hard_max
        double bitrate_hard_window
        long bitrate_av_lo
        long bitrate_av_hi
        double bitrate_av_window
        double bitrate_av_window_center

    ctypedef struct ovectl_ratemanage2_arg:
        int management_active
        long bitrate_limit_min_kbps
        long bitrate_limit_max_kbps
        long bitrate_limit_reservoir_bits
        double bitrate_limit_reservoir_bias
        long bitrate_average_kbps
        double bitrate_average_damping

    cdef enum:
        OV_ECTL_RATEMANAGE2_GET
        OV_ECTL_RATEMANAGE2_SET
        OV_ECTL_LOWPASS_GET
        OV_ECTL_LOWPASS_SET
        OV_ECTL_IBLOCK_GET
        OV_ECTL_IBLOCK_SET
        OV_ECTL_COUPLING_GET
        OV_ECTL_COUPLING_SET
        OV_ECTL_RATEMANAGE_GET
        OV_ECTL_RATEMANAGE_SET
        OV_ECTL_RATEMANAGE_AVG
        OV_ECTL_RATEMANAGE_HARD
        
cdef extern from "vorbis/vorbisfile.h" nogil:
    
    ctypedef struct ov_callbacks:
        size_t (*read_func) (void *ptr, size_t size, size_t nmemb, void *datasource)
        int (*seek_func) (void *datasource, ogg_int64_t offset, int whence)
        int (*close_func) (void *datasource)
        long (*tell_func) (void *datasource)
    
    cdef ov_callbacks OV_CALLBACKS_DEFAULT
    cdef ov_callbacks OV_CALLBACKS_NOCLOSE
    cdef ov_callbacks OV_CALLBACKS_STREAMONLY
    cdef ov_callbacks OV_CALLBACKS_STREAMONLY_NOCLOSE
    
    cdef enum:
        NOTOPEN
        PARTOPEN
        OPENED
        STREAMSET
        INITSET

    ctypedef struct OggVorbis_File:
        void *datasource
        int seekable
        ogg_int64_t offset
        ogg_int64_t end
        ogg_sync_state oy
        int links
        ogg_int64_t *offsets
        ogg_int64_t *dataoffsets
        long *serialnos
        ogg_int64_t *pcmlengths
        vorbis_info *vi
        vorbis_comment *vc
        ogg_int64_t pcm_offset
        int ready_state
        long current_serialno
        int current_link
        double bittrack
        double samptrack
        ogg_stream_state os
        vorbis_dsp_state vd
        vorbis_block vb
        ov_callbacks callbacks

    int ov_clear(OggVorbis_File *vf)
    int ov_fopen(const char *path, OggVorbis_File *vf)
    int ov_open(FILE *f, OggVorbis_File *vf, const char *initial, long ibytes)
    int ov_open_callbacks(void *datasource, OggVorbis_File *vf, const char *initial, long ibytes, ov_callbacks callbacks)
                    
    int ov_test(FILE *f, OggVorbis_File *vf, const char *initial, long ibytes)
    int ov_test_callbacks(void *datasource, OggVorbis_File *vf, const char *initial, long ibytes, ov_callbacks callbacks)
    int ov_test_open(OggVorbis_File *vf)

    long ov_bitrate(OggVorbis_File *vf, int i)
    long ov_bitrate_instant(OggVorbis_File *vf)
    long ov_streams(OggVorbis_File *vf)
    long ov_seekable(OggVorbis_File *vf)
    long ov_serialnumber(OggVorbis_File *vf, int i)

    ogg_int64_t ov_raw_total(OggVorbis_File *vf, int i)
    ogg_int64_t ov_pcm_total(OggVorbis_File *vf, int i)
    double ov_time_total(OggVorbis_File *vf, int i)

    int ov_raw_seek(OggVorbis_File *vf, ogg_int64_t pos)
    int ov_pcm_seek(OggVorbis_File *vf, ogg_int64_t pos)
    int ov_pcm_seek_page(OggVorbis_File *vf, ogg_int64_t pos)
    int ov_time_seek(OggVorbis_File *vf, double pos)
    int ov_time_seek_page(OggVorbis_File *vf, double pos)

    int ov_raw_seek_lap(OggVorbis_File *vf, ogg_int64_t pos)
    int ov_pcm_seek_lap(OggVorbis_File *vf, ogg_int64_t pos)
    int ov_pcm_seek_page_lap(OggVorbis_File *vf, ogg_int64_t pos)
    int ov_time_seek_lap(OggVorbis_File *vf, double pos)
    int ov_time_seek_page_lap(OggVorbis_File *vf, double pos)

    ogg_int64_t ov_raw_tell(OggVorbis_File *vf)
    ogg_int64_t ov_pcm_tell(OggVorbis_File *vf)
    double ov_time_tell(OggVorbis_File *vf)

    vorbis_info *ov_info(OggVorbis_File *vf, int link)
    vorbis_comment *ov_comment(OggVorbis_File *vf, int link)

    long ov_read_float(OggVorbis_File *vf, float ***pcm_channels, int samples, int *bitstream)
    long ov_read_filter(OggVorbis_File *vf, char *buffer, int length, int bigendianp, int word, int sgned, int *bitstream, 
        void (*filter)(float **pcm, long channels, long samples, void *filter_param), void *filter_param)
    long ov_read(OggVorbis_File *vf, char *buffer, int length, int bigendianp, int word, int sgned, int *bitstream)
    int ov_crosslap(OggVorbis_File *vf1, OggVorbis_File *vf2)

    int ov_halfrate(OggVorbis_File *vf, int flag)
    int ov_halfrate_p(OggVorbis_File *vf)