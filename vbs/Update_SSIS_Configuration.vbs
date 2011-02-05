'----------------------------------------------------------------
'SSIS Configuration Update
'Author:	Adam Anderly
'Purpose: 	Updates the SSIS Configuration
'----------------------------------------------------------------

	'Validate passed arguments
	set args = WScript.Arguments
	
	if args.Count <> 3 then
		MsgBox "Invalid number of arguments specified: expected: 3, passed: " & args.Count
	else

		'Extract passed arguments
		filePath 	= args.Item(0)
		environment = args.Item(1)
		packagePath = args.Item(2)
		
		packageRootPath = "C:\SSIS Installation"
		
		'MsgBox filePath & "|" & environment & "|" & packagePath

		UpdateConfigurationSettings filePath, PackageRootPath, environment, packagePath
	
	end if
	
	Sub UpdateConfigurationSettings(filePath, rootPath, environment, packagePath)
	
		set fso = CreateObject("Scripting.FileSystemObject")
		configFile = filePath
		if fso.FileExists(configFile) = false then
			MsgBox "Could not find SSIS package file: " & configFile
			Exit Sub
		end if
		set config = fso.GetFile(configFile)
		
		WScript.StdOut.Write("Updating environment configuration for: " & configFile) 
	
		'Load the .dtsx file - SSIS package definition
		set doc = CreateObject("Microsoft.XmlDom")
		doc.Load(configFile)
		
		doc.setProperty "SelectionLanguage", "XPath" 
		doc.setProperty "SelectionNamespaces", "xmlns:DTS='www.microsoft.com/SqlServer/Dts'"
		node = null
		set node = doc.SelectSingleNode("/DTS:Executable/DTS:Configuration[1]/DTS:Property[@DTS:Name='ConfigurationString']")
		
		if IsNothing(node) = false then
			'MsgBox node.text
			'Update package configuration
			node.text = rootPath & "\" & environment & "\" & packagePath & "\DATACONV.dtsConfig"
			
			doc.save(configFile)
		end if
		set doc = nothing
	
		set config = nothing
		set fso = nothing
	
	End Sub
	
	Function IsNothing (obj)
		If TypeName(obj) = "Nothing" Then
			IsNothing = True
		Else
			IsNothing = False
		End If
	End Function
'-------------------------------------------------------