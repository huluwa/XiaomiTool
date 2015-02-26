@echo off

cls
echo Install recovery
echo.
goto :recovery

:recovery
echo Select your device
echo 1- Xiaomi Mi2(s)
echo 2- Xiaomi Mi2 A
echo 3- Xiaomi Mi3w
echo 4- Xiaomi Mi4w
echo 5- Xiaomi RedMi 1S
set /p S= ? :
if %S%==1 set file=devices\aries\recovery.img & goto :flash
if %S%==2 set file=devices\taurus\recovery.img && goto :flash
if %S%==3 set file=devices\cancro\recovery.img & goto :flash
if %S%==4 set file=devices\cancro\recovery.img & goto :flash
if %S%==5 set file=devices\armani\recovery.img & goto :flash
echo Wrong input!
pause
goto :recovery

:flash
echo Flashing...
@adb reboot bootloader
@fastboot flash recovery %file%
echo Done!
pause
