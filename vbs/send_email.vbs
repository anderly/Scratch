
	Dim strServers
	Dim arrServers
	Dim smtpServer
	Dim emailTo, emailFrom, emailSubject
	
	'----------------------------------------------------------------
	' Begin Config Settings
	'----------------------------------------------------------------
	
		smtpServer 		= "127.0.0.1"
		smtpPort		= 25
		emailTo 		= "to@company.com"
		emailFrom		= "from@company.com"
		emailSubject	= "Email Test"
		
	'----------------------------------------------------------------
	' End Config Settings
	'----------------------------------------------------------------

	Notify("This is a test message")
	
	Sub Notify(strBody)
		set msg = createobject("cdo.message")
		set cfg = createobject("cdo.configuration")

		Set Flds = cfg.Fields
		With Flds
			.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = smtpPort
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 180
			.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtpServer
			'.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 2
			'.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = smtpUsername
			'.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = smtpPassword
			.Update
		End With

		With msg
			Set .Configuration = cfg
				.To = emailTo
				.From = emailFrom
				.Subject = emailSubject
				.TextBody = strBody
				.fields.update
				.Send
		End With

		set msg = nothing
		set cfg = nothing

	End Sub 'Notify
'-------------------------------------------------------