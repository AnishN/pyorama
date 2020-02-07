from pyorama.math3d.common cimport *

ctypedef Vec2C aiVector2D
ctypedef Vec3C aiVector3D
cdef struct aiColor3D:
    float x
    float y
    float z
cdef struct aiColor4D:
    float r
    float g
    float b
    float a
ctypedef QuatC aiQuaternion
ctypedef Mat3C aiMatrix3x3
ctypedef Mat4C aiMatrix4x4

cdef extern from "assimp/version.h":
    const char* aiGetLegalString()
    unsigned int aiGetVersionMinor()
    unsigned int aiGetVersionMajor()
    unsigned int aiGetVersionRevision()
    cdef enum:
        ASSIMP_CFLAGS_SHARED = 0x1
        ASSIMP_CFLAGS_STLPORT = 0x2
        ASSIMP_CFLAGS_DEBUG = 0x4
        ASSIMP_CFLAGS_NOBOOST = 0x8
        ASSIMP_CFLAGS_SINGLETHREADED = 0x10
    unsigned int aiGetCompileFlags()

cdef extern from "assimp/types.h":
    const size_t MAXLEN = 1024
    ctypedef Vec4C aiPlane
    cdef struct aiRay:
        aiVector3D pos
        aiVector3D dir
    cdef struct aiString:
        size_t length
        char data[MAXLEN]
    cdef enum aiReturn:
        aiReturn_SUCCESS = 0x0
        aiReturn_FAILURE = -0x1
        aiReturn_OUTOFMEMORY = -0x3
        _AI_ENFORCE_ENUM_SIZE = 0x7fffffff
    cdef enum aiOrigin:
        aiOrigin_SET = 0x0
        aiOrigin_CUR = 0x1
        aiOrigin_END = 0x2
        _AI_ORIGIN_ENFORCE_ENUM_SIZE = 0x7fffffff
    cdef enum aiDefaultLogStream:
        aiDefaultLogStream_FILE = 0x1
        aiDefaultLogStream_STDOUT = 0x2
        aiDefaultLogStream_STDERR = 0x4
        aiDefaultLogStream_DEBUGGER = 0x8
        _AI_DLS_ENFORCE_ENUM_SIZE = 0x7fffffff
    cdef struct aiMemoryInfo:
        unsigned int textures
        unsigned int materials
        unsigned int meshes
        unsigned int nodes
        unsigned int animations
        unsigned int cameras
        unsigned int lights
        unsigned int total

cdef extern from "assimp/importerdesc.h":
    cdef enum aiImporterFlags:
        aiImporterFlags_SupportTextFlavour = 0x1
        aiImporterFlags_SupportBinaryFlavour = 0x2
        aiImporterFlags_SupportCompressedFlavour = 0x4
        aiImporterFlags_LimitedSupport = 0x8
        aiImporterFlags_Experimental = 0x10
    cdef struct aiImporterDesc:
        const char* mName
        const char* mAuthor
        const char* mMaintainer
        const char* mComments
        unsigned int mFlags
        unsigned int mMinMajor
        unsigned int mMinMinor
        unsigned int mMaxMajor
        unsigned int mMaxMinor
        const char* mFileExtensions
    const aiImporterDesc* aiGetImporterDesc(const char *extension)

cdef extern from "assimp/metadata.h":
    cdef enum aiMetadataType:
        AI_BOOL = 0
        AI_INT32 = 1
        AI_UINT64 = 2
        AI_FLOAT = 3
        AI_DOUBLE = 4
        AI_AISTRING = 5
        AI_AIVECTOR3D = 6
    cdef struct aiMetadataEntry:
        aiMetadataType mType
        void* mData
    cdef struct aiMetadata:
        unsigned int mNumProperties
        aiString* mKeys
        aiMetadataEntry* mValues

