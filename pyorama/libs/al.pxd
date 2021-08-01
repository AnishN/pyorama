cdef extern from "AL/alc.h" nogil:
    cdef struct ALCdevice_struct
    ctypedef ALCdevice_struct ALCdevice
    cdef struct ALCcontext_struct
    ctypedef ALCcontext_struct ALCcontext
    ctypedef char ALCboolean
    ctypedef char ALCchar
    ctypedef signed char ALCbyte
    ctypedef unsigned char ALCubyte
    ctypedef short ALCshort
    ctypedef unsigned short ALCushort
    ctypedef int ALCint
    ctypedef unsigned int ALCuint
    ctypedef int ALCsizei
    ctypedef int ALCenum
    ctypedef float ALCfloat
    ctypedef double ALCdouble
    ctypedef void ALCvoid
    
    cdef enum: ALC_FALSE
    cdef enum: ALC_TRUE
    cdef enum: ALC_FREQUENCY
    cdef enum: ALC_REFRESH
    cdef enum: ALC_SYNC
    cdef enum: ALC_MONO_SOURCES
    cdef enum: ALC_STEREO_SOURCES
    cdef enum: ALC_NO_ERROR
    cdef enum: ALC_INVALID_DEVICE
    cdef enum: ALC_INVALID_CONTEXT
    cdef enum: ALC_INVALID_ENUM
    cdef enum: ALC_INVALID_VALUE
    cdef enum: ALC_OUT_OF_MEMORY
    cdef enum: ALC_MAJOR_VERSION
    cdef enum: ALC_MINOR_VERSION
    cdef enum: ALC_ATTRIBUTES_SIZE
    cdef enum: ALC_ALL_ATTRIBUTES
    cdef enum: ALC_DEFAULT_DEVICE_SPECIFIER
    cdef enum: ALC_DEVICE_SPECIFIER
    cdef enum: ALC_EXTENSIONS
    cdef enum: ALC_EXT_CAPTURE
    cdef enum: ALC_CAPTURE_DEVICE_SPECIFIER
    cdef enum: ALC_CAPTURE_DEFAULT_DEVICE_SPECIFIER
    cdef enum: ALC_CAPTURE_SAMPLES
    cdef enum: ALC_ENUMERATE_ALL_EXT
    cdef enum: ALC_DEFAULT_ALL_DEVICES_SPECIFIER
    cdef enum: ALC_ALL_DEVICES_SPECIFIER
    
    ALCcontext* alcCreateContext(ALCdevice *device, const ALCint* attrlist)
    ALCboolean alcMakeContextCurrent(ALCcontext *context)
    void alcProcessContext(ALCcontext *context)
    void alcSuspendContext(ALCcontext *context)
    void alcDestroyContext(ALCcontext *context)
    ALCcontext* alcGetCurrentContext()
    ALCdevice* alcGetContextsDevice(ALCcontext *context)
    ALCdevice* alcOpenDevice(const ALCchar *devicename)
    ALCboolean alcCloseDevice(ALCdevice *device)
    ALCenum alcGetError(ALCdevice *device)
    ALCboolean alcIsExtensionPresent(ALCdevice *device, const ALCchar *extname)
    void* alcGetProcAddress(ALCdevice *device, const ALCchar *funcname)
    ALCenum alcGetEnumValue(ALCdevice *device, const ALCchar *enumname)
    const ALCchar* alcGetString(ALCdevice *device, ALCenum param)
    void alcGetIntegerv(ALCdevice *device, ALCenum param, ALCsizei size, ALCint *values)
    ALCdevice* alcCaptureOpenDevice(const ALCchar *devicename, ALCuint frequency, ALCenum format, ALCsizei buffersize)
    ALCboolean alcCaptureCloseDevice(ALCdevice *device)
    void alcCaptureStart(ALCdevice *device)
    void alcCaptureStop(ALCdevice *device)
    void alcCaptureSamples(ALCdevice *device, ALCvoid *buffer, ALCsizei samples)

