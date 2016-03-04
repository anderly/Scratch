REM Deletes log files older than 7 days old

SET WORKING_DIR=%CD%
SET TOMCAT_LOG_DIR="C:\logs"
CD %TOMCAT_LOG_DIR%
ForFiles /m *.log /d -7 /c "cmd /c IF EXIST @FILE ECHO DEL @FILE& DEL @FILE"
CD %WORKING_DIR%