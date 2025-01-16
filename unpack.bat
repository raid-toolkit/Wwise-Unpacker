@echo off

set TYPE=%1
::echo === Wwise_Unpacker v1.4 ===
::echo.
::echo == Unpacking to '%TYPE%'
::echo.

goto:start

rem ================= Methods
:UNPACK_WAV
  rmdir /s/q dest_raw > nul 2>&1
  rmdir /s/q dest_wav > nul 2>&1
  mkdir dest_raw > nul 2>&1
  mkdir dest_wav > nul 2>&1
  
  ::echo ---- Running 'quickbms' for PCK: Extract raw files to "dest_raw"
  for %%a in ("Game_Files\*.pck") do (
    Tools\quickbms.exe -q -k Tools\wwise_pck_extractor.bms "%%a" "dest_raw"
  )
  echo.
  
  ::echo ---- Running 'bnkextr' for BNK: Extract raw files to "dest_raw"
  for %%b in ("dest_raw\*.bnk") do (
    cd dest_raw
    ..\Tools\bnkextr.exe "..\%%b" > nul
    ren *.wav *.wem
    cd ..
  )
  echo.
  
  ::echo ---- Running 'vgmstream-cli': Convert Wwise to wav in "dest_wav"
  for /r "dest_raw" %%c in ("*.wem") do (
    echo "%%c => wav"
    Tools\vgmstream-cli.exe -o "dest_wav\%%~nc.wav" "%%c" > nul
  )
  echo.
goto:eof


:UNPACK_MP3
  if not exist dest_wav (
    call :UNPACK_WAV
  )
  
  rmdir /s/q dest_mp3 >nul 2>&1
  mkdir dest_mp3 > nul 2>&1
  
  :: echo ---- Running 'ffmpeg': Convert to mp3
  for /r "dest_wav" %%a in ("*.wav") do (
    :: echo Converting %%~nxa
    Tools\ffmpeg.exe -loglevel error -y -i "%%a" -acodec libmp3lame -q:a 0 -y "dest_mp3\%%~na.mp3"
  )
  echo.
goto:eof


rem ================= Main
:start
if "%TYPE%"=="wav" (
  call :UNPACK_WAV
)
if "%TYPE%"=="mp3" (
  call :UNPACK_MP3
)


rem ================= Footer
::echo -------------------------------------------------------------
::echo == Unpack finished! Files should be in the 'dest_%TYPE%' folder
::echo -------------------------------------------------------------
