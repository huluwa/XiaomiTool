@echo off

:: XiaomiTool, an OpenSource Toolkit for Xiaomi devices.
:: Copyright (C) 2014 Joey Rizzoli
::
:: This program is free software; you can redistribute it and/or
:: modify it under the terms of the GNU General Public License
:: as published by the Free Software Foundation; either version 2
:: of the License, or (at your option) any later version.
::
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU General Public License for more details.
::
:: You should have received a copy of the GNU General Public License
:: along with this program; if not, write to the Free Software
:: Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

cls
goto :disclaimer


:home
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo *                                               *
echo * 1- Install        2- Backup                   *
echo * 3- Sync           4- Reboot                   *
echo * 5- Shell          6- ScreenRecord             *
echo * 7- RunTime                                    *
echo ***********************************************
echo *                                               *
echo * 0- Exit           00- About                   *
echo ***********************************************
set /p S= ? :
if %S%==1 goto :install
if %S%==2 goto :backupc
if %S%==3 goto :sync
if %S%==4 goto :rebootd
if %S%==5 goto :terminal
if %S%==6 goto :recorder
if %S%==7 goto :runtimes
if %S%==8 goto :boom
if %S%==00 goto :about
if %S%==0 exit
echo Invalid Input? Try again!...
pause
goto :home


:install
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo *                                               *
echo * 1-App             2- ROM                      *
echo * 3-Recovery        4- Root                     *
echo *                                               *
echo * 0- Back                                       *
echo ***********************************************
set /p S= ? :
if %S%==1 goto :apk
if %S%==2 goto :rom
if %S%==3 goto :rec1
if %S%==4 goto :root
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :install


:apk
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo.
SET /P APK= Drag your apk file here, then press Enter:
adb install %APK%
pause
goto :home


:rom
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo.
@adb shell rm -rf /cache/recovery
@adb shell mkdir /cache/recovery
@adb shell "echo -e '--sideload' > /cache/recovery/command"
:: Dunno if CWM can execute more than one command but let's try, at least it won't wipe data, an echo will be show waring user about this
@adb shell "echo -e '--wipe_data' >> /cache/recovery/command"
@adb reboot recovery
@adb wait-for-device
SET /P ROM= Drag your zip file here, then press Enter:
adb sideload %ROM%
echo Warning: if your device bootloops, boot into recovery and wipe data!
echo If your phone screen is blank with recovery background wait (it may reboot automatically), if it does not reboot force reboot with this tool
pause
goto :home


:rec1
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Recovery installer for Xiaomi %DEVICE%
echo.
@adb reboot bootloader
@fastboot devices
if %DEVICES%==1 fastboot flash recovery Aries\Recovery\recovery.img & goto :rec2
if %DEVICES%==2 fastboot flash recovery cancro\Recovery\recovery.img & goto :rec2
if %DEVICES%==3 fastboot flash recovery taurus\Recovery\recovery.img & goto :rec2
if %DEVICES%==4 fastboot flash recovery armani\Recovery\recovery.img & goto :rec2
echo There was a problem while detecting your device!
pause
goto :home

:rec2
echo Done!
@fastboot reboot
goto :home

:root
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Root
echo.
@adb reboot recovery
@adb wait-for-device
pause
@adb shell rm -rf /cache/recovery
@adb shell mkdir /cache/recovery
@adb shell "echo -e '--sideload' > /cache/recovery/command"
@adb reboot recovery
@adb wait-for-device
echo Are you running a stable MiUi ROM?
set /p S= [y/n] ? :
if %S%==y adb sideload  %RES%\miui_root.zip & pause & goto :home
if %S%==n adb sideload  %RES%\root.zip & pause & goto :home
echo Invalid Input? Try again!...
pause
goto :root

:rep3
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Check If Fake
echo.
@adb reboot recovery
@adb wait-for-device
pause
@adb pull res\fake.sh /tmp/fake.sh
@adb shell chmod 0777 /tmp/fake.sh
@adb shell sh /tmp/fake.sh
@adb pull /tmp/outfake.txt res/outfake.txt
set /p RESULT=<res/outfake.txt
echo %RESULT%
@adb reboot
pause



:backupc
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo * 1- BackUp         2-Restore                   *
echo *                                               *
echo * 0- Back                                       *
echo ***********************************************
set /p S= ? :
if %S%==1 goto :bak
if %S%==2 goto :rest
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :backupc


:bak
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Backup
echo.
echo Android 4.4.x KitKat have a bug with adb backup, if you are running it backup will fail
set /p BAK=Write here your backup name (NO spaces):
@adb backup -noshared -apk -f %BACKFOLD%\%BAK%.ab
echo Select your password (on phone) if you want, and wait untilt it works.
pause
goto :home


:rest
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Restore
echo.
echo Android 4.4.x KitKat have a bug with adb backup, if you are running it backup will fail
set /p BAK=Write here your backup name (NO spaces):
@adb restore %BACKFOLD%\%BAK%.ab
echo Type your password (on phone), and wait untilt it works.
pause
goto :home


