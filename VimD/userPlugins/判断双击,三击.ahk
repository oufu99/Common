#SingleInstance Force
; 用于统计按键次数
gnPressCount := 0
$LCtrl::
{
        gnPressCount += 1
        SetTimer, ProcSubroutine, Off
        SetTimer, ProcSubroutine, 300
        Return
}
ProcSubroutine:
{
        ; 在计时器事件触发时，需要将其关掉
        SetTimer, ProcSubroutine, Off
        If gnPressCount = 1
        {
                ; 第一类行为
               Send,{Ctrl}
        }Else If gnPressCount = 2
        {
                ; 第二类行为
                Send,{Alt Down}Q{Alt Up}
        }Else
        {
                ; MsgBox, 触发三击鼠标右键事件
        }
        ; 在结束后，还需要将鼠标右键的按键次数置为0，以方便下次使用
        gnPressCount := 0
        Return
}