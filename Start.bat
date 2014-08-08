@echo off
cls
goto :device

#################Initial Menu




:home
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo 1- Install
echo 2- Backup
echo 3- Push and Pull
echo 4- Reboot
echo 5- Shell
if %KK%==1 echo 6- ScreenRecord
if %KK%==1 echo 7- Manage Runtime
echo.
echo 00- Settings
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
goto :home




#############Install


:install
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Installer
echo.
echo 1- Apk       3- Recovery
echo 2- Rom       4- Repartition
echo.
echo 0- Go back
echo.
set /p S= ? :
if %S%==1 goto :apk
if %S%==2 goto :rom
if %S%==3 goto :rec1
if %S%==3 goto :rep1
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :install


:apk
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Apk installer
echo.
SET /P APK= Drag your apk file here, then press Enter:
adb install %APK%
pause
goto :home


:rom
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
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
goto :home


:rec1
if %DEVICE%==1 goto :rec2
if %DEVICE%==2 goto :rec3
if %DEVICE%==3 goto :rec4

:rec2
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Recovery installer for Xiaomi mi2(s)
echo.
@adb reboot bootloader
@fastboot devices
@fastboot flash recovery C:\XiaomiTool\Aries\Recovery\recovery.img
echo Done!
@fastboot reboot
goto :home


:rec3
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Recovery installer for Xiaomi mi3
echo.
@adb reboot bootloader
@fastboot devices
@fastboot flash recovery C:\XiaomiTool\Cancro\Recovery\recovery.img
echo Done!
@fastboot reboot
goto :home

:rec4
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Recovery installer for Xiaomi RedMi 1S
echo.
@adb reboot bootloader
@fastboot devices
@fastboot flash recovery C:\XiaomiTool\armani\Recovery\recovery.img
echo Done!
@fastboot reboot
goto :home

:rep1
if %DEVICE%==1 goto :rep2
if %DEVICE%==2 goto :rep3
echo Device not supported
goto :home

:rep2
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Repartition for Xiaomi mi2(s)
echo.
@adb reboot recovery
@adb wait-for-device
pause
@adb pull C:\XiaomiTool\Aries\Repartition.sh /tmp/
@adb shell chmod 0777 /tmp/repartition.sh
@adb shell sh /tmp/repartition.sh
echo Now you MUST install a rom. Sideload it
pause
goto :rom

:rep3
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Repartition for Xiaomi mi3
echo.
@adb reboot recovery
@adb wait-for-device
pause
@adb pull C:\XiaomiTool\Cancro\Repartition.sh /tmp/
@adb shell chmod 0777 /tmp/repartition.sh
@adb shell sh /tmp/repartition.sh
echo Now you MUST install a rom. Sideload it
pause
goto :rom

##########Settings

:device
echo ################################
echo # Xiaomi Toolkit               #
echo ################################
echo.
echo Choose the number basing on your device name
echo 1- Xiaomi Mi2(s)
echo 2- Xiaomi Mi3
echo 3- Xiaomi RedMi 1S
echo.
echo 0- Quit
set /p S= ? :
if %S%==1 set DEVICE=Mi2 & set KK=1 & goto :home
if %S%==2 set DEVICE=Mi3 & set KK=1 & goto :home
if %S%==3 set DEVICE=RedMi 1S set KK=0 & goto :home
if %S%==0 exit
echo Invalid Input? Try again!...
pause
goto :home



#############Backup

:backupc
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo 1- Backup       2- Restore
echo.
echo 0- Go back
echo.
set /p S= ? :
if %S%==1 goto :bak
if %S%==2 goto :rest
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :backupc

:bak
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Backup
echo.
set /p BAK=Write here your backup name (NO spaces):
@adb backup -nosystem -noshared -apk -f C:\XiaomiTool\Backups\%BAK%.ab
echo Select your password (on phone) if you want, and wait untilt it works.
pause
goto :home

:rest
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Restore
echo.
set /p BAK=Write here your backup name (NO spaces):
@adb restore C:\XiaomiTool\Backups\%BAK%.ab
echo Type your password (on phone), and wait untilt it works.
pause
goto :home


#############Push&Pull
:sync
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo 1- Push a file   2- Import Photos
echo.
echo 0- Go back
echo.
set /p S= ? :
if %S%==1 goto :push
if %S%==2 goto :camera
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :sync

:push
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Push
echo.
set /p PUSH=Drag and drop your file here (one only):
@adb push %PUSH% /sdcard/
pause
goto :starup

:camera
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Import Photos and Videos
echo.
echo File will be placed inside C:\XiaomiTool\Userfiles\Camera
pause
@adb pull /sdcard/DCIM/Camera C:\XiaomiTool\Userfiles\
pause
goto :starup


#############Reboot

:rebootd
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Reboot..
echo.
echo 1- System        3- Bootloader
echo 2- Recovery      4- Download
echo.
echo 0- Go back
echo.
set /p S= ? :
if %S%==1 @adb reboot & goto :home
if %S%==2 @adb reboot recovery & goto:home
if %S%==3 @adb reboot bootloader & goto:home
if %S%==4 @adb reboot dload & goto:home
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :rebootd


#############Shell
:terminal
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Shell
echo.
echo Press CTRL+C when you want to exit from shell
echo.
adb shell
pause
goto :home

:record
cls
echo ################################
echo # Xiaomi Toolkit
echo # Selected device: %DEVICE%
echo ################################
echo.
echo Record
echo.
echo Press CTRL+C when you want to quit
echo.
adb shell screenrecord /sdcard/Movies/screencast/Record.mp4
pause
goto :home
