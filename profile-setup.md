## Making Scripts Easily Accessible

#### Check if you have a profile by running the following in PowerShell:
```
Test-Path $PROFILE
```
 
#### If it returns `False`, create one with:
```
New-Item -Type File -Path $PROFILE -Force
```

#### Edit your PowerShell profile with:
```
notepad $PROFILE
```

#### To include all my scripts in the powershell profile just copy and paste the following code into the PowerShell profile document:
```
$scriptFolder = "$env:USERPROFILE\Documents\PowerShellScripts"
$env:Path += ";$scriptFolder"

function pjs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ProjectType
    )
    # Combine the script path and call it
    $scriptPath = Join-Path $scriptFolder "create-project-structure.ps1"
    & $scriptPath -ProjectType $ProjectType
}

Register-ArgumentCompleter -CommandName pjs -ParameterName ProjectType -ScriptBlock {
    'consoleapp', 'webapi' | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}


function Edit-WithNotepadPlusPlus {
    param(
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    & "C:\Program Files\Notepad++\notepad++.exe" $FilePath
}

Set-Alias -Name npp -Value Edit-WithNotepadPlusPlus


function addef {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ArgumentCompleter({ 'psql', 'sql' | ForEach-Object {
            [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        } })]
        [string]$DatabaseType
    )

    $scriptPath = Join-Path $scriptFolder "add-entity-framework.ps1"
    $parameters = @{ DatabaseType = $DatabaseType }
    Invoke-ScriptWithErrorHandling -ScriptPath $scriptPath -Parameters $parameters
}


function Invoke-ScriptWithErrorHandling {
	param (
		[Parameter(Mandatory = $true)]
		[string]$ScriptPath,
		
		[Parameter(Mandatory = $true)]
		[HashTable]$Parameters
	)
	
	try {
		# Check if the script exists (if this fails, an error is thrown)
		Require-Script $ScriptPath
		
		# Splat the parameters and invoke the script
	& $ScriptPath @Parameters 
	} catch {
		# Catch and display the error
		Write-Host "Error executing script ${$ScriptPath}: $($_.Exception.Message)" -ForegroundColor Red

	}
}


# Checks if the script exists in the designated path and throws an error if it fails to find the script.
function Require-Script {
    param (
        [Parameter(Mandatory = $true)]
        [string]$ScriptPath
    )

    if (-Not (Test-Path $ScriptPath)) {
        throw "Required script not found: $ScriptPath"
    }

    Write-Host "Found script: $ScriptPath" -ForegroundColor Green
    return $true
}
```

If you do not want all scripts included just make sure to inclue the ones referencing the correct scripts in your script folder. And some of the scripts will require the 'Require-Script' function and 'Invoke-ScriptWithErrorHandling' function in order to properly execute.
