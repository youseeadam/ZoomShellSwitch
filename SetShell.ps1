
<##########################
.SYNOPSIS This script will change the shell of a user from invalid.exe to explorer.exe and swap back
.DESCRIPTION This tool should only be used for a Logitech imaged Zoom room. Running this script on a different system could have an undesriable outcome.
    1. Log off the Zoom user account
    2. Logon with the ZoomAdmin account
    3. Run this Script
    4. Log Off the ZoomAdmin account
    5. Logon with the Zoom account
    6. Once Zoom Rooms start click on the Option button and then exit
    7. Make any changes you desire
    8. Log off the Zoom user account
    9. Log back on as the ZoomAdmin
    10. Run the script again
    11. Log off the ZoomAdmin
    12. Log back on as Zoom account    
    You will need to enable running scripts on the system.
    Open PowerShell with elevated permmisions and run Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    Alternatly you can run this command from an elevated command prompt: PowerShell.exe -executionPolicy ByPass -File SetShell.ps1 -ZoomUser Zoom
.Parameter ZoomUser: The username of the account to be changed. It should be simply Zoom. Or in the case of a domain account domainname\username
.EXAMPLE
    SetShell.ps1 -ZoomUser Zoom
##########################>

Param (
    [Parameter (Mandatory = $True,
        ValueFromPipeline = $False,
        Position = 0)]
    [String[]]
    $ZoomUser
)
function Get-SID($AccountName) {
    $NTUserObject = New-Object System.Security.Principal.NTAccount($AccountName)
    $NTUserSID = $NTUserObject.Translate([System.Security.Principal.SecurityIdentifier])
    return $NTUserSID.Value
}

$ZoomUser = Get-Sid $ZoomUser
$regkey = 'HKLM:\SOFTWARE\Microsoft\Windows Embedded\Shell Launcher\' + $ZoomUser

#Get the registry Key for the user
try {$currentShell = Get-ItemPropertyValue $regkey -Name "Shell" -ErrorAction Stop}
catch {
    write-host "Error finding current shell"
    Exit
}

If ($CurrentShell) {

    
    #Switch The Shell
    Switch ($CurrentShell) {

        "Explorer.exe" {
            try { 
            $ZoomShell = Get-ItemPropertyValue $regkey -Name "Shell.Zoom" -ErrorAction Stop
            Set-ItemProperty $regkey -Name "Shell" -Value $ZoomShell -ErrorAction Stop
            Write-Output "Shell Set to $ZoomShell"}
            catch { 
                #Set a Shell regardless
                New-ItemProperty -Path $regkey -Name "Shell" -PropertyType String -Value $currentShell -ErrorAction Stop -Force
                Write-Output "Old Zoom Shell not found, setting to $currentShell"
                Write-Output "Please Check Registry Key $regkey" }
        }
        default {
            try {
                    Rename-ItemProperty -Path $regkey -Name "Shell" -NewName "Shell.Zoom" -ErrorAction Stop -Force
                    New-ItemProperty -Path $regkey -Name "Shell" -PropertyType String -Value "Explorer.exe" -ErrorAction Stop -Force
                    Write-Output "Shell Set to Explorer"
                }
                catch { 
                    Write-Output "Error setting Shell to explorer.exe"
                    Write-Output "Plese Check Registry Key $regkey"
                }
        }
    }
}

