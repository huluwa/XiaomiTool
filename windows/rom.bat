@echo off
cls
echo.
echo ##############################################################
echo #ARIES ToolKit --- Running on: Windows --- By Linuxx         #
echo ##############################################################
echo.
echo.
echo *********************
echo Custom rom Installer
echo *********************
echo.
echo.
pause
@adb reboot recovery
echo Select:Wipe Data / Factory Reset (ONLY if you're changing rom, not an update) , 
echo then Install zip from sideload, select system 1 and
SET /P BUN= Drag zip file here:
adb sideload 
echo ONLY When the recovery will give some Options Like Reboot System Now, Install zip,
pause
echo Enjoy your new custom rom on your Mi2(s)
@adb reboot
pause
