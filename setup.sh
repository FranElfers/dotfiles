pacman -Syu
pacman -Sy nano yazi github-cli zed

# omarchy plugins
omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable -y

# yazi config
install -D yazi.toml ~/.config/yazi/yazi.toml

# cliamp config
install -D cliamp.toml ~/.config/cliamp/config.toml

# github auth
# gh auth login -p https -h github.com -w

# hyprmod
# yay -S hyprmod

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash
