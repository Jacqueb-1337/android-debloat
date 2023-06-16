@echo off
call updater.bat
:start1
setlocal EnableDelayedExpansion
chcp 65001 >nul

for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)

set /a var=0
set /a var1=0

call :ColorText 0C "The program will hang until you plug in a device with adb debugging enabled"
echo.
echo.
set "tempmsg="
:askuninstall
set /p douninstall=%tempmsg%Do you want to uninstall bloatware apps? (y/n) 
IF NOT %douninstall%==y IF NOT %douninstall%==n set tempmsg=%douninstall% is not a valid response. && goto askuninstall
IF %douninstall%==n set "tempmsg=" & goto askaccessibility

for /f "eol=# Tokens=* Delims=" %%x in ('type list2.txt') do adb wait-for-device shell pm uninstall %%x >nul & if !errorlevel!==0 (call :ColorText 0a "o" & echo. Package %%x was uninstalled && set /a var=!var!+1) else (set /a var1=!var1!+1 & call :ColorText 0C "x" & echo. Package %%x doesn't exist)
echo.
echo.
echo %var% apps were uninstalled and %var1% were not uninstalled
echo.
set "tempmsg="
:askaccessibility
echo. %tempmsg% & call :ColorText 0e "Would you like to disable all Accessbility options such as TalkBack " & set /p doaccessibility=(y/n) 
IF NOT %doaccessibility%==y IF NOT %doaccessibility%==n set tempmsg=%doaccessibility% is not a valid response. && goto askaccessibility
IF %doaccessibility%==n goto next
adb wait-for-device shell settings put secure enabled_accessibility_services OTHER_ENABLED_SERVICES && IF %errorlevel%==0 call :ColorText 0a "Disabled New Accessibility Services successfully"
IF NOT %errorlevel%==0 call :ColorText 0C "New Accessibility Services could not be disabled for some reason"
echo.
adb wait-for-device shell settings put secure enabled_accessibility_services com.android.talkback/com.google.android.marvin.talkback.TalkBackService && IF %errorlevel%==0 call :ColorText 0a "Disabled Talkback successfully"
IF NOT %errorlevel%==0 call :ColorText 0C "Talkback could not be disabled for some reason"
echo.
adb wait-for-device shell settings put secure accessibility_shortcut_enabled 0 && IF %errorlevel%==0 call :ColorText 0a "Accessibility shortcut was disabled successfully"
IF NOT %errorlevel%==0 call :ColorText 0C "Accessibility shortcut could not be disabled for some reason"
echo.
adb wait-for-device shell settings put secure accessibility_shortcut_target_service null && IF %errorlevel%==0 call :ColorText 0a "Accessibility shortcut target was set to null"
IF NOT %errorlevel%==0 call :ColorText 0C "Accessibility shortcut target could not be set to null for some reason"
echo.
:next
SET mypath=%~dp0
SET "mypath=%mypath:\=\\%"
%SystemRoot%\System32\wbem\WMIC.exe Process Where "ExecutablePath Like '%mypath%adb.exe'" Call Terminate 2 >NUL
echo Press any key to exit the program & pause >nul
goto :eof
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof
exit /b