cdef extern from "assimp/anim.h":
    cdef struct aiVectorKey:
        double mTime
        aiVector3D mValue
    cdef struct aiQuatKey:
        double mTime
        aiQuaternion mValue
    cdef struct aiMeshKey:
        double mTime
        unsigned int mValue
    cdef struct aiMeshMorphKey:
        double mTime
        unsigned int *mValues
        double *mWeights
        unsigned int mNumValuesAndWeights
    cdef enum aiAnimBehaviour:
        aiAnimBehaviour_DEFAULT = 0x0
        aiAnimBehaviour_CONSTANT = 0x1
        aiAnimBehaviour_LINEAR = 0x2
        aiAnimBehaviour_REPEAT = 0x3
    cdef struct aiNodeAnim:
        aiString mNodeName
        unsigned int mNumPositionKeys
        aiVectorKey* mPositionKeys
        unsigned int mNumRotationKeys
        aiQuatKey* mRotationKeys
        unsigned int mNumScalingKeys
        aiVectorKey* mScalingKeys
        aiAnimBehaviour mPreState
        aiAnimBehaviour mPostState
    cdef struct aiMeshAnim:
        aiString mName
        unsigned int mNumKeys
        aiMeshKey* mKeys
    cdef struct aiMeshMorphAnim:
        aiString mName
        unsigned int mNumKeys
        aiMeshMorphKey* mKeys
    cdef struct aiAnimation:
        aiString mName
        double mDuration
        double mTicksPerSecond
        unsigned int mNumChannels
        aiNodeAnim** mChannels
        unsigned int mNumMeshChannels
        aiMeshAnim** mMeshChannels
        unsigned int mNumMorphMeshChannels
        aiMeshMorphAnim **mMorphMeshChannels

cdef extern from "assimp/camera.h":
    cdef struct aiCamera:
        aiString mName
        aiVector3D mPosition
        aiVector3D mUp
        aiVector3D mLookAt
        float mHorizontalFOV
        float mClipPlaneNear
        float mClipPlaneFar
        float mAspect

cdef extern from "assimp/light.h":
    cdef enum aiLightSourceType:
        aiLightSource_UNDEFINED = 0x0
        aiLightSource_DIRECTIONAL = 0x1
        aiLightSource_POINT = 0x2
        aiLightSource_SPOT = 0x3
        aiLightSource_AMBIENT = 0x4
        aiLightSource_AREA = 0x5
    cdef struct aiLight:
        aiString mName
        aiLightSourceType mType
        aiVector3D mPosition
        aiVector3D mDirection
        aiVector3D mUp
        float mAttenuationConstant
        float mAttenuationLinear
        float mAttenuationQuadratic
        aiColor3D mColorDiffuse
        aiColor3D mColorSpecular
        aiColor3D mColorAmbient
        float mAngleInnerCone
        float mAngleOuterCone
        aiVector2D mSize

