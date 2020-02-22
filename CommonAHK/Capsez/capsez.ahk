#singleinstance force


;  CapsLock & d   用于复制   
;  !Alt ^Ctrl   +Shift &用于连接两个按键(含鼠标按键)  RButton 右键  MButton 鼠标中键 


 
;************** 两个关键字开始 **************
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

;************** 两个关键字结束 **************


; ;************** 自动重启脚本开始 ************** 
;设定15分钟重启一次脚本，防止卡键 1000*60*15
GV_ReloadTimer := % 1000*60*15


Gosub,AutoReloadInit
AutoReloadInit:
	SetTimer, SelfReload, % GV_ReloadTimer
return

SelfReload:
	reload
return
;************** 自动重启脚本结束 ************** 



;************** 自定义方法开始 **************

;按控件内坐标点击
CoordWinClick(x,y){
	CoordMode, Mouse, Window
	click %x%, %y%
}

Sub_MaxRestore:
	WinGet, Status_minmax ,MinMax,A
	If (Status_minmax=1){
		WinRestore A
	}
	else{
		WinMaximize A
	}
return


; 判断字符串是否为空 bool CheckStrIsNull
; 判断剪切板两边是否为空(就是判断有没有选中值) string  CheckOutsideIsSpace()
; 删除一行 void DeleteOneLine()

