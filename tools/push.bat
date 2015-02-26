@echo off
cls
echo Push
echo.
set /p PUSH=Drag and drop your file here (one only):
adb push %PUSH% /sdcard/
pause
