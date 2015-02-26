@echo off
cls
echo Flash zip file
echo.
@adb shell rm -rf /cache/recovery
@adb shell mkdir /cache/recovery
@adb shell "echo -e '--sideload' > /cache/recovery/command"
@adb reboot recovery
@adb wait-for-device
adb sideload res\root.zip
echo If your phone screen is blank with recovery background wait (it may reboot automatically), if not force reboot
pause
