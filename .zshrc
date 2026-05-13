#!/usr/bin/env zsh
# ~/.zshrc
# Interactive shell configuration. Sourced for every new interactive shell.

# ── Instant prompt (Powerlevel10k) – keep near top ───────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Oh-My-Zsh ─────────────────────────────────────────────────────────────────
export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Update behaviour (silent, automatic)
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 14

# Plugins (keep the list lean; heavy plugins → zsh-defer)
plugins=(
  git
  macos
  brew
  docker
  npm
  node
  python
  vscode
  history
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

# ── Aliases ───────────────────────────────────────────────────────────────────
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# ── History ───────────────────────────────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump-${ZSH_VERSION}"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# ── Key bindings ──────────────────────────────────────────────────────────────
bindkey -e                              # emacs-style line editing
bindkey '^[[A' history-search-backward  # up arrow → history search
bindkey '^[[B' history-search-forward   # down arrow → history search
bindkey '^[[H' beginning-of-line        # Home
bindkey '^[[F' end-of-line              # End
bindkey '^[[3~' delete-char             # Delete
bindkey '^[^[[C' forward-word           # Alt+Right
bindkey '^[^[[D' backward-word          # Alt+Left

# ── NVM (Node Version Manager) ────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# ── pyenv ─────────────────────────────────────────────────────────────────────
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# ── rbenv ─────────────────────────────────────────────────────────────────────
if command -v rbenv &>/dev/null; then
  eval "$(rbenv init -)"
fi

# ── fzf ───────────────────────────────────────────────────────────────────────
if command -v fzf &>/dev/null; then
  # Prefer ripgrep for search if available
  if command -v rg &>/dev/null; then
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  fi
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  source <(fzf --zsh) 2>/dev/null || true
fi

# ── bat (better cat) ──────────────────────────────────────────────────────────
if command -v bat &>/dev/null; then
  alias cat="bat --paging=never"
  export BAT_THEME="TwoDark"
fi

# ── zoxide (better cd) ────────────────────────────────────────────────────────
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# ── direnv ───────────────────────────────────────────────────────────────────
if command -v direnv &>/dev/null; then
  eval "$(direnv hook zsh)"
fi

# ── Powerlevel10k config ──────────────────────────────────────────────────────
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ── Local overrides ──────────────────────────────────────────────────────────
# Machine-specific config that is NOT committed to the dotfiles repo
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
