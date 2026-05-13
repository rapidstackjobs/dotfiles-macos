#!/usr/bin/env bash
# =============================================================================
# vscode/extensions.sh – Install VSCode extensions
#
# Run directly:  bash vscode/extensions.sh
# Or via:        ./install.sh  (called automatically)
# =============================================================================

set -euo pipefail

command -v code &>/dev/null || {
  echo "[warn] 'code' CLI not found. Open VSCode → Cmd+Shift+P → 'Shell Command: Install code in PATH'."
  exit 1
}

EXTENSIONS=(
  # ── Themes & icons ──────────────────────────────────────────────────────
  "GitHub.github-vscode-theme"
  "PKief.material-icon-theme"

  # ── AI assistance ────────────────────────────────────────────────────────
  "GitHub.copilot"
  "GitHub.copilot-chat"

  # ── General editing ──────────────────────────────────────────────────────
  "esbenp.prettier-vscode"
  "EditorConfig.EditorConfig"
  "streetsidesoftware.code-spell-checker"
  "aaron-bond.better-comments"
  "usernamehw.errorlens"
  "wix.vscode-import-cost"
  "christian-kohler.path-intellisense"
  "naumovs.color-highlight"

  # ── Git ───────────────────────────────────────────────────────────────────
  "eamodio.gitlens"
  "mhutchie.git-graph"
  "donjayamanne.githistory"

  # ── JavaScript / TypeScript ───────────────────────────────────────────────
  "dbaeumer.vscode-eslint"
  "dsznajder.es7-react-js-snippets"
  "formulahendry.auto-rename-tag"
  "formulahendry.auto-close-tag"
  "bradlc.vscode-tailwindcss"
  "Prisma.prisma"

  # ── Python ────────────────────────────────────────────────────────────────
  "ms-python.python"
  "ms-python.black-formatter"
  "ms-python.pylint"
  "ms-python.debugpy"

  # ── Go ────────────────────────────────────────────────────────────────────
  "golang.go"

  # ── Rust ──────────────────────────────────────────────────────────────────
  "rust-lang.rust-analyzer"

  # ── Shell / DevOps ────────────────────────────────────────────────────────
  "foxundermoon.shell-format"
  "timonwong.shellcheck"
  "ms-azuretools.vscode-docker"
  "ms-kubernetes-tools.vscode-kubernetes-tools"
  "HashiCorp.terraform"
  "redhat.vscode-yaml"

  # ── Databases ─────────────────────────────────────────────────────────────
  "cweijan.vscode-database-client2"

  # ── REST / API ────────────────────────────────────────────────────────────
  "humao.rest-client"

  # ── Markdown / Docs ───────────────────────────────────────────────────────
  "yzhang.markdown-all-in-one"
  "DavidAnson.vscode-markdownlint"

  # ── Remote development ────────────────────────────────────────────────────
  "ms-vscode-remote.remote-ssh"
  "ms-vscode-remote.remote-containers"
)

echo "[info] Installing ${#EXTENSIONS[@]} VSCode extensions…"
failed=()

for ext in "${EXTENSIONS[@]}"; do
  if code --list-extensions 2>/dev/null | grep -qi "^${ext}$"; then
    echo "  [skip] ${ext} (already installed)"
  else
    if code --install-extension "${ext}" --force &>/dev/null; then
      echo "  [ok]   ${ext}"
    else
      echo "  [fail] ${ext}"
      failed+=("${ext}")
    fi
  fi
done

if [[ ${#failed[@]} -gt 0 ]]; then
  echo ""
  echo "[warn] The following extensions failed to install:"
  for ext in "${failed[@]}"; do echo "  - ${ext}"; done
fi

echo ""
echo "[ok] Done installing VSCode extensions."
