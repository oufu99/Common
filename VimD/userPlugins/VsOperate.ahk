#singleinstance force
; Vs专用
#If WinActive("ahk_exe devenv.exe")
{

; ctrl+单击跳转到定义 
^RButton::
  Send,{Click}{Ctrl Down}{F12}{Ctrl Up}
Return

::jp::
SendInput {Text} JSON.parse();
Send,{Left 2}
Return
}

