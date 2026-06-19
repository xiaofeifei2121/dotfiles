# dotfiles

我的 Mac 配置,用 GNU Stow 管理。

## 结构
- `mac/` — Stow packages(zsh / git / starship / karabiner)
- `windows/` — PowerShell profile / aliases / proxy / npm / starship
- `Brewfile` — Homebrew 软件清单
- `bootstrap.sh` — 新机器一键初始化
- `windows/bootstrap.ps1` — Windows PowerShell 配置链接脚本

## Mac 新机器还原
```bash
git clone <仓库地址> ~/dotfiles
cd ~/dotfiles && bash bootstrap.sh
```

## Windows 还原
```powershell
cd C:\Users\qiwan\dotfiles
.\windows\bootstrap.ps1
```

`windows/bootstrap.ps1` 会把当前 `$PROFILE` 和 `~\.config\starship.toml` 软链接到仓库。
如果创建软链接失败,先开启 Windows Developer Mode,或用管理员权限重新打开 PowerShell 后再执行。
已有本地文件会自动备份为 `.bak-年月日-时分秒`;需要强制重建链接时使用:

```powershell
.\windows\bootstrap.ps1 -Force
```

## 日常
- 改配置:直接编辑 `~/.zshrc` 等(软链接,实际改的是仓库文件)
- 新增软件后更新清单:`brew bundle dump --file=Brewfile --force`
- 加新 package:`mkdir mac/<name>` → mv 文件进去 → `stow -t ~ <name>`
- Windows 改 PowerShell 配置:编辑 `windows/*.ps1`
- Windows 重新加载配置:`reload`
