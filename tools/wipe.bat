@echo off
echo Wipe Data
echo.
@adb shell rm -rf /cache/recovery
@adb shell mkdir /cache/recovery
@adb shell "echo -e '--wipe_data' > /cache/recovery/command"
@adb reboot recovery
@adb wait-for-device
echo The device is wiping its data, let it works
echo If your phone screen is blank with recovery background wait some minutes (it may reboot automatically), if not force reboot
pause
