doskey
cls
echo off
..\\tasm.exe /l /zn mlab1.asm

if errorlevel 1 goto edit

..\\tasm.exe  mlab1l.asm

if errorlevel 1 goto edit

..\\tlink.exe mlab1.obj + mlab1l.obj

if errorlevel 1 goto edit

goto end

:edit 
	td.exe mlab1.asm
:end	
	mlab1.exe