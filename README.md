# Dotfiles

个人 Zsh 开发环境配置，支持 Go、Node.js、Python 多语言开发。

## 特性

- **Zinit** - 快速插件管理器，Turbo 模式异步加载
- **Powerlevel10k** - 美观高效的 Zsh 主题
- **多语言支持** - Go / Node.js (NVM) / Python (uv)
- **容器工具** - Podman 补全和别名
- **敏感信息分离** - API tokens 等私密配置独立管理
- **XDG 规范** - 遵循 XDG Base Directory 标准
- **性能优化** - NVM 延迟加载、补全缓存、历史记录优化

## 快速开始

### 1. 前置依赖

```bash
# Debian/Ubuntu
sudo apt install zsh git curl

# 设置 zsh 为默认 shell
chsh -s $(which zsh)
```

### 2. 克隆仓库

```bash
git clone https://github.com/masonsxu/dot-env.git ~/dot-env
cd ~/dot-env
```

### 3. 备份现有配置

```bash
# 备份 .zshrc
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d%H%M%S)
```

### 4. 安装配置

```bash
# 复制主配置
cp .zshrc ~/.zshrc

# 创建私有配置（存放敏感信息）
cp .zshrc.local.example ~/.zshrc.local
```

### 5. 迁移历史记录（重要）

本配置使用 XDG 规范路径存储历史记录，需要迁移旧记录：

```bash
# 创建目录
mkdir -p ~/.local/share/zsh

# 迁移历史记录
[ -f ~/.zsh_history ] && cat ~/.zsh_history >> ~/.local/share/zsh/history

# 验证迁移成功后可删除旧文件（可选）
# rm ~/.zsh_history
```

### 6. 编辑私有配置

```bash
vim ~/.zshrc.local
# 填入你的 API tokens 等敏感信息
```

### 7. 启动新终端

首次启动会自动安装 Zinit 和所有插件，Powerlevel10k 会引导你完成主题配置。

## 开发环境（按需安装）

### Go

```bash
# 从 https://go.dev/dl/ 下载安装
wget https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.23.4.linux-amd64.tar.gz
```

### Node.js (NVM)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# 重启终端后
nvm install --lts
```

### Python (uv)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Podman

```bash
# Debian/Ubuntu
sudo apt install podman podman-compose
```

### Neovim（可选）

```bash
sudo apt install neovim
```

## 文件结构

```
.zshrc              # 主配置（公开）
.zshrc.local        # 私有配置（敏感信息，不提交）
.zshrc.local.example # 私有配置模板
.gitignore          # Git 忽略规则
```

## 配置说明

### 历史记录

| 配置项 | 值 | 说明 |
|--------|-----|------|
| `HISTFILE` | `~/.local/share/zsh/history` | XDG 规范路径 |
| `HISTSIZE` | 100000 | 内存中保留的历史条数 |
| `SAVEHIST` | 100000 | 写入文件的历史条数 |

### 插件列表

| 插件 | 说明 |
|------|------|
| `powerlevel10k` | 高性能 Zsh 主题 |
| `fast-syntax-highlighting` | 语法高亮 |
| `zsh-autosuggestions` | 命令自动建议（基于历史记录） |
| `zsh-completions` | 额外补全定义 |
| `zsh-history-substring-search` | 上下箭头搜索历史 |
| `zsh-z` | 目录快速跳转 |
| `OMZP::git` | Git 别名和补全 |

### 快捷键

| 快捷键 | 功能 |
|--------|------|
| `↑` / `↓` | 历史子串搜索 |
| `Ctrl+P` / `Ctrl+N` | 历史子串搜索（替代方案） |
| `Tab` | 补全菜单 |

## 内置别名

### Git

| 别名 | 命令 |
|------|------|
| `gs` | `git status` |
| `ga` | `git add` |
| `gc` | `git commit` |
| `gp` | `git push` |
| `gl` | `git pull` |
| `gd` | `git diff` |
| `glog` | `git log --oneline --graph` |

### 开发工具

| 别名 | 命令 |
|------|------|
| `ll` | `ls -alh` |
| `la` | `ls -A` |
| `cls` | `clear` |
| `v` / `vim` | `nvim` |
| `gotest` | `go test -v ./...` |
| `gobuild` | `go build -v` |
| `gorun` | `go run` |

### Podman

| 别名 | 命令 |
|------|------|
| `p` | `podman` |
| `pc` | `podman-compose` |
| `pps` | `podman ps` |
| `ppsa` | `podman ps -a` |
| `pi` | `podman images` |
| `prm` | `podman rm` |
| `prmi` | `podman rmi` |
| `plog` | `podman logs` |
| `pex` | `podman exec -it` |
| `docker` | `podman`（兼容别名） |
| `docker-compose` | `podman-compose` |

### 实用函数

| 函数 | 说明 |
|------|------|
| `mkcd dir` | 创建目录并进入 |
| `ff pattern` | 查找文件 |
| `fdir pattern` | 查找目录 |
| `gacp "msg"` | git add + commit + push |
| `port 8080` | 查看端口占用 |

## Zinit 管理

```bash
zinit update        # 更新所有插件
zinit self-update   # 更新 Zinit
zinit times         # 查看加载时间
zinit delete --clean # 清理未使用的插件
```

## 自定义

### 添加新插件

编辑 `~/.zshrc`，在 Zinit 插件区域添加：

```zsh
# 同步加载
zinit light author/plugin-name

# 异步加载（推荐）
zinit ice wait lucid
zinit light author/plugin-name
```

### 添加敏感配置

编辑 `~/.zshrc.local`：

```bash
export MY_API_KEY="your-key-here"
```

同时更新 `.zshrc.local.example` 模板。

### 修改自动建议策略

默认只使用历史记录建议。如需同时使用补全建议：

```zsh
# 在 ~/.zshrc 中修改
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
```

## 故障排除

### 历史记录丢失

检查历史文件路径：

```bash
echo $HISTFILE
# 应该是 ~/.local/share/zsh/history
```

如果旧记录在 `~/.zsh_history`，执行迁移：

```bash
cat ~/.zsh_history >> ~/.local/share/zsh/history
```

### 插件加载慢

查看各插件加载时间：

```bash
zinit times
```

### 补全不生效

重建补全缓存：

```bash
rm -rf ~/.cache/zsh/zcompcache
rm -f ~/.zcompdump*
exec zsh
```

## License

MIT
