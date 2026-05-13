# =============================================================================
# ~/.zshrc – Zsh interactive shell configuration
# =============================================================================

# ── Homebrew (ensure available in interactive shells too) ────────────────────
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ── History ──────────────────────────────────────────────────────────────────
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS       # Don't record duplicate commands
setopt HIST_IGNORE_SPACE      # Don't record commands starting with a space
setopt HIST_VERIFY            # Show command before executing from history
setopt SHARE_HISTORY          # Share history between all sessions
setopt INC_APPEND_HISTORY     # Write to history file immediately

# ── Completion ───────────────────────────────────────────────────────────────
autoload -Uz compinit
# Rebuild completion cache at most once per day
if [[ -n "${ZDOTDIR:-$HOME}/.zcompdump"(#qNmh-20) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select                   # Arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ── Options ──────────────────────────────────────────────────────────────────
setopt AUTO_CD                # Type directory name to cd into it
setopt CORRECT                # Suggest corrections for typos
setopt GLOB_DOTS              # Include dotfiles in glob patterns
setopt NO_BEEP                # No beep on errors

# ── zsh plugins (via Homebrew) ───────────────────────────────────────────────
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix 2>/dev/null || echo /opt/homebrew)}"

ZSH_AUTOSUGGESTIONS="${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_SYNTAX_HIGHLIGHTING="${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

[[ -f "$ZSH_AUTOSUGGESTIONS" ]]     && source "$ZSH_AUTOSUGGESTIONS"
[[ -f "$ZSH_SYNTAX_HIGHLIGHTING" ]] && source "$ZSH_SYNTAX_HIGHLIGHTING"

# ── fzf ──────────────────────────────────────────────────────────────────────
[[ -f "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh" ]]   && source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh"
[[ -f "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh" ]] && source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ── zoxide (smarter cd) ───────────────────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# ── nvm (Node Version Manager) ───────────────────────────────────────────────
export NVM_DIR="${HOME}/.nvm"
[[ -s "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh" ]] && source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
[[ -s "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm" ]] && source "${HOMEBREW_PREFIX}/opt/nvm/etc/bash_completion.d/nvm"

# ── pyenv ────────────────────────────────────────────────────────────────────
export PYENV_ROOT="${HOME}/.pyenv"
[[ -d "${PYENV_ROOT}/bin" ]] && export PATH="${PYENV_ROOT}/bin:${PATH}"
command -v pyenv &>/dev/null && eval "$(pyenv init -)"

# ── Go ───────────────────────────────────────────────────────────────────────
export GOPATH="${HOME}/go"
export PATH="${GOPATH}/bin:${PATH}"

# ── Rust ─────────────────────────────────────────────────────────────────────
[[ -f "${HOME}/.cargo/env" ]] && source "${HOME}/.cargo/env"

# ── Editor ───────────────────────────────────────────────────────────────────
export EDITOR="code --wait"
export VISUAL="$EDITOR"
export PAGER="less"
export LESS="-FRX"

# ── Aliases – navigation ──────────────────────────────────────────────────────
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ── Aliases – ls / eza ───────────────────────────────────────────────────────
if command -v eza &>/dev/null; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -lah --icons --group-directories-first --git"
  alias lt="eza --tree --level=2 --icons"
else
  alias ls="ls --color=auto"
  alias ll="ls -lahG"
fi

# ── Aliases – git ────────────────────────────────────────────────────────────
alias g="git"
alias gs="git status -sb"
alias ga="git add"
alias gc="git commit"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gp="git push"
alias gpl="git pull"
alias gl="git log --oneline --decorate --graph -20"
alias gd="git diff"
alias gds="git diff --staged"
alias grb="git rebase"
alias gst="git stash"
alias gstp="git stash pop"

# ── Aliases – Docker ──────────────────────────────────────────────────────────
alias d="docker"
alias dc="docker compose"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias dimg="docker images"

# ── Aliases – misc ────────────────────────────────────────────────────────────
alias cat="bat --style=plain"       # Better cat (requires bat)
alias grep="grep --color=auto"
alias mkdir="mkdir -pv"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -iv"
alias path='echo -e ${PATH//:/\\n}'  # Pretty-print $PATH
alias reload="exec zsh"             # Reload shell config

# ── Aliases – macOS specifics ────────────────────────────────────────────────
alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO  && killall Finder"

# ── Functions ─────────────────────────────────────────────────────────────────

# Create a directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Find and kill a process by port number
killport() {
  local port="${1:?Usage: killport <port>}"
  lsof -ti ":${port}" | xargs kill -9 || true
  echo "Killed process on port ${port}."
}

# Quick HTTP server in current directory
serve() {
  local port="${1:-8000}"
  python3 -m http.server "${port}"
}

# Extract most archive types
extract() {
  local file="${1:?Usage: extract <file>}"
  case "$file" in
    *.tar.gz|*.tgz)  tar xzf "$file"   ;;
    *.tar.bz2)       tar xjf "$file"   ;;
    *.tar.xz)        tar xJf "$file"   ;;
    *.tar)           tar xf  "$file"   ;;
    *.zip)           unzip   "$file"   ;;
    *.gz)            gunzip  "$file"   ;;
    *.bz2)           bunzip2 "$file"   ;;
    *.7z)            7za x   "$file"   ;;
    *)               echo "Cannot extract: $file" ;;
  esac
}

# Show the top 10 most-used shell commands
top10() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
}

# ── Prompt – Starship ────────────────────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

# ── Local overrides ──────────────────────────────────────────────────────────
# Source machine-specific config that is NOT committed to the repo
[[ -f "${HOME}/.zshrc.local" ]] && source "${HOME}/.zshrc.local"
