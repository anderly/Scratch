@Echo off
FOR /R "C:\Working Folders\System Consolidation\Dev\ePro\" %%i IN (*.dtsx) DO CALL :COPY "%%i" "ePro"
FOR /R "C:\Working Folders\System Consolidation\Dev\eSchedule\" %%i IN (*.dtsx) DO CALL :COPY "%%i" "eSchedule"
FOR /R "C:\Working Folders\System Consolidation\Dev\eService\" %%i IN (*.dtsx) DO CALL :COPY "%%i" "eService"
FOR /R "C:\Working Folders\System Consolidation\Dev\Lawson\CNV_Lawson\" %%i IN (*.dtsx) DO CALL :COPY "%%i" "Lawson"
FOR /R "C:\Working Folders\System Consolidation\Dev\Lawson\CNV10_Lawson_VendorMaster\" %%i IN (*.dtsx) DO CALL :COPY "%%i" "Lawson"
FOR /R "C:\Working Folders\System Consolidation\Dev\PHBS\" %%i IN (*.dtsx) DO CALL :COPY "%%i" "PHBS"
GOTO :END

:COPY
 	SET File=%~f1
 	SET Directory=%~2
	SET Filename=%~n1
	SET File2="C:\Users\aanderly.PHCORP\Desktop\Deploy\SSIS_Deployment\%Directory%\%Filename%.dtsx"
	IF EXIST "%File2%" ATTRIB /S -R "%File2%"
	COPY /Y "%File%" %File2%
:END
REM pause.