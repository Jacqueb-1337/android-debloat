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

for /f "eol=# Tokens=* Delims=" %%x in ('type list2.txt') do adb wait-for-device & adb shell pm uninstall %%x >nul & if !errorlevel!==0 (call :ColorText 0a "o" & echo. Package %%x was uninstalled && set /a var=!var!+1) else (set /a var1=!var1!+1 & call :ColorText 0C "x" & echo. Package %%x doesn't exist)
echo.
echo.
echo %var% apps were uninstalled and %var1% were not uninstalled
echo.
echo Press any key to exit the program & pause >nul
goto :eof
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof