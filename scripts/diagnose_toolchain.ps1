[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Continue"

Write-Host "== Toolchain diagnostics (SopraCube2) ==" -ForegroundColor Cyan
Write-Host "PWD: $PWD"

Write-Host "\n-- CMake --" -ForegroundColor Cyan
Get-Command cmake -ErrorAction SilentlyContinue | Format-List

Write-Host "\n-- Env vars that influence CMake/VS generator --" -ForegroundColor Cyan
"CMAKE_GENERATOR_INSTANCE","VSINSTALLDIR","VSCMD_VER","VisualStudioVersion" | ForEach-Object {
  $name = $_
  $value = (Get-Item -Path "Env:$name" -ErrorAction SilentlyContinue).Value
  if ($null -ne $value -and $value -ne "") {
    Write-Host ("{0}={1}" -f $name, $value)
  } else {
    Write-Host ("{0} is not set" -f $name)
  }
}

Write-Host "\n-- Visual Studio instances (vswhere) --" -ForegroundColor Cyan
$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (Test-Path -LiteralPath $vswhere) {
  & $vswhere -products * -format json
} else {
  Write-Host "vswhere.exe not found at: $vswhere" -ForegroundColor Yellow
}
