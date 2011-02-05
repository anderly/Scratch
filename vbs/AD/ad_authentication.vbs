Dim oADsObject
Set oADsNamespace = GetObject("LDAP:")
Const ADS_SECURE_AUTHENTICATION = 1

ADsPath = "LDAP://domain.com"

fullUserName = "domain\username"
pwd = "[password]"
'if userIdContainsDomain(fullUserName) = false then
'fullUserName = domain & "\" & uid
'end if

ON ERROR RESUME NEXT
Set oADsObject = oADsNamespace.OpenDSObject(ADsPath, fullUserName, pwd, ADS_SECURE_AUTHENTICATION)
If Err.number = 0 Then
  MsgBox "Authenticated"
else
  MsgBox "Authentication Failed"
End If
oADsNamespace = nothing