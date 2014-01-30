@echo off
cls
echo.
echo ##############################################################
echo #ARIES ToolKit --- Running on: Windows --- By Linuxx         #
echo ##############################################################
echo.
echo.
echo *********************
echo Cyanogenmod Installer
echo *********************
echo.
echo.
pause
echo Let the phone reboot, and say goodbye to Miui!
echo waiting Your Phone...
@adb reboot recovery
echo The  Phone Will Be Rebooted on Recovery Mode
echo.
echo REMEMBER: Use VOl + Key and Vol - Key to select, POWER Button to Confirm
echo Press enter to continue...
pause
echo.
echo Select:Wipe Data / Factory Reset (ONLY if you're changing rom, not an update) , then Install zip from sideload, select system 1 and
echo DON'T TOUCH OR REBOOT OR SHUTDOWN OR UNPLUG YOUR DEVICE!!!! THIS WILL TAKE SOME MINUTES!!!!!!!
echo ONLY whan You're ready, press enter to continue...
pause
adb sideload C:\ariesTool\rom\cm.zip
echo When the recovery will give some Options Like Reboot System Now, Install zip,
pause
echo Enjoy your new Cyaogenmod 10.2 stable on your Mi2(s)
@adb reboot
pause
