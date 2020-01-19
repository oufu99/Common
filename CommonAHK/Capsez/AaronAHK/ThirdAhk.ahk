#SingleInstance Force



#IfWinActive, ahk_exe devenv.exe

CapsLock & ~i::
Input,OutputVar, L1 T1
if (OutputVar = "i")
{
   Send,{BackSpace}""{Left}
}
if (OutputVar = "k")
{
	Send,{BackSpace}(){Left}
} 
return

`; & z::SendInput, {Ctrl Down}{Shift Down}{Alt Down}{F12}{Ctrl Up}{Shift Up}{Alt Up}
`; & t::SendInput, {Ctrl Down}[s{Ctrl Up}

CapsLock & `;::SendInput,{End};
CapsLock & g::SendInput,=

; ctrl+单击跳转到定义 
^RButton::
  Send,{Click}{Ctrl Down}{F12}{Ctrl Up}
Return

#IfWinActive