cdef extern from "assimp/material.h":
    cdef const char *AI_DEFAULT_MATERIAL_NAME = b"DefaultMaterial"
    cdef enum aiTextureOp:
        aiTextureOp_Multiply = 0x0
        aiTextureOp_Add = 0x1
        aiTextureOp_Subtract = 0x2
        aiTextureOp_Divide = 0x3
        aiTextureOp_SmoothAdd = 0x4
        aiTextureOp_SignedAdd = 0x5
    cdef enum aiTextureMapMode:
        aiTextureMapMode_Wrap = 0x0
        aiTextureMapMode_Clamp = 0x1
        aiTextureMapMode_Decal = 0x3
        aiTextureMapMode_Mirror = 0x2
    cdef enum aiTextureMapping:
        aiTextureMapping_UV = 0x0
        aiTextureMapping_SPHERE = 0x1
        aiTextureMapping_CYLINDER = 0x2
        aiTextureMapping_BOX = 0x3
        aiTextureMapping_PLANE = 0x4
        aiTextureMapping_OTHER = 0x5
    cdef enum aiTextureType:
        aiTextureType_NONE = 0x0
        aiTextureType_DIFFUSE = 0x1
        aiTextureType_SPECULAR = 0x2
        aiTextureType_AMBIENT = 0x3
        aiTextureType_EMISSIVE = 0x4
        aiTextureType_HEIGHT = 0x5
        aiTextureType_NORMALS = 0x6
        aiTextureType_SHININESS = 0x7
        aiTextureType_OPACITY = 0x8
        aiTextureType_DISPLACEMENT = 0x9
        aiTextureType_LIGHTMAP = 0xA
        aiTextureType_REFLECTION = 0xB
        aiTextureType_UNKNOWN = 0xC
    cdef enum:
        AI_TEXTURE_TYPE_MAX = aiTextureType_UNKNOWN
    cdef enum aiShadingMode:
        aiShadingMode_Flat = 0x1
        aiShadingMode_Gouraud = 0x2
        aiShadingMode_Phong = 0x3
        aiShadingMode_Blinn = 0x4
        aiShadingMode_Toon = 0x5
        aiShadingMode_OrenNayar = 0x6
        aiShadingMode_Minnaert = 0x7
        aiShadingMode_CookTorrance = 0x8
        aiShadingMode_NoShading = 0x9
        aiShadingMode_Fresnel = 0xa
    cdef enum aiTextureFlags:
        aiTextureFlags_Invert = 0x1
        aiTextureFlags_UseAlpha = 0x2
        aiTextureFlags_IgnoreAlpha = 0x4
    cdef enum aiBlendMode:
        aiBlendMode_Default = 0x0
        aiBlendMode_Additive = 0x1
    cdef struct aiUVTransform:
        aiVector2D mTranslation
        aiVector2D mScaling
        float mRotation
    cdef enum aiPropertyTypeInfo:
        aiPTI_Float = 0x1
        aiPTI_Double = 0x2
        aiPTI_String = 0x3
        aiPTI_Integer = 0x4
        aiPTI_Buffer = 0x5
    cdef struct aiMaterialProperty:
        aiString mKey
        unsigned int mSemantic
        unsigned int mIndex
        unsigned int mDataLength
        aiPropertyTypeInfo mType
        char* mData
    cdef struct aiMaterial:
        aiMaterialProperty** mProperties
        unsigned int mNumProperties
        unsigned int mNumAllocated
    aiReturn aiGetMaterialProperty(const aiMaterial* pMat, const char* pKey, unsigned int type, unsigned int index, const aiMaterialProperty** pPropOut)
    aiReturn aiGetMaterialFloatArray(const aiMaterial* pMat, const char* pKey, unsigned int type, unsigned int index, float* pOut, unsigned int* pMax)
    #aiReturn aiGetMaterialFloat(const aiMaterial* pMat, const char* pKey, unsigned int type, unsigned int index, float* pOut)
    aiReturn aiGetMaterialIntegerArray(const aiMaterial* pMat, const char* pKey, unsigned int type, unsigned int index, int* pOut, unsigned int* pMax)
    #aiReturn aiGetMaterialInteger(const aiMaterial* pMat, const char* pKey, unsigned int type, unsigned int index, int* pOut)
    aiReturn aiGetMaterialColor(const aiMaterial* pMat, const char* pKey, unsigned int type, unsigned int index, aiColor4D* pOut)
    aiReturn aiGetMaterialUVTransform(const aiMaterial* pMat, const char* pKey, unsigned int type, unsigned int index, aiUVTransform* pOut)
    aiReturn aiGetMaterialString(const aiMaterial* pMat, const char* pKey, unsigned int type, unsigned int index, aiString* pOut)
    unsigned int aiGetMaterialTextureCount(const aiMaterial* pMat, aiTextureType type)
    aiReturn aiGetMaterialTexture(const aiMaterial* mat, aiTextureType type, unsigned int index, aiString* path, aiTextureMapping* mapping, unsigned int* uvindex, float* blend, aiTextureOp* op, aiTextureMapMode* mapmode, unsigned int* flags)

