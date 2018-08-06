#Persistent
#SingleInstance ignore

SetTimer, MoveMouse, 1000

appName = Mouse Jiggler
appVersion = v1.2.00
jiggleTime = 60000

Gui,  -MinimizeBox -Resize
Gui, Font, S16 CDefault Bold, Sans-Serif
Gui, Add, Text, x10 y10 w330 h30 +Center +BackgroundTrans, %appName% %appVersion%
Gui, Font, S12 CDefault Norm, Sans-Serif
Gui, Add, Text, x10 y45 w330 h30 +Center +BackgroundTrans,  by Steve Reich
Gui, Font, S8 CDefault Norm, Sans-Serif
Gui, Add, Text, x10 y68 w330 h30 +Center +BackgroundTrans,  @2018 Boxshadow Studios
Gui, Add, Button, x125 y105 w100 h26 Default gGuiClose, &Close

Menu, tray, NoStandard
Menu, tray, tip, Active

Menu, tray, add, Pause Jiggler, PauseJiggle
Menu, tray, add, Run on Startup, startUpReg
Menu, tray, add
Menu, tray, add, About..., GuiOpen
Menu, tray, add, Exit, exitHandler
Menu, tray, Default, About...
Menu, tray, Click, 1

RegRead, isFirstTime, HKCU, SOFTWARE\%appName%, ExePath
if ErrorLevel {
	RegWrite, REG_SZ, HKCU, SOFTWARE\%appName%, ExePath, %A_ScriptFullPath%
	RegWrite, REG_SZ, HKCU, SOFTWARE\%appName%, isPaused, 0
}

RegRead, pauseState, HKCU, SOFTWARE\%appName%, isPaused
if (ErrorLevel = 0) {
	state = active
	opt = 17
	if pauseState {
		SetTimer, MoveMouse, Off
		Menu, tray, Rename, Pause Jiggler, Resume Jiggler
		Menu, tray, tip, Paused	
		state = paused
		opt = 2
	}
	TrayTip ,, %appName% is %state%., 3, %opt%
}

RegRead, startUp, HKCU, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %appName%
if (ErrorLevel = 0) {
    RegWrite, REG_SZ, HKCU, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %appName%, %A_ScriptFullPath%
	Menu, Tray, Check, Run on Startup
}

return
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;AUTO EXEC SECTION ENDS HERE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MoveMouse:
	if (A_TimeIdle > jiggleTime) {
		MouseMove, 50, 0, 10, R
		MouseMove, -50, 0, 10, R
		SendInput {RShift}
	}
return

PauseJiggle:
	if(A_ThisMenuItem = "Pause Jiggler"){
		SetTimer, MoveMouse, Off
		RegWrite, REG_SZ, HKCU, SOFTWARE\%appName%, isPaused, 1
		Menu, tray, Rename, Pause Jiggler, Resume Jiggler
		Menu, tray, tip, Paused	
	}
	else{
		SetTimer, MoveMouse, On
		RegWrite, REG_SZ, HKCU, SOFTWARE\%appName%, isPaused, 0
		Menu, tray, Rename, Resume Jiggler, Pause Jiggler
		Menu, tray, tip, Active
	}
return

startUpReg:
	RegRead, startUp, HKCU, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %appName%
	if ErrorLevel {
		RegWrite, REG_SZ, HKCU, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %appName%, %A_ScriptFullPath%
		Menu, Tray, Check, %A_ThisMenuItem%
	}
	else{
		RegDelete, HKCU, SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %appName%
		if ErrorLevel {
			reload
		}
		Menu, Tray, Uncheck, %A_ThisMenuItem%
	}
return

GuiOpen:
	Gui, Show, w350 h145, About %appName%
return

GuiClose:
	Gui, Cancel
return

exitHandler:
	ExitApp