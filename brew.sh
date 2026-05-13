#!/usr/bin/env bash
# brew.sh – Install Homebrew packages and macOS apps
# Usage: bash brew.sh
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ── Install Homebrew if missing ───────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "▶ Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for this session
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "▶ Homebrew already installed – updating…"
  brew update
fi

# ── Helper ───────────────────────────────────────────────────────────────────
install_formula() {
  if brew list --formula "$1" &>/dev/null; then
    echo "  ✓ $1 (already installed)"
  else
    echo "  ⬇ Installing $1…"
    brew install "$1"
  fi
}

install_cask() {
  if brew list --cask "$1" &>/dev/null; then
    echo "  ✓ $1 (already installed)"
  else
    echo "  ⬇ Installing $1…"
    brew install --cask "$1"
  fi
}

# ═════════════════════════════════════════════════════════════════════════════
# FORMULAE (CLI tools)
# ═════════════════════════════════════════════════════════════════════════════
echo ""
echo "▶ Installing CLI tools…"

FORMULAE=(
  # Shell / terminal
  zsh
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  starship            # minimal, fast prompt (alternative to p10k)
  tmux
  antidote            # zsh plugin manager

  # Modern Unix replacements
  bat                 # better cat
  eza                 # better ls
  fd                  # better find
  ripgrep             # better grep
  fzf                 # fuzzy finder
  zoxide              # smarter cd
  delta               # better git diff pager
  dust                # better du
  duf                 # better df
  htop
  procs               # better ps

  # Version managers
  nvm
  pyenv
  rbenv
  ruby-build
  tfenv               # Terraform version manager

  # Developer tools
  git
  git-delta
  gh                  # GitHub CLI
  lazygit
  jq
  yq
  wget
  curl
  httpie
  gnupg
  openssh
  openssl
  direnv
  pre-commit
  tree
  watch
  coreutils
  gnu-sed
  grep
  make

  # Node / JS
  node
  pnpm
  yarn

  # Python
  python
  pipx
  uv                  # fast pip/venv replacement

  # Go
  go

  # Rust
  rustup

  # Containers / Cloud
  docker
  docker-compose
  kubectl
  helm
  k9s
  awscli
  azure-cli
  terraform

  # Databases
  postgresql@16
  mysql
  redis
  sqlite

  # Networking / security
  nmap
  netcat
  mitmproxy
  sslscan
)

for formula in "${FORMULAE[@]}"; do
  install_formula "$formula"
done

# ═════════════════════════════════════════════════════════════════════════════
# CASKS (GUI apps)
# ═════════════════════════════════════════════════════════════════════════════
echo ""
echo "▶ Installing GUI apps…"

CASKS=(
  # Editors / IDEs
  visual-studio-code
  cursor                  # AI-powered VS Code fork
  jetbrains-toolbox

  # Browsers
  google-chrome
  firefox
  arc

  # Terminal
  iterm2
  warp

  # Productivity
  raycast                 # Spotlight replacement
  notion
  obsidian
  1password
  rectangle               # Window manager
  bartender               # Menu bar manager
  alfred

  # Communication
  slack
  discord
  zoom

  # API / HTTP clients
  postman
  insomnia

  # Database GUIs
  tableplus
  dbeaver-community

  # Containers / virtualisation
  docker                  # Docker Desktop
  orbstack                # Lightweight Docker/Linux VMs

  # Design
  figma

  # Fonts
  font-jetbrains-mono
  font-fira-code
  font-hack-nerd-font
  font-meslo-lg-nerd-font
)

for cask in "${CASKS[@]}"; do
  install_cask "$cask"
done

# ═════════════════════════════════════════════════════════════════════════════
# Post-install housekeeping
# ═════════════════════════════════════════════════════════════════════════════
echo ""
echo "▶ Running brew cleanup…"
brew cleanup

echo ""
echo "✅  Homebrew setup complete!"
echo ""
echo "   Next steps:"
echo "   • Run  bash vscode.sh  to install VS Code extensions"
echo "   • Open a new terminal for PATH changes to take effect"
