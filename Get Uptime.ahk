;;--- Head --- Informations --- AHK ---

;;	Appear uptime one time (auto-close after 10 seconds) a day and offer to reboot each 1 of the month.
;;	On each 24 hours of running is appear the msg
;;	Get uptime, shutdowns, reboot, sleep & close session
;;	Compatibility: Windows
;;	All files must be in same folder. Where you want.
;;	64 bit AHK version : 1.1.24.2 64 bit Unicode

;;--- Softwares options ---

	SetWorkingDir, %A_ScriptDir%
	#SingleInstance Force
	#Persistent

	SetEnv, title, Get Uptime
	SetEnv, mode, Uptime & reboot, show msg at 12:00 each days.
	SetEnv, version, Version 2017-08-06-1503
	SetEnv, author, LostByteSoft

	FileInstall, ico_reboot.ico, ico_reboot.ico,0
	FileInstall, Ico_Session.ico, Ico_Session.ico, 0
	FileInstall, ico_shut.ico, ico_shut.ico, 0
	FileInstall, ico_veille.ico, ico_veille.ico, 0
	FileInstall, ico_lock.ico, ico_lock.ico, 0
	FileInstall, ico_secret.ico, ico_secret.ico, 0
	FileInstall, ico_recycle.ico, ico_recycle.ico, 0

;;--- Tray options ---

	Menu, Tray, NoStandard
	Menu, tray, add, --= %title% =--, about1
	Menu, Tray, Icon, --= %title% =--, ico_recycle.ico
	Menu, tray, add,
	Menu, tray, add, Exit %title%, Close				; Close exit program
	Menu, Tray, Icon, Exit %title%, ico_shut.ico
	Menu, tray, add, Refresh, doReload					; Reload the script.
	Menu, Tray, Icon, Refresh, ico_reboot.ico, 1
	Menu, tray, add, Secret MsgBox, secret
	Menu, Tray, Icon, Secret MsgBox, ico_lock.ico, 1
	Menu, tray, add, Show logo, GuiLogo
	Menu, tray, add,
	Menu, tray, add, Reboot PC, Reboot
	Menu, Tray, Icon, Reboot PC, ico_reboot.ico, 1
	Menu, tray, add, Shutdown PC, Shutdownpc
	Menu, Tray, Icon, Shutdown PC, ico_shut.ico, 1
	Menu, tray, add, Session Close, Sessionpc
	Menu, Tray, Icon, Session Close, Ico_Session.ico, 1
	Menu, tray, add, Sleep PC, Sleeppc
	Menu, Tray, Icon, Sleep PC, ico_veille.ico, 1
	Menu, tray, add,
	Menu, tray, add, About - LostByteSoft, about2				; Creates a new menu item.
	Menu, Tray, Icon, About - LostByteSoft, ico_about.ico, 1
	Menu, tray, add, Version , version					; About version
	Menu, Tray, Icon, Version, ico_about.ico, 1
	Menu, tray, add,
	Menu, tray, add, Show Baloon time, showbaloon
	Menu, Tray, Icon, Show Baloon time, ico_recycle.ico, 1
	Menu, tray, add, Get uptime, uptime					; Get the message now
	Menu, Tray, Icon, Get uptime, ico_recycle.ico, 1
	Menu, Tray, Tip, %title%

;;--- Software start here ---

start:
	t_UpTime := A_TickCount // 1000
	;; msgbox, %t_uptime%
	;; IfGreater, t_UpTime, 10, goto, sleep2		; Elapsed seconds since start if uptime upper 10 sec wait imediately
	sleep, 10000
	TrayTip, %title%, %mode% Right click on icon, 2, 1

loop:
	t_TimeFormat := "HH:mm:ss dddd"
	t_StartTime :=                          		; Clear variable = A_Now
	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)
	;; check date and if 1 of month offer reboot
	IfEqual, %A_DD%, 01, goto, offer
	IfEqual, %A_Hour%, 12, goto, daily
	goto, sleep

daily:
	Menu, Tray, Icon, ico_reboot.ico
	MsgBox, 68, Get Uptime (Time out 10 sec(NO)), Start time: `t" %t_StartTime% "`nTime now:`t" %t_NowTime% "`n`nElapsed time:`t" %t_UpTime% "`n`n(Time out 10 sec (NO)) Click YES to reboot, 10
	if ErrorLevel
	goto, sleep
	IfMsgBox Yes, goto, reboot
	IfMsgBox No, goto, sleep
	goto, sleep

