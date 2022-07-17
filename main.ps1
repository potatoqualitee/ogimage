param (
   [string]$TemplatePath,
   [psobject[]]$ReplaceHash,
   [string]$ReplaceHashFilePath,
   [string]$OutputPath
)

if (-not (Test-Path -Path $OutputPath)) {
   $null = New-Item -Path $OutputPath -ItemType Directory -Force
}

Write-Output "This and that"
$ReplaceHash | Get-Member