#singleinstance force

 
; Ctrl:^   Shift:+   Alt:!  鼠标右键:RButton

  Run, C:\Program Files (x86)\Tencent\QQ\Bin\QQ.exe
  Winwaitactive, QQ
  Wingetpos, x, y, w, h
  x:=x+w//2
  y:=y+h//2+110  ;自己微调纵坐标
  Coordmode, Mouse
  Sleep,500
  mouseclick,, x, y



 