@echo off
cls
echo Restore
echo.
echo Android 4.4.x KitKat have a bug with adb backup, if you are running it backup will fail
set /p BAK=Write here your backup name (NO spaces):
@adb restore %BACKFOLD%\%BAK%.ab
echo Type your password (on phone), and wait untilt it works.
pause
