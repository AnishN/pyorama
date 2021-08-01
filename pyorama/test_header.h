#include <SDL2/SDL.h>
#include <SDL2/SDL_syswm.h>
#include <bgfx/c99/bgfx.h>
#include <windows.h>

typedef struct windows_info_t
{
    HWND window;                /**< The window handle */
    HDC hdc;                    /**< The window device context */
    HINSTANCE hinstance;        /**< The instance handle */
} windows_info_t;

bool sdlSetWindow(SDL_Window* _window)
{
    SDL_SysWMinfo wmi;
    SDL_VERSION(&wmi.version);
    if (!SDL_GetWindowWMInfo(_window, &wmi)) {
        return false;
    }
    printf("%d, %d\n", wmi.subsystem, SDL_SYSWM_WINDOWS);
    bgfx_platform_data_t *pd = malloc(sizeof(bgfx_platform_data_t));
    pd->ndt = NULL;
    pd->nwh = ((windows_info_t *)wmi.info.dummy)->window;

    /*
    HWND w = pd->nwh;
    RECT r;
    GetWindowRect(w, &r);
    printf("%p\n", pd->nwh);
    printf("%ld, %ld, %ld, %ld\n", r.left, r.top, r.right, r.bottom);
    */

    /*
    bgfx_platform_data_t *pd = malloc(sizeof(bgfx_platform_data_t));
#if BX_PLATFORM_LINUX || BX_PLATFORM_BSD
    pd.ndt = wmi.info.x11.display;
    pd.nwh = (void*)(uintptr_t)wmi.info.x11.window;
#elif BX_PLATFORM_OSX
    pd.ndt = NULL;
    pd.nwh = wmi.info.cocoa.window;
#elif BX_PLATFORM_WINDOWS
    pd->ndt = NULL;
    pd->nwh = wmi.info.win.window;
#elif BX_PLATFORM_STEAMLINK
    pd.ndt = wmi.info.vivante.display;
    pd.nwh = wmi.info.vivante.window;
#endif // BX_PLATFORM_
    */
    pd->context = NULL;
    pd->backBuffer = NULL;
    pd->backBufferDS = NULL;
    bgfx_set_platform_data(pd);
    free(pd);
    
    return true;
}