cdef extern from "assimp/mesh.h":
    cdef enum:
        AI_MAX_BONE_WEIGHTS
        AI_MAX_VERTICES
        AI_MAX_FACES
        AI_MAX_NUMBER_OF_COLOR_SETS
        AI_MAX_NUMBER_OF_TEXTURECOORDS
    cdef struct aiFace:
        unsigned int mNumIndices
        unsigned int* mIndices
    cdef struct aiVertexWeight:
        unsigned int mVertexId
        float mWeight
    cdef struct aiBone:
        aiString mName
        unsigned int mNumWeights
        aiVertexWeight* mWeights
        aiMatrix4x4 mOffsetMatrix
    cdef enum aiPrimitiveType:
        aiPrimitiveType_POINT = 0x1
        aiPrimitiveType_LINE = 0x2
        aiPrimitiveType_TRIANGLE = 0x4
        aiPrimitiveType_POLYGON = 0x8
    cdef struct aiAnimMesh:
        aiVector3D* mVertices
        aiVector3D* mNormals
        aiVector3D* mTangents
        aiVector3D* mBitangents
        aiColor4D* mColors[AI_MAX_NUMBER_OF_COLOR_SETS]
        aiVector3D* mTextureCoords[AI_MAX_NUMBER_OF_TEXTURECOORDS]
        unsigned int mNumVertices
        float mWeight
    cdef enum aiMorphingMethod:
        aiMorphingMethod_VERTEX_BLEND = 0x1
        aiMorphingMethod_MORPH_NORMALIZED = 0x2
        aiMorphingMethod_MORPH_RELATIVE = 0x3
    cdef struct aiMesh:
        unsigned int mPrimitiveTypes
        unsigned int mNumVertices
        unsigned int mNumFaces
        aiVector3D* mVertices
        aiVector3D* mNormals
        aiVector3D* mTangents
        aiVector3D* mBitangents
        aiColor4D* mColors[AI_MAX_NUMBER_OF_COLOR_SETS]
        aiVector3D* mTextureCoords[AI_MAX_NUMBER_OF_TEXTURECOORDS]
        unsigned int mNumUVComponents[AI_MAX_NUMBER_OF_TEXTURECOORDS]
        aiFace* mFaces
        unsigned int mNumBones
        aiBone** mBones
        unsigned int mMaterialIndex
        aiString mName
        unsigned int mNumAnimMeshes
        aiAnimMesh** mAnimMeshes
        unsigned int mMethod

cdef extern from "assimp/texture.h":
    cdef struct aiTexel:
        unsigned char b,g,r,a
    cdef struct aiTexture:
        unsigned int mWidth
        unsigned int mHeight
        char achFormatHint[9]
        aiTexel* pcData

cdef extern from "assimp/scene.h":
    cdef struct aiNode:
        aiString mName
        aiMatrix4x4 mTransformation
        aiNode* mParent
        unsigned int mNumChildren
        aiNode** mChildren
        unsigned int mNumMeshes
        unsigned int* mMeshes
        aiMetadata* mMetaData
    cdef enum:
        AI_SCENE_FLAGS_INCOMPLETE = 0x1
        AI_SCENE_FLAGS_VALIDATED = 0x2
        AI_SCENE_FLAGS_VALIDATION_WARNING = 0x4
        AI_SCENE_FLAGS_NON_VERBOSE_FORMAT = 0x8
        AI_SCENE_FLAGS_TERRAIN = 0x10
        AI_SCENE_FLAGS_ALLOW_SHARED = 0x20
    cdef struct aiScene:
        unsigned int mFlags
        aiNode* mRootNode
        unsigned int mNumMeshes
        aiMesh** mMeshes
        unsigned int mNumMaterials
        aiMaterial** mMaterials
        unsigned int mNumAnimations
        aiAnimation** mAnimations
        unsigned int mNumTextures
        aiTexture** mTextures
        unsigned int mNumLights
        aiLight** mLights
        unsigned int mNumCameras
        aiCamera** mCameras