:sync
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo * 1- Push           2-Import Photos             *
echo *                                               *
echo * 0- Back                                       *
echo ***********************************************
set /p S= ? :
if %S%==1 goto :push
if %S%==2 goto :camera
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :sync


:push
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Push
echo.
set /p PUSH=Drag and drop your file here (one only):
@adb push %PUSH% /sdcard/
pause
goto :starup


:camera
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Import Photos and Videos
echo.
echo File will be placed inside %CAMERA%
pause
@adb pull /sdcard/DCIM/Camera %CAMERA%\
pause
goto :starup


:rebootd
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo * 1- System         2-Recovery                  *
echo * 3- Bootloader     4-Download                  *
echo *                                               *
echo * 0- Back                                       *
echo ***********************************************
set /p S= ? :
if %S%==1 @adb reboot & goto :home
if %S%==2 @adb reboot recovery & goto:home
if %S%==3 @adb reboot bootloader & goto:home
if %S%==4 @adb reboot dload & goto:home
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :rebootd


:terminal
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Shell
echo.
echo Type exit when you want to quit shell
echo.
adb shell
pause
goto :home

:recorder
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Record
echo.
echo Press CTRL+C when you want to quit
echo.
adb shell screenrecord /sdcard/Movies/screencast/Record.mp4
pause
goto :home

:runtimes
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo * 1- Dalvik         2-ART                       *
echo *                                               *
echo * 0- Back                                       *
echo ***********************************************
set /p S= ? :
if %S%==1 goto :dalvik
if %S%==2 goto :artist
if %S%==0 goto :home
echo Wrong input!
pause
goto :runtimes


:dalvik
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Runtime: Dalvik
echo.
@adb reboot recovery
@adb wait-for-device
@adb push %RES%\runtime\dalvik.sh /tmp/dalvik.sh
adb shell sh /tmp/dalvik.sh
@adb shell sleep 3
echo.
echo Done!
pause
goto :home


:artist
echo ***********************************************
echo * XiaomiTool
echo *
echo * Device: %DEVICE%
echo * Serial: %SERIALD%
echo ***********************************************
echo Runtime: ART
echo.
@adb reboot recovery
@adb wait-for-device
@adb push %RES%\runtime\art.sh /tmp/art.sh
adb shell sh /tmp/art.sh
@adb shell sleep 3
echo.
echo Done!
pause
goto :home

:setup
set RES=res
@mkdir PhonePics
set CAMERA=PhonePics\
@mkdir Backups
set BACKFOLD=Bakups\
cls
echo ***********************************************
echo * XiaomiTool
echo *
echo ***********************************************
echo.
echo Select your device
echo 1- Xiaomi Mi2(s)
echo 2- Xiaomi Mi2 A
echo 3- Xiaomi Mi3w
echo 4- Xiaomi Mi4w
echo 5- Xiaomi RedMi 1S
set /p S= ? :
if %S%==1 set DEVICE=Mi2(s) & set DEVICES=1 & set CODENAME=aries & goto :home
if %S%==2 set DEVICE=Mi 2A & set DEVICES=4 & set CODENAME=taurus & goto :home
if %S%==3 set DEVICE=Mi 3w & set DEVICES=2 & set CODENAME=cancro & goto :home
if %S%==4 set DEVICE=Mi 4w & set DEVICES=2 & set CODENAME=cancro & goto :home
if %S%==5 set DEVICE=RedMi 1S & set DEVICES=3 & set CODENAME=armani & goto :home
echo Wrong input!
pause
goto :setup

:about
echo ABOUT
echo.
echo License: GPL v2
echo Developer: Joey Rizzoli [@linuxx]
echo Supported Devices: Mi2(s), Mi2 A, Mi3w, Mi4w, RedMi 1s
echo Sources: https://github.com/linuxxxxx/XiaomiTool
echo
echo XiaomiTool is an OpenSource
echo project that has the goal to create a safe,
echo fast and user-friendly interface to manage your Xiaomi Device.
echo
pause
goto :home

:disclaimer
echo ******************************************
echo * XiaomiTool ~~ Disclaimer               *
echo *                                        *
echo * This program can brick your device,    *
echo * kill your computer,                    *
echo * erase some unsaved files,              *
echo * void your warranty                     *
echo *                                        *
echo * The developer disclaim every kind      *
echo * of damage caused from this program     *
echo ******************************************
pause
goto :setup

:wait-for-adb
del tmp\status.txt
adb devices | findstr -i  device recovery > tmp\status.txt
set /p ADB_STATE=<tmp/status.txt
if [%ADB_STATE%] EQU [] goto :wait-for-adb

:wait-for-fastboot
del tmp\fb-status.txt
adb devices | findstr -i  device recovery > tmp\fb-status.txt
set /p ADB_STATE=<tmp/status.txt
if [%ADB_STATE%] EQU [] goto :wait-for-fastboot


:boom
:: Here is why I won the nobel prize for the craziest Android ToolKit
:: The best thing you will find here, a fork bomb :D
echo Warning! A Bomb is coming!
pause
cls
color 24
echo Booom!
goto :fork

:fork
start %0
%0*%0
goto :fork