cdef extern from "AL/al.h" nogil:
    ctypedef char ALboolean
    ctypedef char ALchar
    ctypedef signed char ALbyte
    ctypedef unsigned char ALubyte
    ctypedef short ALshort
    ctypedef unsigned short ALushort
    ctypedef int ALint
    ctypedef unsigned int ALuint
    ctypedef int ALsizei
    ctypedef int ALenum
    ctypedef float ALfloat
    ctypedef double ALdouble
    ctypedef void ALvoid

    cdef enum: AL_NONE
    cdef enum: AL_FALSE
    cdef enum: AL_TRUE
    cdef enum: AL_SOURCE_RELATIVE
    cdef enum: AL_CONE_INNER_ANGLE
    cdef enum: AL_CONE_OUTER_ANGLE
    cdef enum: AL_PITCH
    cdef enum: AL_POSITION
    cdef enum: AL_DIRECTION
    cdef enum: AL_VELOCITY
    cdef enum: AL_LOOPING
    cdef enum: AL_BUFFER
    cdef enum: AL_GAIN
    cdef enum: AL_MIN_GAIN
    cdef enum: AL_MAX_GAIN
    cdef enum: AL_ORIENTATION
    cdef enum: AL_SOURCE_STATE
    cdef enum: AL_INITIAL
    cdef enum: AL_PLAYING
    cdef enum: AL_PAUSED
    cdef enum: AL_STOPPED
    cdef enum: AL_BUFFERS_QUEUED
    cdef enum: AL_BUFFERS_PROCESSED
    cdef enum: AL_REFERENCE_DISTANCE
    cdef enum: AL_ROLLOFF_FACTOR
    cdef enum: AL_CONE_OUTER_GAIN
    cdef enum: AL_MAX_DISTANCE
    cdef enum: AL_SEC_OFFSET
    cdef enum: AL_SAMPLE_OFFSET
    cdef enum: AL_BYTE_OFFSET
    cdef enum: AL_SOURCE_TYPE
    cdef enum: AL_STATIC
    cdef enum: AL_STREAMING
    cdef enum: AL_UNDETERMINED
    cdef enum: AL_FORMAT_MONO8
    cdef enum: AL_FORMAT_MONO16
    cdef enum: AL_FORMAT_STEREO8
    cdef enum: AL_FORMAT_STEREO16
    cdef enum: AL_FREQUENCY
    cdef enum: AL_BITS
    cdef enum: AL_CHANNELS
    cdef enum: AL_SIZE
    cdef enum: AL_UNUSED
    cdef enum: AL_PENDING
    cdef enum: AL_PROCESSED
    cdef enum: AL_NO_ERROR
    cdef enum: AL_INVALID_NAME
    cdef enum: AL_INVALID_ENUM
    cdef enum: AL_INVALID_VALUE
    cdef enum: AL_INVALID_OPERATION
    cdef enum: AL_OUT_OF_MEMORY
    cdef enum: AL_VENDOR
    cdef enum: AL_VERSION
    cdef enum: AL_RENDERER
    cdef enum: AL_EXTENSIONS
    cdef enum: AL_DOPPLER_FACTOR
    cdef enum: AL_DOPPLER_VELOCITY
    cdef enum: AL_SPEED_OF_SOUND
    cdef enum: AL_DISTANCE_MODEL
    cdef enum: AL_INVERSE_DISTANCE
    cdef enum: AL_INVERSE_DISTANCE_CLAMPED
    cdef enum: AL_LINEAR_DISTANCE
    cdef enum: AL_LINEAR_DISTANCE_CLAMPED
    cdef enum: AL_EXPONENT_DISTANCE
    cdef enum: AL_EXPONENT_DISTANCE_CLAMPED

    void alDopplerFactor(ALfloat value)
    void alDopplerVelocity(ALfloat value)
    void alSpeedOfSound(ALfloat value)
    void alDistanceModel(ALenum distanceModel)
    void alEnable(ALenum capability)
    void alDisable(ALenum capability)
    ALboolean alIsEnabled(ALenum capability)
    const ALchar* alGetString(ALenum param)
    void alGetBooleanv(ALenum param, ALboolean *values)
    void alGetIntegerv(ALenum param, ALint *values)
    void alGetFloatv(ALenum param, ALfloat *values)
    void alGetDoublev(ALenum param, ALdouble *values)
    ALboolean alGetBoolean(ALenum param)
    ALint alGetInteger(ALenum param)
    ALfloat alGetFloat(ALenum param)
    ALdouble alGetDouble(ALenum param)
    ALenum alGetError()
    ALboolean alIsExtensionPresent(const ALchar *extname)
    void* alGetProcAddress(const ALchar *fname)
    ALenum alGetEnumValue(const ALchar *ename)
    void alListenerf(ALenum param, ALfloat value)
    void alListener3f(ALenum param, ALfloat value1, ALfloat value2, ALfloat value3)
    void alListenerfv(ALenum param, const ALfloat *values)
    void alListeneri(ALenum param, ALint value)
    void alListener3i(ALenum param, ALint value1, ALint value2, ALint value3)
    void alListeneriv(ALenum param, const ALint *values)
    void alGetListenerf(ALenum param, ALfloat *value)
    void alGetListener3f(ALenum param, ALfloat *value1, ALfloat *value2, ALfloat *value3)
    void alGetListenerfv(ALenum param, ALfloat *values)
    void alGetListeneri(ALenum param, ALint *value)
    void alGetListener3i(ALenum param, ALint *value1, ALint *value2, ALint *value3)
    void alGetListeneriv(ALenum param, ALint *values)
    void alGenSources(ALsizei n, ALuint *sources)
    void alDeleteSources(ALsizei n, const ALuint *sources)
    ALboolean alIsSource(ALuint source)
    void alSourcef(ALuint source, ALenum param, ALfloat value)
    void alSource3f(ALuint source, ALenum param, ALfloat value1, ALfloat value2, ALfloat value3)
    void alSourcefv(ALuint source, ALenum param, const ALfloat *values)
    void alSourcei(ALuint source, ALenum param, ALint value)
    void alSource3i(ALuint source, ALenum param, ALint value1, ALint value2, ALint value3)
    void alSourceiv(ALuint source, ALenum param, const ALint *values)
    void alGetSourcef(ALuint source, ALenum param, ALfloat *value)
    void alGetSource3f(ALuint source, ALenum param, ALfloat *value1, ALfloat *value2, ALfloat *value3)
    void alGetSourcefv(ALuint source, ALenum param, ALfloat *values)
    void alGetSourcei(ALuint source,  ALenum param, ALint *value)
    void alGetSource3i(ALuint source, ALenum param, ALint *value1, ALint *value2, ALint *value3)
    void alGetSourceiv(ALuint source,  ALenum param, ALint *values)
    void alSourcePlayv(ALsizei n, const ALuint *sources)
    void alSourceStopv(ALsizei n, const ALuint *sources)
    void alSourceRewindv(ALsizei n, const ALuint *sources)
    void alSourcePausev(ALsizei n, const ALuint *sources)
    void alSourcePlay(ALuint source)
    void alSourceStop(ALuint source)
    void alSourceRewind(ALuint source)
    void alSourcePause(ALuint source)
    void alSourceQueueBuffers(ALuint source, ALsizei nb, const ALuint *buffers)
    void alSourceUnqueueBuffers(ALuint source, ALsizei nb, ALuint *buffers)
    void alGenBuffers(ALsizei n, ALuint *buffers)
    void alDeleteBuffers(ALsizei n, const ALuint *buffers)
    ALboolean alIsBuffer(ALuint buffer)
    void alBufferData(ALuint buffer, ALenum format, const ALvoid *data, ALsizei size, ALsizei freq)
    void alBufferf(ALuint buffer, ALenum param, ALfloat value)
    void alBuffer3f(ALuint buffer, ALenum param, ALfloat value1, ALfloat value2, ALfloat value3)
    void alBufferfv(ALuint buffer, ALenum param, const ALfloat *values)
    void alBufferi(ALuint buffer, ALenum param, ALint value)
    void alBuffer3i(ALuint buffer, ALenum param, ALint value1, ALint value2, ALint value3)
    void alBufferiv(ALuint buffer, ALenum param, const ALint *values)
    void alGetBufferf(ALuint buffer, ALenum param, ALfloat *value)
    void alGetBuffer3f(ALuint buffer, ALenum param, ALfloat *value1, ALfloat *value2, ALfloat *value3)
    void alGetBufferfv(ALuint buffer, ALenum param, ALfloat *values)
    void alGetBufferi(ALuint buffer, ALenum param, ALint *value)
    void alGetBuffer3i(ALuint buffer, ALenum param, ALint *value1, ALint *value2, ALint *value3)
    void alGetBufferiv(ALuint buffer, ALenum param, ALint *values)
