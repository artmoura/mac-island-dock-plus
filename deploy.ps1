# Installs the fork from this folder into Windhawk and recompiles it (needs
# administrator). Also updates the copy in Windhawk's editor, so opening the
# mod there shows this version.
#   powershell -ExecutionPolicy Bypass -File deploy.ps1 [-Disable mod-id,...]
param([string[]]$Disable = @())

$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$source = Join-Path $here 'mac-island-dock-fork.wh.cpp'
$cli = 'C:\Program Files\Windhawk\windhawk-cli.exe'
$data = 'C:\ProgramData\Windhawk'
$id = 'local@mac-island-dock-fork'
Start-Transcript -Path (Join-Path $here 'deploy.log') -Force | Out-Null
try {
    Copy-Item $source (Join-Path $data "ModsSource\$id.wh.cpp") -Force
    "fonte copiada para ModsSource"
    Get-ChildItem (Join-Path $data 'EditorWorkspaces') -Directory | ForEach-Object {
        $file = Join-Path $_.FullName 'mod.wh.cpp'
        if ((Test-Path $file) -and (Select-String -Path $file -Pattern '^// @id\s+mac-island-dock-fork\s*$' -Quiet)) {
            Copy-Item $source $file -Force
            "editor atualizado: $file"
        }
    }
    & $cli mod compile $id 2>&1 | ForEach-Object { "$_" }
    "compile exit: $LASTEXITCODE"
    foreach ($mod in $Disable) {
        & $cli mod disable $mod 2>&1 | ForEach-Object { "$_" }
        "disable $mod exit: $LASTEXITCODE"
    }
} catch {
    "ERRO: $_"
} finally {
    Stop-Transcript | Out-Null
}
