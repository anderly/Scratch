REM Deletes files older than 30 days old
For /F "tokens=1 delims=" %v In ('ForFiles /P "C:\temp" /m *_*_*_*.txt /d -30 2^>^&1') do if EXIST "C:\temp"\%v echo del "C:\temp"\%v& del "C:\temp"\%v"