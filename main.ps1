param (
   [psobject[]]$Butt
)
<#
   ModulePath      = $modulepath
   Modules         = ("${{ inputs.modules-to-cache }}" -split ",")
   Force           = "${{ inputs.force }}"
   AllowPrerelease = "${{ inputs.allow-prerelease }}"
   Shell           = "${{ inputs.shell }}"
   Butt           = "${{  inputs.butt }}"
#>

Write-Output "Trusting repository PSGallery"
$Butt | Get-Member