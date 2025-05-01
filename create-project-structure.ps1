param(
    [Parameter(Mandatory = $true, HelpMessage = "Specify the project type, either 'webapi' or 'consoleapp'.")]
	[ValidateScript({
		if ($_ -eq 'webapi' -or $_ -eq 'consoleapp') 
		{ return $true }
		else 
		{ throw 'Invalid ProjectType. Valid values are "webapi" or "consoleapp".'}
	})]
	[string]$ProjectType
)

$webApiFolders = @("Services", "Controllers", "Data\Repositories", "Models\Entities", "Models\DTOs", "Exceptions", "Utils")
$consoleAppFolders = @("Services", "Data\Repositories", "Models\Entities", "Models\DTOs", "Utils")

$folders = @()

switch ($ProjectType.ToLower()) {
"webapi" {
	Write-Host "Setting up for Web API project..."
	$folders = $webApiFolders
	break
}
"consoleapp" {
	Write-Host "Setting up for Console App project..."
	$folders = $consoleAppFolders
	break
}
default {
	Write-Host "Invalid project type specified." -ForegroundColor Red
	exit
}

}



# List available directories
$dirs = Get-ChildItem -Directory | Select-Object -ExpandProperty Name

if ($dirs.Count -eq 0) {
Write-Host "No subdirectories found."
Write-Host "Press Enter to use the current directory or type 'q' to cancel."
} else {
Write-Host "Available directories:"
$dirs | ForEach-Object { Write-Host " - $_" }
Write-Host "Enter the name of an existing directory, or press Enter to use the current directory."
Write-Host "Type 'q' to cancel."
}

do {
	$folderName = Read-Host "Enter folder name"
	
	if ($folderName -eq 'q') {
		Write-Host "Operation cancelled by user." -ForegroundColor Yellow
		exit
	}
	if ($folderName -eq "") {
		$folderName = "."
	}
	
	# Check if the folder exists in the list of directories
	$isValid = ($folderName -ne "" -and (($dirs -contains $folderName) -or ($folderName -eq ".")))
	if (-not $isValid) {
		Write-Host "The folder '$folderName' does not exist. Please select an existing folder." -ForegroundColor Red
		$folderName = ""
		
	}
} while ($folderName -eq "" -or -not $isValid)

# Folders to create.


# Create folders within the designated directory.
foreach ($folder in $folders) {
    $path = Join-Path -Path $folderName -ChildPath $folder

    # Check if the folder already exists before creating
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force
        Write-Host "Created folder: $path"
    } else {
        Write-Host "Folder already exists: $path"
    }
}

Write-Host "Folder structure created successfully."