cdef extern from "assimp/cfileio.h":
    cdef struct aiFileIO
    cdef struct aiFile
    ctypedef size_t (*aiFileWriteProc) (aiFile*, const char*, size_t, size_t)
    ctypedef size_t (*aiFileReadProc) (aiFile*, char*, size_t,size_t)
    ctypedef size_t (*aiFileTellProc) (aiFile*)
    ctypedef void (*aiFileFlushProc) (aiFile*)
    ctypedef aiReturn (*aiFileSeek) (aiFile*, size_t, aiOrigin)
    ctypedef aiFile* (*aiFileOpenProc) (aiFileIO*, const char*, const char*)
    ctypedef void (*aiFileCloseProc) (aiFileIO*, aiFile*)
    ctypedef char* aiUserData
    cdef struct aiFileIO:
        aiFileOpenProc OpenProc
        aiFileCloseProc CloseProc
        aiUserData UserData
    cdef struct aiFile:
        aiFileReadProc ReadProc
        aiFileWriteProc WriteProc
        aiFileTellProc TellProc
        aiFileTellProc FileSizeProc
        aiFileSeek SeekProc
        aiFileFlushProc FlushProc
        aiUserData UserData

cdef extern from "assimp/cexport.h":
    cdef struct aiExportFormatDesc:
        const char* id
        const char* description
        const char* fileExtension
    size_t aiGetExportFormatCount()
    const aiExportFormatDesc* aiGetExportFormatDescription(size_t pIndex)
    void aiReleaseExportFormatDescription(const aiExportFormatDesc *desc)
    void aiCopyScene(const aiScene* pIn, aiScene** pOut)
    void aiFreeScene(const aiScene* pIn)
    aiReturn aiExportScene(const aiScene* pScene, const char* pFormatId, const char* pFileName, unsigned int pPreprocessing)
    aiReturn aiExportSceneEx(const aiScene* pScene, const char* pFormatId, const char* pFileName, aiFileIO* pIO, unsigned int pPreprocessing)
    cdef struct aiExportDataBlob:
        size_t size
        void* data
        aiString name
        aiExportDataBlob* next
    const aiExportDataBlob* aiExportSceneToBlob(const aiScene* pScene, const char* pFormatId,  unsigned int pPreprocessing)
    void aiReleaseExportBlob(const aiExportDataBlob* pData)

