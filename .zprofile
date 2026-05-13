# ~/.zprofile
# Loaded once at login shell startup.

# ── Homebrew ──────────────────────────────────────────────────────────────────
if [[ -f /opt/homebrew/bin/brew ]]; then
  # Apple Silicon
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  # Intel
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ── PATH ──────────────────────────────────────────────────────────────────────
# Put user-local binaries first
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# ── Editor ────────────────────────────────────────────────────────────────────
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# ── Language / locale ─────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# ── XDG base dirs ─────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
