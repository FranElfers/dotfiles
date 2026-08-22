pacman -Syu
pacman -S nano yazi github-cli

# omarchy plugins
omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable -y

# yazi config
install -D yazi.toml ~/.config/yazi/yazi.toml

# github auth
# gh auth login -p https -h github.com -w

# hyprmod
# yay -S hyprmod
