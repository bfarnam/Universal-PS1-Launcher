param(
[Parameter(Mandatory=$false)]
[ValidateSet("User","Admin")]
[string[]]$RunAs = "User"
);

# Do not modify the sections here - your code goes down at the bottom
[bool]$bRunAsAdmin = $false;
if ($RunAs -eq "Admin") { $bRunAsAdmin = $true; }

$strScriptName = $PSCommandPath;
$strScriptPath = $PSScriptRoot;
$logfile = $strScriptName.Replace('.ps1','.log');
$strVer = "v2.3";
$strVerDate = "2025 January 5";
$strAuthor = "Brett A. Farnam (brett_farnam@yahoo.com)";
$strCopyNotice = "Copyright (c) 2025 "+$strAuthor;

<# ************************************************************************ #>
<# ********************** BEGIN RUN AS ADMIN SECTION ********************** #>
<# ************************************************************************ #>

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
        # We surround the $MyInvocation in 'single qoutes' in case of spaces in long pathnames
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

<#
This is an example of a script which loops through scriptblocks and gives a progress bar.
#>

# Define the message to be displayed on the progress bar
$message = 'Running scripts. Do not close this window.';

# Define the actions to perform as script blocks
$scripts = @(
    {
        $output = "**********************************************************************";
        $output += "`n"+(Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" BEGIN "+$strScriptName;
        $output += "`n**********************************************************************";
        $output += "`nRunning as $env:UserName in $env:UserProfile from "+$strScriptPath;
        $output += "`nRequested to RunAs : "+$RunAs;
        Write-Output $output;
        Start-Sleep -Seconds 1;
    };
    {
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
        $output = "`n**********************************************************************";
        $output += "`n"+(Get-Date -Format "yyyy-MM-dd HH:mm:ss")+" END "+$strScriptName;
        $output += "`nVersion "+$strVer+"    "+$strVerDate+"    "+$strAuthor;
        Write-Output $output;
        Write-Output $strCopyNotice;
        $output = "**********************************************************************";
        $output += "`n`n";
        Write-Output $output;
        Start-Sleep -Seconds 1;
    };
);

# Construct the percentage bar and dispaly the message and progress bar while executing the script blocks
& {
    [float] $complete = 0;
    [float] $increment = 100 / $scripts.Count;
    foreach( $script in $scripts ) {
        Write-Progress -Activity $message -PercentComplete $complete;
        & $script;
        $complete += $increment;
    };
} *>&1 >> $logfile;
