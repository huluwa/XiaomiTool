@echo off

#   Copyright 2014 Joey Rizzoli
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

cls
goto :disclaimer

:home
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo |                                               |
echo | 1- Install        2- Backup                   |
echo | 3- Sync           4- Reboot                   |
echo | 5- Shell          6- ScreenRecord             |
echo | 7- RunTime                                    |
echo |-----------------------------------------------|
echo |                                               |
echo | 0- Exit           00- About                   |
echo |-----------------------------------------------|
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
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo |                                               |
echo | 1-App             2- ROM                      |
echo | 3-Recovery        4- Root                     |
echo |                                               |
echo | 0- Back                                       |
echo |-----------------------------------------------|
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
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo.
SET /P APK= Drag your apk file here, then press Enter:
adb install %APK%
pause
goto :home


:rom
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo.
@adb shell rm -rf /cache/recovery
@adb shell mkdir /cache/recovery
@adb shell "echo -e '--sideload' > /cache/recovery/command"
# Dunno if CWM can execute more than one command but let's try, at least it won't wipe data, an echo will be show waring user about this
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
if %DEVICE%==1 goto :rec2
if %DEVICE%==2 goto :rec3
if %DEVICE%==3 goto :rec4

:rec2
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Recovery installer for Xiaomi mi2(s)
echo.
@adb reboot bootloader
@fastboot devices
@fastboot flash recovery Aries\Recovery\recovery.img
echo Done!
@fastboot reboot
goto :home


:rec3
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Recovery installer for Xiaomi mi3w and mi4w
echo.
@adb reboot bootloader
@fastboot devices
@fastboot flash recovery Cancro\Recovery\recovery.img
echo Done!
@fastboot reboot
goto :home

:rec4
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Recovery installer for Xiaomi RedMi 1S
echo.
@adb reboot bootloader
@fastboot devices
@fastboot flash recovery armani\Recovery\recovery.img
echo Done!
@fastboot reboot
goto :home

:root
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
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
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Repartition for Xiaomi mi3
echo.
@adb reboot recovery
@adb wait-for-device
pause
@adb pull Cancro\Repartition.sh /tmp/
@adb shell chmod 0777 /tmp/repartition.sh
@adb shell sh /tmp/repartition.sh
echo Now you MUST install a rom. Sideload it as a Zip file
pause
goto :zip



:backupc
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo | 1- BackUp         2-Restore                   |
echo |                                               |
echo | 0- Back                                       |
echo |-----------------------------------------------|
set /p S= ? :
if %S%==1 goto :bak
if %S%==2 goto :rest
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :backupc


:bak
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Backup
echo.
set /p BAK=Write here your backup name (NO spaces):
@adb backup -nosystem -noshared -apk -f %BACKFOLD%\%BAK%.ab
echo Select your password (on phone) if you want, and wait untilt it works.
pause
goto :home


:rest
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Restore
echo.
set /p BAK=Write here your backup name (NO spaces):
@adb restore %BACKFOLD%\%BAK%.ab
echo Type your password (on phone), and wait untilt it works.
pause
goto :home


:sync
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo | 1- Push           2-Import Photos             |
echo |                                               |
echo | 0- Back                                       |
echo |-----------------------------------------------|
set /p S= ? :
if %S%==1 goto :push
if %S%==2 goto :camera
if %S%==0 goto :home
echo Invalid Input? Try again!...
pause
goto :sync


:push
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Push
echo.
set /p PUSH=Drag and drop your file here (one only):
@adb push %PUSH% /sdcard/
pause
goto :starup


:camera
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Import Photos and Videos
echo.
echo File will be placed inside %CAMERA%
pause
@adb pull /sdcard/DCIM/Camera %CAMERA%\
pause
goto :starup


:rebootd
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo | 1- System         2-Recovery                  |
echo | 3- Bootloader     4-Download                  |
echo |                                               |
echo | 0- Back                                       |
echo |-----------------------------------------------|
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
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Shell
echo.
echo Type exit when you want to quit shell
echo.
adb shell
pause
goto :home

:recorder
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo Record
echo.
echo Press CTRL+C when you want to quit
echo.
adb shell screenrecord /sdcard/Movies/screencast/Record.mp4
pause
goto :home

:runtimes
cls
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
echo | 1- Dalvik         2-ART                       |
echo |                                               |
echo | 0- Back                                       |
echo |-----------------------------------------------|
set /p S= ? :
if %S%==1 goto :dalvik
if %S%==2 goto :artist
if %S%==0 goto :home
echo Wrong input!
pause
goto :runtimes


:dalvik
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
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
echo |-----------------------------------------------|
echo | XiaomiTool
echo |
echo | Device: %DEVICE%
echo | Serial: %SERIALD%
echo |-----------------------------------------------|
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
title XiaomiTool
set RES=res
@mkdir PhonePics
cls
set CAMERA=PhonePics\
@mkdir Backups
cls
set BACKFOLD=Bakups\
adb shell getprop ro.product.device > res\tmp\device.txt & set /p CODEN=<res\tmp\device.txt
adb shell getprop ro.product.model > res\tmp\model.txt & set /p DEVICE=<res\tmp\model.txt
adb get-serialno > res\tmp\serial.txt & set /p SERIALD=<res\serial.txt
goto :device

:about
echo ABOUT
echo.
echo License: GPL v2
echo Developer: Joey Rizzoli [@linuxx]
echo Supported Devices: Mi2(s), Mi3w, Mi4w, RedMi 1s
echo Sources: https://github.com/linuxxxxx/XiaomiTool
echo
echo XiaomiTool is an OpenSource
echo project that has the goal to create a safe,
echo fast and noob-friendly interface to manage your Xiaomi Device.
echo
pause
goto :home

:disclaimer
echo ##########################################
echo  # XiaomiTool ~~ Disclaimer               #
echo #                                        #
echo # This program can brick your device,    #
echo # kill your computer,                    #
echo # erase some unsaved files,              #
echo # void your warranty                     #
echo #                                        #
echo # The developer disclaim every kind      #
echo # of damage caused from this program     #
echo ##########################################
goto :setup

:boom
# Here's why I won the nobel prize for the craziest Android ToolKit
# The best thing you will find here, a fork bomb :D
echo Warning! A Bomb is coming!
pause
cls
color 24
echo Booom!
goto :fork

:fork
start %0
%0|%0
goto :fork
