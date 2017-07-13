
$urlCurrent = "https://dotnetcli.azureedge.net/dotnet/Sdk/2.0.0-preview2-006497/dotnet-sdk-2.0.0-preview2-006497-win-x64.zip"
$env:DOTNET_INSTALL_DIR = "$pwd\.dotnetsdk"
mkdir $env:DOTNET_INSTALL_DIR -Force | Out-Null
$tempFileCurrent = [System.IO.Path]::GetTempFileName()
(New-Object System.Net.WebClient).DownloadFile($urlCurrent, $tempFileCurrent)
Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory($tempFileCurrent, $env:DOTNET_INSTALL_DIR)
$env:Path = "$env:DOTNET_INSTALL_DIR;$env:Path"

dotnet --info
dotnet restore
dotnet build

$revision = @{ $true = $env:APPVEYOR_BUILD_NUMBER; $false = 1 }[$env:APPVEYOR_BUILD_NUMBER -ne $NULL];
$revision = [convert]::ToInt32($revision, 10)

dotnet pack -c Release -o .\..\..\artifacts --version-suffix=alpha-$revision