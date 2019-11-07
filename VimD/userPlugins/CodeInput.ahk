#singleinstance force
; return 要放在If的外面,不然会穿透继续执行


#If WinActive("用户登录 - Google Chrome") or WinActive("用户登录 ‎- Microsoft Edge")
{
  ::admin::
	Send,{Raw}admin
	Send,{Tab}
	Send,{Raw}PT_DSe/XycOhQW_Q8Cu5tIZg_sg
	Send {Enter}	
	Return 
}

 
#If WinActive("连接到服务器")
{
  ::sa::
	Send,{Raw}sa
	Send,{Tab}
	Send,{Raw}WA@@@Wei315#@#WinGG
	Send,{Enter}
	return
  ::web::
	Send,{Raw}webtest11
	Send,{Enter}
	return 
  ::mobile:: 
	Send,{Raw}mobileTest11
	Send,{Enter}
	return 
}


