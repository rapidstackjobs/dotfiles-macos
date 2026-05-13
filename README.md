# dotfiles-macos

> Opinionated macOS development environment – shell config, VS Code settings,
> Homebrew packages, and VS Code extensions all in one place.

---

## 📁 File Overview

| File | Purpose |
|------|---------|
| `.zprofile` | Login shell: Homebrew PATH, `$EDITOR`, locale |
| `.zshrc` | Interactive shell: Oh-My-Zsh, plugins, history, key bindings, tool hooks |
| `.aliases` | Shortcuts for navigation, git, npm, Python, Docker, macOS utilities |
| `vscode_settings.json` | VS Code editor settings |
| `vscode_keybindings.json` | VS Code keyboard shortcuts |
| `brew.sh` | Installs Homebrew, CLI formulae, and GUI cask apps |
| `vscode.sh` | Installs VS Code extensions and copies settings/keybindings |

---

## 🚀 Quick Start

### 1 – Clone the repo

```bash
git clone https://github.com/<your-username>/dotfiles-macos.git ~/dotfiles
cd ~/dotfiles
```

### 2 – Install Homebrew packages & apps

```bash
bash brew.sh
```

This will:
- Install Homebrew if it isn't already present
- Install all CLI tools (git, fzf, bat, ripgrep, node, python, etc.)
- Install GUI apps via cask (VS Code, iTerm2, Docker, Raycast, etc.)

### 3 – Install VS Code extensions & copy settings

```bash
bash vscode.sh
```

This will:
- Install all listed VS Code extensions
- Copy `vscode_settings.json` → `~/Library/Application Support/Code/User/settings.json`
- Copy `vscode_keybindings.json` → `~/Library/Application Support/Code/User/keybindings.json`

### 4 – Symlink dotfiles

Symlink (or copy) the shell config files to your home directory:

```bash
# Symlink – changes to ~/dotfiles are reflected immediately
ln -sf ~/dotfiles/.zprofile  ~/.zprofile
ln -sf ~/dotfiles/.zshrc     ~/.zshrc
ln -sf ~/dotfiles/.aliases   ~/.aliases
```

### 5 – Install Oh-My-Zsh (if not already installed)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Then install the Powerlevel10k theme and the extra plugins referenced in `.zshrc`:

```bash
# Theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

git clone https://github.com/zsh-users/zsh-completions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions"
```

### 6 – Reload your shell

```bash
exec zsh -l
```

---

## ⚙️ Customisation

### Machine-specific overrides

Add any machine-specific config (tokens, private aliases, etc.) to
`~/.zshrc.local` – this file is sourced by `.zshrc` but is intentionally **not
committed** to the repository.

### Enabling / disabling packages

Edit `brew.sh` and comment out anything you don't need. Each item is in a named
section so it's easy to find.

### Enabling / disabling VS Code extensions

Edit `vscode.sh` and comment out any extension IDs you don't want. Re-run the
script at any time to add new ones.

---

## 🗂 Shell Aliases Reference

A few highlights from `.aliases`:

| Alias | Expands to |
|-------|-----------|
| `..` / `...` | `cd ..` / `cd ../..` |
| `ll` | `ls -lhF` |
| `brewup` | `brew update && brew upgrade && brew cleanup` |
| `gs` | `git status -sb` |
| `gl` | `git log --oneline --graph --decorate --all` |
| `nr` | `npm run` |
| `dcup` | `docker compose up -d` |
| `flushdns` | Flush macOS DNS cache |
| `reload` | `exec zsh -l` |

---

## 🔑 VS Code Keyboard Shortcuts Reference

| Shortcut | Action |
|----------|--------|
| `Ctrl+\`` | Toggle terminal |
| `Cmd+D` | Duplicate line down |
| `Cmd+Shift+D` | Delete line |
| `Alt+↑ / ↓` | Move line up / down |
| `Cmd+Alt+↑ / ↓` | Add cursor above / below |
| `Cmd+B` | Toggle sidebar |
| `Cmd+J` | Toggle panel |
| `Cmd+K Z` | Zen mode |

---

## 📦 What Gets Installed

### CLI Tools (selection)

`git` · `gh` · `fzf` · `bat` · `eza` · `ripgrep` · `fd` · `zoxide` · `delta` ·
`nvm` · `pyenv` · `node` · `python` · `go` · `rustup` · `docker` · `kubectl` ·
`helm` · `k9s` · `awscli` · `terraform` · `jq` · `httpie` · `tmux` · `lazygit`

### GUI Apps (selection)

Visual Studio Code · iTerm2 · Warp · Google Chrome · Arc · Raycast · Notion ·
Obsidian · 1Password · Rectangle · Slack · Postman · TablePlus · Docker Desktop ·
Figma · JetBrains Toolbox

### VS Code Extensions (selection)

One Dark Pro · Prettier · ESLint · GitLens · GitHub Copilot · Python · Pylance ·
Go · Rust Analyzer · Tailwind CSS · REST Client · Docker · Remote SSH · Live Share

---

## 📄 Licence

MIT – feel free to fork and customise for your own workflow.