@echo off
setlocal
@echo off

set ServiceName="TestRunner (managed by AlwaysUpService)"
echo Starting > C:\AlwaysUpRunner.log
start /b powershell Get-Content c:\AlwaysUpRunner.log -Wait -Tail 30
REM ping -n 4 localhost > nul

REM c:\AlwaysUpCLT\UninstallService.exe %ServiceName%
REM c:\AlwaysUpCLT\InstallService.exe "TestRunner" -m -l ".\TestUser" -p "TestPassword1!" -2 "Netman" -of "c:\AlwaysUpRunner.log" %*
c:\AlwaysUpCLT\InstallService.exe "TestRunner" -m -l ".\TestUser" -2 "Netman" -of "c:\AlwaysUpRunner.log" %*
sc start %ServiceName%

REM for /f "TOKENS=1" %%a in ('wmic PROCESS where "Name='TestRunner.exe'" get ProcessID ^| findstr [0-9]') do set MyPID=%%a
REM echo %MyPID%

:waitloop
sc query %ServiceName% | findstr "STOPPED"
IF %ERRORLEVEL% equ 0 GOTO waitloopend
ping -n 4 localhost > nul
goto waitloop
:waitloopend

REM powershell Get-EventLog application -newest 5
REM sc query %ServiceName%

REM after the service stops, kill the background job tailing the AlwaysUpRunner.log file so the container can exit
taskkill /im powershell.exe /f