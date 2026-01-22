[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Version = "2.30.10",

    [Parameter(Mandatory = $false)]
    [string]$Destination = "third_party/SDL2"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Ensure-Dir([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

$repoRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot ".."))
$destPath = Join-Path $repoRoot $Destination
$thirdParty = Join-Path $repoRoot "third_party"

Ensure-Dir $thirdParty

# SDL2 release zip naming convention: SDL2-<version>.zip
$url = "https://github.com/libsdl-org/SDL/releases/download/release-$Version/SDL2-$Version.zip"
$tmp = Join-Path $env:TEMP ("sdl2-src-$Version-" + [System.Guid]::NewGuid().ToString("N"))
$zipPath = Join-Path $tmp "sdl2.zip"

Ensure-Dir $tmp

Write-Host "Downloading SDL2 $Version sources..." -ForegroundColor Cyan
Write-Host "  $url"
Invoke-WebRequest -Uri $url -OutFile $zipPath

Write-Host "Extracting..." -ForegroundColor Cyan
Expand-Archive -Path $zipPath -DestinationPath $tmp -Force

# The zip typically contains a single folder named SDL2-<version>
$extractedRoot = Join-Path $tmp ("SDL2-" + $Version)
if (-not (Test-Path -LiteralPath $extractedRoot)) {
    # Fallback: pick first directory
    $firstDir = Get-ChildItem -LiteralPath $tmp -Directory | Select-Object -First 1
    if ($null -eq $firstDir) {
        throw "Extraction failed: no directory found in $tmp"
    }
    $extractedRoot = $firstDir.FullName
}

if (Test-Path -LiteralPath $destPath) {
    Write-Host "Removing existing $Destination ..." -ForegroundColor Yellow
    Remove-Item -LiteralPath $destPath -Recurse -Force
}

Write-Host "Copying to $Destination ..." -ForegroundColor Cyan
Copy-Item -LiteralPath $extractedRoot -Destination $destPath -Recurse -Force

Write-Host "Done. SDL2 sources are now in $Destination" -ForegroundColor Green
Write-Host "Next: run 'cmake --preset msvc-x64' then build." -ForegroundColor Green
