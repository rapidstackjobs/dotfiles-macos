# macOS dotfiles

Scripts and configuration files to set up a development environment on macOS using **Zsh**, **Homebrew**, and **VSCode**.

---

## What's included

| Path | Purpose |
|------|---------|
| `install.sh` | Main bootstrap script – run this first |
| `Brewfile` | Homebrew Bundle – CLI tools, runtimes, GUI apps |
| `zsh/.zprofile` | Zsh login profile (Homebrew `PATH` setup) |
| `zsh/.zshrc` | Zsh interactive shell config (aliases, plugins, functions, prompt) |
| `vscode/settings.json` | VSCode editor settings |
| `vscode/keybindings.json` | VSCode keyboard shortcuts |
| `vscode/extensions.sh` | Installs a curated set of VSCode extensions |
| `macos/defaults.sh` | macOS system preferences via `defaults write` |

---

## Quick start

### 1. Clone the repo

```bash
git clone https://github.com/rapidstackjobs/dotfiles-macos.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the installer

```bash
chmod +x install.sh
./install.sh
```

The script will:

1. Install **Xcode Command Line Tools** if missing
2. Install **Homebrew** if missing, then run `brew bundle`
3. Symlink `zsh/.zshrc` and `zsh/.zprofile` to `~/.zshrc` and `~/.zprofile`
4. Link VSCode `settings.json` and `keybindings.json` to the correct User directory
5. Install VSCode extensions via `vscode/extensions.sh`
6. Apply macOS system preferences via `macos/defaults.sh`

### 3. Restart your terminal

```bash
exec zsh
```

---

## Running individual pieces

```bash
# Install Homebrew packages only
brew bundle --file=Brewfile

# Install VSCode extensions only
bash vscode/extensions.sh

# Apply macOS defaults only
bash macos/defaults.sh
```

---

## Customisation

### Local overrides

Create `~/.zshrc.local` for machine-specific settings that should **not** be committed:

```bash
# Example ~/.zshrc.local
export WORK_PROXY="http://proxy.example.com:8080"
alias myapp="~/projects/myapp/run.sh"
```

### Brewfile

Edit `Brewfile` to add or remove packages. Apply changes with:

```bash
brew bundle --file=Brewfile
```

### VSCode settings

Edit `vscode/settings.json` or `vscode/extensions.sh`. The settings file is symlinked, so changes are reflected immediately. Run `bash vscode/extensions.sh` to install new extensions.

---

## What gets symlinked

| Source | Destination |
|--------|------------|
| `zsh/.zprofile` | `~/.zprofile` |
| `zsh/.zshrc` | `~/.zshrc` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |

Existing files are backed up to `<file>.bak` before being replaced.

---

## Zsh plugins installed via Homebrew

| Plugin | Description |
|--------|------------|
| `zsh-autosuggestions` | Fish-style command suggestions |
| `zsh-syntax-highlighting` | Real-time syntax highlighting |
| `fzf` | Fuzzy finder (`Ctrl+R`, `Ctrl+T`) |
| `zoxide` | Smarter `cd` with frecency |
| `starship` | Cross-shell, fast prompt |

---

## Key VSCode extensions installed

- **GitHub Copilot** + Copilot Chat
- **Prettier**, **ESLint**, **EditorConfig**
- **GitLens**, Git Graph
- Language support: Python, Go, Rust, TypeScript, Shell
- Docker, Kubernetes, Terraform
- Error Lens, Path Intellisense, Tailwind CSS

---

## License

MIT