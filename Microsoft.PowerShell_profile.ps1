Set-PSReadLineOption -PredictionSource Plugin

$ENV:HTTP_PROXY = "http://127.0.0.1:1089"
$ENV:HTTPS_PROXY = "http://127.0.0.1:1089"

if (Get-Command gpgconf.exe -ErrorAction SilentlyContinue) {
    Start-Job -ScriptBlock { gpgconf.exe --launch gpg-agent } | Out-Null
}
function Use-VS {
    $VsWhere = "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    $VsInstallDir = & $VsWhere -latest -property installationPath
    Import-Module "$VsInstallDir\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"
    Enter-VsDevShell -VsInstallPath $VsInstallDir -SkipAutomaticLocation -Arch amd64 -HostArch amd64
}

function Use-Git {
    Import-Module posh-git
    $env:POSH_GIT_ENABLED = $true
}

function Use-Docker {
    Import-Module DockerCompletion
}

#region conda initialize
# !! Contents within this block are managed by 'conda init' !!
If (Test-Path "C:\Users\LinHe\miniconda3\Scripts\conda.exe") {
    (& "C:\Users\LinHe\miniconda3\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

# Clear blue bg for `ls` directories
$PSStyle.FileInfo.Directory = "`e[34m"

Use-Git

# Remember to change python env settings
# {
#     "background": "#FFDE57",
#     "foreground": "#111111",
#     "invert_powerline": true,
#     "powerline_symbol": "\ue0b2",
#     "properties": {
#       "display_mode": "environment",
#       "fetch_virtual_env": true,
#       "home_enabled": true
#     },
#     "style": "powerline",
#     "template": " \ue235 {{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }} {{ else }}{{ .Full }}{{ end }}{{ end }} ",
#     "type": "python"
#   },
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/powerlevel10k_rainbow.omp.json" | Invoke-Expression

