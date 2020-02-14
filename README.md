# ZoomShellSwitch
<p>In Zoom Rooms, there are sometimes when you need to access the desktop of the ZoomUser. This script will switch it back and forth between the Zoom Shell and explorer.exe</p>
<p>Typically this is used when the resolution of a Zoom room is not correct. On most Windows PC, when running a 4K monitor the scaling is 300%, this can cause some issues with the display. You will want to set the scaling to 100% to resolve it. Since scaling is per user, you need to be able to access the desktop of the Zoom User.</p>
<p>You will need to enable running scripts on the system.<br />
Open PowerShell with elevated permmisions and run 
  <code>Set-ExecutionPolicy -ExecutionPolicy Unrestricted</code>
