#!/usr/bin/env bash
# =============================================================================
# install.sh – Bootstrap a macOS development environment
#
# Usage:
#   chmod +x install.sh && ./install.sh
# =============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colours ────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[info]${NC}  $*"; }
success() { echo -e "${GREEN}[ok]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC}  $*"; }
error()   { echo -e "${RED}[error]${NC} $*" >&2; exit 1; }

# ── macOS check ────────────────────────────────────────────────────────────
[[ "$(uname)" == "Darwin" ]] || error "This script is macOS only."

# ── Xcode Command Line Tools ───────────────────────────────────────────────
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools…"
  xcode-select --install
  # Wait until the tools are installed
  until xcode-select -p &>/dev/null; do sleep 5; done
  success "Xcode Command Line Tools installed."
else
  success "Xcode Command Line Tools already present."
fi

# ── Homebrew ───────────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add Homebrew to PATH for the rest of this script
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  success "Homebrew installed."
else
  success "Homebrew already present."
  brew update
fi

# ── Homebrew Bundle ────────────────────────────────────────────────────────
info "Installing packages from Brewfile…"
brew bundle --file="${DOTFILES_DIR}/Brewfile"
success "Brewfile packages installed."

# ── Zsh dotfiles ───────────────────────────────────────────────────────────
info "Linking Zsh configuration files…"

link_file() {
  local src="$1"
  local dest="$2"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    warn "Backing up existing $dest → ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi
  ln -sf "$src" "$dest"
  success "Linked $dest → $src"
}

link_file "${DOTFILES_DIR}/zsh/.zshrc"   "${HOME}/.zshrc"
link_file "${DOTFILES_DIR}/zsh/.zprofile" "${HOME}/.zprofile"

# ── VSCode extensions ─────────────────────────────────────────────────────
if command -v code &>/dev/null; then
  info "Installing VSCode extensions…"
  bash "${DOTFILES_DIR}/vscode/extensions.sh"
  success "VSCode extensions installed."

  info "Linking VSCode settings…"
  VSCODE_USER_DIR="${HOME}/Library/Application Support/Code/User"
  mkdir -p "${VSCODE_USER_DIR}"
  link_file "${DOTFILES_DIR}/vscode/settings.json" "${VSCODE_USER_DIR}/settings.json"
  link_file "${DOTFILES_DIR}/vscode/keybindings.json" "${VSCODE_USER_DIR}/keybindings.json"
else
  warn "VSCode CLI ('code') not found — skipping extension install."
  warn "Open VSCode, press Cmd+Shift+P, run 'Shell Command: Install code in PATH', then re-run this script."
fi

# ── macOS system defaults ─────────────────────────────────────────────────
info "Applying macOS system preferences…"
bash "${DOTFILES_DIR}/macos/defaults.sh"
success "macOS preferences applied."

# ── Done ───────────────────────────────────────────────────────────────────
echo ""
success "╔══════════════════════════════════════╗"
success "║  Development environment is ready!   ║"
success "╚══════════════════════════════════════╝"
echo ""
info "Restart your terminal (or run 'exec zsh') to load the new shell config."
