@echo off
echo Deploy to DEV?
pause.
%SystemRoot%\Microsoft.NET\Framework\v3.5\MSBuild.exe SSIS_Deploy.proj @DEV.rsp
pause.