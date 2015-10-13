#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global $Drive = "E:"
Global $PathToISOs = "D:\ISOs\"
Global $PathToIMGBURN = "C:\Program Files (x86)\ImgBurn\"
Opt("WinTitleMatchMode", -2)
While 1
	CheckISO()
	Sleep(1000)
WEnd
Func CheckISO()
	;check if disk is present
	If DirGetSize($Drive) > 0 Then
		Sleep(0)
	Else
		Return 0
	EndIf

	;check if disk is already ripped
	Local $DiskName = DriveGetLabel($Drive)
	If FileExists($PathToISOs & $DiskName & ".iso") Then
		Sleep(0)
		;if already ripped wait for disk to be eject then return 2
		Return 2
	Else
		;if not ripped, rip the disk with RipToISO()
		Sleep(0)
		RipToISO($DiskName)
		If FileExists($PathToISOs & $DiskName & ".iso") Then
			;check if disk was successfully ripped
			Local $answer = MsgBox(4, "AutoISO", 'ISO "' & $DiskName & '" Created Successfully! ' & @CRLF & 'Would you like to give it a name that properly identifies this ISO?'&@CRLF&'(Note: You cannnot rename the ISO, else clones will be created, instead a text document is created next to it with the disk title.)')
			If $answer = 6 Then
				Local $NewName = InputBox("AutoISO", "What do you want to call it?")
				FileWrite($PathToISOs & $DiskName & " - " & $NewName & ".txt", 'The path to this ISO is "' & $PathToISOs & $DiskName & '.iso' & @CRLF & 'The user given name for this ISO is "' & $NewName & '"')
			Else
				Local $NewName = $DiskName
				FileWrite($PathToISOs & $DiskName & ".txt", 'The path to this ISO is "' & $PathToISOs & $DiskName & '.iso' & @CRLF & 'The user given name for this ISO is "' & $NewName & '"')
			EndIf

			Return 1
		Else
			MsgBox(0, "AutoISO", "ISO Creation Failed, Retrying.")
			Return -1
		EndIf
	EndIf

	;Return 0 = No Disk Present
	;Return 1 = Ripped Successfully
	;Return -1 = Ripped Unsuccessfully - Retrying...
	;Return 2 = Already Ripped
EndFunc   ;==>CheckISO
Func RipToISO($DiskName)
	Local $PID = ShellExecute("imgburn.exe", '/MODE READ /SRC ' & $Drive & ' /DEST "' & $PathToISOs & $DiskName & '.iso" /VERIFY YES /EJECT NO /WAITFORMEDIA /START /CLOSESUCCESS', $PathToIMGBURN)
	ProcessWaitClose($PID)
	Sleep(1000)
EndFunc   ;==>RipToISO

