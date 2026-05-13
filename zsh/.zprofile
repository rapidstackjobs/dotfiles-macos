# =============================================================================
# ~/.zprofile – Zsh login profile
# Loaded once for login shells. Used for PATH and environment setup.
# =============================================================================

# ── Homebrew ────────────────────────────────────────────────────────────────
# Apple Silicon Macs install Homebrew to /opt/homebrew; Intel Macs use /usr/local
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
