cls
..\\tasm.exe mlab1.asm
pause
if errorlevel 1 goto edit
pause
..\\tasm.exe mlab1l.asm
pause
if errorlevel 1 goto edit
pause
..\\tlink.exe mlab1.obj + mlab1l.obj
pause
if errorlevel 1 goto edit
pause

:edit 
	edit mlab1.asm
