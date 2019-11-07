HHParent:
	vim.comment("<HHParent_FocusToolBar>","聚焦：工具栏")
	vim.comment("<HHParent_FocusContentPanel>","聚焦：内容面板")
	vim.comment("<HHParent_FocusDirectoryTab>","聚焦：目录选项卡")
	vim.comment("<HHParent_FocusIndexTab>","聚焦：索引选项卡")
	vim.comment("<HHParent_FocusSearchTab>","聚焦：索引选项卡")
	vim.comment("<HHParent_FocusSearchTab>","聚焦：搜索选项卡")
	vim.comment("<HHParent_FocusCollectionTab>","聚焦：收藏选项卡")
	vim.comment("<HHParent_ShowContentContentURL>","显示：当前内容URL信息")
	vim.comment("<HHParent_SwitchNavigationPanel>","显示/隐藏：导航栏面板")
	vim.comment("<HHParent_ContentFinder>","查找：内容")
	vim.comment("<HHParent_JumpForward>","跳转：前进")
	vim.comment("<HHParent_JumpBack>","跳转：后退")
	vim.comment("<HHParent_JumpHome>","跳转：主页")
	vim.comment("<HHParent_RollingDown>","滚动：下一格")
	vim.comment("<HHParent_RollingUp>","滚动：上一格")
	vim.comment("<HHParent_RollingPgUp>","滚动：上一屏")
	vim.comment("<HHParent_RollingPgDn>","滚动：下一屏")
	vim.comment("<HHParent_RollingHome>","滚动：最上")
	vim.comment("<HHParent_RollingEnd>","滚动：最下")
	
	vim.SetWin("HHParent", "HH Parent")

	; insert模式
    vim.mode("insert", "HHParent")
	vim.map("<esc>", "<HHParent_NormalMode>", "HHParent")
	
	; normal模式
    vim.mode("normal", "HHParent")
	vim.map("<esc>", "<HHParent_FocusContentPanel>", "HHParent")	
	vim.map("j", "<HHParent_RollingDown>", "HHParent")
	vim.map("k", "<HHParent_RollingUp>", "HHParent")
	vim.map("h", "<HHParent_JumpBack>", "HHParent")
	vim.map("l", "<HHParent_JumpForward>", "HHParent")
	vim.map("gg", "<HHParent_RollingHome>", "HHParent")
	vim.map("G", "<HHParent_RollingEnd>", "HHParent")
	
	vim.map("J", "<HHParent_RollingPgDn>", "HHParent")
	vim.map("K", "<HHParent_RollingPgUp>", "HHParent")
	
	vim.map("i", "<HHParent_InsertMode>", "HHParent")
	
	vim.map("a", "<HHParent_FocusDirectoryTab>", "HHParent")
	vim.map("s", "<HHParent_FocusIndexTab>", "HHParent")
	vim.map("d", "<HHParent_FocusSearchTab>", "HHParent")
	vim.map("f", "<HHParent_FocusCollectionTab>", "HHParent")
	
	vim.map("/", "<HHParent_ContentFinder>", "HHParent")
	
	vim.map("q", "<HHParent_SwitchNavigationPanel>", "HHParent")
	vim.map("u", "<HHParent_ShowContentContentURL>", "HHParent")
	vim.map("t", "<HHParent_FocusToolBar>", "HHParent")
	vim.map("c", "<HHParent_FocusContentPanel>", "HHParent")
	
	vim.BeforeActionDo("HHParent_ForceInsertMode", "HHParent")
return


; 对指定控件使用insert模式
HHParent_ForceInsertMode()
{
    ControlGetFocus, ctrl,ahk_class  HH Parent    
    If RegExMatch(ctrl, "Edit3") or RegExMatch(ctrl, "Edit1") or RegExMatch(ctrl, "Edit2"){
        Return True
    }
    return False
}


<HHParent_NormalMode>:
    vim.mode("normal", "HHParent")	
return

<HHParent_InsertMode>:
    vim.mode("insert", "HHParent")
return


;聚焦到工具栏
<HHParent_FocusToolBar>:
ControlFocus,ToolbarWindow321,ahk_class  HH Parent
return

;聚焦到内容面板
<HHParent_FocusContentPanel>:
ControlFocus,Internet Explorer_Server1,ahk_class  HH Parent
return

;聚焦到目录选项卡
<HHParent_FocusDirectoryTab>:
	SwitchNavigationPanel("Show")
	SendMessage, 0x1330,0,, SysTabControl321, ahk_class  HH Parent  
return

;聚焦到索引选项卡
<HHParent_FocusIndexTab>:
	SwitchNavigationPanel("Show")
	SendMessage, 0x1330,1,, SysTabControl321, ahk_class  HH Parent  
return

;聚焦到搜索选项卡
<HHParent_FocusSearchTab>:
	SwitchNavigationPanel("Show")
	SendMessage, 0x1330,2,, SysTabControl321, ahk_class  HH Parent  
return

;聚焦到收藏选项卡
<HHParent_FocusCollectionTab>:
	SwitchNavigationPanel("Show")
	SendMessage, 0x1330,3,, SysTabControl321, ahk_class  HH Parent  
return


;显示：当前内容URL信息
<HHParent_ShowContentContentURL>:
	Send !gu
return

;显示/隐藏：导航栏面板
<HHParent_SwitchNavigationPanel>:
SwitchNavigationPanel("Switch")
return

;查找：内容
<HHParent_ContentFinder>:
	gosub,<HHParent_FocusContentPanel>
	Send ^f
return

;跳转：前进
<HHParent_JumpForward>:
	Send +{BS}
return

;跳转：后退
<HHParent_JumpBack>:
	Send {BS}
return

;跳转：主页
<HHParent_JumpHome>:
	Send !gh
return

;滚动：下一格
<HHParent_RollingDown>:
	Send {Down}
return

;滚动：上一格
<HHParent_RollingUp>:
	Send {Up}
return

;滚动：上一屏
<HHParent_RollingPgUp>:
	Send {PgUp}
return

;滚动：下一屏
<HHParent_RollingPgDn>:
	Send {PgDn}
return

;滚动：最下
<HHParent_RollingEnd>:
	Send {End}
return

;滚动：最上
<HHParent_RollingHome>:
	Send {Home}
return

;判断导航栏是否显示,显示返回1，隐藏返回0
IsShowNavigationPanel(){
	ControlGet,ov,Visible,,HH Child2,ahk_class  HH Parent
	return ov
}


SwitchNavigationPanel(cmd)
{
	if(cmd=="Switch"){
		if(IsShowNavigationPanel()==1){
			gosub,<HHParent_FocusToolBar>
			Send {Enter}
			;Send !vn
		}
		else{
			gosub,<HHParent_FocusToolBar>
			Send {Enter}
			;Send !vn
		}
	}
	if(cmd=="Show") and  (IsShowNavigationPanel()==0){
		gosub,<HHParent_FocusToolBar>
		Send {Enter}
		;Send !vn
	}
	if(cmd=="Hide") and  (IsShowNavigationPanel()==1){
		gosub,<HHParent_FocusToolBar>
		Send {Enter}
		;Send !vn
	}
}


