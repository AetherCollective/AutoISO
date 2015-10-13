#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Fileversion=1.1
#AutoIt3Wrapper_Res_LegalCopyright=MIT admin@BetaLeaf.net
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Your DVD/CD Drive Letter.
Global $Drive = "E:"

;Where you want the ISO Images to be stored.
Global $PathToISOs = "D:\ISOs\"

;Path to where ImgBurn is Installed. Required to create ISO Images
Global $PathToImgBurn = "C:\Program Files (x86)\ImgBurn\"

;Case Insensitive Windows Title Match Mode with Any Position (WildCard).
Opt("WinTitleMatchMode", -2)

;Main Thread
While 1

	;See Function Comments for AutoISO()
	AutoISO()

	;Prevents excessive cpu workload
	Sleep(1000)

WEnd

Func AutoISO()

	;If Non-Empty Disk is Present
	If DirGetSize($Drive) > 0 Then

		;Do Nothing and resumes the script at line 42.
		Sleep(0)

	Else

		;Return 0 = No Disk Present/Empty Disk Present - Skips ISO Creation
		Return 0

	EndIf

	;Store the Disk Label to a String Variable
	Local $DiskName = DriveGetLabel($Drive)

	;If ISO has already been made for this disk
	If FileExists($PathToISOs & $DiskName & ".iso") Then

		;Return 2 = Already created ISO Image, Skipping
		Return 2

	Else

		; Else create the ISO Image with the MakeISO() function.
		MakeISO($DiskName)

		;If ISO Image exists then
		If FileExists($PathToISOs & $DiskName & ".iso") Then

			;Inform the user the ISO was created successfully. Also asks the user if they want to give the ISO a different name. Due to how AutoISO tracks already created ISOs, it will create an info file with the User Specified name appended.
			Local $answer = MsgBox(4, "AutoISO", 'ISO "' & $DiskName & '" Created Successfully! ' & @CRLF & 'Would you like to give it a name that properly identifies this ISO?' & @CRLF & '(Note: You cannnot rename the ISO, else clones will be created, instead a text document is created next to it with the disk title.)')

			;If Yes then
			If $answer = 6 Then

				;Asks the user what they want the Identifying Name to be.
				Local $NewName = InputBox("AutoISO", "What do you want to call it?")

				;Creates the Info File for the ISO
				FileWrite($PathToISOs & $DiskName & " - " & $NewName & ".txt", 'The path to this ISO is "' & $PathToISOs & $DiskName & '.iso' & @CRLF & 'The user given name for this ISO is "' & $NewName & '"')

			Else

				;Uses the DiskName as the Identifying Name
				Local $NewName = $DiskName

				;Creates the Info File for the ISO
				FileWrite($PathToISOs & $DiskName & ".txt", 'The path to this ISO is "' & $PathToISOs & $DiskName & '.iso' & @CRLF & 'The user given name for this ISO is "' & $NewName & '"')

			EndIf

			;Return 1 = Ripped Successfully
			Return 1

		Else

			;Alert user that ISO creation failed and will be retried.
			MsgBox(0, "AutoISO", "ISO Creation Failed, Retrying.")

			;Return -1 = Ripped Unsuccessfully - Retrying...
			Return -1

		EndIf

	EndIf

EndFunc   ;==>AutoISO

Func MakeISO($DiskName)

	;Start ImgBurn with the Global Settings, Creating the ISO, and self-closes when done.
	Local $PID = ShellExecute("imgburn.exe", '/MODE READ /SRC ' & $Drive & ' /DEST "' & $PathToISOs & $DiskName & '.iso" /VERIFY YES /EJECT NO /WAITFORMEDIA /START /CLOSESUCCESS', $PathToImgBurn)

	;Wait for ImgBurn to finish.
	ProcessWaitClose($PID)

	;Wait for an additional second to allow all handles and threads to release the ISO.
	Sleep(1000)

EndFunc   ;==>MakeISO
