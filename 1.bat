doskey
cls
keyb ru 866
echo off
..\\tasm.exe /m3 mlab1.asm

if errorlevel 1 goto edit

..\\tasm.exe /zi /l  mlab1l.asm

if errorlevel 1 goto edit

..\\tlink.exe /3  mlab1.obj + mlab1l.obj

if errorlevel 1 goto edit

goto end

:edit 
	td.exe mlab1.asm
:end	
	mlab1.exe