@echo off 
for /f "tokens=1 delims=:" %%a in ( 
 '^(echo."%~1"^& echo.!@#^)^|findstr /O /C:"!@#" ' 
) do set /a Length=%%a-5 
echo % for example %Length=%Length%
pause.