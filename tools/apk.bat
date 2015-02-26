@echo off
cls
echo Install an app
echo.
SET /P APK= Drag your apk file here, then press Enter:
adb install %APK%
pause
