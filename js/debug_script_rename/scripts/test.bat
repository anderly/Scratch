@Echo off
REM ----------------------------------------------------------------------------------------
REM <summary>
REM 	Script used to copy the Debug (or Release) javascript files to the runtime location
REM </summary>
REM ----------------------------------------------------------------------------------------
REM Grab the first argument as variable Config (Debug/Release)
SET Config=%~1
REM The loop below is used to get the Length of the Config variable
REM The Length variable is then used in the substring function on Line 19
for /f "tokens=1 delims=:" %%a in ( 
 '^(echo."%Config%"^& echo.!@#^)^|findstr /O /C:"!@#" ' 
) do set /a Length=%%a-5 + 5
FOR /R %%i IN (*.%Config%.js) DO CALL :REN %%i
GOTO :END
:REN
	SET File=%~f1
	REM Set File2 variable to the runtime filename (minus .debug or .release)
	CALL SET File2=%%File:~0,-%Length%%%.txt
	REM Finally, we copy the current debug|release file to the runtime file
	XCOPY /R /Y "%File%" "%File2%"
:END
	Echo JavaScript Configuration Complete