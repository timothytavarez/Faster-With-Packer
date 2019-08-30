$isoFolder = "answer-iso"
if (test-path $isoFolder){
  remove-item $isoFolder -Force -Recurse
}

if (test-path windows\server-2016\answer.iso){
  remove-item windows\server-2016\answer.iso -Force
}

New-Item -ItemType Directory -Name $isoFolder

Copy-Item -Path .\windows\server-2016\Autounattend.xml -Destination $isoFolder\
Copy-Item -Path .\windows\server-2016\sysprep-unattend.xml -Destination $isoFolder\

$textFile = "$isoFolder\Autounattend.xml"

$c = Get-Content -Encoding UTF8 $textFile

# Enable UEFI and disable Non EUFI
#$c | % { $_ -replace '<!-- Start Non UEFI -->','<!-- Start Non UEFI' } | % { $_ -replace '<!-- Finish Non UEFI -->','Finish Non UEFI -->' } | % { $_ -replace '<!-- Start UEFI compatible','<!-- Start UEFI compatible -->' } | % { $_ -replace 'Finish UEFI compatible -->','<!-- Finish UEFI compatible -->' } | sc -Path $textFile

& .\mkisofs.exe -r -iso-level 4 -UDF -o windows\server-2016\answer.iso $isoFolder

if (test-path $isoFolder){
  remove-item $isoFolder -Force -Recurse
}

.\packer.exe build .\templates\server-2016-hyperviso-packer.json