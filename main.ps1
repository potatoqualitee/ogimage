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

Write-Output $CSSPath

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
      $filename = Join-Path -Path $OutputPath -ChildPath $basename
      $outfile = Join-Path -Path $OutputPath -ChildPath $basename.html
      $image = Join-Path -Path $OutputPath -ChildPath $basename.png
      $content | Set-Content -Path $filename

      Write-Output $filename
      Write-Output $outfile
      Write-Output $image
      Write-Output $content
      # Perform conversion
      pandoc -f markdown -t html $filename -o $outfile --self-contained --css=$CSSPath
      #npx playwright screenshot --viewport-size=1200,630 $outfile $image
      if (-not $nonopt) {
         Write-Output "Optimizign $image"
         #optipng -o7 $image *> /dev/null
      }
      <#
            $content | Set-Content -Path /tmp/thumbs/$name.md
            pandoc -f markdown -t html /tmp/thumbs/$name.md -o /tmp/thumbs/$name.html --self-contained --css=gh-pandoc.css
            npx playwright screenshot --viewport-size=1200,630 /tmp/thumbs/$name.html /tmp/thumbs/$name.png
            #optipng -o7 /tmp/thumbs/$name.png | Out-Null
      #>
   }
}