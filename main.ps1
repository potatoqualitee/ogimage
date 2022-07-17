param (
   [string]$TemplatePath,
   [psobject[]]$ReplaceHash,
   [string]$ReplaceHashFilePath,
   [string]$OutputPath,
   [string]$CSSPath,
   [string]$NoOptimize
)

if (-not (Test-Path -Path $OutputPath)) {
   $null = New-Item -Path $OutputPath -ItemType Directory -Force
}

$nonopt = [bool]($NoOptimize)
$template = Get-Content -Path $TemplatePath

if ($ReplaceHashFilePath) {
   $ReplaceHash = Invoke-Expression (Get-Content -Path $ReplaceHashFilePath -Raw)
}

foreach ($hash in $ReplaceHash) {
   foreach ($item in $hash) {
      $content = $template
      foreach ($key in $item.Keys) {
         if ($key -eq "FileName") {
            continue
         }
         $content = $content.Replace($key, $item[$key])
      }
      if ($item["FileName"]) {
         $basename = $item["FileName"]
      } else {
         $count++
         $basename = "image$count"
      }

      # Set all the name variables
      $ext = $TemplatePath.Split('.') | Select-Object -Last 1
      $filename = Join-Path -Path $OutputPath -ChildPath "$basename.$ext"
      $outfile = Join-Path -Path $OutputPath -ChildPath "$basename.html"
      $image = Join-Path -Path $OutputPath -ChildPath "$basename.png"
      $content | Set-Content -Path $filename

      Write-Output "Filename $filename"
      Write-Output "Outfile $outfile"
      Write-Output "Image $image"
      Write-Output "CSS Path $CSSPath"
      
      # Perform conversion
      if ($ext -eq "md") {
         $type = "markdown"
      } else {
         $type = "html"
      }
      $parm = @{
         "-f"               = $type
         "-t"               = "html"
         $filename          = $null
         "-o"               = $outfile
         "--self-contained" = $null
      }
      if ($CSSPath) {
         pandoc -f $type -t html $filename -o $outfile --self-contained --css=$CSSPath
      } else {
         pandoc -f $type -t html $filename -o $outfile --self-contained
      }
      
      npx playwright screenshot --viewport-size=1200,630 $outfile $image
      if (-not $nonopt) {
         Write-Output "Optimizing $image"
         optipng -o7 $image *> /dev/null
      }
   }
}