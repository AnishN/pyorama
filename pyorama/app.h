/* Generated by Cython 0.29.24 */

#ifndef __PYX_HAVE__pyorama__app
#define __PYX_HAVE__pyorama__app

#include "Python.h"

#ifndef __PYX_HAVE_API__pyorama__app

#ifndef __PYX_EXTERN_C
  #ifdef __cplusplus
    #define __PYX_EXTERN_C extern "C"
  #else
    #define __PYX_EXTERN_C extern
  #endif
#endif

#ifndef DL_IMPORT
  #define DL_IMPORT(_T) _T
#endif

__PYX_EXTERN_C struct __pyx_obj_7pyorama_8graphics_15graphics_system_GraphicsSystem *__pyx_v_7pyorama_3app_graphics;
__PYX_EXTERN_C struct __pyx_obj_7pyorama_4core_11user_system_UserSystem *__pyx_v_7pyorama_3app_audio;
__PYX_EXTERN_C struct __pyx_obj_7pyorama_5event_12event_system_EventSystem *__pyx_v_7pyorama_3app_event;
__PYX_EXTERN_C struct __pyx_obj_7pyorama_4core_11user_system_UserSystem *__pyx_v_7pyorama_3app_physics;

#endif /* !__PYX_HAVE_API__pyorama__app */

/* WARNING: the interface of the module init function changed in CPython 3.5. */
/* It now returns a PyModuleDef instance instead of a PyModule instance. */

#if PY_MAJOR_VERSION < 3
PyMODINIT_FUNC initapp(void);
#else
PyMODINIT_FUNC PyInit_app(void);
#endif

#endif /* !__PYX_HAVE__pyorama__app */
