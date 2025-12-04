@ECHO OFF & COLOR
setlocal enableDelayedExpansion
REM These next three lines set the old color scheme in effect
FOR /%_s%F %%A IN ('ECHO prompt $E^| cmd') DO SET "ESC=%%A"
SET "_f=%ESC%[38;2;238;237;240m"
SET "_b=%ESC%[48;2;1;36;86m"
SET "_h=%ESC%[93m"
echo %_f%%_b%

set _version=v2.5 2025 December 04 Maintenance Release
set _copynotice=Copyright (c) 2025 Brett A. Farnam (brett_farnam@yahoo.com)
set _git=Git/GitHub https://github.com/bfarnam/Universal-PS1-Launcher.git

REM     Copyright (c) 2025 Brett A. Farnam (brett_farnam@yahoo.com)
REM     Released under the MIT license
REM     Git/GitHub https://github.com/bfarnam/Universal-PS1-Launcher.git

ECHO:
ECHO  ____ ____ ____ ____ ____ ____ ____ ____ ____
ECHO ^|^|%_h%U%_f% ^|^|^|%_h%n%_f% ^|^|^|%_h%i%_f% ^|^|^|%_h%v%_f% ^|^|^|%_h%e%_f% ^|^|^|%_h%r%_f% ^|^|^|%_h%s%_f% ^|^|^|%_h%a%_f% ^|^|^|%_h%l%_f% ^|^|
ECHO ^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|
ECHO ^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|
ECHO  ____ ____ ____ ____
ECHO ^|^|%_h%.%_f% ^|^|^|%_h%P%_f% ^|^|^|%_h%S%_f% ^|^|^|%_h%1%_f% ^|^|
ECHO ^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|
ECHO ^|/__\^|/__\^|/__\^|/__\^|
ECHO  ____ ____ ____ ____ ____ ____ ____ ____
ECHO ^|^|%_h%L%_f% ^|^|^|%_h%a%_f% ^|^|^|%_h%u%_f% ^|^|^|%_h%n%_f% ^|^|^|%_h%c%_f% ^|^|^|%_h%h%_f% ^|^|^|%_h%e%_f% ^|^|^|%_h%r%_f% ^|^|
ECHO ^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|
ECHO ^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|
ECHO:
ECHO %_version%
ECHO:
ECHO %_copynotice%
ECHO:
ECHO %_git%
ECHO:
ECHO Sets the PowerShell execution policy to allow the running of .PS1 files
ECHO and resets the policy when done!
ECHO:
ECHO Ready to load %~dp0%~n0.ps1 %*
pause
ECHO:

IF exist "%~dp0%~n0.ps1" (
ECHO Setting Execution Policy to BYPASS...
powershell.exe set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
ECHO:
ECHO Starting %~dp0%~n0.ps1 %*
pushd %~dp0
powershell.exe -WindowStyle Maximized -File "%~dp0%~n0.ps1" %*
REM Capture exit code
set "EXIT_CODE=!ERRORLEVEL!"
pushd %~dp0

ECHO:
ECHO Resetting Execution Policy to DEFAULT...
powershell.exe set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Default -Force
) ELSE (
ECHO Cannot start %~dp0%~n0.ps1 %*
ECHO:
ECHO Error: FILE %~dp0%~n0.ps1 DOES NOT EXIST
ECHO:
pause
)

ECHO:
pushd %~dp0
TYPE "%~dp0USAGE.TXT"
popd
ECHO:
ECHO %_version%
ECHO:
ECHO %_copynotice%
ECHO:
ECHO %_git%
ECHO:
ECHO See %~dp0LICENSE.TXT for the license.
ECHO:
ECHO:
ECHO Press ^<ANY^> key to end!
pause
exit /b !EXIT_CODE!
