set myUser = GetObject("WinNT://domain.com/username,user")

MsgBox myUser.FullName
MsgBox myUser.Name
MsgBox myUser.Description
'MsgBox myUser.displayName
MsgBox myUser.HomeDirectory