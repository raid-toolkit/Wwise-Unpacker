@echo off
setlocal
pushd %~dp0
set BaseDir=%~dp0


:loop
if "%~1"=="" goto end

copy "%~1" "%BaseDir%Game_Files" > nul
pushd .
echo Extracting audio from %~fn1
call "%BaseDir%unpack.bat" mp3
popd

mkdir "%BaseDir%Output\%~n1" >nul 2>&1
copy "%BaseDir%dest_mp3\*.mp3" "%BaseDir%Output\%~n1"
del "%BaseDir%Game_Files\*.pck" > nul

rmdir /s/q "%BaseDir%dest_raw" >nul 2>&1
rmdir /s/q "%BaseDir%dest_wav" >nul 2>&1
rmdir /s/q "%BaseDir%dest_mp3" >nul 2>&1
shift
goto loop

:end
popd

start %BaseDir%Output\%~n1

::pause
