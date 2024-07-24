$VersionPrefix = "1.4.0"
$VersionSuffix = "rc1-00001"
$OutputDirectory = (New-Item -Path $PSScriptRoot -Name "v1.4.0" -ItemType directory) 
Copy-Item "$PSScriptRoot\Module\PowerShellLogging" -Destination $OutputDirectory -Recurse
Set-Content $OutputDirectory\PowerShellLogging.psd1 (
(Get-Content $OutputDirectory\PowerShellLogging.psd1) -replace
"(ModuleVersion\s+=\s+)'.*'", "`$1'$VersionPrefix'" -replace
"(Prerelease\s+=\s+)'.*'", "`$1'$VersionSuffix'"
)        
dotnet build -c Release -p:VersionPrefix=$VersionPrefix -p:VersionSuffix=$VersionSuffix
Get-ChildItem -Path bin\Release -Recurse -Filter "*.dll" | Move-Item -Destination $OutputDirectory
Get-ChildItem -Path $OutputDirectory -Recurse | Compress-Archive -DestinationPath $OutputDirectory\v1.4.0.zip
& gh release create v1.4.0 $OutputDirectory\v1.4.0.zip

