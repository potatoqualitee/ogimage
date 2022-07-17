param (
   [string]$TemplatePath,
   [psobject[]]$ReplaceHash,
   [string]$OutputPath
)
<#
   TemplatePath  = ${{  inputs.template-path }}
   ReplaceHash   = ${{  inputs.replace-hash }}
   OutputPath    = "${{ inputs.output-path }}"
#>

if (-not (Test-Path -Path $OutputPath)) {
   $null = New-Item -Path $OutputPath -ItemType Directory -Force
}


Write-Output "This and that"
$ReplaceHash | Get-Member