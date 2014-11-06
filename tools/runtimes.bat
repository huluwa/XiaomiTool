@echo off
adb shell getprop ro.build.version.release | findstr -i 4.4 > tmp\androidapi.txt
set /p build =< tmp\androidapi.txt
if %build%==4.4 goto :runtimes
echo The device is not running KitKat!
pause
exit

:runtimes
cls
echo Manage runtimes
echo.
echo 1- Dalvik         2-ART
echo.
echo 0- Back
echo.
set /p S= ? :
if %S%==1 goto :dalvik
if %S%==2 goto :artist
if %S%==0 goto :home
echo Wrong input!
pause
goto :runtimes


:dalvik
cls
echo Runtime: Dalvik
echo.
@adb reboot recovery
@adb wait-for-device
@adb push res\runtime\dalvik.sh /tmp/dalvik.sh
adb shell sh /tmp/dalvik.sh
@adb shell sleep 3
echo.
echo Done!
pause

:artist
cls
echo Runtime: ART
echo.
@adb reboot recovery
@adb wait-for-device
@adb push res\runtime\art.sh /tmp/art.sh
adb shell sh /tmp/art.sh
@adb shell sleep 3
echo.
echo Done!
pause