cdef extern from "assimp/cimport.h":
    ctypedef void (*aiLogStreamCallback)(const char*, char*)
    cdef struct aiLogStream:
        aiLogStreamCallback callback
        char* user
    cdef struct aiPropertyStore:
        char sentinel
    ctypedef bint aiBool
    cdef enum:
        AI_FALSE = 0
        AI_TRUE = 1
    const aiScene* aiImportFile(const char* pFile, unsigned int pFlags)
    const aiScene* aiImportFileEx(const char* pFile, unsigned int pFlags, aiFileIO* pFS)
    const aiScene* aiImportFileExWithProperties(const char* pFile, unsigned int pFlags, aiFileIO* pFS, const aiPropertyStore* pProps)
    const aiScene* aiImportFileFromMemory(const char* pBuffer, unsigned int pLength, unsigned int pFlags, const char* pHint)
    const aiScene* aiImportFileFromMemoryWithProperties(const char* pBuffer, unsigned int pLength, unsigned int pFlags, const char* pHint, const aiPropertyStore* pProps)
    const aiScene* aiApplyPostProcessing(const aiScene* pScene, unsigned int pFlags)
    aiLogStream aiGetPredefinedLogStream(aiDefaultLogStream pStreams, const char* file)
    void aiAttachLogStream(const aiLogStream* stream)
    void aiEnableVerboseLogging(aiBool d)
    aiReturn aiDetachLogStream(const aiLogStream* stream)
    void aiDetachAllLogStreams()
    void aiReleaseImport(const aiScene* pScene)
    const char* aiGetErrorString()
    aiBool aiIsExtensionSupported(const char* szExtension)
    void aiGetExtensionList(aiString* szOut)
    void aiGetMemoryRequirements(const aiScene* pIn, aiMemoryInfo* in_)
    aiPropertyStore* aiCreatePropertyStore()
    void aiReleasePropertyStore(aiPropertyStore* p)
    void aiSetImportPropertyInteger(aiPropertyStore* store, const char* szName, int value)
    void aiSetImportPropertyFloat(aiPropertyStore* store, const char* szName, float value)
    void aiSetImportPropertyString(aiPropertyStore* store, const char* szName, const aiString* st)
    void aiSetImportPropertyMatrix(aiPropertyStore* store, const char* szName, const aiMatrix4x4* mat)
    void aiCreateQuaternionFromMatrix(aiQuaternion* quat, const aiMatrix3x3* mat)
    void aiDecomposeMatrix(const aiMatrix4x4* mat, aiVector3D* scaling, aiQuaternion* rotation, aiVector3D* position)
    void aiTransposeMatrix4(aiMatrix4x4* mat)
    void aiTransposeMatrix3(aiMatrix3x3* mat)
    void aiTransformVecByMatrix3(aiVector3D* vec, const aiMatrix3x3* mat)
    void aiTransformVecByMatrix4(aiVector3D* vec, const aiMatrix4x4* mat)
    void aiMultiplyMatrix4(aiMatrix4x4* dst, const aiMatrix4x4* src)
    void aiMultiplyMatrix3(aiMatrix3x3* dst, const aiMatrix3x3* src)
    void aiIdentityMatrix3(aiMatrix3x3* mat)
    void aiIdentityMatrix4(aiMatrix4x4* mat)
    size_t aiGetImportFormatCount()
    const aiImporterDesc* aiGetImportFormatDescription( size_t pIndex)

cdef extern from "assimp/postprocess.h":
    cdef enum aiPostProcessSteps:
        aiProcess_CalcTangentSpace = 0x1
        aiProcess_JoinIdenticalVertices = 0x2
        aiProcess_MakeLeftHanded = 0x4
        aiProcess_Triangulate = 0x8
        aiProcess_RemoveComponent = 0x10
        aiProcess_GenNormals = 0x20
        aiProcess_GenSmoothNormals = 0x40
        aiProcess_SplitLargeMeshes = 0x80
        aiProcess_PreTransformVertices = 0x100
        aiProcess_LimitBoneWeights = 0x200
        aiProcess_ValidateDataStructure = 0x400
        aiProcess_ImproveCacheLocality = 0x800
        aiProcess_RemoveRedundantMaterials = 0x1000
        aiProcess_FixInfacingNormals = 0x2000
        aiProcess_SortByPType = 0x8000
        aiProcess_FindDegenerates = 0x10000
        aiProcess_FindInvalidData = 0x20000
        aiProcess_GenUVCoords = 0x40000
        aiProcess_TransformUVCoords = 0x80000
        aiProcess_FindInstances = 0x100000
        aiProcess_OptimizeMeshes = 0x200000
        aiProcess_OptimizeGraph = 0x400000
        aiProcess_FlipUVs = 0x800000
        aiProcess_FlipWindingOrder = 0x1000000
        aiProcess_SplitByBoneCount = 0x2000000
        aiProcess_Debone = 0x4000000
        aiProcess_GlobalScale = 0x8000000
    cdef enum:
        aiProcess_ConvertToLeftHanded    
        aiProcessPreset_TargetRealtime_Fast
        aiProcessPreset_TargetRealtime_Quality
        aiProcessPreset_TargetRealtime_MaxQuality