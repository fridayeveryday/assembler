doskey
cls
keyb ru 866
echo off
..\\tasm.exe  mlab1.asm

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