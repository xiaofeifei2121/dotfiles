# 命令行工具初始化(无配置文件,靠 shell 钩子生效)

# zoxide:智能 cd。装了才初始化,避免新机器未装时报错。
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# fzf:PSReadLine 键位(Ctrl+t 查文件 / Ctrl+r 查历史),需 PSFzf 模块。
# 如未安装 PSFzf,可执行:Install-Module PSFzf -Scope CurrentUser
if (Get-Command fzf -ErrorAction SilentlyContinue) {
    if (Get-Module -ListAvailable -Name PSFzf) {
        Import-Module PSFzf
        Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
    }
}
