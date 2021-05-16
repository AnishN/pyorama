typedef enum ProjectionMode 
{
    PROJECTION_MODE_2D,
    PROJECTION_MODE_3D,
} ProjectionMode;

typedef struct Projection2DC 
{
    float left;
    float right;
    float bottom;
    float top;
    float near;
    float far;
} Projection2DC;

typedef struct Projection3DC 
{
    float fovy;
    float aspect;
    float near;
    float far;
} Projection3DC;

typedef struct ProjectionC
{
    ProjectionMode mode;
    union 
    {
        Projection2DC two_d;
        Projection3DC three_d;
    }
} ProjectionC;