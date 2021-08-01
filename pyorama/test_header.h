#include <SDL2/SDL.h>
#include <SDL2/SDL_syswm.h>
#include <bgfx/c99/bgfx.h>

bool sdlSetWindow(SDL_Window* _window)
{
    SDL_SysWMinfo wmi;
    SDL_VERSION(&wmi.version);
    if (!SDL_GetWindowWMInfo(_window, &wmi)) {
        return false;
    }
    printf("%d, %d\n", wmi.subsystem, SDL_SYSWM_WINDOWS);
    bgfx_platform_data_t pd;
    
    #if BX_PLATFORM_LINUX || BX_PLATFORM_BSD
        pd.ndt = wmi.info.x11.display;
        pd.nwh = (void*)(uintptr_t)wmi.info.x11.window;
    #elif BX_PLATFORM_OSX
        pd.ndt = NULL;
        pd.nwh = wmi.info.cocoa.window;
    #elif BX_PLATFORM_WINDOWS
        #include <windows.h>
        typedef struct windows_info_t
        {
            HWND window;
            HDC hdc;
            HINSTANCE hinstance;
        } windows_info_t;
        pd.ndt = NULL;
        pd.nwh = ((windows_info_t *)wmi.info.dummy)->window;
    #elif BX_PLATFORM_STEAMLINK
        pd.ndt = wmi.info.vivante.display;
        pd.nwh = wmi.info.vivante.window;
    #endif
    pd.context = NULL;
    pd.backBuffer = NULL;
    pd.backBufferDS = NULL;
    bgfx_set_platform_data(&pd);
    
    return true;
}
