#singleinstance force


;  CapsLock & d   ���ڸ���   




 
;************** �����ؼ��ֿ�ʼ **************
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

;************** �����ؼ��ֽ��� **************


; ;************** �Զ������ű���ʼ ************** 
;�趨15��������һ�νű�����ֹ���� 1000*60*15
GV_ReloadTimer := % 1000*60*15


Gosub,AutoReloadInit
AutoReloadInit:
	SetTimer, SelfReload, % GV_ReloadTimer
return

SelfReload:
	reload
return
;************** �Զ������ű����� ************** 



;************** �Զ��巽����ʼ **************

Sub_MaxRestore:
	WinGet, Status_minmax ,MinMax,A
	If (Status_minmax=1){
		WinRestore A
	}
	else{
		WinMaximize A
	}
return


; �ж��ַ����Ƿ�Ϊ�� bool CheckStrIsNull
; �жϼ��а������Ƿ�Ϊ��(�����ж���û��ѡ��ֵ) string  CheckOutsideIsSpace()
; ɾ��һ�� void DeleteOneLine()

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

; ɾ��һ��
DeleteOneLine()
{
  temp:=clipboard
  check:=CheckOutsideIsSpace()
  Switch check 
  {
    ; 1����ͷ 2������������ 3�Ǳ���ȫ�ǿո�
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
       ; ֻ��һ�пո��ʱ�����⴦��
       SendInput,{Home}+{End}{Backspace 2}
    }
  }
  clipboard:=temp
  Return
}

