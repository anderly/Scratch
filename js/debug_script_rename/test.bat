@Echo off
For /R %%A IN (*.js) Do Call :ATTR %%A
GOTO :END
:ATTR
	SET File=%~f1
	SET File2=%File:~-8%
	IF NOT "%File2%" == "debug.js" ATTRIB /S -R "%File%"
:END
Pause.