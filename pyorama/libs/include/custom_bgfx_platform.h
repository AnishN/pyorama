#include <SDL2/SDL.h>
#include <SDL2/SDL_syswm.h>
#include <bgfx/c99/bgfx.h>

//platform-specific includes go up here
#if BX_PLATFORM_LINUX || BX_PLATFORM_BSD
#elif BX_PLATFORM_OSX
#elif BX_PLATFORM_WINDOWS
    #include <windows.h>
#elif BX_PLATFORM_STEAMLINK
#endif

SDL_SysWMinfo *bgfx_fetch_wmi(void)
{
    SDL_SysWMinfo *wmi = malloc(sizeof(SDL_SysWMinfo));
    wmi->version.major = SDL_MAJOR_VERSION;
    wmi->version.minor = SDL_MINOR_VERSION;
    wmi->version.patch = SDL_PATCHLEVEL;
    return wmi;
}

void *bgfx_get_window_nwh(SDL_SysWMinfo *wmi, SDL_Window* _window)
{
    if (!SDL_GetWindowWMInfo(_window, wmi)) {
        return false;
    }
    
    void *nwh = NULL;
    #if BX_PLATFORM_LINUX || BX_PLATFORM_BSD
        nwh = (void*)(uintptr_t)wmi->info.x11.window;
    #elif BX_PLATFORM_OSX
        nwh = wmi->info.cocoa.window;
    #elif BX_PLATFORM_WINDOWS
        typedef struct windows_info_t
        {
            HWND window;
            HDC hdc;
            HINSTANCE hinstance;
            int a;
        } windows_info_t;
        nwh = ((windows_info_t *)wmi->info.dummy)->window;
    #elif BX_PLATFORM_STEAMLINK
        nwh = wmi->info.vivante.window;
    #endif
    return nwh;
}

void *bgfx_get_window_ndt(SDL_SysWMinfo *wmi, SDL_Window* _window)
{
    if (!SDL_GetWindowWMInfo(_window, wmi)) {
        return false;
    }

    void *ndt = NULL;
    #if BX_PLATFORM_LINUX || BX_PLATFORM_BSD
        ndt = wmi->info.x11.display;
    #elif BX_PLATFORM_OSX
        ndt = NULL;
    #elif BX_PLATFORM_WINDOWS
        ndt = NULL;
    #elif BX_PLATFORM_STEAMLINK
        ndt = wmi->info.vivante.display;
    #endif
    return ndt;
}

bool bgfx_get_platform_data_from_window(SDL_SysWMinfo *wmi, SDL_Window* _window)
{
    if (!SDL_GetWindowWMInfo(_window, wmi)) {
        return false;
    }
    bgfx_platform_data_t pd;
    pd.nwh = bgfx_get_window_nwh(wmi, _window);
    pd.ndt = bgfx_get_window_ndt(wmi, _window);
    pd.context = NULL;
    pd.backBuffer = NULL;
    pd.backBufferDS = NULL;
    bgfx_set_platform_data(&pd);
    return true;
}
