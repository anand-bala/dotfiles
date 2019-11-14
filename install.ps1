###############################################################################
# Install script for dotfiles
# Author: Anand Balakrishnan <anandbala1597@gmail.com>
###############################################################################

param([Parameter(Mandatory=$true)][String[]] $Configs)

$SCRIPTPATH=$PSScriptRoot

function install_nvim {
  $src = "$($SCRIPTPATH)\nvim"
  $dest = "$($Env:LOCALAPPDATA)\nvim"

  Get-ChildItem "$($src)" | % {
    New-Item -Force -ItemType SymbolicLink -Path "$($dest)\$($_.Name)" -Target $_.FullName 
  }
}

function install_pwsh {
  $src = "$($SCRIPTPATH)\powershell"
  $dest = (Split-Path -Path $Profile.CurrentUserAllHosts)
  
  Get-ChildItem "$($src)" | % {
    New-Item -Force -ItemType SymbolicLink -Path "$($dest)\$($_.Name)" -Target $_.FullName 
  }
}

foreach ( $prog in $Configs ) {
  switch -Regex ( $prog ){
    'neovim|nvim' { Write-Host "Installing Neovim config" | install_nvim }
    'powershell|posh|pwsh' { Write-Host "Installing Powershell config" | install_pwsh }
    default { Write-Error "[$($prog)]?! I have no idea what you're talking about..." }
  }
}




