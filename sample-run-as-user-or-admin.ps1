param(
[Parameter(Mandatory=$false)]
[ValidateSet("User","Admin")]
[string[]]$RunAs = "User"
);

<#
    Copy the contents of this file to the very beginning of your scripts.
    You can:
        1.  Use this as a "template" and use the script blocks for your code
        - OR -
        2.  Replace the code block (BEGIN CODE to END CODE) with your code.
    
    NOTE:
    If you pass parameters, you will have to modify the $newProcess.Arguments
    line.
#>

# Do not modify the sections here - your code goes down at the bottom
[bool]$bRunAsAdmin = $false;
if ($RunAs -eq "Admin") { $bRunAsAdmin = $true; };

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
    if ($bRunAsAdmin) {
        # Create a new process object that starts PowerShell
        $newProcess = new-object System.Diagnostics.ProcessStartInfo("PowerShell.exe");
        
        # Specify the current script path and name as a parameter 
        # Add -NoExit to prevent the screen from closing for troubleshooting
        # -WindowStyle Maximized makes sure that this window covers everything
        # -ExecutionPolicy Bypass is "just in case"
        # We surround $MyInvocation.MyCommand.Definition in 'single quotes' in case of spaces in long path names
        $newProcess.Arguments = "-WindowStyle Maximized -ExecutionPolicy Bypass & '" + $myInvocation.MyCommand.Definition +"' -RunAs $RunAs";
        
        # Indicate that the process should be elevated
        $newProcess.Verb = "RunAs";
        
        # Start the new process
        [System.Diagnostics.Process]::Start($newProcess);
    
        # Exit from the current, unelevated, process
        exit;
    };
}

<# ************************************************************************ #>
<# *********************** END RUN AS ADMIN SECTION *********************** #>
<# ************************************************************************ #>

<# ****************************** BEGIN CODE ****************************** #>
<#
    This is an example of a script which loops through script blocks and gives
    a progress bar.
    Your code would replace this code.
#>

# Define the variables used
$strScriptName = $PSCommandPath;
$strScriptPath = $PSScriptRoot;
$logfile = $strScriptName.Replace('.ps1','.log');
$strVer = "v2.3";
$strVerDate = "2025 January 5";
$strAuthor = "Brett A. Farnam (brett_farnam@yahoo.com)";
$strCopyNotice = "Copyright (c) 2025 "+$strAuthor;

# Define the message to be displayed on the progress bar
$message = 'Running scripts. Do not close this window.';

# Define the actions to perform as script blocks
$scripts = @(
    {
        # Add an entry to a log file to show the BEGIN of the script
        $output = "**********************************************************************";
        $output += "`n"+(Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" BEGIN "+$strScriptName;
        $output += "`n**********************************************************************";
        $output += "`nRunning as $env:UserName in $env:UserProfile from "+$strScriptPath;
        $output += "`nRequested to RunAs : "+$RunAs;
        Write-Output $output;
        Start-Sleep -Seconds 1;
    };
    {
        # Add an entry to a log file to show the information about the script and system environment
        Write-Output $strCopyNotice;
        $output = "Version "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
        $output += "`n**********************************************************************";
        Write-Output $output;
        $output = "Running on "+$Env:UserDomain+" as "+$Env:UserName+" with PID: "+$PID;
        $output += "`nRunning from "+$Host.Name+" using "+$ShellID+" with PowerShell Version Info:";
        Write-Output $output;
        $output = ( ForEach-Object { ($PSVersionTable|Out-String -Stream) -replace "^","`t" } ).TrimEnd();
        if ($IsCodeCLR) { $output += "Running on the .NET Core Runtime (CoreCLR)"; };
        if ($IsLinux) { $output += "Running in the Linux Operating System"; };
        if ($IsMacOS) { $output += "Running in the MacOS Operating System"; };
        if ($IsWindows) { $output += "Running in the Windows Operating System"; };
        $output += "`n**********************************************************************";
        Write-Output $output;
        Start-Sleep -Seconds 1;
    };
    {
        # SOME CODE HERE
        Start-Sleep -Seconds 1;
    };
    {
        # SOME MORE CODE HERE
        Start-Sleep -Seconds 1;
    };
    {
        # Add an entry to a log file to show the END of the script
        $output = "`n**********************************************************************";
        $output += "`n"+(Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" END "+$strScriptName;
        $output += "`nVersion "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
        Write-Output $output;
        Write-Output $strCopyNotice;
        $output = "**********************************************************************";
        # We add a couple of new lines at the very end to make it easier to find the BEGIN tag
        # when there are multiple runs.
        $output += "`n`n";
        Write-Output $output;
        Start-Sleep -Seconds 1;
    };
);

# Construct the percentage bar and displays the message and progress bar while executing the script blocks
& {
    [float] $complete = 0;
    [float] $increment = 100 / $scripts.Count;
    foreach( $script in $scripts ) {
        Write-Progress -Activity $message -PercentComplete $complete;
        & $script;
        $complete += $increment;
    };
} *>&1 >> $logfile;

<#
    NOTES
        & { my code } 
        purpose: executes all code within the code block
        
        & { my code } *>&1 >> $logfile;
        purpose: executes all code with in the code block and redirects output
        to the $logfile variable (Which is defined as the script name but ends in .log)
        
        *   : This is a wildcard character that matches all streams.
        
        >&1 : Redirects all streams (including standard output, error output,
            and warning output) to the standard output stream (stream 1).
            
        >>  : Appends the output to an existing file, rather than overwriting it.
              (This will create a file if it does not exist)
#>
<# ******************************* END CODE ******************************* #>
