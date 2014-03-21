@echo off
cls
goto :device

#################Initial Menu




:startup
cls
echo ################################
echo # Xiaomi Toolkit               #
echo # Selected device: %DEVICE%    #
echo ################################
echo.
echo 1- Install         4- Reboot
echo 2- Backup          5- Shell
echo 3- Push and Pull   6- Settings
echo .
echo 0- Exit
echo.
echo.
set /p S= ? :
if %S%==1 goto :install
if %S%==2 goto :backupc
if %S%==3 goto :sync
if %S%==4 goto :rebootd
if %S%==5 goto :terminal
if %S%==6 goto :setup
if %S%==0 exit
echo Invalid Input? Try again!...
pause
goto :startup




#############Install


:install
cls
echo ################################
echo # Xiaomi Toolkit               #
echo # Selected device: %DEVICE%    #
echo ################################
echo.
echo Installer
echo.
echo 1- Apk       3- Recovery
echo 2- Rom
echo.
echo 0- Go back
echo.
set /p S= ? :
if %S%==1 goto :apk
if %S%==2 goto :rom
if %S%==3 goto :rec1
if %S%==0 goto :startup
echo Invalid Input? Try again!...
pause
goto :install


:apk
cls
echo ################################
echo # Xiaomi Toolkit               #
echo # Selected device: %DEVICE%    #
echo ################################
echo.
echo Apk installer
echo.
SET /P APK= Drag your apk file here, then press Enter: 
adb install %APK%
pause
goto :startup


:rom
cls
echo ################################
echo # Xiaomi Toolkit               #
echo # Selected device: %DEVICE%    #
echo ################################
echo.
echo Rom Installer
echo.
@adb reboot recovery
echo Wipe /data if needed and enable sideload
SET /P ROM= Drag your zip file here, then press Enter:  
adb sideload %ROM%
echo Phone will apply the update, do not reboot it untit it ends
pause
goto :startup


:rec1
if %DEVICE%==1 goto :rec2
if %DEVICE%==2 goto :rec3

:rec2
cls
echo ################################
echo # Xiaomi Toolkit               #
echo # Selected device: %DEVICE%    #
echo ################################
echo.
echo Recovery installer for Xiaomi mi2(s)
echo.
@adb reboot bootloader
@fastboot devices
@fastboot flash recovery C:\XiaomiTool\Aries\Recovery\recovery.img
echo Done!
@fastboot reboot
goto :startup


:rec3
cls
echo ################################
echo # Xiaomi Toolkit               #
echo # Selected device: %DEVICE%    #
echo ################################
echo.
echo Recovery installer for Xiaomi mi3
echo.
@adb reboot bootloader
@fastboot devices
@fastboot flash recovery C:\XiaomiTool\Cancro\Recovery\recovery.img
echo Done!
@fastboot reboot
goto :startup







##########Settings

:device
echo.
echo.
echo Select your device
echo.
set /p DEVICE= 1- Xiaomi Mi2(s)      2- Xiaomi Mi3    :
goto :startup
