#!/bin/bash

install -D ~/.gitignore gitignore

backup_config() {
    install -D ~/$1 $1
}

backup_config .bash_profile
backup_config .bashrc
backup_config .config/btop/btop.conf
backup_config .config/cliamp/config.toml
backup_config .config/cliamp/playlists/radio-stations.toml
backup_config .config/gtk-3.0/bookmarks
backup_config .config/hypr/hyprland-gui.lua
backup_config .config/hypr/hyprland.lua
backup_config .config/hypr/input.lua
backup_config .config/hypr/monitors.lua
backup_config .config/omarchy/audio-preferences.json
backup_config .config/omarchy/audio-rules.json
backup_config .config/omarchy/branding/about.txt
backup_config .config/omarchy/branding/screensaver.txt
backup_config .config/omarchy/shell.json
backup_config .config/omarchy/ussego.otoru.json
backup_config .config/yazi/yazi.toml
backup_config .config/zed/keymap.json
backup_config .config/zed/settings.json
backup_config .gemini/antigravity-cli/settings.json
backup_config .local/bin/quickshell
backup_config .local/state/omarchy/powerprofiles/battery
backup_config .local/state/omarchy/workspace-layouts/1.lua
