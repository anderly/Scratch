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
	Set objTextFile = fso.CreateTextFile(yyyy & mm & "\" & strComputer & "_installed_hotfixes.txt", True)

	'Open Windows Management Instruction (WMI) Object
	Set objWMIService = GetObject("winmgmts:" _
	& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
	Set colItems = objWMIService.ExecQuery _
	("Select * from Win32_QuickFixEngineering")
	'Loop through each installed piece of software
	For Each item in colItems
      objTextFile.WriteLine "Caption: " & item.Caption
      objTextFile.WriteLine "CS Name: " & item.CSName
      objTextFile.WriteLine "Description: " & item.Description
      objTextFile.WriteLine "Fix Comments: " & item.FixComments
      objTextFile.WriteLine "HotFix ID: " & item.HotFixID
      objTextFile.WriteLine "InstallationDate: " & item.InstallDate
      objTextFile.WriteLine "Installed By: " & item.InstalledBy
      objTextFile.WriteLine "Installed On: " & item.InstalledOn
      objTextFile.WriteLine "Name: " & item.Name
      objTextFile.WriteLine "Service Pack In Effect: " & item.ServicePackInEffect
      objTextFile.WriteLine "Status: " & item.Status
      objTextFile.WriteLine
	Next
	
	objTextFile.Close
	set objTextFile = nothing