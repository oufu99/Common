

<ShowTaskbar>:
NumPut( ABS_ALWAYSONTOP1, Taskbar_Off+24 )
DllCall("Shell32.dll\SHAppBarMessage", UInt,ABM_SETSTATE1, UInt,&APPBARDATA1 )
WinShow, ahk_class Shell_TrayWnd
Return

<HideTaskbar>:
NumPut( ABS_AUTOHIDE1|ABS_ALWAYSONTOP1, Taskbar_Off+24 )
DllCall("Shell32.dll\SHAppBarMessage", UInt,ABM_SETSTATE1, UInt,&APPBARDATA1 )
WinHide, ahk_class Shell_TrayWnd  ; Hide Taskbar
Return