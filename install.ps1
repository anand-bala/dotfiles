###############################################################################
# Install script for dotfiles
# Author: Anand Balakrishnan <anandbala1597@gmail.com>
###############################################################################

param([Parameter(Mandatory=$true)][String[]] $Configs)

$SCRIPTPATH=$PSScriptRoot


function __recurse_install {
  param (
      [Parameter(Mandatory = $true)]
      [ValidateScript({
        if( -Not ($_ | Test-Path) ){
        throw "File or folder does not exist"
        }
        return $true
        })]
      [System.IO.DirectoryInfo]$Path,
      [Parameter(Mandatory = $true)]
      [ValidateScript({
        if ( -Not ($_ | Test-Path) ) {
          throw "Destination folder does not exist"
        }
        if ( -Not ($_ | Test-Path -Type Container) ) {
          throw "Provided destination must be a folder"
        }
        return $true
      })]
      [System.IO.DirectoryInfo]$Destination
      )

  Get-ChildItem -Directory "$($Path.FullName)" | % {
    $dest = New-Item  -Force -Type Directory -Path "$($Destination.FullName)\$($_.Name)"
    __recurse_install -Path $_ -Destination $dest
  }

  Get-ChildItem -File "$($Path.FullName)" | % {
    New-Item  -Force -ItemType SymbolicLink -Path "$($Destination.FullName)\$($_.Name)" -Target $_.FullName
  }
}


function install_nvim {
  $src = (Get-Item "$($SCRIPTPATH)\nvim")
  $dest = (New-Item -Type Directory -Force -Path "$($Env:LOCALAPPDATA)\nvim")

  # Get-ChildItem "$($src)" | % {
  #   New-Item -Force -ItemType SymbolicLink -Path "$($dest)\$($_.Name)" -Target $_.FullName 
  # }
  New-Item -Type Directory -Force -Path $dest
  __recurse_install -Path $src -Destination $dest
}


function install_pwsh {
  $src = (Get-Item "$($SCRIPTPATH)\powershell")
  $dest = (New-Item -Type Directory -Force -Path (Split-Path -Path $Profile.CurrentUserAllHosts))

  
  # Get-ChildItem "$($src)" | % {
  #   New-Item -Force -ItemType SymbolicLink -Path "$($dest)\$($_.Name)" -Target $_.FullName 
  # }
  __recurse_install -Path $src -Destination $dest
}

foreach ( $prog in $Configs ) {
  switch -Regex ( $prog ){
    'neovim|nvim' { Write-Host "Installing Neovim config" | install_nvim }
    'powershell|posh|pwsh' { Write-Host "Installing Powershell config" | install_pwsh }
    default { Write-Error "[$($prog)]?! I have no idea what you're talking about..." }
  }
}




