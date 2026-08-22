pacman -Syu
pacman -Sy nano yazi github-cli zed

# omarchy plugins
omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable -y

# configs
install -D yazi.toml ~/.config/yazi/yazi.toml
install -D cliamp.toml ~/.config/cliamp/config.toml
install -D hyprland-gui.lua ~/.config/hypr/hyprland-gui.lua

# github auth
# gh auth login -p https -h github.com -w

# hyprmod
# yay -S hyprmod

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash
