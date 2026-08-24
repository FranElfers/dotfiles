#!/bin/bash

# correr esto antes de conectarse a internet si se instalo en una vm
# sudo ufw allow in on virbr0
# sudo ufw route allow in on virbr0

omarchy update -y
omarchy pkg add nano yazi github-cli zed bun go fuse2 webkit2gtk-4.1 uv

# hyprmod
yay -S hyprmod --noconfirm

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash

# omarchy plugins
omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable -y
omarchy plugin add https://github.com/bscott/cliamp-oma-plugin.git --enable -y

# configs
USER_HOME="${HOME}"
[ -n "$SUDO_USER" ] && USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

REPO_RAW_URL="https://raw.githubusercontent.com/FranElfers/dotfiles/master"

download_config() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    curl -fsSL "$REPO_RAW_URL/$src" -o "$dest"
    [ -n "$SUDO_USER" ] && chown "$SUDO_USER:" "$dest"
}

download_config "yazi.toml" "$USER_HOME/.config/yazi/yazi.toml"
download_config "cliamp/config.toml" "$USER_HOME/.config/cliamp/config.toml"
download_config "cliamp/radio-stations.toml" "$USER_HOME/.config/cliamp/playlists/radio-stations.toml"
download_config "hypr/hyprland-gui.lua" "$USER_HOME/.config/hypr/hyprland-gui.lua"
download_config "hypr/input.lua" "$USER_HOME/.config/hypr/input.lua"
download_config ".bashrc" "$USER_HOME/.bashrc"
download_config ".bash_profile" "$USER_HOME/.bash_profile"
download_config "omarchy_shell.json" "$USER_HOME/.config/omarchy/shell.json"
download_config "workspace/1.lua" "$USER_HOME/.local/state/omarchy/workspace-layouts/1.lua"
download_config "zed.json" "$USER_HOME/.config/zed/settings.json"
download_config "btop.conf" "$USER_HOME/.config/btop/btop.conf"

# Antra
curl -Lo "$USER_HOME/Antra.AppImage" https://github.com/anandprtp/Antra/releases/latest/download/Antra-Linux.AppImage
chmod +x "$USER_HOME/Antra.AppImage"

# github auth
# gh auth login -p https -h github.com -w

# swap fn & ctrl keys on macbook
# echo "options hid_apple swap_fn_leftctrl=1" | sudo tee /etc/modprobe.d/hid_apple.conf
# limine-mkinitcpio
