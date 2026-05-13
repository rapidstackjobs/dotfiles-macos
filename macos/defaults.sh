#!/usr/bin/env bash
# =============================================================================
# macos/defaults.sh – Apply sensible macOS system preferences
#
# Run directly:  bash macos/defaults.sh
# Or via:        ./install.sh  (called automatically)
#
# References:
#   https://macos-defaults.com
#   https://github.com/mathiasbynens/dotfiles/blob/main/.macos
# =============================================================================

set -euo pipefail

echo "[info] Applying macOS defaults…"

# ── Close System Preferences to avoid overrides ──────────────────────────────
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

# ── General ──────────────────────────────────────────────────────────────────
# Expand save/print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode         -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2        -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint            -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2           -bool true

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable auto-correct, smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled  -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled   -bool false

# ── Keyboard ─────────────────────────────────────────────────────────────────
# Enable key repeat (disable press-and-hold for accent characters)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Fastest key repeat rate and shortest delay
defaults write NSGlobalDomain KeyRepeat        -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable auto-capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# ── Trackpad ─────────────────────────────────────────────────────────────────
# Enable tap to click for current user and login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ── Screen ───────────────────────────────────────────────────────────────────
# Require password immediately after sleep/screen saver
defaults write com.apple.screensaver askForPassword      -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to ~/Desktop/Screenshots
SCREENSHOT_DIR="${HOME}/Desktop/Screenshots"
mkdir -p "${SCREENSHOT_DIR}"
defaults write com.apple.screencapture location   -string "${SCREENSHOT_DIR}"
defaults write com.apple.screencapture type       -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# Enable HiDPI display modes
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# ── Finder ───────────────────────────────────────────────────────────────────
# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar   -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Show full POSIX path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid .DS_Store files on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores     -bool true

# Show ~/Library folder
chflags nohidden "${HOME}/Library"

# ── Dock ─────────────────────────────────────────────────────────────────────
# Set Dock size and position
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock orientation -string "bottom"

# Auto-hide Dock
defaults write com.apple.dock autohide      -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-multiplier -float 0.4

# Don't show recent apps in Dock
defaults write com.apple.dock show-recents -bool false

# Minimise windows into their app icon
defaults write com.apple.dock minimize-to-application -bool true

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# ── Safari & WebKit ───────────────────────────────────────────────────────────
# Enable Safari's Developer Tools
defaults write com.apple.Safari IncludeDevelopmentMenu         -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

# ── Activity Monitor ─────────────────────────────────────────────────────────
# Show all processes
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# ── TextEdit ─────────────────────────────────────────────────────────────────
# Use plain text mode by default
defaults write com.apple.TextEdit RichText -int 0

# ── Time Machine ─────────────────────────────────────────────────────────────
# Prevent Time Machine from prompting to use new disks as backup volumes
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# ── Restart affected apps ─────────────────────────────────────────────────────
for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" 2>/dev/null || true
done

echo "[ok] macOS defaults applied. Some changes require a logout/restart."
