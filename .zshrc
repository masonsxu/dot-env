# ============================================================
# Powerlevel10k instant prompt (必须最靠前)
# ============================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================
# XDG Base Directory
# ============================================================
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# ============================================================
# Zsh 性能与行为优化
# ============================================================
# 补全缓存
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# 补全菜单
zstyle ':completion:*' menu select

# 补全大小写不敏感
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# 历史记录
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_FIND_NO_DUPS SHARE_HISTORY EXTENDED_HISTORY

# ============================================================
# Autosuggestions（启动前配置）
# ============================================================
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
# 在使用 history-substring-search 时清除 autosuggestions，避免叠加显示
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(
  history-substring-search-up
  history-substring-search-down
  accept-line       # 按回车时清除建议，避免终端回显显示建议内容
)

# ============================================================
# Zinit 插件管理器
# ============================================================
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"

if [[ ! -d "$ZINIT_HOME" ]]; then
  print -P "%F{33}Installing zinit...%f"
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# ============================================================
# Zinit 插件加载
# ============================================================

# Powerlevel10k
zinit ice depth=1
zinit light romkatv/powerlevel10k

# 核心插件（延迟加载）
zinit wait lucid for \
  zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start; _zsh_autosuggest_bind_widgets" \
    zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
    zsh-users/zsh-completions

# 历史子串搜索（同步加载，确保键绑定生效）
zinit light zsh-users/zsh-history-substring-search
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey "^P" history-substring-search-up
bindkey "^N" history-substring-search-down
bindkey -M vicmd "k" history-substring-search-up
bindkey -M vicmd "j" history-substring-search-down

# z 目录跳转
zinit ice wait lucid
zinit light agkozak/zsh-z

# Git（OMZ 片段）
zinit ice wait lucid
zinit snippet OMZP::git

# Podman 补全
if command -v podman &>/dev/null; then
  zinit ice wait lucid as"completion"
  zinit snippet https://github.com/containers/podman/raw/main/completions/zsh/_podman
fi

# ============================================================
# 通用环境变量
# ============================================================
export EDITOR='nvim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ============================================================
# Podman 运行时
# ============================================================
if [[ -z "$XDG_RUNTIME_DIR" ]]; then
  export XDG_RUNTIME_DIR="/run/user/$UID"
  if [[ ! -d "$XDG_RUNTIME_DIR" ]]; then
    export XDG_RUNTIME_DIR="/tmp/$USER-runtime"
    mkdir -m 0700 -p "$XDG_RUNTIME_DIR"
  fi
fi
export CONTAINER_CMD=podman

# ============================================================
# Go 开发环境
# ============================================================
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,direct
export PATH="$PATH:$GOBIN"

# ============================================================
# Node.js (NVM) 直接加载
# ============================================================
export NVM_DIR="$HOME/.nvm"

# 检查 nvm 是否安装
if [[ ! -d "$NVM_DIR" ]]; then
  echo "⚠️  NVM 未安装在 $NVM_DIR"
  echo ""
  echo "是否要自动安装 NVM？"
  echo "  运行: install_nvm"
else
  # 直接加载 nvm
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
  fi
fi

# ============================================================
# Python (uv)
# ============================================================
export UV_HOME="$HOME/.local/bin"

# ============================================================
# 常用别名
# ============================================================
alias ll='ls -alh'
alias la='ls -A'
alias cls='clear'
alias vim='nvim'
alias v='nvim'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias glog='git log --oneline --graph --decorate -10'

# Go
alias gotest='go test -v ./...'
alias gobuild='go build -v'
alias gorun='go run'

# Podman
alias p='podman'
alias pc='podman-compose'
alias pps='podman ps'
alias ppsa='podman ps -a'
alias pi='podman images'
alias prm='podman rm'
alias prmi='podman rmi'
alias plog='podman logs'
alias pex='podman exec -it'
alias docker='podman'
alias docker-compose='podman-compose'

# ============================================================
# 实用函数
# ============================================================
mkcd() { mkdir -p "$1" && cd "$1"; }
ff() { find . -type f -name "*$1*"; }
fdir() { find . -type d -name "*$1*"; }
gacp() { git add -A && git commit -m "$1" && git push; }
port() { lsof -i :"$1"; }

# NVM 安装函数
install_nvm() {
  if [[ -d "$HOME/.nvm" ]]; then
    echo "✅ NVM 已经安装在 $HOME/.nvm"
    echo "如需重新安装，请先删除该目录"
    return 0
  fi

  echo "正在安装 NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

  if [[ $? -eq 0 ]]; then
    echo "✅ NVM 安装成功！"
    echo "请运行以下命令使配置生效："
    echo "  source ~/.zshrc"
  else
    echo "❌ NVM 安装失败"
    return 1
  fi
}

# ============================================================
# PATH 整理
# ============================================================
export PATH="$HOME/.local/bin:$PATH"
typeset -U PATH path

# ============================================================
# Powerlevel10k 配置
# ============================================================
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ============================================================
# 私有配置
# ============================================================
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================================
# 补全系统初始化（只做一次）
# ============================================================
autoload -Uz compinit
compinit -C
zinit cdreplay -q

# uv 补全（缓存到文件提升启动速度）
if command -v uv &>/dev/null; then
  _uv_comp="$XDG_CACHE_HOME/zsh/uv_completion.zsh"
  if [[ ! -f "$_uv_comp" || "$(command -v uv)" -nt "$_uv_comp" ]]; then
    uv generate-shell-completion zsh > "$_uv_comp" 2>/dev/null
  fi
  [[ -f "$_uv_comp" ]] && source "$_uv_comp"
  unset _uv_comp
fi
