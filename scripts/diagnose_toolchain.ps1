[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

Write-Host "== Toolchain diagnostics (SopraCube2) ==" -ForegroundColor Cyan
Write-Host "PWD: $PWD"

Write-Host "`n-- CMake --" -ForegroundColor Cyan
Get-Command cmake -ErrorAction SilentlyContinue | Format-List

Write-Host "`n-- Env vars that influence CMake/VS generator --" -ForegroundColor Cyan
"CMAKE_GENERATOR_INSTANCE","VSINSTALLDIR","VSCMD_VER","VisualStudioVersion" | ForEach-Object {
  $name = $_
  $value = $null
  $item = Get-Item -Path "Env:$name" -ErrorAction SilentlyContinue
  if ($null -ne $item) {
    $value = $item | Select-Object -ExpandProperty Value -ErrorAction SilentlyContinue
  }
  if ($null -ne $value -and $value -ne "") {
    Write-Host ("{0}={1}" -f $name, $value)
  } else {
    Write-Host ("{0} is not set" -f $name)
  }
}

Write-Host "`n-- Visual Studio instances (vswhere) --" -ForegroundColor Cyan
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (Test-Path -LiteralPath $vswhere) {
  Write-Host "All instances:" -ForegroundColor Gray
  & $vswhere -products * -format json

  Write-Host "`nInstances with MSVC C++ tools (VC.Tools.x86.x64):" -ForegroundColor Gray
  $msvcInstances = & $vswhere -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
  if ($null -ne $msvcInstances -and ($msvcInstances | Measure-Object).Count -gt 0) {
    $msvcInstances
  } else {
    Write-Host "No Visual Studio installation with MSVC C++ tools was found." -ForegroundColor Yellow
    Write-Host "Install Visual Studio 2022 (Community) or Build Tools 2022 with: 'Desktop development with C++'" -ForegroundColor Yellow
  }
} else {
  Write-Host "vswhere.exe not found at: $vswhere" -ForegroundColor Yellow
}

Write-Host "`n-- MSVC tools on PATH --" -ForegroundColor Cyan
Get-Command cl.exe -ErrorAction SilentlyContinue | Format-List
Get-Command msbuild.exe -ErrorAction SilentlyContinue | Format-List
