param (
    [string]$DbServer,
    [string]$DbName,
    [string]$BackupPath,
    [string]$BackupName,
    [string]$Version,
    [string]$NugetSourceUrl,
    [string]$NugetApiKey,
    [string]$Authors
)

$fullPath = (Get-Item -Path $BackupPath).FullName # Use absolute path
$backupPathAndName = Join-Path -Path $fullPath -ChildPath $BackupName

Backup-SqlDatabase -ServerInstance $DbServer -Database $DbName -BackupFile $backupPathAndName -Initialize
Write-Host("Created Backup - " + $BackupName)

$packageManifest = @"
<?xml version="1.0" encoding="utf-8"?>
<package>
<metadata>
    <id>$BackupName</id>
    <version>$Version</version>
    <description>Encapsulates a single backup file called $BackupName</description>
    <authors>$Authors</authors>
</metadata>
<files>
    <file src="$backupPathAndName"/>
</files>
</package>
"@

$targetNugetExe = "$PSScriptRoot\.nuget\nuget.exe"
$sourceNugetExe = "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe"

if(![System.IO.File]::Exists($targetNugetExe)) {
    Write-Host "Downloading nuget.exe"
    New-Item -ItemType Directory -Path "$PSScriptRoot\.nuget"
    Invoke-WebRequest $sourceNugetExe -OutFile $targetNugetExe
}

Out-File -FilePath ".\$BackupName.nuspec" -InputObject $packageManifest
& $targetNugetExe pack -NonInteractive ".\$BackupName.nuspec"

if ($false -eq $?) {
    Remove-Item -Path ".\$BackupName.nuspec"
    throw "Nuget pack error."
}
Remove-Item -Path ".\$BackupName.nuspec"

$backupFileName = "$BackupName.$Version.nupkg"

& $targetNugetExe push ".\$backupFileName" -ApiKey $NugetApiKey -Source $NugetSourceUrl -NonInteractive
    
if ($false -eq $?) {
    Remove-Item -Path ".\$backupFileName"
    throw "Nuget push error."
}
Remove-Item -Path ".\$backupFileName"