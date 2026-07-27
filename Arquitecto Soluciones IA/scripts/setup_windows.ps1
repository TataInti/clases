<#
Bootstrap para Windows.

Uso recomendado desde PowerShell:
    powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/TataInti/clases/main/scripts/setup_windows.ps1')))"

Si ya tienes el repositorio clonado:
  powershell -ExecutionPolicy Bypass -File .\scripts\setup_windows.ps1

Tambien se puede ejecutar desde cualquier carpeta:
  powershell -ExecutionPolicy Bypass -File .\setup_windows.ps1 -InstallRoot "$env:USERPROFILE\GitHub"
#>

[CmdletBinding()]
param(
    [string]$RepoUrl = "https://github.com/TataInti/clases.git",
    [string]$InstallRoot = (Join-Path $env:USERPROFILE "GitHub"),
    [string]$ProjectName = "clases",
    [switch]$SkipDependencies,
    [switch]$NoOpenVSCode
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$PythonVersion = "3.12.3"
$PythonInstallDir = Join-Path $env:LOCALAPPDATA "Programs\Python\Python3123"
$Extensions = @(
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-toolsai.jupyter",
    "ms-toolsai.jupyter-renderers",
    "ms-toolsai.vscode-jupyter-cell-tags",
    "ms-toolsai.vscode-jupyter-slideshow",
    "ms-vscode.powershell"
)

function Write-Step {
    param([Parameter(Mandatory = $true)][string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Test-Command {
    param([Parameter(Mandatory = $true)][string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Update-CurrentPath {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $paths = @($machinePath, $userPath, $env:Path) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    $env:Path = ($paths -join ";")
}

function Invoke-External {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [string[]]$ArgumentList = @(),
        [string]$Description = $FilePath
    )

    Write-Host "-> $Description"
    & $FilePath @ArgumentList
    if ($LASTEXITCODE -ne 0) {
        throw "Fallo '$Description' con codigo de salida $LASTEXITCODE."
    }
}

function Install-WingetPackage {
    param(
        [Parameter(Mandatory = $true)][string]$Id,
        [Parameter(Mandatory = $true)][string]$Name,
        [string]$CommandName
    )

    if ($CommandName -and (Test-Command $CommandName)) {
        Write-Host "OK: $Name ya esta instalado."
        return
    }

    if (-not (Test-Command "winget")) {
        throw "winget no esta disponible. Instala 'App Installer' desde Microsoft Store y vuelve a ejecutar este script."
    }

    $arguments = @(
        "install",
        "--id", $Id,
        "--exact",
        "--source", "winget",
        "--accept-package-agreements",
        "--accept-source-agreements"
    )
    Invoke-External "winget" $arguments "Instalando $Name"
    Update-CurrentPath
}

function Get-CodeCli {
    $command = Get-Command "code.cmd" -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }

    $command = Get-Command "code" -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }

    $candidates = @(
        (Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\bin\code.cmd"),
        (Join-Path $env:ProgramFiles "Microsoft VS Code\bin\code.cmd")
    )

    if (${env:ProgramFiles(x86)}) {
        $candidates += (Join-Path ${env:ProgramFiles(x86)} "Microsoft VS Code\bin\code.cmd")
    }

    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate) { return $candidate }
    }

    throw "No se encontro la CLI de VS Code despues de instalarlo. Cierra y abre PowerShell, o verifica que 'code' este en PATH."
}

function Test-VSCodeCli {
    try {
        [void](Get-CodeCli)
        return $true
    }
    catch {
        return $false
    }
}

function Get-Python312Info {
    $checks = @()
    $exactPython = Join-Path $PythonInstallDir "python.exe"
    if (Test-Path -LiteralPath $exactPython) {
        $checks += [pscustomobject]@{ Command = $exactPython; PrefixArgs = @() }
    }

    if (Test-Command "py") {
        $checks += [pscustomobject]@{ Command = "py"; PrefixArgs = @("-3.12") }
    }

    $standardCandidates = @(
        (Join-Path $env:LOCALAPPDATA "Programs\Python\Python312\python.exe"),
        (Join-Path $env:ProgramFiles "Python312\python.exe")
    )

    if (${env:ProgramFiles(x86)}) {
        $standardCandidates += (Join-Path ${env:ProgramFiles(x86)} "Python312\python.exe")
    }

    foreach ($candidate in $standardCandidates) {
        if (Test-Path -LiteralPath $candidate) {
            $checks += [pscustomobject]@{ Command = $candidate; PrefixArgs = @() }
        }
    }

    foreach ($commandName in @("python", "python3")) {
        if (Test-Command $commandName) {
            $checks += [pscustomobject]@{ Command = $commandName; PrefixArgs = @() }
        }
    }

    foreach ($check in $checks) {
        $arguments = @()
        $arguments += $check.PrefixArgs
        $arguments += @("-c", "import sys; print(sys.executable); print('.'.join(map(str, sys.version_info[:3]))); print(sys.version_info[0]); print(sys.version_info[1])")
        $output = & $check.Command @arguments 2>$null
        if ($LASTEXITCODE -ne 0 -or @($output).Count -lt 4) { continue }

        if ($output[2].Trim() -eq "3" -and $output[3].Trim() -eq "12") {
            return [pscustomobject]@{
                Command = $check.Command
                PrefixArgs = @($check.PrefixArgs)
                Executable = $output[0].Trim()
                Version = $output[1].Trim()
            }
        }
    }

    return $null
}

function Install-Python3123 {
    $info = Get-Python312Info
    if ($info -and $info.Version -eq $PythonVersion) {
        Write-Host "OK: Python $PythonVersion ya esta instalado en $($info.Executable)."
        return $info
    }

    Write-Step "Instalando Python $PythonVersion"
    New-Item -ItemType Directory -Force -Path $PythonInstallDir | Out-Null

    $suffix = ""
    if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
        $suffix = "-arm64"
    }
    elseif ([Environment]::Is64BitOperatingSystem) {
        $suffix = "-amd64"
    }

    $fileName = "python-$PythonVersion$suffix.exe"
    $installerPath = Join-Path $env:TEMP $fileName
    $installerUrl = "https://www.python.org/ftp/python/$PythonVersion/$fileName"

    Write-Host "Descargando $installerUrl"
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

    $installerArguments = "/quiet InstallAllUsers=0 TargetDir=`"$PythonInstallDir`" PrependPath=1 Include_launcher=1 Include_pip=1 Include_test=0"
    $process = Start-Process -FilePath $installerPath -ArgumentList $installerArguments -Wait -PassThru
    if ($process.ExitCode -ne 0) {
        throw "El instalador de Python termino con codigo de salida $($process.ExitCode)."
    }

    Update-CurrentPath
    $info = Get-Python312Info
    if (-not $info -or $info.Version -ne $PythonVersion) {
        throw "No se pudo confirmar Python $PythonVersion despues de la instalacion."
    }

    Write-Host "OK: Python $PythonVersion instalado en $($info.Executable)."
    return $info
}

function Invoke-Python312 {
    param(
        [Parameter(Mandatory = $true)]$PythonInfo,
        [Parameter(Mandatory = $true)][string[]]$ArgumentList,
        [Parameter(Mandatory = $true)][string]$Description
    )

    $arguments = @()
    $arguments += $PythonInfo.PrefixArgs
    $arguments += $ArgumentList
    Invoke-External $PythonInfo.Command $arguments $Description
}

function Sync-Repository {
    Write-Step "Sincronizando repositorio"
    New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null
    $repoPath = Join-Path $InstallRoot $ProjectName

    if (Test-Path -LiteralPath (Join-Path $repoPath ".git")) {
        Write-Host "OK: el repositorio ya existe en $repoPath."
        Invoke-External "git" @("-C", $repoPath, "remote", "set-url", "origin", $RepoUrl) "Configurando remoto origin"
        Invoke-External "git" @("-C", $repoPath, "fetch", "origin") "Descargando referencias de GitHub"
        Invoke-External "git" @("-C", $repoPath, "pull", "--ff-only") "Actualizando rama local"
        return $repoPath
    }

    if (Test-Path -LiteralPath $repoPath) {
        $items = @(Get-ChildItem -LiteralPath $repoPath -Force -ErrorAction SilentlyContinue)
        if ($items.Count -gt 0) {
            throw "La carpeta $repoPath existe y no es un repositorio Git vacio. Usa -InstallRoot o -ProjectName para elegir otra ubicacion."
        }
    }

    Invoke-External "git" @("clone", $RepoUrl, $repoPath) "Clonando repositorio desde GitHub"
    return $repoPath
}

function Configure-VSCodeWorkspace {
    param([Parameter(Mandatory = $true)][string]$RepoPath)

    Write-Step "Configurando VS Code para el repo"
    $vscodeDir = Join-Path $RepoPath ".vscode"
    New-Item -ItemType Directory -Force -Path $vscodeDir | Out-Null

    $settingsPath = Join-Path $vscodeDir "settings.json"
    $settingsJson = @'
{
  "python.defaultInterpreterPath": "${workspaceFolder}\\.venv\\Scripts\\python.exe",
  "python.terminal.activateEnvironment": true,
  "jupyter.notebookFileRoot": "${workspaceFolder}",
  "jupyter.askForKernelRestart": false
}
'@
    Set-Content -LiteralPath $settingsPath -Value $settingsJson -Encoding UTF8

    $extensionsPath = Join-Path $vscodeDir "extensions.json"
    $recommendations = ($Extensions | ForEach-Object { "    `"$_`"" }) -join ",`r`n"
    $extensionsJson = @"
{
  "recommendations": [
$recommendations
  ]
}
"@
    Set-Content -LiteralPath $extensionsPath -Value $extensionsJson -Encoding UTF8
}

function Install-VSCodeExtensions {
    param([Parameter(Mandatory = $true)][string]$CodeCli)

    Write-Step "Instalando extensiones de VS Code"
    foreach ($extension in $Extensions) {
        Invoke-External $CodeCli @("--install-extension", $extension, "--force") "Instalando extension $extension"
    }
}

function Initialize-VirtualEnvironment {
    param(
        [Parameter(Mandatory = $true)][string]$RepoPath,
        [Parameter(Mandatory = $true)]$PythonInfo
    )

    Write-Step "Preparando entorno virtual"
    $venvPath = Join-Path $RepoPath ".venv"
    $venvPython = Join-Path $venvPath "Scripts\python.exe"
    $requirementsPath = Join-Path $RepoPath "requirements.txt"
    $createVenv = $true

    if (Test-Path -LiteralPath $venvPython) {
        $venvVersion = & $venvPython -c "import sys; print('.'.join(map(str, sys.version_info[:3])))" 2>$null
        if ($LASTEXITCODE -eq 0 -and $venvVersion.Trim() -eq $PythonVersion) {
            Write-Host "OK: el entorno virtual ya existe en $venvPath."
            $createVenv = $false
        }
        else {
            Write-Warning "El entorno virtual existente no usa Python $PythonVersion. Se recreara .venv."
            Remove-Item -LiteralPath $venvPath -Recurse -Force
        }
    }

    if ($createVenv) {
        Invoke-Python312 $PythonInfo @("-m", "venv", $venvPath) "Creando entorno virtual .venv"
    }

    Invoke-External $venvPython @("-m", "pip", "install", "--upgrade", "pip", "setuptools", "wheel", "ipykernel") "Actualizando herramientas base del entorno"

    if (-not $SkipDependencies) {
        try {
            Invoke-External $venvPython @("-m", "pip", "install", "-r", $requirementsPath) "Instalando dependencias del repo"
        }
        catch {
            Write-Warning "La instalacion de requirements.txt fallo. En Windows, llama-cpp-python puede requerir compiladores C++ si no hay wheel compatible."
            Write-Warning "Si ese es el caso, instala 'Visual Studio Build Tools 2022' con la carga de C++ y vuelve a ejecutar este script."
            throw
        }
    }
    else {
        Write-Host "Saltando instalacion de dependencias por -SkipDependencies."
    }

    Invoke-External $venvPython @("-m", "ipykernel", "install", "--user", "--name", "clases-python312", "--display-name", "Python 3.12 (.venv clases)") "Registrando kernel de Jupyter"
}

Write-Step "Verificando herramientas de Windows"
Install-WingetPackage -Id "Git.Git" -Name "Git" -CommandName "git"
if (-not (Test-Command "git")) {
    throw "Git esta instalado, pero no se encontro en PATH. Cierra y abre PowerShell, y vuelve a ejecutar este script."
}

if (Test-VSCodeCli) {
    Write-Host "OK: Visual Studio Code ya esta instalado."
}
else {
    Install-WingetPackage -Id "Microsoft.VisualStudioCode" -Name "Visual Studio Code"
}

$codeCli = Get-CodeCli

$pythonInfo = Install-Python3123
$repoPath = Sync-Repository
Configure-VSCodeWorkspace -RepoPath $repoPath
Install-VSCodeExtensions -CodeCli $codeCli
Initialize-VirtualEnvironment -RepoPath $repoPath -PythonInfo $pythonInfo

Write-Step "Listo"
Write-Host "Repo: $repoPath"
Write-Host "Python: $((Join-Path $repoPath '.venv\Scripts\python.exe'))"
Write-Host "Kernel: Python 3.12 (.venv clases)"

if (-not $NoOpenVSCode) {
    Invoke-External $codeCli @($repoPath) "Abriendo VS Code"
}