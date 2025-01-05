This command file which can be run from either the command line or simply by double clicking on it will search the current directory for a file with the same name ending in .ps1 and then run the powershell script.

This will work even if the execution policy for scripts is enabled.  The command file first disables the policy, runs the script, then re-enables the policy.  This way if there are other scripts chained they will also run.

I have two sample scripts so that you can run the code as admin:

By adding the code in the sample script to your script, you can pass the -RunAs Admin command to the command file to elevate the script to the Administrator level.  If UAC is on, you will be prompted for Administrator credentials.