offer:
	Menu, Tray, Icon, ico_reboot.ico
	;;; MsgBox, 68, Get Uptime (No time out), Start time: `t" %t_StartTime% "`nTime now:`t" %t_NowTime% "`n`nElapsed time:`t" %t_UpTime% "`n`n(No time out waiting answer) Click YES to reboot
	MsgBox, 68, Get Uptime (Time out 10 sec(NO)), Start time: `t" %t_StartTime% "`nTime now:`t" %t_NowTime% "`n`nElapsed time:`t" %t_UpTime% "`n`n(Time out 10 sec (NO)) Click YES to reboot, 10
	if ErrorLevel
	goto, sleep
	IfMsgBox Yes, goto, reboot
	IfMsgBox No, goto, sleep
	goto, sleep

sleep:
	Menu, Tray, Icon, ico_recycle.ico
	sleep, 3600000
	goto, loop

	;; 1000 = 1 sec
	;; 60000 = 1 min
	;; 3 600 000 = 1 hour
	;; 86400000 = 24 hour
	;; 2147483647 = 24 days ; maximum

;; sleep2:
;;	;;msgbox, sleep2
;;	t_TimeFormat := "HH:mm:ss dddd"
;;	t_StartTime :=                          		; Clear variable = A_Now
;;	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
;;	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
;;	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
;;	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
;;	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)
;;	TrayTip, %title%, %t_UpTime%, 2, 1
;;	sleep, 86400000
;;	goto, loop

secret:
	Menu, Tray, Icon, ico_secret.ico
	MsgBox, 0, GET UPTIME SECRET, title=%title% mode=%mode% version=%version% t_UpTime=%t_UpTime% author=%author% A_WorkingDir=%A_WorkingDir%
	Menu, Tray, Icon, ico_recycle.ico
	Goto, Start

;--- Computer mode ---

reboot:
	Menu, Tray, Icon, ico_shut.ico
	sleep, 1000
	Shutdown, 6
	ExitApp

shutdownpc:
	Menu, Tray, Icon, ico_shut.ico
	sleep, 1000
	Shutdown, 5
	ExitApp

sessionpc:
	Menu, Tray, Icon, Ico_Session.ico
	sleep, 1000
	Shutdown, 0
	Goto, Start

sleeppc:
	Menu, Tray, Icon, ico_veille.ico
	sleep, 1000
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
	Goto, Start

;;--- Quit (escape , esc) ---

Close:
	ExitApp

GuiLogo:

	Gui, Add, Picture, x25 y25 w200 h200 , ico_recycle.ico
	Gui, Show, w250 h250, %title% Logo
	goto, loop

;;--- Tray Bar (must be at end of file) ---

about1:
about2:
	TrayTip, %title%, %mode% by %author%, 2, 1
	Return

showbaloon:
	t_TimeFormat := "HH:mm:ss dddd"
	t_StartTime :=                          		; Clear variable = A_Now
	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)
	TrayTip, %title%, %t_UpTime%, 2, 1
	Return

uptime:
	t_TimeFormat := "HH:mm:ss dddd"
	t_StartTime :=                          		; Clear variable = A_Now
	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)
	goto, daily


version:
	TrayTip, %title%, %version%, 2, 2
	Return

doReload:
	Reload
	Return

;;--- End of script ---
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   Version 3.14159265358979323846264338327950288419716939937510582
;                          March 2017
;
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
;
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
;
;              You just DO WHAT THE FUCK YOU WANT TO.
;
;		     NO FUCKING WARRANTY AT ALL
;
;	As is customary and in compliance with current global and
;	interplanetary regulations, the author of these pages disclaims
;	all liability for the consequences of the advice given here,
;	in particular in the event of partial or total destruction of
;	the material, Loss of rights to the manufacturer's warranty,
;	electrocution, drowning, divorce, civil war, the effects of
;	radiation due to atomic fission, unexpected tax recalls or
;	    encounters with extraterrestrial beings 'elsewhere.
;
;              LostByteSoft no copyright or copyleft.
;
;	If you are unhappy with this software i do not care.
;
;;--- End of file ---