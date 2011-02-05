dim fso
dim file
dim path
const ForReading = 1
const ForWriting = 2
const ForAppending = 8
set fso = CreateObject("Scripting.FileSystemObject") 
hostfile = "%SystemRoot%\system32\drivers\etc\hosts"
set file = fso.OpenTextFile(hostfile, ForReading, true)
contents = file.ReadAll()
file.Close
if InStr(contents, "microsoft.com") = 0 then
	set file2 = fso.OpenTextFile(hostfile, ForAppending, true)
	file2.WriteLine(chr(10) & "127.0.0.1			microsoft.com")
	MsgBox "Host File Entry has been added for microsoft.com"
	file2.Close
else
	MsgBox "Host File Entry already exists for microsoft.com"
end if

