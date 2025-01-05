<#
    Copy and paste everything here to the very beginning of your script
    If you pass parameters, you will have to modify the $newProcess.Arguments line
#>

<# ************************************************************************ #>
<# ********************** BEGIN RUN AS ADMIN SECTION ********************** #>
<# ************************************************************************ #>

#   Copyright (c) 2025 Brett A. Farnam (brett_farnam@yahoo.com)
#   Released under the MIT license

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent();
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID);

# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator;

# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
{
    # We are running 'as Administrator' - so change the title and background color to indicate this
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " ( Elevated )";
    $Host.UI.RawUI.BackgroundColor = "DarkRed"; $Host.UI.RawUI.ForegroundColor = "DarkYellow"; 
    Clear-Host;
}
else
{
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + " ( User )";
    Clear-Host;
    
    # We are not running "as Administrator" - so relaunch as administrator IF requested
    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo("PowerShell.exe");
    
    # Specify the current script path and name as a parameter 
    # Add -NoExit to prevent the screen from closing for troubleshooting
    # -WindowStyle Maximized makes sure that this window covers everything
    # -ExecutionPolicy Bypass is "just in case"
    # We surround the $MyInvocation in 'single qoutes' in case of spaces in long pathnames
    $newProcess.Arguments = "-WindowStyle Maximized -ExecutionPolicy Bypass & '" + $myInvocation.MyCommand.Definition +"' ";
    
    # Indicate that the process should be elevated
    $newProcess.Verb = "RunAs";
    
    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);
    
    # Exit from the current, unelevated, process
    exit;
}

<# ************************************************************************ #>
<# *********************** END RUN AS ADMIN SECTION *********************** #>
<# ************************************************************************ #>
