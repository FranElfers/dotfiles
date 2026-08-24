#!/bin/bash

USER_HOME="${HOME}"
[ -n "$SUDO_USER" ] && USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

cp "$USER_HOME/.config/yazi/yazi.toml" yazi.toml
cp "$USER_HOME/.config/cliamp/config.toml" cliamp/config.toml
cp "$USER_HOME/.config/cliamp/playlists/radio-stations.toml" cliamp/radio-stations.toml
cp "$USER_HOME/.config/hypr/hyprland-gui.lua" hyprland-gui.lua
cp "$USER_HOME/.bashrc" .bashrc
cp "$USER_HOME/.bash_profile" .bash_profile
cp "$USER_HOME/.config/omarchy/shell.json" omarchy_shell.json
cp "$USER_HOME/.local/state/omarchy/workspace-layouts/1.lua" workspace/1.lua
cp "$USER_HOME/.config/zed/settings.json" zed.json
cp "$USER_HOME/.config/btop/btop.conf" btop.conf
