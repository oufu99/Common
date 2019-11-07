#singleinstance force

; sql的代码段  如果后面有多的SQL直接加  or WinActive("spy名")
#Include D:\MyLove\VimD\userPlugins\ManuIdProvide.ahk

#If WinActive("ahk_exe navicat.exe")
{
  ::scust::
	SendInput {Text}select * from tb_customer_%ManuId%	
	Return

  ::suser::
	SendInput {Text}select * from tb_user where  manufacturer_id=%ManuId%	
	Return
  
  ::irule::
	SendInput {Text} INSERT INTO ``ymt.ws_sys``.``tb_rule_mapping_class``` (``ManuId``, ``ClassName``, ``Json``, ``filter_keyword``, ``new_url``) VALUES (%ManuId%, 'pcRedirect', NULL, '/agent/pay', '/youzuan/agent/pay');
	Return
  ::irule2::
	SendInput {Text} INSERT INTO ``ymt.ws_sys``.``tb_rule_mapping_class``(``ManuId``, ``ClassName``, ``Json``, ``filter_keyword``, ``new_url``) VALUES (``ManuId``, 'mobileRedirect', NULL, '/agent/pay', '/youzuan/agent/pay');
	Return
	
	
	 ::scata::
	SendInput {Text} select * from tb_customer_catalog where manufacturer_id=10022;
	Return
	
	 ::irule2::
	SendInput {Text} INSERT INTO ``ymt.ws_sys``.``tb_rule_mapping_class``(``ManuId``, ``ClassName``, ``Json``, ``filter_keyword``, ``new_url``) VALUES (``ManuId``, 'mobileRedirect', NULL, '/agent/pay', '/youzuan/agent/pay');
	Return
	 ::irule2::
	SendInput {Text} INSERT INTO ``ymt.ws_sys``.``tb_rule_mapping_class``(``ManuId``, ``ClassName``, ``Json``, ``filter_keyword``, ``new_url``) VALUES (``ManuId``, 'mobileRedirect', NULL, '/agent/pay', '/youzuan/agent/pay');
	Return
	
	
	
  
}

