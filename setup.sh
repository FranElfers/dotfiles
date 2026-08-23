#!/bin/bash

# correr esto antes de conectarse a internet si se instalo en una vm
# sudo ufw allow in on virbr0
# sudo ufw route allow in on virbr0

omarchy update -y
omarchy pkg add nano yazi github-cli zed bun go

# omarchy plugins
omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable -y

# configs
USER_HOME="${HOME}"
[ -n "$SUDO_USER" ] && USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

install -D yazi.toml "$USER_HOME/.config/yazi/yazi.toml"
install -D cliamp.toml "$USER_HOME/.config/cliamp/config.toml"
install -D hyprland-gui.lua "$USER_HOME/.config/hypr/hyprland-gui.lua"
install -D .bashrc "$USER_HOME/.bashrc"
install -D .bash_profile "$USER_HOME/.bash_profile"
install -D omarchy_shell.json "$USER_HOME/.config/omarchy/shell.json"
install -D workspace/1.lua "$USER_HOME/.local/state/omarchy/workspace-layouts/1.lua"
install -D cliamp/radio-stations.toml "$USER_HOME/.config/cliamp/playlists/radio-stations.toml"
install -D zed.json "$USER_HOME/.config/zed/settings.json"
install -D btop.conf "$USER_HOME/.config/btop/btop.conf"

# github auth
# gh auth login -p https -h github.com -w

# hyprmod
# yay -S hyprmod

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash
