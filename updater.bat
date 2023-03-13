
echo Checking for package list updates...
curl --silent https://drive.google.com/u/0/uc?id=1cH3-sJzDHpAgZfRCOBI7X8LseXorOQGa^&export=download -L --ssl-no-revoke | for /f "tokens=3" %%a in ('find "List version: "') do @echo %%a>latestver.txt
if NOT %errorlevel%==0 echo. & echo Couldn't check for updates for some reason. Continuing in 20 seconds, or press any key to do it now... & timeout 20 >nul & goto next
cls
echo.
set /p latestver=<latestver.txt
del /f latestver.txt
set /a latestver=%latestver%
if NOT exist list2.txt goto doupdateyn
type list2.txt | for /f "tokens=3" %%a in ('find "List version: "') do @echo %%a>thisver.txt
set /p thisver=<thisver.txt
del /f thisver.txt
set /a thisver=%thisver%
:doupdateyn
if NOT exist list2.txt set /a thisver=0
echo Latest list version: %latestver%
echo Installed list version: %thisver%
echo.
set /a tempvar=%latestver%-%thisver%
if NOT %tempvar%==0 set /p doupdate=There is an update available for the package list, would you like to download it? (y/n) 
if %tempvar%==0 echo There isn't an update available for the package list, moving on. & goto next
if NOT %doupdate%==y if NOT %doupdate%==n cls & echo THAT ISN'T A VALID RESPONSE. PLEASE ENTER 'y' OR 'n'. & goto doupdateyn
if %doupdate%==n goto next
curl https://drive.google.com/u/0/uc?id=1cH3-sJzDHpAgZfRCOBI7X8LseXorOQGa^&export=download -L --ssl-no-revoke -o list2.txt
:next
