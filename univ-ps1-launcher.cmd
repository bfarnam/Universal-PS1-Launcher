@ECHO OFF & COLOR 4F 
setlocal enableDelayedExpansion
set _version=v2.3 2025 January 5 General Release
set _copynotice=Copyright (c) 2025 Brett A. Farnam (brett_farnam@yahoo.com)

REM     Copyright (c) 2025 Brett A. Farnam (brett_farnam@yahoo.com)
REM     Released under the MIT license

ECHO
ECHO  ____ ____ ____ ____ ____ ____ ____ ____ ____ 
ECHO ^|^|U ^|^|^|n ^|^|^|i ^|^|^|v ^|^|^|e ^|^|^|r ^|^|^|s ^|^|^|a ^|^|^|l ^|^|
ECHO ^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|
ECHO ^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|
ECHO  ____ ____ ____ ____                          
ECHO ^|^|. ^|^|^|P ^|^|^|S ^|^|^|1 ^|^|                         
ECHO ^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|                         
ECHO ^|/__\^|/__\^|/__\^|/__\^|                         
ECHO  ____ ____ ____ ____ ____ ____ ____ ____      
ECHO ^|^|L ^|^|^|a ^|^|^|u ^|^|^|n ^|^|^|c ^|^|^|h ^|^|^|e ^|^|^|r ^|^|     
ECHO ^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|^|__^|^|     
ECHO ^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|/__\^|     
ECHO.
ECHO %_version%
ECHO.
ECHO %_copynotice%
ECHO.
ECHO Sets the PowerShell execution policy to allow the running of .PS1 files
ECHO and resets the policy when done!
ECHO.

IF exist "%~dp0%~n0.ps1" (
ECHO Setting Execution Policy to BYPASS...
powershell.exe set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass -Force
ECHO.
ECHO Starting %~dp0%~n0.ps1 %*
pushd %~dp0
powershell.exe -WindowStyle Maximized -File "%~dp0%~n0.ps1" %*
pushd %~dp0

ECHO.
ECHO Resetting Execution Policy to DEFAULT...
powershell.exe set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Default -Force
) ELSE (
ECHO Cannot start %~dp0%~n0.ps1 %*
ECHO.
ECHO FILE %~dp0%~n0.ps1 DOES NOT ESIST
ECHO.
pause
)

ECHO.
pushd %~dp0
TYPE "%~dp0USAGE.TXT"
popd
ECHO.
ECHO %_version%
ECHO.
ECHO %_copynotice%
ECHO.
ECHO See %~dp0LICENSE.TXT for the license.
ECHO.
ECHO.
ECHO Press ^<ANY^> key to end!
pause