CheckStrIsNull(inputStr)
{
   LenthA:=StrLen(inputStr)
    
   inputStr := StrReplace(inputStr, A_Space, "")
   inputStr := StrReplace(inputStr, A_Tab, "")
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
   clipboard :=
   SendInput,{End}
   SendInput,+{Home}
   SendInput,^c
   ClipWait,0.2
   checkedStr:=clipboard
   LenthA:=StrLen(checkedStr)
   ; msgBox,剪切板初始值:%checkedStr%
   ; msgBox,初始长度:%LenthA%
   ; 替换掉空格,tab缩进和" "
   checkedStr := StrReplace(checkedStr, A_Space, "")
   checkedStr := StrReplace(checkedStr, A_Tab, "")
   checkedStr := StrReplace(checkedStr, " ", "")
   LenthB:=StrLen(checkedStr)
   ; msgBox,剪切板第二次:%checkedStr%
   ; msgBox,第二次长度%LenthB%
   ; 让光标返回到最后面
   SendInput,{End}
   ; 这个要先验证 不然就返回2了  
   
   ; 1是行头 2是行内有数据 3是本行全是空格
   ; 初始长度不相等,但是最后替换了空格的长度是0就说明这行全是空格
   if(LenthA!=LenthB and LenthB=0)
   {
     ; 全是空格 全是空格需要特殊处理
     return "3"
   }
   if(StrLen(checkedStr)=0)
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

CheckIsXing(isLeft)
{
  clipboard=
  if(isLeft=="zuo")
  {
    Send,+{Left}
  }
  else
  {
    Send,+{Right}
  }
  Send,^c
  sleep,200
  if(clipboard="*")
  {
   return true
  }
  return false
}


;************** 自定义方法结束 **************



;************** CapsLock相关开始 ************** 

CapsLock::
	suspend permit
	 
return

; ctrl+caps恢复大写
^CapsLock::
	GetKeyState t, CapsLock, T
	IfEqual t,D, SetCapslockState AlwaysOff
	Else SetCapslockState AlwaysOn
Return

;enter 回车窗口最大化
CapsLock & Enter:: GoSub,Sub_MaxRestore

CapsLock & d::DeleteOneLine()

;重要
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


; 解决按了以后锁定大写问题
 
CapsLock & q::SendInput,q
CapsLock & u::SendInput,u
CapsLock & g::SendInput,g
CapsLock & y::SendInput,y
CapsLock & p::SendInput,p
CapsLock & v::SendInput,v
CapsLock & t::SendInput,t
CapsLock & a::SendInput,a
CapsLock & x::SendInput,x

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
 

;************** CapsLock相关结束 ************** 

;************** 分号相关开始 ************** 

`; & j:: SendInput,{Blind}{Down}
`; & k:: SendInput,{Blind}{Up}
`; & h:: SendInput,{Blind}{Left}
`; & l:: SendInput,{Blind}{Right}
`; & Space:: SendInput,{Blind}{Delete}

;恢复分号自身功能
;$`;:: SendInput,`;
`;:: SendInput,`;
^`;:: SendInput,^`;
^+`;:: SendInput,^+`;
!`;:: SendInput,!`;
::: SendInput,:

;************** 分号相关结束 ************** 

;************** tab相关开始 **************  

Tab & d::SendInput,{Home 2}+{End}

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

;恢复tab自身功能
Tab:: SendInput,{Tab}
#Tab:: SendInput,#{Tab}
+Tab:: SendInput,+{Tab}
^Tab:: SendInput,^{Tab}
^+Tab:: SendInput,^+{Tab}

;************** tab相关结束 **************  


;************** 我的其他Ahk代码 **************

; ctrl+y出现右键
^y::Click,right

; ctrl+空格 自动打开listary搜索百度
^Space::
Send,^j
sleep,100
Send,{Space 2}
return 
 
 ;在Vs中不生效 然后把Vs的快捷键重新定义一下成为不常用的,就可以了
^+Space::
{
   ; 判断剪切板是否有值
   if(!CheckClipIsEmpty())
	{
	    Send,^j
	    sleep,100
	    Send,{Space 2}
	    ; 如果剪切板中有值就直接粘贴
		Send,^v
		Sleep,200
		Send,{Enter}
	}	
return
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

; qq和Tim 按alt+d  其他的可以继续扩展
$!d::
{
	; 判断是微信
	IfWinActive,ahk_class WeChatMainWndForPC
	{
		WinGetPos, wxx, wxy,wxw,wxh, ahk_class WeChatMainWndForPC
		wxw := wxw - 80
		wxh := wxh - 60
		 
		CoordWinClick(wxw,wxh)
		return
	}
	IfWinActive,ahk_class TXGuiFoundation
	{
		WinGetPos, wxx, wxy,wxw,wxh, ahk_class TXGuiFoundation
		wxw := wxw - 380
		wxh := wxh - 100
		 
		CoordWinClick(wxw,wxh)
		return
	}
	Send,!d
	return
}

CapsLock & `::
{
   IfWinActive,ahk_exe navicat.exe
  	{
	    temp:=clipboard
		; 判断左右有没有值然后在单词左右附加`
		isLeft:=CheckWordLeftOrRight()
		isXing:=CheckIsXing(isLeft)
		
	    if(isXing=1)
		{
		  Send,{Left}``{Right}``
		  return
		}
		; 左边输入没问题 现在如果是返回右直接发一个ctrl右变成和左边一样
		if(isLeft="you")
		{
		  SendInput,^{Right}
		}
		
		 SendInput,^{Left}```
		 SendInput,^{Right}```
		 clipboard:=temp
		 return
  	}
  return
		
}


;************** 我的其他Ahk代码结束 ************** 



;************** 剪切板相关开始 ************** 

; 增强剪切板 如果没选中任何东西就复制一整行 
; 一些软件不打开
GroupAdd,CopyGroup,ahk_exe devenv.exe
GroupAdd,CopyGroup,ahk_exe Totalcmd64.exe

  
$^c::
IfWinNotActive,ahk_group CopyGroup
{
    clipboard = 
	SendInput,^c
	; 判断剪切板是否为空
	ClipWait,0.2
	; 浏览器要用,但是某一部分不要用
    if(clipboard=""  and !(WinActive("ahk_exe chrome.exe")))
 	{
 	    ; 如果为空就全部复制
        SendInput,{End}+{Home}
	    SendInput,^c
	    SendInput,{End}
 	}
	; 去掉浏览器的小尾巴
    IfWinActive,ahk_exe chrome.exe
	{
		content := Clipboard
		; 匹配正则开始
		content := RegExReplace(content, "—{8,}[\s\S]*原文链接：https?://blog\.csdn\.net[\s\S]*$","")
	    content := RegExReplace(content, "作者：[\s\S]*链接：https://www.zhihu.com[\s\S]*$","")
 	    content := RegExReplace(content, "作者：[\s\S]*链接：https://www.imooc.com[\s\S]*$","")
	    content := RegExReplace(content, "作者：[\s\S]*链接：https://www.jianshu.com[\s\S]*$","")
		; 把最后的空格或者换行符移除掉 上面是.*? 匹配非换行符 
	    content := RegExReplace(content, "`as)\s+$")
		; 匹配正则结束
		Clipboard := content
		Return
	}
}
else
{
	 
}	
return


$^x::
IfWinNotActive,ahk_group CopyGroup
{
    clipboard = 
	SendInput,^x
	; 判断剪切板是否为空
	ClipWait,0.2
	; 浏览器要用,但是某一部分不要用
    if(clipboard=""  and !(WinActive("ahk_exe chrome.exe")))
 	{
 	    ; 如果为空就全部复制
		SendInput,{End}+{Home}
		SendInput,^x
		SendInput,+{Home}{BackSpace 2}
 	}
}
else
{
	 
}	
return
 
 
`; & v::SendInput,^v
;************** 剪切板相关结束 ************** 


 
;************** Vs相关开始 ************** 
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

^+Space::
{
   Send,{Ctrl Down}kp{Ctrl Up}
   return 
}


#IfWinActive

;************** Vs相关结束 ************** 




;************** 热字串相关开始 ************** 
::mb::
	SendInput,msgBox
return

;************** 热字串相关结束 ************** 

 
;************** 自定义其他的开始 **************

; 注释掉F1,免得总是按错 F1也没啥用
F1::


;************** 自定义其他的结束 **************
 

 

 