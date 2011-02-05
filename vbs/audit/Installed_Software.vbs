strComputer = "crpaanderly1"

	mm = Month(Date)
	yyyy = Year(Date)
	
	If Len(mm) = 1 Then mm = "0" & mm
	
	'Create folder for current month and year
	Set fso = CreateObject("Scripting.FileSystemObject")
	If fso.FolderExists(yyyy & mm) = False Then
		fso.CreateFolder(yyyy & mm)
	End If
	
	'Create file for the current server's software
	Set objTextFile = fso.CreateTextFile(yyyy & mm & "\" & strComputer & "_installed_software.txt", True)

	'Open Windows Management Instruction (WMI) Object
	Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery _
	("Select * from Win32_Product")
	'Loop through each installed piece of software
	For Each item in colItems
		objTextFile.WriteLine "Caption: " & item.Caption
      objTextFile.WriteLine "Description: " & item.Description
      objTextFile.WriteLine "Identifying Number: " & item.IdentifyingNumber
      objTextFile.WriteLine "Installation Date: " & item.InstallDate
      objTextFile.WriteLine "Installation Date 2: " & item.InstallDate2
      objTextFile.WriteLine "Installation Location: " & item.InstallLocation
      objTextFile.WriteLine "Installation State: " & item.InstallState
      objTextFile.WriteLine "Name: " & item.Name
      objTextFile.WriteLine "Package Cache: " & item.PackageCache
      objTextFile.WriteLine "SKU Number: " & item.SKUNumber
      objTextFile.WriteLine "Vendor: " & item.Vendor
      objTextFile.WriteLine "Version: " & item.Version
      objTextFile.WriteLine
	Next
	
	objTextFile.Close
	set objTextFile = nothing