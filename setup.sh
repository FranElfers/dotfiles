#!/bin/bash
clear

trap 'tput csr 0 $(tput lines); tput cnorm; echo; exit' INT TERM EXIT

tput civis
tput csr 0 $(($(tput lines) - 2))

update_omarchy() {
    omarchy update -y
}

install_packages_pacman() {
    omarchy pkg add nano yazi github-cli zed bun go fuse2 webkit2gtk-4.1 uv syncthing flatpak
}

install_packages_aur() {
    yay -S hyprmod omazed --noconfirm
    omazed setup
}

install_plugins() {
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
}

download_configs() {
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
    download_config .config/zed/keymap.json
    download_config .config/zed/settings.json
    download_config .gemini/antigravity-cli/settings.json
    download_config .local/state/omarchy/powerprofiles/battery
    download_config .local/state/omarchy/workspace-layouts/1.lua
    download_config .local/state/syncthing/config.xml
}

download_external_apps() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash &
    curl -fsSL https://get.pnpm.io/install.sh | sh - &
    curl -fsSL https://antigravity.google/cli/install.sh | bash
    curl -Lo "$USER_HOME/Antra.AppImage" https://github.com/anandprtp/Antra/releases/latest/download/Antra-Linux.AppImage &
    wait
    chmod +x "$USER_HOME/Antra.AppImage"
}

end() {
    omarchy restart shell
}

scripts=(
    update_omarchy
    install_packages_pacman
    install_packages_aur
    install_plugins
    download_configs
    download_external_apps
    end
)

titles=(
    "Actualizando Omarchy"
    "Instalando paquetes (pacman)"
    "Instalando paquetes (AUR)"
    "Instalando plugins de Omarchy"
    "Descargando configuraciones"
    "Descargando Apps externas"
    "Finalizando"
)

for (( i=0; i<${#scripts[@]}; i++ )); do
    clear
    tput sc
    tput cup $(tput lines) 0
    echo -ne " <=========[  ${titles[i]}  ]=========>"
    tput rc
    ${scripts[$i]}
done

clear
echo -e "\n¡Instalación completada!"
