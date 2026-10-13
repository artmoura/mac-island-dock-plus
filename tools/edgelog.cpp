#include <windows.h>
#include <shellapi.h>
#include <cstdio>
#include <string>

// For `seconds`, each time the mouse reaches a monitor's bottom edge, logs
// what the mod's full-screen check looks at: the window in front, the one at
// the top of that monitor, the taskbar there and Windows' notification state.
static std::wstring Describe(HWND h) {
    if (!h) {
        return L"(none)";
    }
    wchar_t cls[96] = L"", title[64] = L"", exe[MAX_PATH] = L"?";
    GetClassNameW(h, cls, 96);
    GetWindowTextW(h, title, 64);
    RECT r{};
    GetWindowRect(h, &r);
    DWORD pid = 0;
    GetWindowThreadProcessId(h, &pid);
    if (HANDLE p = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, FALSE, pid)) {
        DWORD n = MAX_PATH;
        QueryFullProcessImageNameW(p, 0, exe, &n);
        CloseHandle(p);
    }
    const wchar_t* name = wcsrchr(exe, L'\\');
    const LONG style = GetWindowLongW(h, GWL_STYLE);
    const LONG ex = GetWindowLongW(h, GWL_EXSTYLE);
    wchar_t text[700];
    swprintf(text, 700,
             L"%ls [%ls] '%ls' rect=(%ld,%ld)-(%ld,%ld) zoomed=%d caption=%d "
             L"topmost=%d",
             name ? name + 1 : exe, cls, title, r.left, r.top, r.right,
             r.bottom, IsZoomed(h), (style & WS_CAPTION) == WS_CAPTION,
             (ex & WS_EX_TOPMOST) != 0);
    return text;
}

int wmain(int argc, wchar_t** argv) {
    SetProcessDPIAware();
    const int seconds = argc > 1 ? _wtoi(argv[1]) : 90;
    const ULONGLONG end = GetTickCount64() + seconds * 1000ULL;
    std::wstring last;
    while (GetTickCount64() < end) {
        Sleep(150);
        POINT pt;
        GetCursorPos(&pt);
        HMONITOR monitor = MonitorFromPoint(pt, MONITOR_DEFAULTTONEAREST);
        MONITORINFO info{sizeof(info)};
        GetMonitorInfoW(monitor, &info);
        if (pt.y < info.rcMonitor.bottom - 2) {
            continue;
        }
        QUERY_USER_NOTIFICATION_STATE state{};
        SHQueryUserNotificationState(&state);
        HWND foreground = GetForegroundWindow();
        const POINT top{(info.rcMonitor.left + info.rcMonitor.right) / 2,
                        info.rcMonitor.top + 1};
        HWND atTop = GetAncestor(WindowFromPoint(top), GA_ROOT);
        const POINT bottom{pt.x, info.rcMonitor.bottom - 1};
        HWND atBottom = GetAncestor(WindowFromPoint(bottom), GA_ROOT);
        wchar_t head[200];
        swprintf(head, 200, L"monitor=(%ld,%ld)-(%ld,%ld) state=%d",
                 info.rcMonitor.left, info.rcMonitor.top, info.rcMonitor.right,
                 info.rcMonitor.bottom, (int)state);
        std::wstring line = std::wstring(head) + L"\n  front:  " +
                            Describe(GetAncestor(foreground, GA_ROOT)) +
                            L"\n  top:    " + Describe(atTop) +
                            L"\n  bottom: " + Describe(atBottom);
        if (line != last) {
            SYSTEMTIME t;
            GetLocalTime(&t);
            wprintf(L"%02d:%02d:%02d %ls\n", t.wHour, t.wMinute, t.wSecond,
                    line.c_str());
            fflush(stdout);
            last = line;
        }
    }
    return 0;
}
