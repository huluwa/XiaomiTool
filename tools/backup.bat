@echo off
cls
echo Backup
echo.
echo Android 4.4.x KitKat has a bug with adb backup, if you are running it backup will fail
set /p BAK=Write here your backup name (NO spaces):
@adb backup -noshared -apk -f %BACKFOLD%\%BAK%.ab
echo Select your password (on phone) if you want, and wait untilt it works.
pause
