# Universal PS1 Launcher

A simple utility to make running powershell scripts as easy as a double click even if running powershell scripts is disabled.

## Usage
Name the launcher the same name as your powershell script .PS1 file.

**EXAMPLE:** To run MyFile.ps1 copy UniversalPS1Launcher.cmd to MyFile.cmd

To run your script, simply double click the .cmd file from File Explorer, or run from a command line, powershell window, or terminal window.

**EXAMPLE:** `C:\users\public> MyFile.cmd`

**NOTE:** Any command line variables will be passed to the script.

## Run As Administrator
### From within File Explorer
By right clicking on the universal launcer, and selecting Run as Administrator, your script will run with elevetated permissions. If UAC is turned on, you will be prompted to continue.  If you do not posses Administrator rights, you will be prompted for credentials.

### Always run the script As Admin
To always run a script with Administrative Privileges, copy the contents of the sample-run-as-admin.ps1 to the beginning of your .ps1 file. If UAC is turned on, you will be prompted to continue.  If you do not posses Administrator rights, you will be prompted for credentials.

**EXAMPLE:** `C:\users\public> MyFile.cmd`

### To selectively run As User or As Admin
To run a script with User or Administrative Privileges, copy the contents of the sample-run-as-user-or-admin.ps1 to the beginning of your .ps1 file. Then specify "-RunAs Admin" when running the .cmd file to run with
Administrative privileges. If UAC is turned on, you will be prompted to continue.  If you do not posses Administrator rights, you will be prompted for credentials.

**EXAMPLE:** `C:\users\public> MyFile.cmd -RunAs Admin`

## More Sample Code
The sample-run-as-user-or-admin.ps1 has additional sample code to allow you to display a progress bar while performing actions.


