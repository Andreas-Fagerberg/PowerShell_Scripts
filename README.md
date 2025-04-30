# PowerShell_scripts
Some simple PowerShell scripts to help with setting up a projects file structure.

### Set up a PowerShell profile:

#### 1. Open PowerShell and check if you have a profile set up by running and skip to step 3 if this returns true:
```
Test-Path $PROFILE
```
#### 2. Create a profile by running the following command in the PowerShell:
```
New-Item -Path $PROFILE -ItemType File -Force
```
#### 3. Edit your profile: 
```
notepad $PROFILE
```
or
```
code $PROFILE
```
#### and add the path to your scripts in the notepad document:
```
# Set this to the full path where you keep your PowerShell scripts
$scriptFolder = "C:\Path\To\Your\PowerShellScripts"
    
# Add the folder to the PATH (only if it's not already included)
if (-not ($env:Path -split ';' | Where-Object { $_ -eq $scriptFolder })) {
    $env:Path += ";$scriptFolder"
}
```

### Add scripts to your PowerShell profile:

#### 1. Edit your profile: 
```
notepad $PROFILE
```
or
```
code $PROFILE
```
#### 2. Add the script to the document:
```
# Create a function alias to run your script
function your-script-alias {
    # The param needs to mirror the content of your script param in order to function.
    param (
        [Parameter(Mandatory = $true)]
        [string]$YourParameterName
    )
    # Combine the script path and call it
    $scriptPath = Join-Path $scriptFolder "name-of-your-script.ps1"
    & $scriptPath -ProjectType $ProjectType
}
```
#### 3. Save the changes and restart PowerShell or run:
```
. $PROFILE
```


