;;--- Head --- AHK ---
;; Appear uptime one time (auto-close after 10 seconds) a day and offer to reboot each 1 of the month.
;; On each 24 hours of running is appear the msg
;; Get uptime, shutdowns, reboot, sleep & close session

	SetEnv, title, Get Uptime
	SetEnv, mode, Uptime & reboot (once a month)
	SetEnv, version, Version 2017-03-06
	SetEnv, author, LostByteSoft

;;--- Softwares options ---

	#SingleInstance Force
	#Persistent

;;--- Tray options ---

	Menu, tray, add, Refresh, doReload		; Reload the script.
	Menu, tray, add, +-------, secret		; empty space #1
	Menu, tray, add, Reboot PC, Rebootpc
	Menu, tray, add, Shutdown PC, Shutdownpc
	Menu, tray, add, Session Close, Sessionpc
	Menu, tray, add, Sleep PC, Sleeppc
	Menu, tray, add, ++------, about2		; empty space #2
	Menu, tray, add, About, about1			; Creates a new menu item.
	Menu, tray, add, Version, version		; About version
	Menu, tray, add, +++-----, about3		; empty space #3
	Menu, tray, add, Show Baloon time, showbaloon
	Menu, tray, add, Get uptime, uptime		; Get the message now

;;--- Software start here ---

start:
	t_UpTime := A_TickCount // 1000
	;;msgbox, %t_uptime%
	IfGreater, t_UpTime, 10, goto, sleep2		; Elapsed seconds since start if uptime upper 10 sec wait imediately
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
	goto, daily

daily:
	Menu, Tray, Icon, ico_reboot.ico
	MsgBox, 68, Get Uptime (Time out 10 sec(NO)), Start time: `t" %t_StartTime% "`nTime now:`t" %t_NowTime% "`n`nElapsed time:`t" %t_UpTime% "`n`n(Time out 10 sec (NO)) Click YES to reboot, 10
	if ErrorLevel
	goto, sleep1
	IfMsgBox Yes, goto, reboot
	IfMsgBox No, goto, sleep1
	goto, sleep1

offer:
	Menu, Tray, Icon, ico_reboot.ico
	MsgBox, 68, Get Uptime (No time out), Start time: `t" %t_StartTime% "`nTime now:`t" %t_NowTime% "`n`nElapsed time:`t" %t_UpTime% "`n`n(No time out waiting answer) Click YES to reboot
	if ErrorLevel
	goto, sleep1
	IfMsgBox Yes, goto, reboot
	IfMsgBox No, goto, sleep1
	goto, sleep1

sleep1:
	Menu, Tray, Icon, ico_time.ico
	sleep, 86400000
	goto, loop
	;; 1000 = 1 sec
	;; 60000 = 1 min
	;; 3 600 000 = 1 hour
	;; 86400000 = 24 hour
	;; 2147483647 = 24 days ; maximum

sleep2:
	;;msgbox, sleep2
	t_TimeFormat := "HH:mm:ss dddd"
	t_StartTime :=                          		; Clear variable = A_Now
	t_UpTime := A_TickCount // 1000				; Elapsed seconds since start
	t_StartTime += -t_UpTime, Seconds       		; Same as EnvAdd with empty time
	FormatTime t_NowTime, , %t_TimeFormat%  		; Empty time = A_Now
	FormatTime t_StartTime, %t_StartTime%, %t_TimeFormat%
	t_UpTime := % t_UpTime // 86400 " days " mod(t_UpTime // 3600, 24) ":" mod(t_UpTime // 60, 60) ":" mod(t_UpTime, 60)
	TrayTip, %title%, %t_UpTime%, 2, 1
	sleep, 86400000
	goto, loop

reboot:
	Menu, Tray, Icon, ico_shut.ico
	sleep, 1000
	Shutdown, 6
	ExitApp

;;--- Quit (escape , esc) ---

	GuiClose:
	ExitApp

;;--- Tray Bar (must be at end of file) ---

secret:
	Menu, Tray, Icon, ico_reboot.ico
	MsgBox, 0, GET UPTIME SECRET, title=%title% mode=%mode% version=%version% t_UpTime=%t_UpTime% author=%author%
	Menu, Tray, Icon, ico_time.ico
	Return

about1:
about2:
about3:
	TrayTip, %title%, %mode%, 2, 1
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

version:
	TrayTip, %title%, %version%, 2, 2
	Return

uptime:
	goto, loop

rebootpc:
	Menu, Tray, Icon, ico_reboot.ico
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
	Return

sleeppc:
	Menu, Tray, Icon, ico_veille.ico
	sleep, 1000
	DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
	Return

doReload:
	Reload
	Return

;;--- End of script ---

;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;                    Version 2, December 2004
 
; Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
 
; Everyone is permitted to copy and distribute verbatim or modified
; copies of this license document, and changing it is allowed as long
; as the name is changed.
 
;            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
;   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
;              You just DO WHAT THE FUCK YOU WANT TO.

;;--- End of file ---