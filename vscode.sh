#!/usr/bin/env bash
# vscode.sh – Install VS Code extensions
# Usage: bash vscode.sh
# ─────────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ── Resolve 'code' command ────────────────────────────────────────────────────
CODE_CMD=""

for candidate in \
    "code" \
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
    "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
do
  if command -v "$candidate" &>/dev/null || [[ -x "$candidate" ]]; then
    CODE_CMD="$candidate"
    break
  fi
done

if [[ -z "$CODE_CMD" ]]; then
  echo "✗ VS Code CLI ('code') not found."
  echo "  • Open VS Code → Command Palette (⌘⇧P) → 'Shell Command: Install code in PATH'"
  exit 1
fi

echo "▶ Using VS Code CLI: $CODE_CMD"
echo ""

# ── Helper ────────────────────────────────────────────────────────────────────
install_ext() {
  local ext="$1"
  if "$CODE_CMD" --list-extensions 2>/dev/null | grep -qi "^${ext}$"; then
    echo "  ✓ $ext (already installed)"
  else
    echo "  ⬇ Installing $ext…"
    "$CODE_CMD" --install-extension "$ext" --force 2>/dev/null \
      && echo "    ✓ Done" \
      || echo "    ✗ Failed (extension may be unavailable or renamed)"
  fi
}

# ═════════════════════════════════════════════════════════════════════════════
# EXTENSIONS
# ═════════════════════════════════════════════════════════════════════════════

# ── Themes & icons ─────────────────────────────────────────────────────────
echo "▶ Themes & Icons"
EXTENSIONS=(
  zhuangtongfa.material-theme          # One Dark Pro
  pkief.material-icon-theme
  GitHub.github-vscode-theme
  dracula-theme.theme-dracula
  sdras.night-owl
)

# ── Formatting & linting ────────────────────────────────────────────────────
echo "▶ Formatting & Linting"
EXTENSIONS+=(
  esbenp.prettier-vscode
  dbaeumer.vscode-eslint
  foxundermoon.shell-format
  timonwong.shellcheck
  editorconfig.editorconfig
  streetsidesoftware.code-spell-checker
)

# ── Language support ────────────────────────────────────────────────────────
echo "▶ Language Support"
EXTENSIONS+=(
  # JavaScript / TypeScript
  ms-vscode.vscode-typescript-next
  bradlc.vscode-tailwindcss
  burkeholland.simple-react-snippets
  dsznajder.es7-react-js-snippets

  # Python
  ms-python.python
  ms-python.vscode-pylance
  ms-python.black-formatter
  ms-python.isort
  ms-python.debugpy

  # Go
  golang.go

  # Rust
  rust-lang.rust-analyzer
  vadimcn.vscode-lldb

  # HTML / CSS
  formulahendry.auto-close-tag
  formulahendry.auto-rename-tag
  pranaygp.vscode-css-peek

  # JSON / YAML / TOML
  redhat.vscode-yaml
  tamasfe.even-better-toml
  zainchen.json

  # Markdown
  yzhang.markdown-all-in-one
  DavidAnson.vscode-markdownlint
  bierner.markdown-preview-github-styles

  # Docker / K8s
  ms-azuretools.vscode-docker
  ms-kubernetes-tools.vscode-kubernetes-tools

  # Terraform / IaC
  hashicorp.terraform
  hashicorp.hcl
)

# ── Git & version control ───────────────────────────────────────────────────
echo "▶ Git & Version Control"
EXTENSIONS+=(
  eamodio.gitlens
  mhutchie.git-graph
  GitHub.vscode-pull-request-github
  waderyan.gitblame
)

# ── AI assistants ───────────────────────────────────────────────────────────
echo "▶ AI Assistants"
EXTENSIONS+=(
  GitHub.copilot
  GitHub.copilot-chat
)

# ── Productivity & utilities ─────────────────────────────────────────────────
echo "▶ Productivity"
EXTENSIONS+=(
  christian-kohler.path-intellisense
  christian-kohler.npm-intellisense
  naumovs.color-highlight
  usernamehw.errorlens
  gruntfuggly.todo-tree
  aaron-bond.better-comments
  oderwat.indent-rainbow
  vincaslt.highlight-matching-tag
  pflannery.vscode-versionlens
  ritwickdey.liveserver
  ms-vscode.live-server
  ms-vsliveshare.vsliveshare
  WakaTime.vscode-wakatime
  vscodevim.vim                    # Vim emulation – remove if not needed
)

# ── REST / GraphQL clients ───────────────────────────────────────────────────
echo "▶ REST / GraphQL"
EXTENSIONS+=(
  humao.rest-client
  GraphQL.vscode-graphql
  GraphQL.vscode-graphql-syntax
)

# ── Testing ─────────────────────────────────────────────────────────────────
echo "▶ Testing"
EXTENSIONS+=(
  ms-vscode.test-adapter-converter
  hbenl.vscode-test-explorer
  formulahendry.code-runner
)

# ── Remote development ───────────────────────────────────────────────────────
echo "▶ Remote Development"
EXTENSIONS+=(
  ms-vscode-remote.remote-ssh
  ms-vscode-remote.remote-containers
  ms-vscode-remote.vscode-remote-extensionpack
)

# ═════════════════════════════════════════════════════════════════════════════
# Install all extensions
# ═════════════════════════════════════════════════════════════════════════════
echo ""
echo "▶ Installing extensions (${#EXTENSIONS[@]} total)…"
echo ""

for ext in "${EXTENSIONS[@]}"; do
  install_ext "$ext"
done

# ═════════════════════════════════════════════════════════════════════════════
# Copy settings & keybindings
# ═════════════════════════════════════════════════════════════════════════════
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

copy_config() {
  local src="$1" dst="$2"
  if [[ -f "$src" ]]; then
    if [[ -f "$dst" ]]; then
      echo "  ⚠  $dst already exists – backed up to ${dst}.bak"
      cp "$dst" "${dst}.bak"
    fi
    cp "$src" "$dst"
    echo "  ✓ Copied $(basename "$src") → $dst"
  fi
}

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "▶ Copying VS Code settings…"
mkdir -p "$VSCODE_USER_DIR"
copy_config "$DOTFILES_DIR/vscode_settings.json"    "$VSCODE_USER_DIR/settings.json"
copy_config "$DOTFILES_DIR/vscode_keybindings.json" "$VSCODE_USER_DIR/keybindings.json"

echo ""
echo "✅  VS Code setup complete!"
echo ""
echo "   Restart VS Code to apply all changes."
