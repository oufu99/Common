

 
; Ctrl:^   Shift:+   Alt:!  ����Ҽ�:RButton

^Numpad0::
   Run, D:\Tools\OpenMyTools\bin\Debug\OpenMyTools.exe
Return


^Numpad1::
   Run, C:\Program Files (x86)\WizNote\Wiz.exe
Return


F1::
 Run,D:\MyLove\TotalCommand\Totalcmd64.exe
Return

; ��TC��ʼ ========
#If WinActive("ahk_class CabinetWClass") or WinActive("ahk_class ExploreWClass")
{
	!w::
		selected := ExplorerInfo(2)
		if(selected="")
		{
		  selected := ExplorerInfo()
		}
	
		 run, D:\MyLove\TotalCommand\Totalcmd64.exe /T /O /P=R /S /A /R=%selected%
	return
}
;����
#If WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW")
{
	!w::
		selected := ExplorerInfo(2)
		if(selected="")
		{
		  selected := ExplorerInfo()
		}
	    run, D:\MyLove\TotalCommand\Totalcmd64.exe /T /O /P=R /S /A /R=%selected%
	return
}



ExplorerInfo(mode="",hwnd="") { ;Method="��ǰĿ¼"��ʱ��ֻ���ص�ǰĿ¼;
;modeĬ�Ͽ�ֵʱ,�����Ƿ�ѡ���ļ�/�ļ��нԷ��ص�ǰ·��(Ŀ¼��);
;mode=0ʱ,��ѡ�����ļ�/�ļ����򷵻�ѡ�е�Ŀ¼��,����ѡ��ʱ���ؿ�;
;mode=1ʱ,��ѡ�����ļ�/�ļ����򷵻����·��+�ļ���,��ѡ��ʱ����Ŀ¼��;
;mode=2ʱ,��ѡ�����ļ�/�ļ����򷵻����·��+�ļ���,��ѡ��ʱ���ؿ�ֵ;
 
;@��лQuant��ԭʼ����
Toreturn=
filenum1=0
filenum2=0
WinGet, Process, ProcessName, % "ahk_id " (hwnd := hwnd? hwnd:WinExist("A")) ;����ط��ж��Ƿ������hwndֵ,���������Ϊ��,���ȡ��ǰ���ڵľ���������ʹ�ø����ľ����
;�ó����������Ӧ�Ľ������ƣ�
WinGetClass class, ahk_id %hwnd% ;���ݾ������ȡ��Ӧhwnd�Ĵ��ڵ�������
ComObjError(0) ;����ʾ������ʾ�Ĵ���
if (Process = "explorer.exe") ;�������Ϊexplorer������жϵ���ʱ�������棨Progman|WorkerW��������Դ��������(Cabinet|Explore)WClass����
if (class ~= "Progman|WorkerW")
{
ControlGet, files, List, Selected Col1, SysListView321, ahk_class %class% ;��ȡѡ�е��ļ����б�[�޷���ȡ����չ��]
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
for window in ComObjCreate("Shell.Application").Windows ;������ǰ��Դ�������д򿪵Ĵ��ڣ�
{
if (window.hwnd==hwnd) ;�ڶ��������ȡ��λ����ǰ��hwnd���ĸ����ڣ�
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
 
fde:=Trim(Toreturn,"`r`n") ;������·�����ļ���,������չ��;
if mode<> ;modeΪ012ʱ
{
if (filenum1+filenum2=0)
{
if (mode=0)||(mode=2)
{
return
}
else ;mod=1ʱ�����;
return fde
}else
{
if (mode=1) or (mode=2)
if (filenum1<>0)
{
aa:=ѡ�����ļ�()
return aa ;ѡ�����ļ�()
}
else
return fde
}
}
if InStr(FileExist(fde), "D") ;�����ж�Ŀ¼
return,RegExReplace(Trim(Toreturn,"`r`n") . "\","\\\\","\") ;�����. "\"�Ǹ�ѡ�����ļ��м���\
else if Toreturn<>
{
StringMid,Toreturn2, Toreturn,1,InStr(Toreturn,"\",,0)-1 ;�������Ŀ¼�����һ����б�ܽ��н�ȡ,ȡǰ���Ŀ¼��
return RegExReplace(Toreturn2 . "\","\\\\","\")
}
}
 
ѡ�����ļ�(){
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
}}

; ��TC���� ========