EVERYTHING:
global everythingpath:="D:\Program Files to Portable type\Everything 1.4.0.713b\Everything.exe"
;vim.Comment("<EVERYTHING_打开路径>","EVERYTHING_打开路径")
;vim.comment("<EVERYTHING_复制完整路径>","EVERYTHING_复制完整路径")
;vim.comment("<EVERYTHING_按名称排序>","EVERYTHING_按名称排序")
;vim.comment("<EVERYTHING_按更新时间排序>","EVERYTHING_按更新时间排序")
;vim.comment("<EVERYTHING_按路径排序>","EVERYTHING_按路径排序")
;vim.comment("<EVERYTHING_按类型排序>","EVERYTHING_按类型排序")
;vim.comment("<EVERYTHING_按运行次数排序>","EVERYTHING_按运行次数排序")

vim.mode("normal","EVERYTHING")
vim.map("i","<Insert_Mode_EVERYTHING>","EVERYTHING")
vim.map("op","<EVERYTHING_打开路径>","EVERYTHING")
vim.map("oo","<EVERYTHING_搜索所有文件>","EVERYTHING")
vim.map("yp","<EVERYTHING_复制完整路径>","EVERYTHING")
vim.map("sn","<EVERYTHING_按名称排序>","EVERYTHING")
vim.map("sd","<EVERYTHING_按更新时间排序>","EVERYTHING")
vim.map("sp","<EVERYTHING_按路径排序>","EVERYTHING")
vim.map("se","<EVERYTHING_按类型排序>","EVERYTHING")
vim.map("sc","<EVERYTHING_按运行次数排序>","EVERYTHING")
vim.map("ge","<EVERYTHING_跳转至搜索框>","EVERYTHING")
;vim.map("f","<运行且激活程序Everything>","EVERYTHING")
;vim.map("<lwin>f","<ToggleEverything>")

vim.mode("insert","EVERYTHING")
vim.map("<esc>","<Normal_Mode_EVERYTHING>","EVERYTHING")


;vim.mode("normal","EVERYTHING")
;gosub,<normalmode_LED1>
Return

EVERYTHING_CheckMode()
{
	ControlGetFocus,ctrl,ahk_class EVERYTHING
	;MsgBox,%ctrl%
	If RegExMatch(ctrl,"Edit1")
	;CoordMode,Caret,Window
	;ToolTip, X%A_CaretX% Y%A_CaretY%, A_CaretX, A_CaretY - 20
	;If A_CaretX>10
		return True
	return False
}


;快捷键设定为Win+f



<Normal_Mode_EVERYTHING>:
    Send,{Esc}
    vim.Mode("normal","EVERYTHING")
    ;gosub,<normalmode_LED1>
    ;emptymem()
return
; <insert_TC> {{{1
<Insert_Mode_EVERYTHING>:
    vim.Mode("insert","EVERYTHING")
    ;gosub,<insertmode_LED1>
return

<mode_window_EVERYTHING>:
    vim.mode("window","EVERYTHING")
    ;gosub,<windowmode_LED1>
return


;移动
<EVERYTHING_复制完整路径>:
{
	send,^+c
return
}

<EVERYTHING_打开路径>:
{
	send,^{Enter}
return
}

<EVERYTHING_跳转至搜索框>:
{
    send,{F3}
return
}


<EVERYTHING_搜索所有文件>:
{
    send,{AppsKey}
    send,{down}{down}{down}{down}{down}{down}{down}{down}
    send,{enter}
return
}

<EVERYTHING_按名称排序>:
{
	send,^1
return
}

<EVERYTHING_按更新时间排序>:
{
	send,^6
return
}

<EVERYTHING_按路径排序>:
{
	send,^2
return
}

<EVERYTHING_按类型排序>:
{
	send,^5
return
}

<EVERYTHING_按运行次数排序>:
{
	send,^+!1
return
}



<运行且激活程序Everything>:
{
DetectHiddenWindows, on
IfWinNotExist ahk_class EVERYTHING
    Run "D:\GreenProgram\Everything\Everything.exe"
Else
IfWinNotActive ahk_class EVERYTHING
WinActivate
Else
WinMinimize
Return
}

<ToggleEverything>:
    IfWinExist,ahk_class EVERYTHING
        WinActivate,ahk_class EVERYTHING
    Else
        Run,%Everythingpath%
    Loop,4
    {
        IfWinNotActive,ahk_class EVERYTHING
            WinActivate,ahk_class EVERYTHING
        Else
            Break
        Sleep,500
    }
    ;emptymem()
return