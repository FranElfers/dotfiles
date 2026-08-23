omarchy update -y
omarchy pkg add -y nano yazi github-cli zed bun go

# omarchy plugins
omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable -y

# configs
install -D yazi.toml ~/.config/yazi/yazi.toml
install -D cliamp.toml ~/.config/cliamp/config.toml
install -D hyprland-gui.lua ~/.config/hypr/hyprland-gui.lua
install -D .bashrc ~/.bashrc
install -D .bash_profile ~/.bash_profile
install -D .omarchy_shell.json ~/.config/omarchy/shell.json
install -D workspace/1.lua ~/.local/state/omarchy/workspace-layouts/1.lua 

# github auth
# gh auth login -p https -h github.com -w

# hyprmod
# yay -S hyprmod

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash
