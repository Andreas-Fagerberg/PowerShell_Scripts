param (
	[Parameter(Mandatory = $true, HelpMessage = "Specify the database type, either 'psql' or 'sql'.")]
	[ValidateScript({
		if ($_.ToLower() -eq 'psql' -or $_.ToLower() -eq 'sql') { 
			return $true }
		else {
			throw 'Invalid DatabaseType. Valid values are "psql" or "sql"'}
	})]
	[string]$DatabaseType
)

$commands = @{
	'general' = @(
		"dotnet tool install --global dotnet-ef",
		"dotnet add package Microsoft.EntityFrameworkCore.Design"
		)
	'psql' = @(
		"dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL"
		) 
 	'sql' = @(
		"dotnet add package Microsoft.EntityFrameworkCore.SqlServer"
	)
	'identityCore' = @(
		"dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore",
		"dotnet add package Microsoft.AspNetCore.Identity.UI"
	)
}

$selectedCommands = @()

Write-Host "Setting up for " + $DatabaseType.ToLower() + ". Would you like to add Identity Core? (y/n)"
Write-Host "Type 'q' to cancel."
do {
	$choice = Read-Host "Enter choice"
	$isValid = $false
	if ($choice -eq 'q') {
		Write-Host "Operation cancelled by user." -ForegroundColor Yellow
		exit
	}
	elseif ($choice.ToLower() -eq 'y') {
		$selectedCommands += $commands.general 
		$selectedCommands += $commands.($DatabaseType.ToLower()) 
		$selectedCommands += $commands.identityCore 
		$isValid = $true
	}
	elseif ($choice.ToLower() -eq 'n') {
		$selectedCommands += $commands.general 
		$selectedCommands += $commands.($DatabaseType.ToLower())
		$isValid = $true	
	}
	else {
		Write-Host "Invalid option please enter only (y/n) or 'q' to cancel."
	}
} while(-not $isValid)

$totalDuration = 0.0
foreach($command in $selectedCommands) {
    Write-Host "Executing: $command"
    
    # Measure time for each command execution
    $duration = Measure-Command {
        try {
            Invoke-Expression $command
        } catch {
            Write-Host "Error executing command $command" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
        }
    }
    $totalDuration += $duration.TotalSeconds
    Write-Host "Command executed in: $($duration.TotalSeconds) seconds" -ForegroundColor Yellow
}

Write-Host "Installation finished after: $totalDuration" -ForegroundColor Green