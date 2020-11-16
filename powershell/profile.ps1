###############################################################################
# PowerShell Profile - Anand Balakrishnan
###############################################################################
$env:ConEmuANSI = $True

# -- Remove some aliases.
# I prefer scoop's version of these utilities, and so would prefer running the
# original stuff as opposed to the powershell stuff. 
remove-item alias:curl
remove-item alias:wget

# -- Appearance stuff

Import-Module oh-my-posh

if (Get-Command starship -ErrorAction SilentlyContinue) {
  Invoke-Expression (&starship init powershell)
}

# $psdir = "$($Env:HOMEPATH)/Documents/WindowsPowerShell/autoload"
# Get-ChildItem "${psdir}\*.ps1" | ForEach-Object { Import-Module $_ } 

# -- Dev stuff

# Conda {{
$CondaHook = "$($Env:HOME)\miniconda3\shell\condabin\conda-hook.ps1" 
if (Test-Path -Type Leaf $CondaHook) {
  . $CondaHook
}

# }}


