#singleinstance force


;  CapsLock & d   用于复制   

Hotkey,CapsLock & ~i,subWordi

subWordi:
Hotkey,CapsLock & k,off
Input,outputvar,L1 T1
Switch OutputVar 
{
	case "i":
	{
		Send,{BackSpace}""{Left}
	}
	case "k":
	{
		Send,{BackSpace}(){Left}		
	}
	Default:
	{
		Send,%OutputVar%	
	}
}
Hotkey,CapsLock & k,on
return


;************** 自定义其他的开始 **************

; 注释掉F1,免得总是按错 F1也没啥用
F1::


;************** 自定义其他的结束 **************

;管理员权限代码，放在文件开头 {{{1
Loop, %0%
  {
    param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
    params .= A_Space . param
  }
ShellExecute := A_IsUnicode ? "shell32\ShellExecute":"shell32\ShellExecuteA"
if not A_IsAdmin
{
    If A_IsCompiled
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_ScriptFullPath, str, params , str, A_WorkingDir, int, 1)
    Else
       DllCall(ShellExecute, uint, 0, str, "RunAs", str, A_AhkPath, str, """" . A_ScriptFullPath . """" . A_Space . params, str, A_WorkingDir, int, 1)
    ExitApp
}

;文件头 {{{1
;Directives
#WinActivateForce
#InstallKeybdHook
#InstallMouseHook
#Persistent                   ;让脚本持久运行(关闭或ExitApp)
#MaxMem 4	;max memory per var use
#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 1000 ;Avoid warning when mouse wheel turned very fast
SetCapsLockState AlwaysOff
;SendMode InputThenPlay
;KeyHistory
SetBatchLines -1                	 	;让脚本无休眠地执行（换句话说，也就是让脚本全速运行）
SetKeyDelay -1							;设置每次Send和ControlSend发送键击后自动的延时,使用-1表示无延时
Process Priority,,High           	    ;线程,主,高级别

SendMode Input

DetectHiddenWindows, on
SetTitleMatchMode, 2

SetWinDelay,0
SetControlDelay,0


;************** group定义^ ************** {{{1
;GroupAdd, group_browser,ahk_class St.HDBaseWindow
GroupAdd, group_browser,ahk_class IEFrame               ;IE
GroupAdd, group_browser,ahk_class MozillaWindowClass    ;Firefox
GroupAdd, group_browser,ahk_class Chrome_WidgetWin_0    ;Chrome
GroupAdd, group_browser,ahk_class Chrome_WidgetWin_1    ;Chrome
GroupAdd, group_browser,ahk_class Chrome_WidgetWin_100  ;liebao
GroupAdd, group_browser,ahk_class QQBrowser_WidgetWin_1

GroupAdd, group_disableCtrlSpace, ahk_exe excel.exe
GroupAdd, group_disableCtrlSpace, ahk_exe pycharm.exe
GroupAdd, group_disableCtrlSpace, ahk_exe SQLiteStudio.exe

GroupAdd,GroupDiagOpenAndSave,Open ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,Save As ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,另存为 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,保存 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,复制 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,新建 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,打开 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,图形另存为 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,文件打开 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,保存副本 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,上传 ahk_class #32770
GroupAdd,GroupDiagOpenAndSave,选择文件 ahk_class #32770

;GroupAdd, group_disableCtrlSpace, ahk_exe gvim.exe 
;GroupAdd, group_disableCtrlSpace, ahk_class NotebookFrame（注：ahk_class后面是AHK检测出的mathematica的class名）

;************** group定义$ **************

;设定15分钟重启一次脚本，防止卡键 1000*60*15
GV_ReloadTimer := % 1000*60*5


;if COMMANDER_PATH = 
;{
;msgbox % COMMANDER_PATH
;COMMANDER_PATH := "D:\totalcmd_bar"
;EnvSet,COMMANDER_PATH,D:\totalcmd_bar
;}

;如果是自己从tc中启动的本脚本，将会自动带上COMMANDER_PATH
;但如果是别的地方，比如注册表的autorun环节先启动的本脚本，那么就有必要先设置这个变量
;1、先启动脚本，正常是随系统自启动，那么COMMANDER_PATH为空
;2、再启动tc，那么COMMANDER_PATH变量还是为空，可以读取运行中的exe路径
;3、最后再是根据脚本所在目录中是否存在TOTALCMD.EXE或者TOTALCMD64.EXE
WinGet,TcExeFullPath,ProcessPath,ahk_class TTOTAL_CMD
;msgbox % A_WorkingDir
;msgbox % TcExeFullPath==""
;msgbox % COMMANDER_PATH=""
;msgbox %TcExeFullPath%

if !TcExeFullPath ;没tc在运行
{
	if A_Is64bitOS {
		if FileExist(A_WorkingDir . "\" . "TOTALCMD64.EXE") {
			TcExeFullPath := A_WorkingDir . "\" . "TOTALCMD64.EXE"
			EnvSet,COMMANDER_PATH, A_WorkingDir
		} else if FileExist(A_WorkingDir . "\" . "TOTALCMD.EXE") {
			TcExeFullPath := A_WorkingDir . "\" . "TOTALCMD.EXE"
			EnvSet,COMMANDER_PATH, A_WorkingDir
		} else{
			toolTip  
			sleep 2000
			tooltip
		}
	}
	else {
		if FileExist(A_WorkingDir . "\" . "TOTALCMD.EXE") {
			TcExeFullPath := A_WorkingDir . "\" . "TOTALCMD.EXE"
			EnvSet,COMMANDER_PATH, A_WorkingDir
		} else {
			toolTip  
			sleep 2000
			tooltip
		}
	}
}
else{ ;有tc在运行
	if !COMMANDER_PATH  ;但脚本先启动，比如随系统自启动，所以并没有COMMANDER_PATH变量
	{
		WinGet,TcExeName,ProcessName,ahk_class TTOTAL_CMD
		StringTrimRight, COMMANDER_PATH, TcExeFullPath, StrLen(TcExeName)+1
		EnvSet,COMMANDER_PATH, % COMMANDER_PATH
	}
	else{
		;有TcExeFullPath 也有COMMANDER_PATH了，
		;msgbox 啥都不做
	}
}



;GV_ToolsPath := % GF_GetSysVar("ToolsPath")
GV_TempPath := % GF_GetSysVar("TEMP")
;是否启用光标下滚轮
GV_ToggleWheelOnCursor := 1

;单键模式
GV_ToggleKeyMode := 0
;双击快捷键间隔175微秒，别改
GV_Timer := 175
GV_KeyClickAction1 :=
GV_KeyClickAction2 :=
GV_KeyClickAction3 :=

TC_Msg := 1075
CM_OpenDrives := 2122
CM_OpenDesktop := 2121
CM_OpenPrinters := 2126
CM_OpenNetwork := 2125
CM_OpenControls := 2123
CM_OpenRecycled := 2127
CM_CopySrcPathToClip := 2029
CM_ConfigSaveDirHistory := 582

ScreenShotPath := "C:\"

;Tim中座标位置
Tim_Start_X := 100
Tim_Start_Y := 100
Tim_Bar_Height := 60 

WX_Start_X := 180
WX_Start_Y := 100
WX_Bar_Height := 62 

TG_Start_X := 100
TG_Start_Y := 110
TG_Bar_Height := 62 

CreatTrayMenu()

;自动重启脚本
Gosub,AutoReloadInit
AutoReloadInit:
	SetTimer, SelfReload, % GV_ReloadTimer
return

SelfReload:
	reload
return


;用ramdisk的时候，有时候不能自动的建立Temp目录
;FileDelete,% GV_TempPath
;FileCreateDir, % GV_TempPath
;FileCreateDir, % GV_TempPath . "\ChromeCache"


;************** 在光标下方滚轮 ************** {{{1
;Autoexecute code
CoordMode, Mouse, Screen
MinLinesPerNotch := 1
MaxLinesPerNotch := 5
AccelerationThreshold := 100
AccelerationType := "L" ;Change to "P" for parabolic acceleration
StutterThreshold := 10
;************** 以上是自动执行部分，必须要执行 autorun ************** {{{1

;************** 在光标下方滚轮^ ************** {{{1 ;Function definitions
 ;See above for details on parameters
FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
{
	Critical ;Buffer all missed scrollwheel input to prevent missing notches
	SetBatchLines, -1 ;Run as fast as possible

	;Stutter filter: Prevent stutter caused by cheap mice by ignoring successive WheelUp/WheelDown events that occur to close together.
	If(A_TimeSincePriorHotkey < StutterThreshold) ;Quickest succession time in ms
		If(A_PriorHotkey = "WheelUp" Or A_PriorHotkey ="WheelDown")
			Return

	MouseGetPos, m_x, m_y
	m_x &= 0xFFFF

	MouseGetPos,,,, ControlClass2, 2
	MouseGetPos,,,, ControlClass3, 3

	if(A_Is64bitOS)
		;64-bit systems use this line
		ControlClass1 := DllCall( "WindowFromPoint", "int64", m_x | (m_y << 32), "Ptr")
	else
		ControlClass1 := DllCall("WindowFromPoint", "int", m_x, "int", m_y)

	lParam := (m_y << 16) | m_x
	wParam := (120 << 16) ;Wheel delta is 120, as defined by MicroSoft

	;Detect WheelDown event
	If(A_ThisHotkey = "WheelDown" Or A_ThisHotkey = "^WheelDown" Or A_ThisHotkey = "+WheelDown" Or A_ThisHotkey = "*WheelDown")
		wParam := -wParam ;If scrolling down, invert scroll direction
	;Detect modifer keys held down (only Shift and Control work)
	If(GetKeyState("Shift","p"))
		wParam := wParam | 0x4
	If(GetKeyState("Ctrl","p"))
		wParam := wParam | 0x8

	;If you don't need scroll acceleration, you can simply remove the LinesPerNotch() function def and set Lines := 1. Additionally you will want to strip out all the related unused function parameters.
	Lines := LinesPerNotch(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType)
	;Run this loop several times to create the impression of faster scrolling
	Loop, %Lines%
	{
		If(ControlClass2 = "")
			SendMessage, 0x20A, wParam, lParam,, ahk_id %ControlClass1%
		Else
		{
			SendMessage, 0x20A, wParam, lParam,, ahk_id %ControlClass2%
			If(ControlClass2 != ControlClass3)
				SendMessage, 0x20A, wParam, lParam,, ahk_id %ControlClass3%
		}
	}
}

LinesPerNotch(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType)
{
	T := A_TimeSincePriorHotkey
	;Normal slow scrolling, separationg between scroll events is greater than AccelerationThreshold miliseconds.
	If((T > AccelerationThreshold) Or (T = -1)) ;T = -1 if this is the first hotkey ever run
	{
		Lines := MinLinesPerNotch
	}
	;Fast scrolling, use acceleration
	Else
	{
		If(AccelerationType = "P")
		{
			;Parabolic scroll speed curve
			;f(t) = At^2 + Bt + C
			A := (MaxLinesPerNotch-MinLinesPerNotch)/(AccelerationThreshold**2)
			B := -2 * (MaxLinesPerNotch - MinLinesPerNotch)/AccelerationThreshold
			C := MaxLinesPerNotch
			Lines := Round(A*(T**2) + B*T + C)
		}
		Else
		{
			;Linear scroll speed curve
			;f(t) = Bt + C
			B := (MinLinesPerNotch-MaxLinesPerNotch)/AccelerationThreshold
			C := MaxLinesPerNotch
			Lines := Round(B*T + C)
		}
	}
	Return Lines
}

;All hotkeys can use the same instance of FocuslessScroll(). No need to have separate calls unless each hotkey requires different parameters (e.g. you want to disable acceleration for Ctrl-WheelUp and Ctrl-WheelDown). If you want a single set of parameters for all scrollwheel actions, you can simply use *WheelUp:: and *WheelDown:: instead.

;Win10里面已经不需要光标下滚轮这个功能
;if A_OSVersion in WIN_2003, WIN_XP, WIN_7
#If GV_ToggleWheel=1
	WheelUp::
		if A_OSVersion in WIN_2003, WIN_XP, WIN_7 
		{
			FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
		}
		else{
			Send,{WheelUp}
		}
	return

	^WheelUp::
		if A_OSVersion in WIN_2003, WIN_XP, WIN_7 
		{
			FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
		}
		else{
			Send,^{WheelUp}
		}
	return

	WheelDown::
		if A_OSVersion in WIN_2003, WIN_XP, WIN_7 
		{
			FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
		}
		else{
			Send,{WheelDown}
		}
	return

	^WheelDown::
		if A_OSVersion in WIN_2003, WIN_XP, WIN_7 
		{
			FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
		}
		else{
			Send,^{WheelUp}
		}
	return
#if

;WheelUp::
;^WheelUp:: ;zooms in
;WheelDown::
;^WheelDown:: ;zoom out
	;FocuslessScroll(MinLinesPerNotch, MaxLinesPerNotch, AccelerationThreshold, AccelerationType, StutterThreshold)
;Return

;************** Capslock+鼠标滚轮调整窗口透明度^    ************** {{{1
;~LShift & WheelUp::
Capslock & WheelUp::
; 透明度调整，增加。
WinGet, Transparent, Transparent,A
If (Transparent="")
	Transparent=255
	;Transparent_New:=Transparent+10
	Transparent_New:=Transparent+20
	If (Transparent_New > 254)
		Transparent_New =255
	WinSet,Transparent,%Transparent_New%,A

	tooltip 原透明度: %Transparent_New% `n新透明度: %Transparent%
	SetTimer, RemoveToolTip_transparent_Lwin, 1500
return

Capslock & WheelDown::
;透明度调整，减少。
WinGet, Transparent, Transparent,A
If (Transparent="")
	Transparent=255
	Transparent_New:=Transparent-10  ;◆透明度减少速度。
	;msgbox,Transparent_New=%Transparent_New%
	If (Transparent_New < 30)    ;◆最小透明度限制。
		Transparent_New = 30
	WinSet,Transparent,%Transparent_New%,A
	tooltip 原透明度: %Transparent_New% `n新透明度: %Transparent%
	;查看当前透明度（操作之后的）。
	;sleep 1500
	SetTimer, RemoveToolTip_transparent_Lwin, 1500
return

;设置Lwin &Mbutton直接恢复透明度到255。
Capslock & Mbutton::
	WinGet, Transparent, Transparent,A
	WinSet,Transparent,255,A
	tooltip 恢复 ;查看当前透明度（操作之后的）。
	;sleep 1500
	SetTimer, RemoveToolTip_transparent_Lwin, 1500
return

RemoveToolTip_transparent_Lwin:
	tooltip
	SetTimer, RemoveToolTip_transparent_Lwin, Off
return
;************shift+鼠标滚轮调整窗口透明度$***********

;http://www.autohotkey.com/forum/topic6772-75.html
;************** 在光标下方滚轮$ **************
;************** 按住Caps拖动鼠标^    ************** {{{1
Capslock & LButton::
Escape & LButton::
	CoordMode, Mouse  ; Switch to screen/absolute coordinates.
	MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
	WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
	WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
	if EWD_WinState = 0  ; Only if the window isn't maximized 
		SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
	GetKeyState, EWD_LButtonState, LButton, P
	if EWD_LButtonState = U  ; Button has been released, so drag is complete.
	{
		SetTimer, EWD_WatchMouse, off
		return
	}
	;GetKeyState, EWD_EscapeState, Escape, P
	;if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
	;{
	;	SetTimer, EWD_WatchMouse, off
	;	WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
	;	return
	;}
	; Otherwise, reposition the window to match the change in mouse coordinates
	; caused by the user having dragged the mouse:
	CoordMode, Mouse
	MouseGetPos, EWD_MouseX, EWD_MouseY
	WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
	SetWinDelay, -1   ; Makes the below move faster/smoother.
	WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
	EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
	EWD_MouseStartY := EWD_MouseY
return
;************** 按住ESC拖动$    **************


;************** Ez的方法^ ************** {{{1
GF_GetSysVar(sys_var_name)
{
	EnvGet, sv,% sys_var_name
	return % sv
}

AscSend(str){
	SetFormat, Integer, H
	for k,v in StrSplit(str)
	out.="{U+ " Ord(v) "}"
	Sendinput % out
}

;适合单行直接调用
CoordWinClick(x,y){
	CoordMode, Mouse, Window
	click %x%, %y%
}

;在调用的过程前面统一加上一句 CoordMode, Mouse, Window 较好，下同
ClickSleep(x,y,s){
	click %x%, %y%
	Sleep, % 100*s
}


ControlClickSleep(ctl,s){
	ControlClick, %ctl%
	Sleep, % 100*s
}

MyWinWaitActive(title){
	WinWait, %title%, 
	IfWinNotActive, %title%, , WinActivate, %title%, 
	WinWaitActive, %title%, 
}

/*
If (GetCursorShape() = 161920)      ;I 型光标
	SwitchIME("E0220804")               ;搜狗输入法中文半角
else 
	SwitchIME("4090409")	              ;英文键盘布局
return
*/
SwitchIME(dwLayout){
	DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, (DllCall("LoadKeyboardLayout", "Str", dwLayout, UInt, 0x01)))
}

/*
SwitchIME(dwLayout){ ;修改当前窗口输入法
    HKL:=DllCall("LoadKeyboardLayout", Str, dwLayout, UInt, 1)
    ControlGetFocus,ctl,A
    SendMessage,0x50,0,HKL,%ctl%,A
}
*/

GetCursorShape(){   ;获取光标特征码 by nnrxin  
    VarSetCapacity( PCURSORINFO, 20, 0) ;为鼠标信息 结构 设置出20字节空间
    NumPut(20, PCURSORINFO, 0, "UInt")  ;*声明出 结构 的大小cbSize = 20字节
    DllCall("GetCursorInfo", "Ptr", &PCURSORINFO) ;获取 结构-光标信息
    if ( NumGet( PCURSORINFO, 4, "UInt")="0" ) ;当光标隐藏时，直接输出特征码为0
        return, 0
    VarSetCapacity( ICONINFO, 20, 0) ;创建 结构-图标信息
    DllCall("GetIconInfo", "Ptr", NumGet(PCURSORINFO, 8), "Ptr", &ICONINFO)  ;获取 结构-图标信息
    VarSetCapacity( lpvMaskBits, 128, 0) ;创造 数组-掩图信息（128字节）
    DllCall("GetBitmapBits", "Ptr", NumGet( ICONINFO, 12), "UInt", 128, "UInt", &lpvMaskBits)  ;读取 数组-掩图信息
    loop, 128{ ;掩图码
        MaskCode += NumGet( lpvMaskBits, A_Index, "UChar")  ;累加拼合
    }
    if (NumGet( ICONINFO, 16, "UInt")<>"0"){ ;颜色图不为空时（彩色图标时）
        VarSetCapacity( lpvColorBits, 4096, 0)  ;创造 数组-色图信息（4096字节）
        DllCall("GetBitmapBits", "Ptr", NumGet( ICONINFO, 16), "UInt", 4096, "UInt", &lpvColorBits)  ;读取 数组-色图信息
        loop, 256{ ;色图码
            ColorCode += NumGet( lpvColorBits, A_Index*16-3, "UChar")  ;累加拼合
        }  
    } else
        ColorCode := "0"
    DllCall("DeleteObject", "Ptr", NumGet( ICONINFO, 12))  ; *清理掩图
    DllCall("DeleteObject", "Ptr", NumGet( ICONINFO, 16))  ; *清理色图
    VarSetCapacity( PCURSORINFO, 0) ;清空 结构-光标信息
    VarSetCapacity( ICONINFO, 0) ;清空 结构-图标信息
    VarSetCapacity( lpvMaskBits, 0)  ;清空 数组-掩图
    VarSetCapacity( lpvColorBits, 0)  ;清空 数组-色图
    return, % MaskCode//2 . ColorCode  ;输出特征码
}

Sub_KeyClick123:
	if winc_presses > 0 ; SetTimer 已经启动, 所以我们记录键击.
	{
		winc_presses += 1
		return
	}
	; 否则, 这是新开始系列中的首次按下. 把次数设为 1 并启动
	; 计时器：
	winc_presses = 1
	SetTimer, KeyWinC, % GV_Timer ; 在 400 毫秒内等待更多的键击.
return

KeyWinC:
	SetTimer, KeyWinC, off
	if winc_presses = 1 ; 此键按下了一次.
	{
		fun_KeyClickAction123(GV_KeyClickAction1)
	}
	else if winc_presses = 2 ; 此键按下了两次.
	{
		fun_KeyClickAction123(GV_KeyClickAction2)
	}
	else if winc_presses > 2
	{
		fun_KeyClickAction123(GV_KeyClickAction3)
		;MsgBox, Three or more clicks detected.
	}
	; 不论触发了上面的哪个动作, 都对 count 进行重置
	; 为下一个系列的按下做准备:
	winc_presses = 0
return

fun_KeyClickAction123(act){
	If RegExMatch(act,"i)^(run,)",m) {
		run,% substr(act,strlen(m1)+1)
	}
	else If RegExMatch(act,"i)^(send,)",m) {
		Send,% substr(act,strlen(m1)+1)
	}
	else If RegExMatch(act,"i)^(SendInput,)",m) {
		SendInput,% substr(act,strlen(m1)+1)
	}
	else If RegExMatch(act,"i)^(GoSub,)",m) {
		GoSub,% substr(act,strlen(m1)+1)
	}
}


;%A_YYYY%-%A_MM%-%A_DD%-%A_MSec%
;msgbox % fun_GetFormatTime("yyyy-MM-dd-HH-mm-ss")
fun_GetFormatTime(f,t="")
{
;FormatTime, TimeString, 200504, 'Month Name': MMMM`n'Day Name': dddd
;FormatTime, TimeString, ,'Month Name': MMMM`n'Day Name': dddd
FormatTime, TimeString, %t% ,%f%
return %TimeString%
}

Sub_ClipAppend:
	;SendInput,^{Home}^+{End}^c
	Send,^c
	ToolTip 已经添加到 %GV_TempPath%\ClipAppend.txt
	FileAppend, %ClipBoard%.`n, %GV_TempPath%\ClipAppend.txt
	Sleep 1000
	ToolTip
return


Sub_MaxRestore:
	WinGet, Status_minmax ,MinMax,A
	If (Status_minmax=1){
		WinRestore A
	}
	else{
		WinMaximize A
	}
return


Sub_WindowNoCaption:
	WinGetPos, xTB, yTB,lengthTB,hightTB, ahk_class Shell_TrayWnd
	;msgbox %xTB%
	;msgbox %yTB%
	;msgbox %lengthTB%
	;msgbox %hightTB%
	bd := 8 ;win8Border = 4
	lW := A_ScreenWidth
	hW := A_ScreenHeight
	if(xTB == 0){ ;左边和上、下面的情况
		if(yTB == 0){ ;任务栏在上和左
			if(lengthTB == A_ScreenWidth){ ;在上
				xW := 0
				yW := hightTB
				lW := A_ScreenWidth
				hW := A_ScreenHeight - hightTB
			}
			else{ ;在左
				xW := lengthTB
				yW := 0
				lW := A_ScreenWidth - lengthTB
				hW := A_ScreenHeight
			}
		}
		else{ ;在下
			xW := 0	
			yW := 0
			lW := A_ScreenWidth
			hW := A_ScreenHeight - hightTB
		}
	}
	else{ ;在右
		xW := 0
		yW := 0
		lW := A_ScreenWidth - lengthTB
		hW := A_ScreenHeight
	}
	WinSet, Style, ^0xC00000, A
return

;打开剪贴板中多个链接
OpenClipURLS:
	Loop, parse, clipboard, `n, `r  ; 在 `r 之前指定 `n, 这样可以同时支持对 Windows 和 Unix 文件的解析.
	{
		cu := A_LoopField
		if(RegExMatch(A_LoopField,"^http")){
			sleep 200
			run, nircmd shexec open "%A_LoopField%"
		}
	}
return
;************** Ez的方法$ **************


;************** Youdao_网络翻译^ ********* {{{1
;语音+弹窗  翻译-中英互译	by天甜	From:Cando_有道翻译+剪贴板函数+Splash函数+判断调试

<#y::
	原值:=Clipboard
	clipboard =
	Send ^c
	gosub sound
Return
sound:
	ClipWait,0.5
	If(ErrorLevel)
		{
		InputBox,varTranslation,请输入,你想翻译啥，我来说
		if !ErrorLevel
			{
			Youdao译文:=YouDaoApi(varTranslation)
			Youdao_网络释义:= json(Youdao译文, "web.value")
			SplashYoudaoMsg("Youdao_网络翻译", Youdao_网络释义)
			spovice:=ComObjCreate("sapi.spvoice")
			spovice.Speak(Youdao_网络释义)
			Sleep, 3000
			SplashTextOff
			}
		}
	else
		{
			varTranslation:=clipboard
			Youdao译文:=YouDaoApi(varTranslation)
			Youdao_网络释义:= json(Youdao译文, "web.value")
			SplashYoudaoMsg("Youdao_网络翻译", Youdao_网络释义)
			spovice:=ComObjCreate("sapi.spvoice")
			spovice.Speak(Youdao_网络释义)
			Sleep, 3000
			SplashTextOff
		}
	Clipboard:=原值
return

SplashYoudaoMsg(title, content){
	;SoundBeep 750, 500
	MouseGetPos, MouseX, MouseY ;获得鼠标位置x,y
	MouseZ := MouseX + 100
	SplashTextOn , 400, 60, %title%, %content%
	WinMove, %title%, , %MouseZ%, %MouseY%
	WinSet, Transparent, 200, %title%
}

YouDaoApi(KeyWord)
{
;    KeyWord:=SkSub_UrlEncode(KeyWord,"utf-8")
	url:="http://fanyi.youdao.com/fanyiapi.do?keyfrom=qqqqqqqq123&key=86514254&type=data&doctype=json&version=1.1&q=" . KeyWord
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET", url)
    WebRequest.Send()
    result := WebRequest.ResponseText
    Return result
}
json(ByRef js, s, v = "")
{
	j = %js%
	Loop, Parse, s, .
	{
		p = 2
		RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
		Loop {
			If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
				. "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
				Return
			Else If (x2 == q2 or q2 == "*") {
				j = %x3%
				z += p + StrLen(x2) - 2
				If (q3 != "" and InStr(j, "[") == 1) {
					StringTrimRight, q3, q3, 1
					Loop, Parse, q3, ], [
					{
						z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
						j = %x1%
					}
				}
				Break
			}
			Else p += StrLen(x)
		}
	}
	If v !=
	{
		vs = "
		If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
			and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
			vs := "", v := vx1
		StringReplace, v, v, ", \", All
		js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
	}
	Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
		? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}
;************** Youdao_网络翻译$ *********

;************** 组合快捷键部分 ************** {{{1
;************** Escape相关 ************** {{{2
; +HJKL 表示左下右上方向  SendInput@chm
Escape & j:: SendInput,{Blind}{Down}
Escape & k:: SendInput,{Blind}{Up}
Escape & h:: SendInput,{Blind}{Left}
Escape & l:: SendInput,{Blind}{Right}

Escape & w:: SendInput,{Blind}^{Right}
Escape & b:: SendInput,{Blind}^{Left}

Escape & e:: SendInput,{Blind}{PgDn}
Escape & q:: SendInput,{Blind}{PgUp}

;************** u,i单击双击^ ************** 
;Escape & u:: SendInput,{Blind}^{End}
;Escape & i:: SendInput,{Blind}^{Home}
;Escape & n:: SendInput,{Blind}{PgDn}
;Escape & m:: SendInput,{Blind}{PgUp}

Escape & u::
	GV_KeyClickAction1 := "SendInput,{End}"
	GV_KeyClickAction2 := "SendInput,^{End}"
	GoSub,Sub_KeyClick123
return

Escape & i::
	GV_KeyClickAction1 := "SendInput,{Home}"
	GV_KeyClickAction2 := "SendInput,^{Home}"
	GoSub,Sub_KeyClick123
return

Escape & n::
	GV_KeyClickAction1 := "SendInput,{PgDn}"
	GV_KeyClickAction2 := "SendInput,^{PgDn}"
	GoSub,Sub_KeyClick123
return

Escape & m::
	GV_KeyClickAction1 := "SendInput,{PgUp}"
	GV_KeyClickAction2 := "SendInput,^{PgUp}"
	GoSub,Sub_KeyClick123
return
;************** u,i单击双击$ **************

;***************** 剪贴板相关^ ************** {{{2
Escape & v::
	if EscapeV_presses > 0
	{
		EscapeV_presses += 1
		return
	}
	EscapeV_presses = 1
	SetTimer, KeyEscapeV, 175
return

KeyEscapeV:
	SetTimer, KeyEscapeV, off
	if EscapeV_presses = 1
	{
		GoSub,PastePureText
	}
	else if EscapeV_presses = 2
	{
		;msgbox 285
		;Menu, MyMenu, Show
		;EzMenuShow()
		;EzOtherMenuShow()
	}
	EscapeV_presses = 0
return


Escape & c::
	GoSub,Sub_ClipAppend
return

PastePureText:
	IfWinActive, ahk_class ConsoleWindowClass
	{
		;SendInput,!{Space}ep
		Send {Click Right}
	}
	else
	{
		clipboard = %clipboard%
		send,{Blind}^v
	}
return

;#z::Menu, MyMenu, Show  ; i.e. press the Win-Z hotkey to show the menu.
;***************** 剪贴板相关$ **************
;关闭和刷新
Escape & g:: SendInput,{Blind}^w
Escape & r:: SendInput,{Blind}^r
;切换tab
Escape & o:: send,{Blind}^+{Tab}
Escape & p:: send,{Blind}^{Tab}
;右键和DEL
;Escape & y:: send,{AppsKey}
Escape & y:: Send {Click Right}
Escape & d:: SendInput,{Delete}
;Alttab，Win8下暂时不能用
Escape & .:: AltTab
Escape & ,:: ShiftAltTab


;enter 回车窗口最大化
;Escape & Enter:: WinMaximize A
Escape & Enter:: GoSub,Sub_MaxRestore
Escape & Space:: WinMinimize A
^#u:: GoSub,OpenClipURLS

Escape & Pause::
	suspend permit
	pause toggle
return

;最后一行恢复自身功能，重要
Escape::
	suspend permit
	SendInput,{Escape}
return

/*
~Escape::
If (A_PriorHotkey=A_ThisHotkey && A_TimeSincePriorHotkey<200){
	;MsgBox You double taped %A_ThisHotkey%
	WinClose A
}
else {
	;sleep 200
	;msgbox press %A_ThisHotkey% for %A_TimeSinceThisHotkey%
	;if (A_TimeSinceThisHotkey > 200 && A_TimeSinceThisHotkey < 1000){
	SendInput {Escape}
	;}
}
return
*/


;************** CapsLock相关 ************** {{{2



	



;enter 回车窗口最大化
CapsLock & Enter:: GoSub,Sub_MaxRestore


;************** 自定义方法开始 **************

; 判断字符串是否为空 bool CheckStrIsNull
; 判断剪切板两边是否为空(就是判断有没有选中值) string  CheckOutsideIsSpace()
; 删除一行 void DeleteOneLine()

CheckStrIsNull(inputStr)
{
   LenthA:=StrLen(inputStr)
    
   inputStr := StrReplace(inputStr, A_Space, "")
   inputStr := StrReplace(inputStr, " ", "")
   LenthB:=StrLen(inputStr)
    
   if(LenthB=0)
   {
     return true
   }
   else
   {
      return false
   }
}

; 删除一行
DeleteOneLine()
{
  temp:=clipboard
  check:=CheckOutsideIsSpace()
  ; msgBox,%check%
  Switch check 
  {
    ; 1是行头 2是行内有数据 3是本行全是空格
    case "1":
    {
    	SendInput,{Backspace}
    }
	case "2":
    {
        SendInput,{Home 2}+{End}{Backspace 2}
    }
	case "3":
    {
       ; 只有一行空格的时候特殊处理
       SendInput,{Home}+{End}{Backspace 2}
    }
  }
  clipboard:=temp
  Return
}

; 判断两边是否是空
CheckOutsideIsSpace()
{
   clipboard := ""
   SendInput,{End}
   SendInput,+{Home}
   SendInput,^c
   ClipWait,0.2
   LenthA:=StrLen(clipboard)
   ; msgBox,%clipboard%
   ; msgBox,%LenthA%
   clipboard := StrReplace(clipboard, A_Space, "")
   clipboard := StrReplace(clipboard, " ", "")
   LenthB:=StrLen(clipboard)
   ; msgBox,%clipboard%
   ; msgBox,%LenthB%
   ; 让光标返回到最后面
   SendInput,{End}
   ; 这个要先验证 不然就返回2了  
   ; a不等于b就说明a是有空格的,b是把空格全部替换掉,如果等于0了就代表这行
   if(LenthA!=LenthB and LenthB=0)
   {
     ; 全是空格 全是空格需要特殊处理
     return "3"
   }
   if(StrLen(clipboard)=0)
   {
     return "1"
   }
   else
   {
      return "2"
   }
}

 
CheckWordLeftOrRight()
{
   clipboard := ""
   SendInput,+{Left}
   SendInput,^c
   ClipWait,0.2
   ; 还原光标位置
   SendInput,{Right}
   if(clipboard=" " or clipboard="""")
   {
	  ; 左边是空格,所以是向右边过去
	  return "you" 
   }
   else
   {
      return "zuo"
   }
}

CheckClipIsEmpty()
{

tempClip:=clipboard
if(tempClip="")
{
  return true
}
else
{
  return false
}
}

; win+e 如果剪切板中是路径就直接打开
#e::
{

tempClip:=clipboard
Sleep,200
strIndex1:=InStr(tempClip,":\") 
strIndex2:=InStr(tempClip,":/")
; 如果是文件就不打开
strIndex3:=InStr(tempClip,".")
SendInput,#e
if((strIndex1 > 0 || strIndex2 > 0) && strIndex3 = 0)
{
  ; msgBox,33
  Sleep,500
  Send,!d
  Sleep,200
  Send,^v
  Sleep,100
  Send,{Enter}
}
else
{
; msgBox,44
}

return 
}

; 向左选中一个单词并取消掉最后的一个空格
CheckLeftWord(){
clipboard := ""
SendInput,{Ctrl Down}{Left}{Shift Down}{Right}{Shift Up}{Ctrl Up}
; 把这些复制 判断最后一个
SendInput,{Right}{Shift Down}{Left}{Shift Up}
SendInput,^c
ClipWait,0.2
; 专门为了Vs改的,如果后面是空格就去掉
if(clipboard=" ")
{
 SendInput,{Ctrl Down}{Left}{Shift Down}{Right}{Shift Up}{Ctrl Up}+{Left}
}
else
{
  SendInput,{Ctrl Down}{Left}{Shift Down}{Right}{Shift Up}{Ctrl Up}
}
return
}

CheckRightWord(){
	SendInput,{Right}
	CheckLeftWord()
}


;************** 自定义方法结束 **************


;========================================自定义开始========================================
; 调整了  直接在这文件中搜索 调用任务栏相关程序快捷键
; ;+空格 改成了BackSpace
; ;+z 去掉了 免得冲突Vs的按键
; 删除了 CapsLock & n:: 把CapsLock & o p 改成了n m

; 我的其他Ahk代码

; ctrl+空格 自动打开listary搜索百度
^Space::
; 判断剪切板是否有值
Send,^j
sleep,100
Send,{Space 2}
return 
 
 
#Space::
; 判断剪切板是否有值
Send,^j
sleep,100
Send,{Space 2}
; 如果剪切板中有值就直接粘贴
if(!CheckClipIsEmpty())
{
 Send,^v
 Sleep,200
 Send,{Enter}
}
return
; 我的其他Ahk代码


;************** 代码开始 **************
^y::Click,right
CapsLock & d::DeleteOneLine()
CapsLock & Space:: send,{Backspace}
CapsLock & j:: SendInput,{Blind}{Down}
CapsLock & k:: SendInput,{Blind}{Up}
CapsLock & h:: SendInput,{Blind}{Left}
CapsLock & l:: SendInput,{Blind}{Right}

CapsLock & e::SendInput,{End}
CapsLock & b::SendInput,{Home}
; 通用的情况很有可能按错成l 只有在Vs中才能用到;
CapsLock & `;::SendInput,{End};
CapsLock & Backspace::SendInput,{Backspace}
;CapsLock & n:: SendInput,{Blind}{Right}
;CapsLock & m:: SendInput,{Blind}{Left}
; caps加上面的数字会变成大写 所以全部重写
CapsLock & 1::Send, {!}
CapsLock & 2::Send, `@  
CapsLock & 3::Send, {#}
CapsLock & 4::Send, `$
CapsLock & 5::Send, `%
CapsLock & 6::Send, {^} 
CapsLock & 7::Send, `& 
CapsLock & 8::Send, `* 
CapsLock & 9::Send, (){Left}
CapsLock & )::Send, (){Left}

; 加数字变大写 重写结束


; 解决按了以后锁定大写的问题
 
CapsLock & q::SendInput,q
CapsLock & u::SendInput,u
CapsLock & g::SendInput,g
CapsLock & y::SendInput,y
CapsLock & p::SendInput,p
CapsLock & v::SendInput,v
CapsLock & t::SendInput,t

; 解决按了以后锁定大写的问题

CapsLock & r::SendInput,{Shift}
CapsLock & f:: SendInput,{End}{Enter}
CapsLock & n:: send,{Blind}^{Right}
CapsLock & m:: send,{Blind}^{Left}

; 自动完成括号等开始
CapsLock & <::SendInput,`<`>{Left}
; 大括号很特殊 需要这么输出才行
CapsLock & [::
{
 Send, {{}{}}{Left}
 return
}

CapsLock & '::SendInput,""{Left}
CapsLock & w::
tempA:=clipboard
isLeft:=CheckWordLeftOrRight()
if(isLeft="zuo")
{
  CheckLeftWord()
}
else
{
  CheckRightWord()
}
clipboard:=tempA
return








; 自动完成括号等结束  +是Shift  ^是ctrl
Tab & h:: SendInput,+{Left}
Tab & j:: SendInput,+{Down}
Tab & l:: SendInput,+{Right}
Tab & k:: SendInput,+{Up}}

Tab & b:: SendInput,+^{Home}
Tab & e:: SendInput,+^{End}
Tab & n:: SendInput,+^{Right}
Tab & m:: SendInput,+^{Left}


Tab & r:: SendInput,{Blind}+^{Left}
Tab & Space:: send,{Backspace}
; ;用来选中

`; & b::SendInput,{Home}
`; & e::SendInput,{End}

; 开始 ;开始

`; & j:: SendInput,+{Down}
`; & k:: SendInput,+{Up}
`; & h:: SendInput,+{Left}
`; & l:: SendInput,+{Right}
`; & n:: SendInput,^{Right}
`; & m:: SendInput,^{Left}


`; & Space:: SendInput,{Delete}
`; & d::DeleteOneLine()
; ; & d::SendInput,{Home 2}+{End}
Tab & d::SendInput,{Home 2}+{End}

; 增强剪切板 如果没选中任何东西就复制一整行 去掉浏览器的小尾巴
GroupAdd,CopyGroup,ahk_exe devenv.exe
GroupAdd,CopyGroup,ahk_exe Totalcmd64.exe

; 去掉浏览器去小尾巴
; $^c::
; SendInput,^c
; ; 浏览器单独处理
; IfWinActive,ahk_exe chrome.exe
; {
;    ; 判断剪切板是否为空
;    Sleep,0.2
;    content :=  clipboard
;    msgBox,%clipboard%
;    ; 匹配正则开始
;    content := RegExReplace(content, "`as)————————————————(\r\n?|\n).*原文链接：https?://blog\.csdn\.net.*?$")
;    content := RegExReplace(content, "`as)作者：[^\r\n]*(\r\n?|\n)链接：https://www.zhihu.com.*?$")
;    content := RegExReplace(content, "`as)作者：[^\r\n]*(\r\n?|\n)链接：https://www.imooc.com.*?$")
;    ; 匹配正则结束
;    msgBox,%content%
;    clipboard := content
;    return
; }	
; return

$^c::
{
  clipboard=
  SendInput,^c
  IfWinActive,ahk_exe chrome.exe
  {
     ; clipWait方法,只会判断剪切板是否为空 只要之前有值也是返回true的
     ClipWait, 0.8
     ; 判断剪切板是否为空
     ; msgBox,%clipboard%
     content :=  clipboard
     ; 匹配正则开始
 
	 content := RegExReplace(content, "—{8,}[\s\S]*原文链接：https?://blog\.csdn\.net[\s\S]*$","")
	 content := RegExReplace(content, "作者：[\s\S]*链接：https://www.zhihu.com[\s\S]*$","")
 	 content := RegExReplace(content, "作者：[\s\S]*链接：https://www.imooc.com[\s\S]*$","")
	 content := RegExReplace(content, "作者：[\s\S]*链接：https://www.jianshu.com[\s\S]*$","")
	 ; 把最后的空格或者换行符移除掉 上面是.*? 匹配非换行符
	 
	 content := RegExReplace(content, "`as)\s+$")
     ; 匹配正则结束
     clipboard := content
  }	
  return
}

; ctrl+shift+c整行复制
+^c:: SendInput,{Home}+{End}^c
 

$^x::
	clipboard = 
	SendInput,^x
	; 判断剪切板是否为空
	ClipWait,0.2
    if(clipboard="" and !(WinActive("ahk_exe chrome.exe")))
 	{
 	   ; 如果为空就全部复制
       SendInput,{End}{Shift Down}{Home}{Shift Up}
	   SendInput,^x
	   SendInput,{End}
 	}
return

`; & z::SendInput,{Ctrl Down}z{Ctrl Up}
`; & v::SendInput,^v
;复制粘贴相关结束

 
; Vs开始
#IfWinActive, ahk_exe devenv.exe


`; & z::SendInput, {Ctrl Down}{Shift Down}{Alt Down}{F12}{Ctrl Up}{Shift Up}{Alt Up}
`; & t::SendInput, {Ctrl Down}[s{Ctrl Up}

CapsLock & `;::SendInput,{End};
CapsLock & g::SendInput,=

; ctrl+单击跳转到定义 
^RButton::
  Send,{Click}{Ctrl Down}{F12}{Ctrl Up}
Return

CapsLock & [::
{
	; Vs大括号输入 形成一个{}中间空一行的样式
	Send, {{}{Enter}
	Send, {}}{Up}{Enter}
	Return
}

+RButton::Send,^+.


#IfWinActive

; Vs结束

; =========================自定义热字串-开始============================

::mb::
	SendInput,msgBox
return

; =========================自定义热字串-结束============================

;========================================自定义结束========================================


^!#r:: 
	;<==关闭hint模式键
	;down:=(down) ? 0 : 1
	Reload    ;<==用重启脚本来修复已知缺陷：需要按两次F2才能再开启hint by Zz
return
 

;+CapsLock:: CapsLock "之前的写法
;^PrintScreen::
^CapsLock::  ; control + capslock to toggle capslock.  alwaysoff/on so that the key does not blink
	GetKeyState t, CapsLock, T
	IfEqual t,D, SetCapslockState AlwaysOff
	Else SetCapslockState AlwaysOn
Return


;************** 分号;相关 ************** 

;恢复分号自身功能
;$`;:: SendInput,`;
`;:: SendInput,`;
^`;:: SendInput,^`;
^+`;:: SendInput,^+`;
!`;:: SendInput,!`;
::: SendInput,:


;************** `相关 ************** {{{2
;这个位置顺手，主要是在按住做了那么选择之后，再去按ctrl或者；分号等就显得远了
` & 1:: SendInput,^x
` & 2:: SendInput,^c
` & 3:: SendInput,^v
` & 4:: SendInput,{Del}
` & `;:: SendInput,{Blind}{Home}+{End}

` & j:: SendInput,{Blind}+{Down}
` & k:: SendInput,{Blind}+{Up}
` & h:: SendInput,{Blind}+{Left}
` & l:: SendInput,{Blind}+{Right}

` & b:: SendInput,{Blind}^+{Left}
` & w:: SendInput,{Blind}^+{Right}

;` & o:: SendInput,{Blind}^{PgUp}
;` & p:: SendInput,{Blind}^{PgDn}
` & n:: SendInput,{Blind}+{PgDn}
` & m:: SendInput,{Blind}+{PgUp}
;` & y:: SendInput,{Blind}{Home}+{End}
;` & u:: SendInput,{Blind}+{End}
;` & i:: SendInput,{Blind}+{Home}
` & u::
	GV_KeyClickAction1 := "SendInput,+{End}"
	GV_KeyClickAction2 := "SendInput,^+{End}"
	GoSub,Sub_KeyClick123
return

` & i::
	GV_KeyClickAction1 := "SendInput,+{Home}"
	GV_KeyClickAction2 := "SendInput,^+{Home}"
	GoSub,Sub_KeyClick123
return

` & y::
	GV_KeyClickAction1 := "SendInput,{Blind}{Home}+{End}"
	GV_KeyClickAction2 := "SendInput,^{Home}"
	GoSub,Sub_KeyClick123
return

;点不是默认的“确定”或者OK按钮，如果没有就点第一个Button1，适用与那种简单的对话框，比如TC的备注
` & Enter::
	try {
		SetTitleMatchMode RegEx
		SetTitleMatchMode Slow
		ControlClick, i).*确定|OK.*, A
	} catch e {
		ControlClick, Button1, A
	}
return


+`::SendInput,~
`::SendInput,``
^`::SendInput,^``
!`::SendInput,!``
+!`::SendInput,+!``
;`::EzMenuShow()


;************** Alttab相关 **************  

;按住左键再进行滚轮，在AltaTab菜单中，可以点击右键或者按空格进行确认选择。
;多用在把文件拖到别的程序中打开，或者类似于qq微信传文件。也可以将浏览器中的图片直接拖到文件管理器中保存
; LButton & WheelUp::ShiftAltTab
; LButton & WheelDown::AltTab
;就没必要还用这个了
;LWin & WheelUp::ShiftAltTab
;LWin & WheelDown::AltTab

;鼠标中操作
#IfWinActive, ahk_class TaskSwitcherWnd
;Win10自己已经支持alttab中按空格选择程序
;if A_OSVersion in WIN_2003, WIN_XP, WIN_7
;{
!Space::send,{Alt Up}
Space::send,{Alt Up}
;}
;在alttab的菜单中，点右键选中对应的程序
!RButton::send,{Alt Up}
~LButton & RButton::send,{Alt Up}

;alt+shift+tab，切换到上一个窗口功能，放在一起共用 TaskSwitcherWnd算了
;<+Tab::ShiftAltTab


;左手
!q::SendInput,{Blind}{Left}
;右手
!j::SendInput,{Blind}{Down}
!k::SendInput,{Blind}{Up}
!h::SendInput,{Blind}{Left}
!l::SendInput,{Blind}{Right}
!u::SendInput,{Blind}{End}
!i::SendInput,{Blind}{Home}
!,::SendInput,{Blind}{Left}
!.::SendInput,{Blind}{Right}


#IfWinActive

;10改成了MultitaskingViewFrame
#IfWinActive, ahk_class MultitaskingViewFrame
!RButton::send,{Alt Up}
~LButton & RButton::send,{Alt Up}

;左手
!q::SendInput,{Blind}{Left}
;右手
!j::SendInput,{Blind}{Down}
!k::SendInput,{Blind}{Up}
!h::SendInput,{Blind}{Left}
!l::SendInput,{Blind}{Right}
!u::SendInput,{Blind}{End}
!i::SendInput,{Blind}{Home}
!,::SendInput,{Blind}{Left}
!.::SendInput,{Blind}{Right}

#IfWinActive

;************** tab相关 **************  
;基本操作上下左右，还可以扩展，主要用在左键右鼠的操作方式

;对应任务栏上固定的前5个程序快速切换
Tab & 1:: send,#1
Tab & 2:: send,#2
Tab & 3:: send,#3
Tab & 4:: send,#4
Tab & 5:: send,#5


;重要的alttab菜单
<!Tab::AltTab


;好用
;!+Tab::MsgBox 111
;!Tab::MsgBox 222
;不好用

;恢复tab自身功能
Tab:: SendInput,{Tab}
#Tab:: SendInput,#{Tab}
+Tab:: SendInput,+{Tab}
^Tab:: SendInput,^{Tab}
^+Tab:: SendInput,^+{Tab}


;************** 截图小功能 ************** {{{2
>!Space::fun_NircmdScreenShot(1)
^PrintScreen::fun_NircmdScreenShot(0)
+PrintScreen::fun_NircmdScreenShot(1)
fun_NircmdScreenShot(wd)
{
	;1 ActiveWin ,0 WholeDesktop
	ScreenShotPath := "D:\"
	if(wd==1){
		SSFileName = % ScreenShotPath . "SSAW-" . fun_GetFormatTime( "yyyy-MM-dd HH-mm-ss" ) . ".png"
		run nircmd savescreenshotwin "%SSFileName%"
	}
	else{
		SSFileName = % ScreenShotPath . "SSWD-" .  fun_GetFormatTime( "yyyy-MM-dd HH-mm-ss" ) . ".png"
		run nircmd savescreenshot "%SSFileName%"
	}
}



;************** 窗口相关 ************** {{{2
;#a:: WinClose A
;去掉标题栏
#f11::
	;WinSet, Style, ^0xC00000, A ;用来切换标题行，主要影响是无法拖动窗口位置。
	;WinSet, Style, ^0x40000, A ;用来切换sizing border，主要影响是无法改变窗口大小。
	GoSub, Sub_WindowNoCaption
return

#f12::Winset, Alwaysontop, toggle, A


;刷新本脚本
;^!#r:: reload
;^!#r::
;reload
;ToolTip 已经刷新脚本
;Sleep 2000
;ToolTip
;return

;************** mouse鼠标相关 ************** {{{2
;鼠标侧边键XButton2
;XButton1:: Send,{PgUp}
;XButton2:: Send,{PgDn}

;************** 单键快捷键模式相关 ************** {{{1
;ScrollLock::
CapsLock & /::
Escape & /::
;	GV_ToggleKeyMode := !GV_ToggleKeyMode
return

#If GV_ToggleKeyMode=1
j::Send {Down}
k::Send {Up}
h::Send {Left}
l::Send {Right}
y:: Send {Click Right}

u::
	GV_KeyClickAction1 := "SendInput,{End}"
	GV_KeyClickAction2 := "SendInput,^{End}"
	GoSub,Sub_KeyClick123
return

i::
	GV_KeyClickAction1 := "SendInput,{Home}"
	GV_KeyClickAction2 := "SendInput,^{Home}"
	GoSub,Sub_KeyClick123
return

n::
	GV_KeyClickAction1 := "SendInput,{PgDn}"
	GV_KeyClickAction2 := "SendInput,^{PgDn}"
	GoSub,Sub_KeyClick123
return

m::
	GV_KeyClickAction1 := "SendInput,{PgUp}"
	GV_KeyClickAction2 := "SendInput,^{PgUp}"
	GoSub,Sub_KeyClick123
return

o:: send,{Blind}^+{Tab}
p:: send,{Blind}^{Tab}
.:: SendInput,^w
w:: SendInput,^w

`;:: Send {Click}
,:: SendInput,{Escape}

#If

;************** 应用程序相关 ************** {{{1
;************** _group相关 ************** {{{2
#IfWinActive, ahk_group group_browser
	F1:: SendInput,^t
	F2:: send,{Blind}^+{Tab}
	F3:: send,{Blind}^{Tab}
	F4:: SendInput,^w
	`;:: 
		;msgbox % GetCursorShape()
		;64位的Win7下是148003967
		If (GetCursorShape() = 148003967)      ;I 型光标
			SendInput,`;
		else 
			Send {Click}
	return
	!`;:: Send {Click Right}
	;^`;:: Send,`;

	;按住左键点右键发送Ctrl+W关闭标签
	~LButton & RButton:: send ^w

#IfWinActive

 



;totalcmd中特殊的按住左键点右键移动
;#IfWinNotActive ahk_class TTOTAL_CMD
;~LButton & RButton::
	;;opera 等少数软件之中都可以有自己的按住左键点右键功能
	;if not WinActive("ahk_class OperaWindowClass") and not WinActive("GreenBrowser"){
	;send ^w
	;}
;return 
;#IfWinNotActive




;************** 启动程序快捷键（建议修改） ************** {{{1
#h::run, cmd
;管理员权限cmd
^#h::run, *RunAs cmd


 

;************** 各程序快捷键或功能 ************** {{{1
;调用任务栏相关程序快捷键 {{{2


`; & q::
	send,#1
return

; `; & w::
; 	send,#2
; return

 
; `; & t::
; 	Run, C:\Program Files (x86)\Notepad++\notepad++.exe
; return

 


#IfWinActive ahk_class TXGuiFoundation       ;QQ,Tim
{
	!1::CoordWinClick(Tim_Start_X, Tim_Start_Y+(1-1)*Tim_Bar_Height)
	!2::CoordWinClick(Tim_Start_X, Tim_Start_Y+(2-1)*Tim_Bar_Height)
	!3::CoordWinClick(Tim_Start_X, Tim_Start_Y+(3-1)*Tim_Bar_Height)
	!4::CoordWinClick(Tim_Start_X, Tim_Start_Y+(4-1)*Tim_Bar_Height)
	!5::CoordWinClick(Tim_Start_X, Tim_Start_Y+(5-1)*Tim_Bar_Height)
	!6::CoordWinClick(Tim_Start_X, Tim_Start_Y+(6-1)*Tim_Bar_Height)
	!7::CoordWinClick(Tim_Start_X, Tim_Start_Y+(7-1)*Tim_Bar_Height)
	!8::CoordWinClick(Tim_Start_X, Tim_Start_Y+(8-1)*Tim_Bar_Height)
	!9::CoordWinClick(Tim_Start_X, Tim_Start_Y+(9-1)*Tim_Bar_Height)
	!0::CoordWinClick(Tim_Start_X, Tim_Start_Y+(10-1)*Tim_Bar_Height)
}


;微信PC客户端
#IfWinActive ahk_exe WeChat.exe
{
	;聚焦搜索框
	!/::CoordWinClick(100,36)
	;点击绿色聊天的数字
	!,::
		CoordMode, Mouse, Window
		click 28,90 2
		Sleep,100
		click 180,100
	Return
	;聚焦打字框
	!`;::
		WinGetPos, wxx, wxy,wxw,wxh, ahk_class WeChatMainWndForPC
		wxw := wxw - 80
		wxh := wxh - 60
		CoordWinClick(wxw,wxh)
	return

	!1::CoordWinClick(WX_Start_X, WX_Start_Y+(1-1)*WX_Bar_Height)
	!2::CoordWinClick(WX_Start_X, WX_Start_Y+(2-1)*WX_Bar_Height)
	!3::CoordWinClick(WX_Start_X, WX_Start_Y+(3-1)*WX_Bar_Height)
	!4::CoordWinClick(WX_Start_X, WX_Start_Y+(4-1)*WX_Bar_Height)
	!5::CoordWinClick(WX_Start_X, WX_Start_Y+(5-1)*WX_Bar_Height)
	!6::CoordWinClick(WX_Start_X, WX_Start_Y+(6-1)*WX_Bar_Height)
	!7::CoordWinClick(WX_Start_X, WX_Start_Y+(7-1)*WX_Bar_Height)
	!8::CoordWinClick(WX_Start_X, WX_Start_Y+(8-1)*WX_Bar_Height)
	!9::CoordWinClick(WX_Start_X, WX_Start_Y+(9-1)*WX_Bar_Height)
	!0::CoordWinClick(WX_Start_X, WX_Start_Y+(10-1)*WX_Bar_Height)
}


;telegram
#IfWinActive ahk_exe Telegram.exe
{
	!/::CoordWinClick(150,52)
	!1::CoordWinClick(TG_Start_X, TG_Start_Y+(1-1)*TG_Bar_Height)
	!2::CoordWinClick(TG_Start_X, TG_Start_Y+(2-1)*TG_Bar_Height)
	!3::CoordWinClick(TG_Start_X, TG_Start_Y+(3-1)*TG_Bar_Height)
	!4::CoordWinClick(TG_Start_X, TG_Start_Y+(4-1)*TG_Bar_Height)
	!5::CoordWinClick(TG_Start_X, TG_Start_Y+(5-1)*TG_Bar_Height)
	!6::CoordWinClick(TG_Start_X, TG_Start_Y+(6-1)*TG_Bar_Height)
	!7::CoordWinClick(TG_Start_X, TG_Start_Y+(7-1)*TG_Bar_Height)
	!8::CoordWinClick(TG_Start_X, TG_Start_Y+(8-1)*TG_Bar_Height)
	!9::CoordWinClick(TG_Start_X, TG_Start_Y+(9-1)*TG_Bar_Height)
	!0::CoordWinClick(TG_Start_X, TG_Start_Y+(10-1)*TG_Bar_Height)
}


#IfWinActive,批量重命名 ahk_class TMultiRename
{
F1::Send,!p{tab}{enter}e
}

;totalcmd中快捷键 {{{2
#IfWinActive ahk_class TTOTAL_CMD
	,:: 
		ControlGetFocus, TC_CurrentControl, A
		;msgbox % name
		;TInEdit1 地址栏和重命名 Edit1 命令行
		if (RegExMatch(TC_CurrentControl, "TMyListBox1|TMyListBox2"))
			TcSendPos(524)   ;cm_ClearAll
		else
			send,`,
	return
	/*
	   [:: send,{Home}{Down}
	 */
	;]:: send,{End}
	;复制到对面选中目录
	^!F5::
		send,{Tab}^+c{Tab}{F5}
		Sleep,500
		send,^v
		Sleep,500
		send,{Enter 2}
	return
	;移动到对面选中目录
	^!F6::
		send,{Tab}^+c{Tab}{F6}
		Sleep,500
		send,^v
		Sleep,500
		send,{Enter 2}
	return
	;加上剪贴板中内容改名
	^F2::
		send,+{F6}
		Sleep,300
		send,{right}
		Sleep,300
		send,{Space}^v
		Sleep,300
		send,{Enter}
	return

	;中键点击，在新建标签中打开
	MButton::
		Send,{Click}
		Sleep 50
		TcSendPos(3003)
	return

	`:: GoSub,Sub_azHistory

#IfWinActive

TcSendPos(Number)
{
    PostMessage 1075, %Number%, 0, , AHK_CLASS TTOTAL_CMD
}


;excel中 {{{2
;excel 2010: ahk_class bosa_sdm_XL9  excel2013: ahk_class XLMAIN ahk_exe C:\Windows\System32\Notepad.exe 
#IfWinActive ahk_exe excel.exe 
{
	;复制单元格纯文本
	!c:: send,{F2}^+{Home}^c{Esc}
	;筛选
	f3::PostMessage, 0x111, 447, 0, , a   
	;定位
	!g::ControlClick, Edit1
	;详细编辑
	!;::ControlClick, EXCEL<1
}

 

;快速目录切换 {{{2
;收藏的目录，
;最近使用的目录
;#IfWinActive 另存为 ahk_class #32770
;#If WinActive("另存为 ahk_class #32770") or WinActive("打开 ahk_class #32770")
;!f:: SendPath2Diag("另存为","Edit1","d:\My Documents\桌面")
;send,!n%2Path%{Enter}{Del}
;send,% text
;ControlSetText, Edit1, "d:\My Documents\桌面",A
;ControlSetText, Edit1, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
#IfWinActive, ahk_group GroupDiagOpenAndSave
	!g:: GoSub,Sub_SendCurDiagPath2Tc
	!t:: GoSub,Sub_SendTcCurPath2Diag
#IfWinActive

;在TC中打开对话框的路径
Sub_SendCurDiagPath2Tc:
	WinGetText, CurWinAllText
	;MsgBox, The text is:`n%CurWinAllText%
	Loop, parse, CurWinAllText, `n, `r
	{
		If RegExMatch(A_LoopField, "^地址: "){
			curDiagPath := SubStr(A_LoopField,4)
			break
		}
	}
	;msgbox % curDiagPath
	WinActivate, ahk_class TTOTAL_CMD
	ControlSetText, Edit1, cd %curDiagPath%, ahk_class TTOTAL_CMD
	sleep 900
	ControlSend, Edit1, {enter}, ahk_class TTOTAL_CMD
return

;将tc中路径发送到对话框
Sub_SendTcCurPath2Diag:
	;将剪贴板中内容作为文件名
	B_Clip2Name := false
	B_ChangeDiagSize := true

	;先获取TC中当前路径
	clip:=Clipboard
	Clipboard =
    ;CM_CopySrcPathToClip 2029
	PostMessage, TC_Msg, CM_CopySrcPathToClip,0,, ahk_class TTOTAL_CMD
	ClipWait, 1
	srcDIR := Clipboard
	Clipboard:=clip

	;再发送剪贴板路径到控件
	ControlFocus, Edit1, A
	send,{Backspace}
	sleep 100
	ControlSetText, Edit1, %srcDIR%,A
	send,{enter}
	;msgbox %clip%
	if(B_Clip2Name){
		Sleep 100
		ControlSetText, Edit1, %clip%,A
	}
	;ControlSetText, Edit1, %text%,A
	if(B_ChangeDiagSize){
		;WinGetPos, xTB, yTB,lengthTB,hightTB, ahk_class Shell_TrayWnd
		;改变对话框大小，省事就直接移动到100,100的位置，然后85%屏幕大小，否则就要详细结算任务栏在上下左右的位置
		WinMove, A,,80,80, A_ScreenWidth * 0.85, A_ScreenHeight * 0.85
	}
return
;构建对话框中菜单
Sub_Menu2Diag:
;左边历史
;右边历史
;hotdir
return


;Totalcmd历史记录 {{{2
;添加按照ini读取的启动菜单，接管`按键
;剪贴板增强
;固定文本条目增强
;#Persistent
Sub_azHistory:

    Global TC_azHistorySelect
	;MaxItem := 36
	;MaxItem := 10
	MaxItem := 30

	WinGet,exeName,ProcessName,A
	WinGet,exeFullPath,ProcessPath,A
	;D:\tools\totalcmd\TOTALCMD.EXE 正常多数是这种情况

	if(SubStr(exeFullPath,2,2)!=":\")
	{
		WinGet,pid,PID,A
		;\Device\RAMDriv\totalcmd\TOTALCMD.EXE 在内存盘上是
		sql = Select * from Win32_Process WHERE ProcessId = %pid%
		for process in ComObjGet("winmgmts:").ExecQuery(sql)
		{
			exeFullPath := process.CommandLine
			;"Z:\totalcmd\TOTALCMD.EXE"
		}
		exeFullPath := SubStr(exeFullPath,2,StrLen(exeFullPath)-3)
	}

	StringLeft, tcPath, exeFullPath, StrLen(exeFullPath)-StrLen(exeName)-1

	aTCINI = %tcPath%\wincmd.ini
    If Strlen(aTCINI)
    {
		PostMessage, TC_Msg, CM_ConfigSaveDirHistory,0,, ahk_class TTOTAL_CMD
        Sleep, 800
        If Mod(TC_LeftRight(), 2)
            Direct := "Left"
        Else
            Direct := "Right"

		try{
			;[LeftHistory]RedirectSection=%COMMANDER_PATH%\USER\HISTORY.INI
			INIRead, aRSTCINI, %aTCINI%, %Direct%History, RedirectSection
			;%COMMANDER_PATH%\USER\HISTORY.INI
			if SubStr(aRSTCINI,2,14)=="COMMANDER_PATH"
			{
				HINI := % SubStr(aRSTCINI,17)
				aTCINI = %tcPath%%HINI%
			}
		}
		catch e{
		}

        INIRead, HistoryList, %aTCINI%, %Direct%History
        arrHistory := StrSplit(HistoryList, "`n", "`r")
        TC_azHistorySelect := {}
        SplitPath, A_LineFile, , ScriptDir
        ;IconFile := ScriptDir "\azHistory.icl"
        Menu, TC_azHistory, UseErrorLevel
        Menu, TC_azHistory, DeleteAll
		if(arrHistory.MaxIndex()<MaxItem)
			MaxItem := arrHistory.MaxIndex()
        Loop % MaxItem
        {
			Value := RegExReplace(arrHistory[A_Index],"^\d\d?=")
			IconNum := A_Index
			if(A_Index <= 10)
				Char := "[&" Chr(A_Index+47) "]"
			else if(A_Index <= 36)
				Char := "[&" Chr(A_Index+54) "]"
			Else
				Char = ""
				;Break
            TC_azHistorySelect[A_Index] := Value
            Value := RegExReplace(Value, "::(\{[0-9a-zA-Z\-]*\})?\|")
            Menu, TC_azHistory, Add, %Char%    %Value%, azHistory_Select
            ;Menu, TC_azHistory, Add, %Value%%A_Tab%%Char%, azHistory_Select
            ;Menu, TC_azHistory, Icon, %Value%%A_Tab%%Char%, %IconFile%, %IconNum%
        }
        ControlGetFocus,TLB,ahk_class TTOTAL_CMD
        ControlGetPos,xn,yn,wn,,%TLB%,ahk_class TTOTAL_CMD
		yn := yn - 80
        Menu, TC_azHistory, Add, 关闭%A_Tab%[& ],TC_azHistory_DeleteAll
		Menu, TC_azHistory, Show, %XN%, %YN%
    }
return

TC_azHistory_DeleteAll:
	Menu, TC_azHistory, DeleteAll
return

azHistory_Select:
	Global TC_azHistorySelect
    Value := TC_azHistorySelect[A_ThisMenuItemPos]
    If RegExMatch(Value, "^::")
    {
        If RegExMatch(Value, "::\{20D04FE0\-3AEA\-1069\-A2D8\-08002B30309D\}")
            Number := CM_OpenDrives
        Else If RegExMatch(Value, "::(?!\{)")
            Number := CM_OpenDesktop
        Else If RegExMatch(Value, "::\{21EC2020\-3AEA\-1069\-A2DD\-08002B30309D\}\\::\{2227A280\-3AEA\-1069\-A2DE\-08002B30309D\}")
		    Number := cm_OpenPrinters
	    Else If RegExMatch(Value, "::\{F02C1A0D\-BE21\-4350\-88B0\-7367FC96EF3C\}")
		    Number := cm_OpenNetwork
        Else If RegExMatch(Value, "::\{26EE0668\-A00A\-44D7\-9371\-BEB064C98683\}\\0")
		    Number := cm_OpenControls
	    Else If RegExMatch(Value, "::\{645FF040\-5081\-101B\-9F08\-00AA002F954E\}")
		    Number := cm_OpenRecycled
        PostMessage, %TC_Msg%, %Number%, 0, , AHK_CLASS TTOTAL_CMD
    }
    Else
    {
        ThisMenuItem := RegExReplace(Value,"\t.*$")
        WinGet, ExeName, ProcessName, ahk_class TTOTAL_CMD
		ControlSetText, Edit1, cd %ThisMenuItem%, ahk_class TTOTAL_CMD
		ControlSend, Edit1, {enter}, ahk_class TTOTAL_CMD
    }
return

TC_LeftRight()
{
	Location := 0
	ControlGetPos,x1,y1,,,%TCPanel1%,AHK_CLASS TTOTAL_CMD
	If x1 > %y1%
		location += 2
	ControlGetFocus,TLB,ahk_class TTOTAL_CMD
	ControlGetPos,x2,y2,wn,,%TLB%,ahk_class TTOTAL_CMD
	If location
	{
		If x1 > %x2%
			location += 1
	}
	Else
	{
		If y1 > %y2%
			location += 1
	}
	Return location
}

MenuHandler:
MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
return


CreatTrayMenu()
{
Menu,Tray,NoStandard
Menu,Tray,add,重启(&R),Menu_Reload
Menu,Tray,add
Menu,Tray,add,暂停热键(&S),Menu_Suspend
Menu,Tray,add,暂停脚本(&A),Menu_Pause
Menu,Tray,add,退出(&X),Menu_Exit
}
Menu_Reload:
	Reload
return
Menu_Suspend:
	Menu,tray,ToggleCheck,暂停热键(&S)
	Suspend
return
Menu_Pause:
	Menu,tray,ToggleCheck,暂停脚本(&A)
	Pause
return
Menu_Exit:
	ExitApp
return

Quit:
ExitApp

; vim: textwidth=120 wrap tabstop=4 shiftwidth=4
; vim: foldmethod=marker fdl=0
