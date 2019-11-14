$CondaProfileHook = "$($Env:CONDA_ROOT)/shell/condabin/conda-hook.ps1"
if (Test-Path($CondaProfileHook)) {
  Import-Module "$CondaProfileHook"
}

