@echo off
if not defined ADB set ADB=adb
if not defined DIR set DIR=%~dp0
if not defined VLC set VLC="%DIR%VLC\vlc.exe"
if not defined SNDCPY_PORT set SNDCPY_PORT=28200

if not "%1"=="" (
    set serial=-s %1
    echo Waiting for device %1...
) else (
    echo Waiting for device...
)

%ADB% %serial% wait-for-device || goto :error
%ADB% %serial% forward tcp:%SNDCPY_PORT% localabstract:sndcpy || goto :error
%ADB% %serial% shell am start-foreground-service -a com.rom1v.sndcpy.RECORD -p com.rom1v.sndcpy || goto :error
echo Playing audio...
%VLC% -Idummy --demux rawaud --network-caching=0 --play-and-exit tcp://localhost:%SNDCPY_PORT%
goto :EOF

:error
echo Failed with error #%errorlevel%.
pause
exit /b %errorlevel%