; �ж������Ƿ��ǿ�
CheckOutsideIsSpace()
{
   clipboard :=
   SendInput,{End}
   SendInput,+{Home}
   SendInput,^c
   ClipWait,0.2
   checkedStr:=clipboard
   LenthA:=StrLen(checkedStr)
   ; msgBox,���а��ʼֵ:%checkedStr%
   ; msgBox,��ʼ����:%LenthA%
   ; �滻���ո�,tab������" "
   checkedStr := StrReplace(checkedStr, A_Space, "")
   checkedStr := StrReplace(checkedStr, A_Tab, "")
   checkedStr := StrReplace(checkedStr, " ", "")
   LenthB:=StrLen(checkedStr)
   ; msgBox,���а�ڶ���:%checkedStr%
   ; msgBox,�ڶ��γ���%LenthB%
   ; �ù�귵�ص������
   SendInput,{End}
   ; ���Ҫ����֤ ��Ȼ�ͷ���2��  
   
   ; 1����ͷ 2������������ 3�Ǳ���ȫ�ǿո�
   ; ��ʼ���Ȳ����,��������滻�˿ո�ĳ�����0��˵������ȫ�ǿո�
   if(LenthA!=LenthB and LenthB=0)
   {
     ; ȫ�ǿո� ȫ�ǿո���Ҫ���⴦��
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
   ; ��ԭ���λ��
   SendInput,{Right}
   if(clipboard=" " or clipboard="""")
   {
	  ; ����ǿո�,���������ұ߹�ȥ
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

; win+e ������а�����·����ֱ�Ӵ�
#e::
{

tempClip:=clipboard
Sleep,200
strIndex1:=InStr(tempClip,":\") 
strIndex2:=InStr(tempClip,":/")
; ������ļ��Ͳ���
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

; ����ѡ��һ�����ʲ�ȡ��������һ���ո�
CheckLeftWord(){
clipboard := ""
SendInput,{Ctrl Down}{Left}{Shift Down}{Right}{Shift Up}{Ctrl Up}
; ����Щ���� �ж����һ��
SendInput,{Right}{Shift Down}{Left}{Shift Up}
SendInput,^c
ClipWait,0.2
; ר��Ϊ��Vs�ĵ�,��������ǿո��ȥ��
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


;************** �Զ��巽������ **************



;************** CapsLock��ؿ�ʼ ************** 

CapsLock::
	suspend permit
	 
return

; ctrl+caps�ָ���д
^CapsLock::
	GetKeyState t, CapsLock, T
	IfEqual t,D, SetCapslockState AlwaysOff
	Else SetCapslockState AlwaysOn
Return

;enter �س��������
CapsLock & Enter:: GoSub,Sub_MaxRestore

CapsLock & d::DeleteOneLine()

;��Ҫ
CapsLock & Space:: send,{Backspace}
CapsLock & j:: SendInput,{Blind}{Down}
CapsLock & k:: SendInput,{Blind}{Up}
CapsLock & h:: SendInput,{Blind}{Left}
CapsLock & l:: SendInput,{Blind}{Right}

CapsLock & e::SendInput,{End}
CapsLock & b::SendInput,{Home}
; ͨ�õ�������п��ܰ����l ֻ����Vs�в����õ�;
CapsLock & `;::SendInput,{End};
CapsLock & Backspace::SendInput,{Backspace}
;CapsLock & n:: SendInput,{Blind}{Right}
;CapsLock & m:: SendInput,{Blind}{Left}
; caps����������ֻ��ɴ�д ����ȫ����д
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

; �����ֱ��д ��д����


; ��������Ժ�������д������
 
CapsLock & q::SendInput,q
CapsLock & u::SendInput,u
CapsLock & g::SendInput,g
CapsLock & y::SendInput,y
CapsLock & p::SendInput,p
CapsLock & v::SendInput,v

; ��������Ժ�������д������

CapsLock & r::SendInput,{Shift}
CapsLock & f:: SendInput,{End}{Enter}
CapsLock & n:: send,{Blind}^{Right}
CapsLock & m:: send,{Blind}^{Left}

; �Զ�������ŵȿ�ʼ
CapsLock & <::SendInput,`<`>{Left}
; �����ź����� ��Ҫ��ô�������
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
 

;************** CapsLock��ؽ��� ************** 

;************** �ֺ���ؿ�ʼ ************** 

`; & j:: SendInput,{Blind}{Down}
`; & k:: SendInput,{Blind}{Up}
`; & h:: SendInput,{Blind}{Left}
`; & l:: SendInput,{Blind}{Right}
`; & Space:: SendInput,{Blind}{Delete}

;�ָ��ֺ�������
;$`;:: SendInput,`;
`;:: SendInput,`;
^`;:: SendInput,^`;
^+`;:: SendInput,^+`;
!`;:: SendInput,!`;
::: SendInput,:

;************** �ֺ���ؽ��� ************** 

;************** tab��ؿ�ʼ **************  

Tab & d::SendInput,{Home 2}+{End}

 ; �Զ�������ŵȽ���  +��Shift  ^��ctrl
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

;�ָ�tab������
Tab:: SendInput,{Tab}
#Tab:: SendInput,#{Tab}
+Tab:: SendInput,+{Tab}
^Tab:: SendInput,^{Tab}
^+Tab:: SendInput,^+{Tab}

;************** tab��ؽ��� **************  


;************** �ҵ�����Ahk���� **************

; ctrl+y�����Ҽ�
^y::Click,right

; ctrl+�ո� �Զ���listary�����ٶ�
^Space::
Send,^j
sleep,100
Send,{Space 2}
return 
 
 ;��Vs�в���Ч Ȼ���Vs�Ŀ�ݼ����¶���һ�³�Ϊ�����õ�,�Ϳ�����
^+Space::
{
   ; �жϼ��а��Ƿ���ֵ
	Send,^j
	sleep,100
	Send,{Space 2}
	; ������а�����ֵ��ֱ��ճ��
	if(!CheckClipIsEmpty())
	{
		Send,^v
		Sleep,200
		Send,{Enter}
	}	
return
}
 

;************** �ҵ�����Ahk������� ************** 



;************** ���а���ؿ�ʼ ************** 

; ��ǿ���а� ���ûѡ���κζ����͸���һ���� 
; һЩ�������
GroupAdd,CopyGroup,ahk_exe devenv.exe
GroupAdd,CopyGroup,ahk_exe Totalcmd64.exe

  
$^c::
IfWinNotActive,ahk_group CopyGroup
{
    clipboard = 
	SendInput,^c
	; �жϼ��а��Ƿ�Ϊ��
	ClipWait,0.2
	; �����Ҫ��,����ĳһ���ֲ�Ҫ��
    if(clipboard=""  and !(WinActive("ahk_exe chrome.exe")))
 	{
 	    ; ���Ϊ�վ�ȫ������
        SendInput,{End}+{Home}
	    SendInput,^c
	    SendInput,{End}
 	}
	; ȥ���������Сβ��
    IfWinActive,ahk_exe chrome.exe
	{
		content := Clipboard
		; ƥ������ʼ
		content := RegExReplace(content, "��{8,}[\s\S]*ԭ�����ӣ�https?://blog\.csdn\.net[\s\S]*$","")
	    content := RegExReplace(content, "���ߣ�[\s\S]*���ӣ�https://www.zhihu.com[\s\S]*$","")
 	    content := RegExReplace(content, "���ߣ�[\s\S]*���ӣ�https://www.imooc.com[\s\S]*$","")
	    content := RegExReplace(content, "���ߣ�[\s\S]*���ӣ�https://www.jianshu.com[\s\S]*$","")
		; �����Ŀո���߻��з��Ƴ��� ������.*? ƥ��ǻ��з� 
	    content := RegExReplace(content, "`as)\s+$")
		; ƥ���������
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
	; �жϼ��а��Ƿ�Ϊ��
	ClipWait,0.2
	; �����Ҫ��,����ĳһ���ֲ�Ҫ��
    if(clipboard=""  and !(WinActive("ahk_exe chrome.exe")))
 	{
 	    ; ���Ϊ�վ�ȫ������
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
;************** ���а���ؽ��� ************** 


 
;************** Vs��ؿ�ʼ ************** 
#IfWinActive, ahk_exe devenv.exe


`; & z::SendInput, {Ctrl Down}{Shift Down}{Alt Down}{F12}{Ctrl Up}{Shift Up}{Alt Up}
`; & t::SendInput, {Ctrl Down}[s{Ctrl Up}

CapsLock & `;::SendInput,{End};
CapsLock & g::SendInput,=

; ctrl+������ת������ 
^RButton::
  Send,{Click}{Ctrl Down}{F12}{Ctrl Up}
Return

CapsLock & [::
{
	; Vs���������� �γ�һ��{}�м��һ�е���ʽ
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

;************** Vs��ؽ��� ************** 




;************** ���ִ���ؿ�ʼ ************** 
::mb::
	SendInput,msgBox
return

;************** ���ִ���ؽ��� ************** 

 
;************** �Զ��������Ŀ�ʼ **************

; ע�͵�F1,������ǰ��� F1Ҳûɶ��
F1::


;************** �Զ��������Ľ��� **************
 

 

 