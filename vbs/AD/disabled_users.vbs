
	'ADO Constants
	Const adCmdStoredProc = &H0004
	Const adParamOutput = &H0002
	Const adParamInputOutput = &H0003

	'Active Directory Constants
	Const ADS_SCOPE_SUBTREE = 2

	Dim objCommand, cmdEV2ActiveUsers, conn1, conn2, strBase, strFilter, strAttributes 

	Dim strQuery, rsADUsers, rsDisabledUsers, rsEV2ActiveUsers, strName
	
	set objCommand = CreateObject("ADODB.Command") 
	set conn1 = CreateObject("ADODB.Connection") 

	conn1.Provider = "ADsDSOObject" 
	conn1.Open "Active Directory Provider"

	objCommand.ActiveConnection = conn1 

	'Search entire domain. 
	strBase = "<LDAP://chomes.com>" 

	' Filter users where Account Disabled OR SmartCard Required is TRUE 
	'strFilter = "(&(objectCategory=User)(userAccountControl:1.2.840.113556.1.4.803:=2))"
	'userAccountControl Flags:
	'  Property					Hexidecimal		Decimal
	'	Account Disabled		0x0002			2
	'	SmartCard Required		0x40000			262144
	strFilter = "(&(objectCategory=User))" 

	' Retrieve NT Name of user accounts, the sAMAccountName attribute. 
	strAttributes = "sAMAccountName" 

	' Construct the query. 
	strQuery = strBase & ";" & strFilter & ";" & strAttributes & ";subtree" 
	objCommand.CommandText = strQuery 
	objCommand.Properties("Page Size") = 100 
	objCommand.Properties("Timeout") = 30 
	objCommand.Properties("Cache Results") = False 

	' Run the ADO query. 
	set rsDisabledUsers = objCommand.Execute

	MsgBox rsDisabledUsers.RecordCount

	rsDisabledUsers.Close()
	set rsDisabledUsers = nothing
