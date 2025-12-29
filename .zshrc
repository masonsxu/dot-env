# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================
# Zinit 插件管理器
# =============================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# 自动安装 zinit
if [[ ! -d "$ZINIT_HOME" ]]; then
  print -P "%F{33}Installing zinit...%f"
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# =============================================
# Zinit 插件加载
# =============================================
# Powerlevel10k 主题
zinit ice depth=1
zinit light romkatv/powerlevel10k

# 核心插件（Turbo 模式延迟加载，提升启动速度）
zinit wait lucid for \
  atinit"zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

# 历史子串搜索（输入部分命令后上下键切换匹配历史）
zinit ice wait lucid atload"
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
"
zinit light zsh-users/zsh-history-substring-search

# z 目录跳转
zinit ice wait lucid
zinit light agkozak/zsh-z

# Git 插件（OMZ 片段）
zinit ice wait lucid
zinit snippet OMZP::git

# Podman 补全
if command -v podman &> /dev/null; then
  zinit ice wait lucid as"completion"
  zinit snippet https://github.com/containers/podman/raw/main/completions/zsh/_podman
fi

# =============================================
# 通用环境变量
# =============================================
export EDITOR='nvim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG 目录规范
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# Podman 运行时配置
if [[ -z "$XDG_RUNTIME_DIR" ]]; then
  export XDG_RUNTIME_DIR=/run/user/$UID
  if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
    export XDG_RUNTIME_DIR=/tmp/$USER-runtime
    mkdir -m 0700 -p "$XDG_RUNTIME_DIR"
  fi
fi
export CONTAINER_CMD=podman

# =============================================
# Go 开发环境
# =============================================
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# Go Modules 配置
go env -w GO111MODULE=on 2>/dev/null
go env -w GOPROXY=https://goproxy.cn,direct 2>/dev/null

# =============================================
# Node.js 开发环境 (NVM)
# =============================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# 备用：系统级 NVM
[ -s "/usr/share/nvm/init-nvm.sh" ] && \. "/usr/share/nvm/init-nvm.sh"

# =============================================
# Python 开发环境 (uv)
# =============================================
export UV_HOME="$HOME/.local/bin"
# uv 自动管理 Python 版本，无需额外配置
# 启用 uv 的 shell 补全
if command -v uv &> /dev/null; then
  eval "$(uv generate-shell-completion zsh)"
fi

# =============================================
# 常用别名
# =============================================
# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate -10'

# 开发工具
alias ll='ls -alh'
alias la='ls -A'
alias vim='nvim'
alias v='nvim'
alias cls='clear'

# Go
alias gotest='go test -v ./...'
alias gobuild='go build -v'
alias gorun='go run'

# Podman 容器
alias p='podman'
alias pc='podman-compose'
alias pps='podman ps'
alias ppsa='podman ps -a'
alias pi='podman images'
alias prm='podman rm'
alias prmi='podman rmi'
alias plog='podman logs'
alias pex='podman exec -it'
# 兼容 docker 命令习惯
alias docker='podman'
alias docker-compose='podman-compose'

# =============================================
# 实用函数
# =============================================
# 创建目录并进入
mkcd() { mkdir -p "$1" && cd "$1"; }

# 快速查找文件
ff() { find . -type f -name "*$1*"; }

# 快速查找目录
fd() { find . -type d -name "*$1*"; }

# Git 提交并推送
gacp() { git add -A && git commit -m "$1" && git push; }

# 查看端口占用
port() { lsof -i :"$1"; }

# =============================================
# PATH 整理（放在最后，避免重复）
# =============================================
# 额外工具路径
export PATH="$HOME/.local/bin:$PATH"

# 确保 PATH 无重复（Zsh 特有）
typeset -U PATH

# =============================================
# Powerlevel10k 主题配置
# =============================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =============================================
# 加载本地私有配置（敏感信息）
# =============================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
