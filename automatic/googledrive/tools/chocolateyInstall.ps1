﻿$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
. $toolsDir\helpers.ps1

[version] $softwareVersion = '73.0.4.0'
$installedVersion = Get-InstalledVersion

if ($installedVersion -eq $softwareVersion -and !$env:ChocolateyForce) {
  Write-Output "Google Drive $version is already installed. Skipping download and installation."
}
else {
  if ($softwareVersion -le $installedVersion) {
    Write-Output "Current installed version (v$installedVersion) must be uninstalled first..."
    Uninstall-CurrentVersion
    throw 'Windows must be rebooted before installation can be completed!'
  }

  $url = 'https://dl.google.com/drive-file-stream/GoogleDriveSetup.exe'
  $checksum = '1916B0329B9361456493EF0153C187D34F34B2ED5C20AD6ADCDFCC24EFF87D0D'
  $checksumType = 'sha256'

  $packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $toolsDir
    fileType       = 'exe'
    url            = $url
    checksum       = $checksum
    checksumType   = $checksumType
    softwareName   = 'Google Drive*'
    silentArgs     = "--silent --desktop_shortcut"
    validExitCodes = @(0, 1641, 3010)
  }

  $pp = Get-PackageParameters
  if ($pp.NoStart) {
    $packageArgs['silentArgs'] += ' --skip_launch_new'
  }
  if ($pp.NoGsuiteIcons) {
    $packageArgs['silentArgs'] += ' --gsuite_shortcuts=false'
  }

  Install-ChocolateyPackage @packageArgs
}
