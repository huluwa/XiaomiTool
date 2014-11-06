@echo off
erase tmp
mkdir tmp
echo Getting info...
@adb shell getprop ro.product.brand > tmp\brand
set brand =< rmp\brand
@adb shell getprop ro.product.device > tmp\device
set device =< tmp\device
@adb shell getprop ro.board.platform > tmp\platform
set platform =< tmp\platform
@adb shell getprop ro.build.version.release > tmp\release
set release =< tmp\release
@adb shell getprop ro.build.display.id > tmp\build
set build =< tmp\build
@adb shell uname -r > tmp\kernel
set kernel =< tmp\kernel
@adb shell getprop ro.product.device > tmp\device
set device =< tmp\device
@adb shell getprop ro.product.model > tmp\model
set model =< tmp\model
cls
echo Device info
echo.
echo Device: %model%
echo OEM: %brand%
echo Name: %device%
echo SOC: %platform%
echo Android: %release%
echo Build: %build%
echo Kernel: Linux %kernel%
echo.
echo.
pause
