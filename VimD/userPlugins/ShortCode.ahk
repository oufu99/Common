#singleinstance force

; return 要放在If的外面,不然会穿透继续执行

:?:dt::
Send,dotnet{Space}
Return


^Numpad9::
; 先定义一个变量用来存储盘符
clipboard = 
Send,{Alt Down}d{Alt Up}{Home}{Shift Down}{Right}{Shift Up}{Ctrl Down}c{Ctrl Up}
diskFirst=%clipboard%
clipboard =  
Send,{Home}{Shift Down}{End}{Shift Up}^c
Run, cmd.exe
WinWait, 命令提示符, , 0
Send,%diskFirst%
Send,{Raw}:
Send,{Enter}
Send,{Raw}cd
Send,{Space}
; Send,{RButton}
Send,%clipboard%
Send,{Enter}
Return
