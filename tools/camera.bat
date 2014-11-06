@echo off
@mkdir PhonePics
set CAMERA=PhonePics\
cls
set
echo Import Photos and Videos
echo.
echo File will be placed inside %CAMERA%
pause
adb pull /sdcard/DCIM/Camera %CAMERA%\
pause
