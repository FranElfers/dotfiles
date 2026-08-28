#!/bin/bash

# correr esto antes de conectarse a internet si se instalo en una vm
# sudo ufw allow in on virbr0
# sudo ufw route allow in on virbr0

omarchy update -y
omarchy pkg add nano yazi github-cli zed bun go fuse2 webkit2gtk-4.1 uv syncthing flatpak

# hyprmod, omazed
yay -S hyprmod omazed --noconfirm
omazed setup

# omarchy plugins
omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable -y &
omarchy plugin add https://github.com/bscott/cliamp-oma-plugin.git --enable -y &
omarchy plugin add https://github.com/SirJul1337/omarchy-lock-explorer.git --enable -y &
omarchy plugin add https://github.com/brianblakely/omarchy-plugins.git --enable -y &
omarchy plugin add https://github.com/ussego/otoru.git --enable -y &
omarchy plugin add https://github.com/TheTrueFerret/omarchy-decent-workspaces.git --enable -y &
omarchy plugin add https://github.com/ssupt/omarchy-bluetooth-audio.git --enable -y &
omarchy plugin add https://github.com/edgarsilva/omarchy-hw-monitor.git --enable -y &
omarchy plugin add https://github.com/ssupt/omarchy-audio-control.git --enable -y &
wait

# configs
USER_HOME="${HOME}"
[ -n "$SUDO_USER" ] && USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

REPO_RAW_URL="https://raw.githubusercontent.com/FranElfers/dotfiles/master"

download_config() {
    local dest="$USER_HOME/$1"
    mkdir -p "$(dirname "$dest")"
    curl -fSL "$REPO_RAW_URL/$1" -o "$dest"
    [ -n "$SUDO_USER" ] && chown "$SUDO_USER:" "$dest"
}

download_config .bash_profile
download_config .bashrc
download_config .config/btop/btop.conf
download_config .config/cliamp/config.toml
download_config .config/cliamp/playlists/radio-stations.toml
download_config .config/gtk-3.0/bookmarks
download_config .config/hypr/hyprland-gui.lua
download_config .config/hypr/hyprland.lua
download_config .config/hypr/input.lua
download_config .config/hypr/monitors.lua
download_config .config/omarchy/audio-preferences.json
download_config .config/omarchy/audio-rules.json
download_config .config/omarchy/shell.json
download_config .config/omarchy/ussego.otoru.json
download_config .config/yazi/yazi.toml
download_config .config/zed/settings.json
download_config .gemini/antigravity-cli/settings.json
download_config .local/state/omarchy/powerprofiles/battery
download_config .local/state/omarchy/workspace-layouts/1.lua
download_config .local/state/syncthing/config.xml

# nvm, pnpm, antigravity, antra
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash &
curl -fsSL https://get.pnpm.io/install.sh | sh - &
curl -fsSL https://antigravity.google/cli/install.sh | bash
curl -Lo "$USER_HOME/Antra.AppImage" https://github.com/anandprtp/Antra/releases/latest/download/Antra-Linux.AppImage &
wait
chmod +x "$USER_HOME/Antra.AppImage"

# github auth
# gh auth login -p https -h github.com -w

# set lock screen
omarchy restart shell

# swap fn & ctrl keys on macbook
# echo "options hid_apple swap_fn_leftctrl=1" | sudo tee /etc/modprobe.d/hid_apple.conf
# sudo mkinitcpio -P

# fix macbook T2 speakers
# curl -sSL https://raw.githubusercontent.com/ngodn/linux-t2-mbp16_1-arch-audio-setup/main/install.sh | bash
