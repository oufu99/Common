
; Tab用来打开程序或者是选中单词 行等

; 打开记事本  打开Notepad++
Tab & t::
IfWinExist, Notepad++
	 {
   	 	WinActivate ; 使用前面找到的窗口
	 }
   	 else
   	 {
   	    Run, %NotePadPath%
   	    WinActivate ; 
   	 }
return

^+q::
InputBox, ChoiceText, 请选择您想要的操作, 1.备份AdBlock 2.还原AdBlock
if ChoiceText=1
{
   BankAdBlock()   
}
if ChoiceText=2
{
	ResetAdBlock()
}    	 
return


ResetAdBlock()
{
 
 tempClip:=clipboard

 OutputVar:= ReadText(targetTextPath)
 Run,%chromePath%
 Sleep,1000
 ; 模拟点击坐标
 Send,#{Up}
 Sleep,300
 Send,!d
 Sleep,300
 ; 打开去广告的地址
 clipboard:=adblockPath
 ClipWait,0.2
 SendInput,^v
 Send,{Enter}
 Sleep,600
 Click,%screePoint%
 Sleep,300
 Send,^a{Delete}
 Sleep,300
 clipboard:=OutputVar
 ClipWait,0.2
 SendInput,^v
 Sleep,200
 Click,%screePoint%
 Sleep,500
 SendInput,^w
}
 

           
BankAdBlock(){
     ; 保存剪切板的值
	 tempClip:=clipboard
	 Run,%chromePath%
	 Sleep,1000
	 
	 ; 打开地址
	 Send,#{Up}
	 Sleep,300
	 Send,!d
	 Sleep,500
	 ; 打开去广告的地址
	 clipboard:=adblockPath
	 SendInput,^v
	 Send,{Enter}
	 Sleep,800
	 Click,%screePoint%
	 Sleep,300
	 Send,^a
	 Sleep,200
	 Send,^c
	 ClipWait,0.5
	
	 ruleText:=clipboard
	 WriteFile(targetTextPath,ruleText)
	 clipboard:=tempClip
	 Send,^w
}

	
	
`; & Tab:: 
IfWinExist, TTOTAL_CMD
		WinActivate ; 使用前面找到的窗口
	else
	   Run, %TCPath%
	   WinActivate
return

^!c::
       ; 判断是否在TC中运行

	   selected := ExplorerInfo(3)
	    if(selected="")
		{
		  Run,cmd,C:\
		}
		else
		{
		  Run,cmd, %selected%
		}
	return

; 打开TC开始 ========
#If WinActive("ahk_class CabinetWClass") or WinActive("ahk_class ExploreWClass")
	!w::
		selected := ExplorerInfo(1)
		 run, %TCPath% /T /O /P=R /S /A /R=%selected%
	return
	
	^w::
		selected := ExplorerInfo(2)
		if(selected="")
		{
		  Send,w
		  return
		}
		run, %NotePadPath% %selected%
		 
	return
	
;桌面
#If WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW")
	!w::
		selected := ExplorerInfo(1)
	    run, D:\MyLove\TotalCommand\Totalcmd64.exe /T /O /P=R /S /A /R=%selected%
	return
	^w::
		selected := ExplorerInfo(2)
		if(selected="")
		{
		  Send,w
		  return
		}
		 run, %NotePadPath% %selected%
	return

#If

ExplorerInfo(mode="",hwnd="") { ;Method="当前目录"的时候只返回当前目录;
	;mode默认空值时,不论是否选中文件/文件夹皆返回当前路径(目录名);
	;mode=0时,若选择了文件/文件夹则返回选中的目录名,不无选中时返回空;
	;mode=1时,若选择了文件/文件夹则返回完成路径+文件名,无选中时返回目录名;
	;mode=2时,若选择了文件/文件夹则返回完成路径+文件名,无选中时返回空值;
	 
	;@感谢Quant的原始代码
	Toreturn=
	filenum1=0
	filenum2=0
	WinGet, Process, ProcessName, % "ahk_id " (hwnd := hwnd? hwnd:WinExist("A")) ;这个地方判断是否给定了hwnd值,如果给定的为空,则获取当前窗口的句柄；否则就使用给定的句柄。
	;得出给定句柄对应的进程名称；
	WinGetClass class, ahk_id %hwnd% ;根据句柄来获取对应hwnd的窗口的类名；
	ComObjError(0) ;不显示对象显示的错误。
	if (Process = "explorer.exe") ; 如果进程为explorer则进行判断到底时处于桌面（Progman|WorkerW）还是资源管理器（(Cabinet|Explore)WClass）；
	if (class ~= "Progman|WorkerW")
	{
		ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class% ;获取选中的文件的列表[无法获取到扩展名]
		if files=
		Toreturn .= A_Desktop
		else
		{
			filenum1++
			Loop, Parse, files, `n, `r
			Toreturn .= A_Desktop "\" A_LoopField "`n"
		}
	}
	else if (class ~= "(Cabinet|Explore)WClass")
	{
		for window in ComObjCreate("Shell.Application").Windows ;遍历当前资源管理器中打开的窗口；
		{
			if (window.hwnd==hwnd) ;在多个窗口中取定位符合前面hwnd的哪个窗口；
			{
				pp:=window.Document.folder.self.path
				sel := window.Document.SelectedItems
				for item in sel
				{
					filenum2++
					Toreturn .= item.path "`r`n"
				}
				if Toreturn=
				Toreturn:=pp
			}
		}
	}
	 
	fde:=Trim(Toreturn,"`r`n") ;完整的路径和文件名,包括扩展名;
	if mode<> ;mode为012时
	{
		if (filenum1+filenum2=0)
		{
			if (mode=0)||(mode=2)
				return
			else ;mod=1时的情况;
				return fde
		}else {
			if (mode=1) or (mode=2)
				if (filenum1<>0)
				{
					aa:=CheckedFile()
					return aa ;CheckedFile()
				}
			else
				return fde
		}
	}
	if InStr(FileExist(fde), "D") ;这里判断目录
		return,RegExReplace(Trim(Toreturn,"`r`n") . "\","\\\\","\") ;这里的. "\"是给选定的文件夹加上\
	else if Toreturn<>
	{
		StringMid,Toreturn2, Toreturn,1,InStr(Toreturn,"\",,0)-1 ;如果不是目录则按最后一个反斜杠进行截取,取前面的目录；
		return RegExReplace(Toreturn2 . "\","\\\\","\")
	}
}
 
CheckedFile(){
	Clip:=ClipboardAll
	Clipboard=
	send ^c
	ClipWait,0.5
	cliptem:=Clipboard
	if (StrSplit(Cliptem,"`r").MaxIndex()=1)
	{
		Clipboard:= % Clip
		return RegExReplace(cliptem,"`r`n","")
	}
	else
	{
		Clipboard:= % Clip
		return cliptem
	}
}