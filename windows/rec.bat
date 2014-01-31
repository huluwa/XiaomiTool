@echo off
cls
@adb reboot bootloader
@fastboot flash recovery C:\ariesTool\recovery\recovery.img
@fastboot reboot
