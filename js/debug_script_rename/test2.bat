@echo off
For /R %%A IN (*.debug.txt) Do Call :REN %%A
GOTO :END

:REN
SET File1=%~f1
SET File2=%File1:.Debug=%
Copy %File1% %File2%
REM echo %File

:END