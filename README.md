# Dotfiles

个人 Zsh 开发环境配置，支持 Go、Node.js、Python 多语言开发。

## 特性

- **Zinit** - 快速插件管理器，Turbo 模式异步加载
- **Powerlevel10k** - 美观高效的 Zsh 主题
- **多语言支持** - Go / Node.js (NVM) / Python (uv)
- **容器工具** - Podman/Docker 补全
- **敏感信息分离** - API tokens 等私密配置独立管理

## 快速开始

### 1. 克隆仓库

```bash
git clone https://github.com/yourusername/dot-env.git
cd dot-env
```

### 2. 安装配置

```bash
# 备份现有配置
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.backup

# 复制配置文件
cp .zshrc ~/.zshrc

# 创建本地私有配置
cp .zshrc.local.example ~/.zshrc.local
```

### 3. 编辑私有配置

```bash
vim ~/.zshrc.local
# 填入你的 API tokens 等敏感信息
```

### 4. 重启终端

首次启动会自动安装 Zinit 和所有插件。

## 前置依赖

| 工具 | 安装命令 | 说明 |
|------|---------|------|
| Zsh | `sudo apt install zsh` | Shell |
| Git | `sudo apt install git` | 版本控制 |
| Neovim | `sudo apt install neovim` | 编辑器（可选） |

### 开发环境（按需安装）

**Go**
```bash
# 从 https://go.dev/dl/ 下载安装
```

**Node.js (NVM)**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install --lts
```

**Python (uv)**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## 文件结构

```
.zshrc              # 主配置（公开）
.zshrc.local        # 私有配置（敏感信息，不提交）
.zshrc.local.example # 私有配置模板
.gitignore          # Git 忽略规则
```

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
| `v` | `nvim` |
| `gotest` | `go test -v ./...` |
| `pd` | `podman` |

### 实用函数
| 函数 | 说明 |
|------|------|
| `mkcd dir` | 创建目录并进入 |
| `ff pattern` | 查找文件 |
| `fd pattern` | 查找目录 |
| `gcp "msg"` | git add + commit + push |
| `port 8080` | 查看端口占用 |

## Zinit 管理

```bash
zinit update        # 更新所有插件
zinit self-update   # 更新 Zinit
zinit times         # 查看加载时间
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

## License

MIT
